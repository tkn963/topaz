﻿#include "gambits_container.h"

#include "../../ability.h"
#include "../../spell.h"
#include "../../mobskill.h"
#include "../../weapon_skill.h"
#include "../../ai/states/mobskill_state.h"
#include "../../ai/states/magic_state.h"
#include "../../ai/states/weaponskill_state.h"
#include "../../utils/battleutils.h"
#include "../../utils/trustutils.h"

namespace gambits
{

// Validate gambit before it's inserted into the gambit list
// Check levels, etc.
void CGambitsContainer::AddGambit(Gambit_t gambit)
{
    bool available = true;
    for (auto& action : gambit.actions)
    {
        if (action.reaction == G_REACTION::MA && action.select == G_SELECT::SPECIFIC)
        {
            if (!spell::CanUseSpell(static_cast<CBattleEntity*>(POwner), static_cast<SpellID>(action.select_arg)))
            {
                available = false;
            }
        }
    }
    if (available)
    {
        gambits.push_back(gambit);
    }
}

void CGambitsContainer::Tick(time_point tick)
{
    if (tick < m_lastAction)
    {
        return;
    }

    auto random_offset = static_cast<std::chrono::milliseconds>(tpzrand::GetRandomNumber(1000, 2500));
    m_lastAction = tick + random_offset;

    auto controller = static_cast<CTrustController*>(POwner->PAI->GetController());

    // TODO: Is this necessary?
    if (POwner->PAI->IsCurrentState<CMagicState>() ||
        POwner->PAI->IsCurrentState<CWeaponSkillState>() ||
        POwner->PAI->IsCurrentState<CMobSkillState>())
    {
        return;
    }

    auto target = POwner->GetBattleTarget();
    if (!target)
    {
        return;
    }

    // Deal with TP skills before any gambits
    // TODO: Should this be its own special gambit?
    if (POwner->health.tp >= 1000)
    {
        auto checkTrigger = [&]() -> bool
        {
            if (POwner->health.tp >= 3000) { return true;  } // Go, go, go!

            switch (tp_trigger)
            {
                case G_TP_TRIGGER::ASAP:
                {
                    return true;
                    break;
                }
                case G_TP_TRIGGER::OPENER:
                {
                    bool result = false;
                    static_cast<CCharEntity*>(POwner->PMaster)->ForPartyWithTrusts([&result](CBattleEntity* PMember)
                    {
                        if (PMember->health.tp >= 1000)
                        {
                            result = true;
                        }
                    });
                    return result;
                    break;
                }
                case G_TP_TRIGGER::CLOSER:
                {
                    auto PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN);

                    // TODO: ...and has a valid WS...

                    return PSCEffect && PSCEffect->GetStartTime() + 3s < server_clock::now() && PSCEffect->GetTier() == 0;
                    break;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        };

        std::optional<TrustSkill_t> chosen_skill;
        SKILLCHAIN_ELEMENT chosen_skillchain = SC_NONE;
        if (checkTrigger())
        {
            switch (tp_select)
            {
                case G_SELECT::RANDOM:
                {
                    chosen_skill = tp_skills.at(tpzrand::GetRandomNumber(tp_skills.size()));
                    break;
                }
                case G_SELECT::HIGHEST: // Form the best possible skillchain
                {
                    auto PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN);

                    if (!PSCEffect) // Opener
                    {
                        // TODO: This relies on the skills being passed in in some kind of correct order...
                        // Probably best to do this another way
                        chosen_skill = tp_skills.at(tp_skills.size() - 1);
                        break;
                    }

                    // Closer
                    for (auto& skill : tp_skills)
                    {
                        std::list<SKILLCHAIN_ELEMENT> resonanceProperties;
                        if (uint16 power = PSCEffect->GetPower())
                        {
                            resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power & 0xF));
                            resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power >> 4 & 0xF));
                            resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power >> 8));
                        }

                        std::list<SKILLCHAIN_ELEMENT> skillProperties;
                        skillProperties.push_back((SKILLCHAIN_ELEMENT)skill.primary);
                        skillProperties.push_back((SKILLCHAIN_ELEMENT)skill.secondary);
                        skillProperties.push_back((SKILLCHAIN_ELEMENT)skill.tertiary);
                        if (SKILLCHAIN_ELEMENT possible_skillchain = battleutils::FormSkillchain(resonanceProperties, skillProperties); possible_skillchain != SC_NONE)
                        {
                            if (possible_skillchain >= chosen_skillchain)
                            {
                                chosen_skill = skill;
                                chosen_skillchain = possible_skillchain;
                            }
                        }
                    }
                    break;
                }
            }
        }

        if (chosen_skill)
        {
            if (chosen_skill->skill_type == G_REACTION::WS)
            {
                CWeaponSkill* PWeaponSkill = battleutils::GetWeaponSkill(chosen_skill->skill_id);
                if (battleutils::isValidSelfTargetWeaponskill(PWeaponSkill->getID()))
                {
                    target = POwner;
                }
                else
                {
                    target = POwner->GetBattleTarget();
                }
                controller->WeaponSkill(target->targid, PWeaponSkill->getID());
            }
            else // Mobskill
            {
                controller->MobSkill(target->targid, chosen_skill->skill_id);
            }
            return;
        }
    }

    // Didn't WS/MS, go for other Gambits
    for (auto gambit : gambits)
    {
        if (tick < gambit.last_used + std::chrono::seconds(gambit.retry_delay))
        {
            continue;
        }

        auto checkTrigger = [&](CBattleEntity* target, Predicate_t& predicate) -> bool
        {
            switch (predicate.condition)
            {
            case G_CONDITION::ALWAYS:
            {
                return true;
                break;
            }
            case G_CONDITION::HPP_LT:
            {
                return target->GetHPP() < predicate.condition_arg;
                break;
            }
            case G_CONDITION::HPP_GTE:
            {
                return target->GetHPP() >= predicate.condition_arg;
                break;
            }
            case G_CONDITION::MPP_LT:
            {
                return target->GetMPP() < predicate.condition_arg;
                break;
            }
            case G_CONDITION::TP_LT:
            {
                return target->health.tp < (int16)predicate.condition_arg;
                break;
            }
            case G_CONDITION::TP_GTE:
            {
                return target->health.tp >= (int16)predicate.condition_arg;
                break;
            }
            case G_CONDITION::STATUS:
            {
                return target->StatusEffectContainer->HasStatusEffect(static_cast<EFFECT>(predicate.condition_arg));
                break;
            }
            case G_CONDITION::NOT_STATUS:
            {
                return !target->StatusEffectContainer->HasStatusEffect(static_cast<EFFECT>(predicate.condition_arg));
                break;
            }
            case G_CONDITION::STATUS_FLAG:
            {
                return target->StatusEffectContainer->HasStatusEffectByFlag(static_cast<EFFECTFLAG>(predicate.condition_arg));
                break;
            }
            case G_CONDITION::HAS_TOP_ENMITY:
            {
                return (controller->GetTopEnmity()) ? controller->GetTopEnmity()->targid == POwner->targid : false;
                break;
            }
            case G_CONDITION::NOT_HAS_TOP_ENMITY:
            {
                return (controller->GetTopEnmity()) ? controller->GetTopEnmity()->targid != POwner->targid : false;
                break;
            }
            case G_CONDITION::SC_AVAILABLE:
            {
                auto PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN);
                return PSCEffect && PSCEffect->GetStartTime() + 3s < server_clock::now() && PSCEffect->GetTier() == 0;
                break;
            }
            case G_CONDITION::NOT_SC_AVAILABLE:
            {
                auto PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN);
                return PSCEffect == nullptr;
                break;
            }
            case G_CONDITION::MB_AVAILABLE:
            {
                auto PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN);
                return PSCEffect && PSCEffect->GetStartTime() + 3s < server_clock::now() && PSCEffect->GetTier() > 0;
                break;
            }
            default: { return false;  break; }
            }
        };

        auto runPredicate = [&](Predicate_t& predicate) -> CBattleEntity*
        {
            auto isValidMember = [&](CBattleEntity* PPartyTarget)
            {
                return PPartyTarget->isAlive() &&
                    POwner->loc.zone == PPartyTarget->loc.zone &&
                    distance(POwner->loc.p, PPartyTarget->loc.p) <= 15.0f;
            };

            static_cast<CCharEntity*>(POwner->PMaster)->ForPartyWithTrusts([&](CBattleEntity* PMember)
            {
                if (isValidMember(PMember) && checkTrigger(PMember, predicate))
                {
                    target = PMember;
                }
            });

            return nullptr;
        };

        bool predicates_all_true = true;
        for (auto& predicate : gambit.predicates)
        {
            auto result = runPredicate(predicate);
            if (!result)
            {
                predicates_all_true = false;
                return;
            }
            target = result;
        }

        if (!predicates_all_true)
        {
            continue;
        }

        for (auto& action : gambit.actions)
        {
            if (action.reaction == G_REACTION::MA)
            {
                if (action.select == G_SELECT::SPECIFIC)
                {
                    auto spell_id = POwner->SpellContainer->GetAvailable(static_cast<SpellID>(action.select_arg));
                    if (spell_id.has_value())
                    {
                        controller->Cast(target->targid, static_cast<SpellID>(spell_id.value()));
                    }
                }
                else if (action.select == G_SELECT::HIGHEST)
                {
                    auto spell_id = POwner->SpellContainer->GetBestAvailable(static_cast<SPELLFAMILY>(action.select_arg));
                    if (spell_id.has_value())
                    {
                        controller->Cast(target->targid, static_cast<SpellID>(spell_id.value()));
                    }
                }
                else if (action.select == G_SELECT::LOWEST)
                {
                    // TODO
                    //auto spell_id = POwner->SpellContainer->GetWorstAvailable(static_cast<SPELLFAMILY>(gambit.action.select_arg));
                    //if (spell_id.has_value())
                    //{
                    //    controller->Cast(target->targid, static_cast<SpellID>(spell_id.value()));
                    //}
                }
                else if (action.select == G_SELECT::RANDOM)
                {
                    auto spell_id = POwner->SpellContainer->GetSpell();
                    if (spell_id.has_value())
                    {
                        controller->Cast(target->targid, static_cast<SpellID>(spell_id.value()));
                    }
                }
                else if (action.select == G_SELECT::MB_ELEMENT)
                {
                    CStatusEffect* PSCEffect = target->StatusEffectContainer->GetStatusEffect(EFFECT_SKILLCHAIN, 0);
                    std::list<SKILLCHAIN_ELEMENT> resonanceProperties;
                    if (uint16 power = PSCEffect->GetPower())
                    {
                        resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power & 0xF));
                        resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power >> 4 & 0xF));
                        resonanceProperties.push_back((SKILLCHAIN_ELEMENT)(power >> 8));
                    }

                    std::optional<SpellID> spell_id;
                    for (auto& resonance_element : resonanceProperties)
                    {
                        for (auto& chain_element : battleutils::GetSkillchainMagicElement(resonance_element))
                        {
                            // TODO: SpellContianer->GetBestByElement(ELEMENT)
                            // NOTE: Iterating this list in reverse guarantees finding the best match
                            for (size_t i = POwner->SpellContainer->m_damageList.size(); i > 0 ; --i)
                            {
                                auto spell = POwner->SpellContainer->m_damageList[i-1];
                                auto spell_element = spell::GetSpell(spell)->getElement();
                                if (spell_element == chain_element)
                                {
                                    spell_id = spell;
                                    break;
                                }
                            }
                        }
                    }

                    if (spell_id.has_value())
                    {
                        controller->Cast(target->targid, static_cast<SpellID>(spell_id.value()));
                    }
                }
            }
            else if (action.reaction == G_REACTION::JA)
            {
                CAbility* PAbility = ability::GetAbility(action.select_arg);
                if (PAbility->getValidTarget() == TARGET_SELF)
                {
                    target = POwner;
                }
                else
                {
                    target = POwner->GetBattleTarget();
                }

                if (action.select == G_SELECT::SPECIFIC)
                {
                    controller->Ability(target->targid, PAbility->getID());
                }
            }
            else if (action.reaction == G_REACTION::MSG)
            {
                if (action.select == G_SELECT::SPECIFIC)
                {
                    //trustutils::SendTrustMessage(POwner, action.select_arg);
                }
            }

            // Assume success
            if (gambit.retry_delay != 0)
            {
                gambit.last_used = tick;
            }
        }
    }
}

} // namespace gambits
-----------------------------------------
-- Spell: Freeze II
-- Deals ice damage to an enemy and lowers its resistance against fire.
-----------------------------------------
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------------

function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
    local spellParams = {}
    spellParams.hasMultipleTargetReduction = false
    spellParams.resistBonus = 1.0
    spellParams.V = 710
    spellParams.V0 = 900
    spellParams.V50 = 1100
    spellParams.V100 = 1287
    spellParams.V200 = 1662
    spellParams.M = 2
    spellParams.M0 = 4
    spellParams.M50 = 3.74
    spellParams.M100 = 3.75
    spellParams.M200 = 3
    spellParams.I = 780
    spellParams.bonusmab = caster:getMerit(tpz.merit.ANCIENT_MAGIC_ATK_BONUS)
    spellParams.AMIIburstBonus = caster:getMerit(tpz.merit.ANCIENT_MAGIC_BURST_DMG)/100


    -- no point in making a separate function for this if the only thing they won't have in common is the name
    handleNinjutsuDebuff(caster, target, spell, 30, 60, tpz.mod.FIRERES)
	
	if (damage > 0) then
        local duration = 60
        local resist = applyResistanceAddEffect(player, target, tpz.magic.ele.WIND, 0)
        if (target:hasStatusEffect(tpz.effect.DEFENSE_DOWN) == false) and resist >= 0.5  then
            target:addStatusEffect(tpz.effect.DEFENSE_DOWN, 18.75, 0, duration * resist)
        end
		local resist = applyResistanceAddEffect(player, target, tpz.magic.ele.ICE, 0)
        if (target:hasStatusEffect(tpz.effect.EVASION_DOWN) == false) and resist >= 0.5  then
            target:addStatusEffect(tpz.effect.EVASION_DOWN, 20, 0, duration * resist)
        end
    end

    return doElementalNuke(caster, spell, target, spellParams)
end

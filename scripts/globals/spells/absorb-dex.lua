--------------------------------------
-- Spell: Absorb-DEX
-- Steals an enemy's dexterity.
--------------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------------

function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
    local level = player:getMainLvl()
    local power = math.floor(3 + (level / 5))

    if (target:hasStatusEffect(tpz.effect.DEX_DOWN) or caster:hasStatusEffect(tpz.effect.DEX_BOOST)) then
        spell:setMsg(tpz.msg.basic.MAGIC_NO_EFFECT) -- no effect
    else
        local dINT = caster:getStat(tpz.mod.INT) - target:getStat(tpz.mod.INT)
        local params = {}
        params.diff = nil
        params.attribute = tpz.mod.INT
        params.skillType = 37
        params.bonus = 0
        params.effect = nil
        local resist = applyResistance(caster, target, spell, params)
        if (resist <= 0.5) then
            spell:setMsg(tpz.msg.basic.MAGIC_RESIST)
        else
            spell:setMsg(tpz.msg.basic.MAGIC_ABSORB_DEX)
            caster:addStatusEffect(tpz.effect.DEX_BOOST, power*resist*((100+(caster:getMod(tpz.mod.AUGMENTS_ABSORB)))/100), ABSORB_SPELL_TICK, power*ABSORB_SPELL_TICK) -- caster gains DEX
            target:addStatusEffect(tpz.effect.DEX_DOWN, power*resist*((100+(caster:getMod(tpz.mod.AUGMENTS_ABSORB)))/100), ABSORB_SPELL_TICK, power*ABSORB_SPELL_TICK)    -- target loses DEX
        end
    end
    return tpz.effect.DEX_DOWN
end

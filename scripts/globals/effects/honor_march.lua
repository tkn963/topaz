-----------------------------------
--
--    tpz.effect.HONOR_MARCH
-- getPower returns the TIER (e.g. 1, 2, 3, 4)
-- DO NOT ALTER ANY OF THE EFFECT VALUES! DO NOT ALTER EFFECT POWER!
-- Todo: Find a better way of doing this. Need to account for varying modifiers + CASTER's skill (not target)
-----------------------------------
require("scripts/globals/status")
-----------------------------------

function onEffectGain(target, effect)
    target:addMod(tpz.mod.HASTE_MAGIC, effect:getPower())
    target:addMod(tpz.mod.ATT, effect:getSubPower())
end

function onEffectTick(target, effect)
end

function onEffectLose(target, effect)
    target:delMod(tpz.mod.HASTE_MAGIC, effect:getPower())
    target:delMod(tpz.mod.ATT, effect:getSubPower())
end

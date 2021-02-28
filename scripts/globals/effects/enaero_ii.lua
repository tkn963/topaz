-----------------------------------
--
--
--
-----------------------------------
require("scripts/globals/status")
-----------------------------------

function onEffectGain(target, effect)
    target:addMod(tpz.mod.ENSPELL, tpz.magic.element.WIND + 8) -- Tier IIs have higher "enspell IDs"
    target:addMod(tpz.mod.ENSPELL_DMG, 14 + effect:getPower())
    target:addMod(tpz.mod.SUBTLE_BLOW, 10)
end

function onEffectTick(target, effect)
end

function onEffectLose(target, effect)
    target:setMod(tpz.mod.ENSPELL_DMG, 0)
    target:setMod(tpz.mod.ENSPELL, 0)
    target:delMod(tpz.mod.SUBTLE_BLOW, 10)
end

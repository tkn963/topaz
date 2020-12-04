-----------------------------------------
-- ID: 5644
-- Item: jack-o-pie
-- Food Effect: 1hour, All Races
-----------------------------------------
-- MP 45
-- CHR -1
-- Intelligence 4
-- +21% Macc(cap: 10)
-- -5 ENMITY
-- +5 MP recovered while healing
-----------------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------------

function onItemCheck(target)
    local result = 0
    if target:hasStatusEffect(tpz.effect.FOOD) or target:hasStatusEffect(tpz.effect.FIELD_SUPPORT_FOOD) then
        result = tpz.msg.basic.IS_FULL
    end
    return result
end

function onItemUse(target)
    target:addStatusEffect(tpz.effect.FOOD, 0, 0, 3600, 5644)
end

function onEffectGain(target, effect)
    target:addMod(tpz.mod.MP, 45)
    target:addMod(tpz.mod.CHR, -1)
    target:addMod(tpz.mod.INT, 4)
    target:addMod(tpz.mod.FOOD_MACCP, 21)
    target:addMod(tpz.mod.FOOD_MACC_CAP, 10)
    target:addMod(tpz.mod.ENMITY, -5)
    target:addMod(tpz.mod.MPHEAL, 5)
end

function onEffectLose(target, effect)
    target:delMod(tpz.mod.MP, 45)
    target:delMod(tpz.mod.CHR, -1)
    target:delMod(tpz.mod.INT, 4)
    target:delMod(tpz.mod.FOOD_MACCP, 21)
    target:delMod(tpz.mod.FOOD_MACC_CAP, 10)
    target:delMod(tpz.mod.ENMITY, -5)
    target:delMod(tpz.mod.MPHEAL, 5)
end

-----------------------------------------
-- ID: 4525
-- Item: pumpkin_pie_+1
-- Food Effect: 60Min, All Races
-----------------------------------------
-- Magic 45
-- Intelligence 4
-- Charisma -1
-- MP Recovered While Healing 1
-- Macc +21%(Cap: 24)
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
    target:addStatusEffect(tpz.effect.FOOD, 0, 0, 3600, 4525)
end

function onEffectGain(target, effect)
    target:addMod(tpz.mod.MP, 45)
    target:addMod(tpz.mod.MND, 3)
    target:addMod(tpz.mod.CHR, -1)
    target:addMod(tpz.mod.MPHEAL, 1)
    target:addMod(tpz.mod.FOOD_MACCP, 21)
    target:addMod(tpz.mod.FOOD_MACC_CAP, 12)
end

function onEffectLose(target, effect)
    target:delMod(tpz.mod.MP, 45)
    target:delMod(tpz.mod.MND, 3)
    target:delMod(tpz.mod.CHR, -1)
    target:delMod(tpz.mod.MPHEAL, 1)
    target:delMod(tpz.mod.FOOD_MACCP, 21)
    target:delMod(tpz.mod.FOOD_MACC_CAP, 12)
end

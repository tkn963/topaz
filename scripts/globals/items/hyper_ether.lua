-----------------------------------------
-- ID: 5255
-- Item: Hyper-Ether
-- Item Effect: Restores 125 MP
-----------------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")

function onItemCheck(target)
    if (target:getMP() == target:getMaxMP()) then
        return tpz.msg.basic.ITEM_UNABLE_TO_USE
    elseif (target:hasStatusEffect(tpz.effect.MEDICINE)) then
        return tpz.msg.basic.ITEM_NO_USE_MEDICATED
    end
    return 0
end

function onItemUse(target)
    target:messageBasic(tpz.msg.basic.RECOVERS_MP, 0, target:addMP(400*ITEM_POWER))
    --target:addStatusEffect(tpz.effect.MEDICINE, 0, 0, 300)
end

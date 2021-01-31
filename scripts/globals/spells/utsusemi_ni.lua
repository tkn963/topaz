-----------------------------------------
-- Spell: Utsusemi: Ni
-----------------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------------
--[[
function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
    local effect = target:getStatusEffect(tpz.effect.COPY_IMAGE)

    -- Get extras shadows
    local numShadows = 3
    local icon = tpz.effect.COPY_IMAGE_3

    if (caster:getMainJob() == tpz.job.NIN) then
        numShadows = 4 + target:getMod(tpz.mod.UTSUSEMI_BONUS)
        icon = tpz.effect.COPY_IMAGE_4
    end

    if (effect == nil or effect:getPower() <= 2) then
        target:addStatusEffectEx(tpz.effect.COPY_IMAGE, icon, 2, 0, 900, 0, numShadows)
        spell:setMsg(tpz.msg.basic.MAGIC_GAIN_EFFECT)
    else
        spell:setMsg(tpz.msg.basic.MAGIC_NO_EFFECT)
    end

    return tpz.effect.COPY_IMAGE
end
--]]


function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
function onSpellCast(caster,target,spell)
    local effect = target:getStatusEffect(tpz.effect.COPY_IMAGE)
	and target:delStatusEffect(67) -- Third Eye and Utsusemi don't stack.  Utsusemi removes Third Eye.

    -- Get extras shadows
    local numShadows = 3
    local icon = tpz.effect.COPY_IMAGE_3

    if (caster:getMainJob() == tpz.job.NIN) then
        numShadows = 4 + target:getMod(tpz.mod.UTSUSEMI_BONUS)
        icon = tpz.effect.COPY_IMAGE_4
    end

    if (effect == nil or effect:getPower() <= 2) then
        target:addStatusEffectEx(tpz.effect.COPY_IMAGE, icon, 2, 0, 900, 0, numShadows)
        spell:setMsg(tpz.msg.basic.MAGIC_GAIN_EFFECT)
    else
        spell:setMsg(tpz.msg.basic.MAGIC_NO_EFFECT)
    end

    return tpz.effect.COPY_IMAGE
end
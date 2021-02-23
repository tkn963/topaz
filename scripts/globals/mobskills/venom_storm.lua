---------------------------------------------
--
-- Venom Storm
--
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
---------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    local typeEffect = tpz.effect.POISON

    skill:setMsg(MobStatusEffectMove(mob, target, typeEffect, 30, 3, 60))
    return typeEffect
end

---------------------------------------------
--
-- Venom Breath
--
---------------------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/monstertpmoves")
---------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    local typeEffect = tpz.effect.POISON
    MobStatusEffectMove(mob, target, typeEffect, 100, 3, 60)

    local dmgmod = MobBreathMove(mob, target, 0.25, 1, tpz.magic.ele.WATER, 100)
    local dmg = MobFinalAdjustments(dmgmod, mob, skill, target, tpz.attackType.BREATH, tpz.damageType.ICE, MOBPARAM_IGNORE_SHADOWS)
    target:takeDamage(dmg, mob, tpz.attackType.BREATH, tpz.damageType.ICE)
    return dmg
end

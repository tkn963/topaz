---------------------------------------------------
-- Dark Star
-- Deals dark elemental damage to enemies in a '18 radius. Additional effect: Defense Down and Magic Defense Down.
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
---------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)

    MobStatusEffectMove(mob, target, tpz.effect.DEFENSE_DOWN, 25, 0, 30)
    MobStatusEffectMove(mob, target, tpz.effect.MAGIC_DEFENSE_DOWN, 25, 0, 30)

    local dmgmod = 1
    local info = MobMagicalMove(mob, target, skill, mob:getWeaponDmg() * 3, tpz.magic.ele.DARK, dmgmod, TP_NO_EFFECT, 1)
    local dmg = MobFinalAdjustments(info.dmg, mob, skill, target, tpz.attackType.MAGICAL, tpz.damageType.DARK, MOBPARAM_WIPE_SHADOWS)
    target:takeDamage(dmg, mob, tpz.attackType.MAGICAL, tpz.damageType.DARK)
    return dmg
end

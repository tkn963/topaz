---------------------------------------------
--  Eyes on Me
--  Deals dark damage to an enemy.
--  Spell Type: Magical (Dark)
--  Range: Casting range 13'
---------------------------------------------

require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/monstertpmoves")

---------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    local dmgmod = mob:getWeaponDmg() * 5

    local dmg = MobFinalAdjustments(dmgmod, mob, skill, target, tpz.attackType.SPECIAL, tpz.damageType.ELEMENTAL, MOBPARAM_IGNORE_SHADOWS)

    target:takeDamage(dmg, mob, tpz.attackType.SPECIAL, tpz.damageType.ELEMENTAL)
	if dmg > 0 then
		dmg = 500
	end

    return dmg
end

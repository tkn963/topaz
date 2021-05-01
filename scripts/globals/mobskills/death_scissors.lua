---------------------------------------------
--  Death Scissors
--
--  Description: Damage varies with TP.
--  Type: Physical (Slashing)
--
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
    local numhits = 1
    local accmod = 1
    local dmgmod = 3
    local info = MobPhysicalMove(mob, target, skill, numhits, accmod, dmgmod, TP_CRIT_VARIES, 1.5, 1.75, 2)
    local dmg = MobFinalAdjustments(info.dmg, mob, skill, target, tpz.attackType.PHYSICAL, tpz.damageType.SLASHING, info.hitslanded)

    -- keep damage around 700
  --  if (dmg > 700) then
    --    dmg = dmg * 0.7
    --end

    target:takeDamage(dmg, mob, tpz.attackType.PHYSICAL, tpz.damageType.SLASHING)
	if dmg > 0 then target:tryInterruptSpell(mob, info.hitslanded) end
    return dmg
end

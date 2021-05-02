---------------------------------------------------
-- Slam Dunk
-- Deals damage to a single target. Additional effect: bind
---------------------------------------------------

require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/monstertpmoves")

---------------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)

    local numhits = 1
    local accmod = 1
    local dmgmod = 1.5
    local info = MobPhysicalMove(mob, target, skill, numhits, accmod, dmgmod, TP_NO_EFFECT)
    local dmg = MobFinalAdjustments(info.dmg, mob, skill, target, tpz.attackType.PHYSICAL, tpz.damageType.H2H, info.hitslanded)

    local typeEffect = tpz.effect.BIND

    if mob:isInDynamis() then 
        dmgmod = 3
    end

    target:takeDamage(dmg, mob, tpz.attackType.PHYSICAL, tpz.damageType.H2H)
    MobPhysicalStatusEffectMove(mob, target, skill, typeEffect, 1, 0, 20)
	if dmg > 0 then target:tryInterruptSpell(mob, info.hitslanded) end

    return dmg
end

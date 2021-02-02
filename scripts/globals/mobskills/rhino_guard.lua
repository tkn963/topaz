---------------------------------------------
-- Rhino Guard
--
-- Description: Enhances evasion.
-- Type: Enhancing
-- Utsusemi/Blink absorb: N/A
-- Range: Self
-- Notes: Very sharp evasion increase.
---------------------------------------------
require("scripts/globals/monstertpmoves")
require("scripts/globals/settings")
require("scripts/globals/status")
---------------------------------------------

function onMobSkillCheck(target, mob, skill)
    return 0
end

function onMobWeaponSkill(target, mob, skill)
    local typeEffect = tpz.effect.EVASION_BOOST
    local power = 30 + mob:getMainLvl()
    skill:setMsg(MobBuffMove(mob, typeEffect, power, 0, 60)) -- buffed to 30
    return typeEffect
end

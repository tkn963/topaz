---------------------------------------------
-- Sigh
--
-- Description: Self Evasion Boost. Extremely potent, but quickly decays over time.
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
    local power = 10 + (mob:getMainLvl() / 1)

    skill:setMsg(MobBuffMove(mob, typeEffect, power, 0, 30))
    return typeEffect
end

------------------------------
-- Area: The Eldieme Necropolis
--   Murgleis
------------------------------
require("scripts/globals/hunts")
require("scripts/globals/titles")
require("scripts/globals/mobs")
require("scripts/globals/status")
mixins = {require("scripts/mixins/job_special")}
------------------------------

function onMobSpawn(mob)
    mob:addStatusEffect(tpz.effect.PROTECT, 175, 0, 3600)
    mob:addStatusEffect(tpz.effect.SHELL, 25, 0, 3600)
    mob:addStatusEffect(tpz.effect.PHALANX, 30, 0, 180)
    mob:addStatusEffect(tpz.effect.TEMPER, 15, 0, 180)
    mob:addStatusEffect(tpz.effect.HASTE, 30, 0, 180)
end

function onMobDeath(mob, player, isKiller)
player:PrintToPlayer("Maybe...you...are...worthy...of...my...power...",0,"Murgleis")
end



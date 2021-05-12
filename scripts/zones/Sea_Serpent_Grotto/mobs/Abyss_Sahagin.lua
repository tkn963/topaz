-----------------------------------
-- Area: Sea Serpent Grotto
--   NM: Abyss Sahagin
-----------------------------------
mixins = {require("scripts/mixins/job_special")}
-----------------------------------
function onMobSpawn(mob)
    mob:addMod(tpz.mod.ATTP, 50)
    mob:addMod(tpz.mod.DEFP, 35)
    mob:addMod(tpz.mod.ACC, 50) 
    mob:addMod(tpz.mod.EVA, 20)
    mob:setMobMod(tpz.mobMod.GIL_MIN, 6000)
end

function onMobDeath(mob, player, isKiller)
end

function onMobDespawn(mob)
    mob:setRespawnTime(math.random(1200, 1500)) -- 20 to 25 minutes
end

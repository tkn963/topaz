-----------------------------------
-- Area: Monarch Linn
--  Mob: Watch Hippogryph
-- Beloved of the Atlantes
-----------------------------------
require("scripts/globals/titles")
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------

function onMobSpawn(mob)
     mob:addMod(tpz.mod.DEFP, 20) 
     mob:addMod(tpz.mod.ATTP, 10)
     mob:addMod(tpz.mod.ACC, 30) 
     mob:addMod(tpz.mod.EVA, 30)
     mob:setMobMod(tpz.mobMod.NO_DROPS)
end

function onMobFight(mob, target)
    local hitTrigger = mob:getLocalVar("TriggerHit")
    local Guard = GetMobByID(mob:getID()+1)
    local Guardtwo = GetMobByID(mob:getID()+3)
    local Guardthree = GetMobByID(mob:getID()+5)

    if mob:getHPP() <= 75 and hitTrigger == 0 then
        Guard:spawn()
        Guard:updateEnmity(target)
        mob:setLocalVar("TriggerHit", 1)
        printf("Spawning Guard Hippo #1");
    end
    if mob:getHPP() <= 50 and hitTrigger == 1 then
        Guardtwo:spawn()
        Guard:updateEnmity(target)
        mob:setLocalVar("TriggerHit", 2)
        printf("Spawning Guard Hippo #2");
    end
    if mob:getHPP() <= 25 and hitTrigger == 2 then
        Guardthree:spawn()
        Guard:updateEnmity(target)
        mob:setLocalVar("TriggerHit", 3)
        printf("Spawning Guard Hippo #3");
    end
end


function onMobInitialize(mob)
    mob:setMobMod(tpz.mobMod.ADD_EFFECT, 1)
end

function onAdditionalEffect(mob, target, damage)
    return tpz.mob.onAddEffect(mob, target, damage, tpz.mob.ae.STUN, {chance = 20, duration = 5})
end

function onMobDeath(mob, player, isKiller)
    DespawnMob(mob:getID()+1)
end
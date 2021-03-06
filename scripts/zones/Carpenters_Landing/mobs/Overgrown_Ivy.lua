-----------------------------------
-- Area: Carpenters_Landing
--  Mob: Overgrown Ivy
-----------------------------------
function onMobInitialize(mob)
    mob:setMod(tpz.mod.REGAIN, 50)
    mob:addMod(tpz.mod.DEFP, 20) 
    mob:addMod(tpz.mod.ATTP, 10)
    mob:addMod(tpz.mod.ACC, 30) 
    mob:addMod(tpz.mod.EVA, 30)
    mob:setMod(tpz.mod.REFRESH, 40)
end

function onMobFight( mob, target )
    local HP = mob:getHPP()

    if HP <= 15 then
         mob:setMod(tpz.mod.REGAIN, 3000)
         mob:setMobMod(tpz.mobMod.SKILL_LIST, 1154)
    end
end


function onMobDeath(mob, player, isKiller)
    if (player:getCurrentMission(COP) == tpz.mission.id.cop.THE_ROAD_FORKS and player:getCharVar("EMERALD_WATERS_Status") == 4) then
        player:setCharVar("EMERALD_WATERS_Status", 5)
    end
end

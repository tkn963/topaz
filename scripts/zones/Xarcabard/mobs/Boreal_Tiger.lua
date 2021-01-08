-----------------------------------
-- Area: Xarcabard
--   NM: Boreal Tiger
-- Involved in Quests: Atop the Highest Mountains
-- !pos 341 -29 370 112
-----------------------------------
local ID = require("scripts/zones/Xarcabard/IDs")
require("scripts/globals/keyitems")
require("scripts/globals/settings")
require("scripts/globals/quests")
-----------------------------------

function onMobSpawn(mob)
    -- Failsafe to make sure NPC is down when NM is up
    if OLDSCHOOL_G2 then
        GetNPCByID(ID.npc.BOREAL_TIGER_QM):showNPC(0)
    end
    mob:setMod(tpz.mod.SILENCERES, 100)
    mob:setMod(tpz.mod.SLEEPRES, 100)
     mob:setMod(tpz.mod.LULLABYRES, 100)
    tpz.mix.jobSpecial.config(mob, {
        specials =
        {
            {id = tpz.jsa.MIGHTY_STRIKES, hpp = math.random(50, 50)},
        },
    })
end

function onMobDeath(mob, player, isKiller)
    if OLDSCHOOL_G2 then
        -- show ??? for desired duration
        -- notify people on the quest who need the KI
        GetNPCByID(ID.npc.BOREAL_TIGER_QM):showNPC(FRIGICITE_TIME)
        if
            not player:hasKeyItem(tpz.ki.ROUND_FRIGICITE) and
            player:getQuestStatus(JEUNO, tpz.quest.id.jeuno.ATOP_THE_HIGHEST_MOUNTAINS) == QUEST_ACCEPTED
        then
            player:messageSpecial(ID.text.BLOCKS_OF_ICE)
        end
    end
end

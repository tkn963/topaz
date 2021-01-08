-----------------------------------
-- Area: Xarcabard
--   NM: Boreal Hound
-- Involved in Quests: Atop the Highest Mountains
-- !pos -21 -25 -490 112
-----------------------------------
local ID = require("scripts/zones/Xarcabard/IDs")
require("scripts/globals/keyitems")
require("scripts/globals/settings")
require("scripts/globals/quests")
-----------------------------------

function onMobSpawn(mob)
    -- Failsafe to make sure NPC is down when NM is up
    if OLDSCHOOL_G2 then
        GetNPCByID(ID.npc.BOREAL_HOUND_QM):showNPC(0)
    end
     mob:setMod(tpz.mod.UDMGPHYS, 50)
     mob:setMod(tpz.mod.SLEEPRES, 100)
     mob:setMod(tpz.mod.LULLABYRES, 100)
     tpz.mix.jobSpecial.config(mob, {
        specials =
        {
            {id = tpz.jsa.BLOOD_WEAPON, hpp = math.random(50, 50)},
        },
    })
end

function onMobDeath(mob, player, isKiller)
    if OLDSCHOOL_G2 then
        -- show ??? for desired duration
        -- notify people on the quest who need the KI
        GetNPCByID(ID.npc.BOREAL_HOUND_QM):showNPC(FRIGICITE_TIME)
        if
            not player:hasKeyItem(tpz.ki.TRIANGULAR_FRIGICITE) and
            player:getQuestStatus(JEUNO, tpz.quest.id.jeuno.ATOP_THE_HIGHEST_MOUNTAINS) == QUEST_ACCEPTED
        then
            player:messageSpecial(ID.text.BLOCKS_OF_ICE)
        end
    end
end

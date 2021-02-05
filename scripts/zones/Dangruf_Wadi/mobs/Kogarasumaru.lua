------------------------------
-- Area: The Eldieme Necropolis
--   Kogarasumaru
------------------------------
require("scripts/globals/hunts")
require("scripts/globals/titles")
require("scripts/globals/mobs")
require("scripts/globals/status")
mixins = {require("scripts/mixins/job_special")}
------------------------------

function onMobSpawn(mob)
function onMobSpawn(mob)
    tpz.mix.jobSpecial.config(mob, {
        specials =
        {
            {
                id = tpz.jsa.MEIKYO_SHISUI,
                hpp = 25,
                begCode = function(mob)
                  mob:setMobMod(tpz.mobMod.MOBMOD_SKILL_LIST, 2002)
                  mob:messageText(mob, ID.text.HOW_CAN_YOU_EXPECT_TO_KILL_ME)
               -- mob:PrintToArea("My power is too great for you!",0,"Murgleis")
                end,
                endCode = function(mob)
                  mob:setMobMod(tpz.mobMod.MOBMOD_SKILL_LIST, 2001)
                  mob:messageText(mob, ID.text.WHEN_YOU_CANT_EVEN_HIT_ME)
                end,
            },
        },
    })
end

function onMobDeath(mob, player, isKiller)
player:PrintToPlayer("Maybe...you...are...worthy...of...my...power...",0,"Kogarasumaru")
end



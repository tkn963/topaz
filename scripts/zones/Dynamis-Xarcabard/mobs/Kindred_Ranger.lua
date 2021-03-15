-----------------------------------
-- Area: Dynamis - Xarcabard
--  Mob: Kindred Ranger
-----------------------------------
mixins =
{
    require("scripts/mixins/dynamis_beastmen"),
    require("scripts/mixins/job_special")
}
local ID = require("scripts/zones/Dynamis-Xarcabard/IDs")
require("scripts/globals/mobs")
-----------------------------------
function onMobSpawn(mob)
    mob:setMobMod(tpz.mobMod.ATTACK_SKILL_LIST, 1157)
end

function onMobDeath(mob, player, isKiller)
end

function onMobDespawn(mob)
    tpz.mob.phOnDespawn(mob, ID.mob.MARQUIS_CIMERIES_PH, 50, 3600) -- 20 minutes
end



-----------------------------------
-- Area: Dynamis - Beaucedine
--  Mob: Vanguard Ogresoother
-----------------------------------
mixins =
{
    require("scripts/mixins/dynamis_beastmen"),
    require("scripts/mixins/job_special")
}
local ID = require("scripts/zones/Dynamis-Beaucedine/IDs")
require("scripts/globals/mobs")
-----------------------------------

function onMobDeath(mob, player, isKiller)
end

function onMobDespawn(mob)
    tpz.mob.phOnDespawn(mob, ID.mob.SOO_JOPO_THE_FIENDKING_PH, 50, 3600) -- 20 minutes
end

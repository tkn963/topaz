-----------------------------------
-- Area: Dynamis - San d'Oria
--  Mob: Steelshank Kratzvatz
-----------------------------------
mixins =
{
    require("scripts/mixins/dynamis_beastmen"),
    require("scripts/mixins/job_special")
}
-----------------------------------
function onMobSpawn(mob)
     mob:addMod(tpz.mod.DEFP, 30) 
     mob:addMod(tpz.mod.ATTP, 20)
     mob:addMod(tpz.mod.ACC, 50) 
     mob:addMod(tpz.mod.EVA, 30)
     mob:setMod(tpz.mod.REFRESH, 300)
end

function onMobFight(mob, target)
    tpz.mix.jobSpecial.config(mob, {
        between = 60,
        specials =
        {
            {id = tpz.jsa.INVINCIBLE, cooldown = 0, hpp = 90},
            {id = tpz.jsa.FAMILIAR, cooldown = 0, hpp = 90},
        },
    })
end

function onMobDeath(mob, player, isKiller)
end

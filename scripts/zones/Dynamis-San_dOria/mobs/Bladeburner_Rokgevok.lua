-----------------------------------
-- Area: Dynamis - San d'Oria
--  Mob: Bladeburner Rokgevok
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
end

function onMobFight(mob, target)
    tpz.mix.jobSpecial.config(mob, {
        between = 60,
        specials =
        {
            {id = tpz.jsa.MANAFONT, cooldown = 0, hpp = 90},
            {id = tpz.jsa.MIGHTY_STRIKES, cooldown = 0, hpp = 90},
        },
    })
end

function onMobDeath(mob, player, isKiller)
end

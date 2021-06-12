-----------------------------------
-- Blade Teki
-- Katana weapon skill
-- Skill Level: 70
-- Decription: Deals water elemental damage. Damage varies with TP.
-- Aligned with the Aqua Gorget.
-- Aligned with the Aqua Belt.
-- Element: Water
-- Modifiers: STR:20%  INT:20%
-- 100%TP    200%TP    300%TP
-- 0.50      0.75      1.00
-----------------------------------
require("scripts/globals/magic")
require("scripts/globals/status")
require("scripts/globals/settings")
require("scripts/globals/weaponskills")
-----------------------------------

function onUseWeaponSkill(player, target, wsID, tp, primary, action, taChar)

    local params = {}
    params.numHits = 1
    params.ftp100 = 1.5 params.ftp200 = 1.7 params.ftp300 = 2.0
    params.str_wsc = 0.0 params.dex_wsc = 0.2 params.vit_wsc = 0.0 params.agi_wsc = 0.2 params.int_wsc = 0.0 params.mnd_wsc = 0.0 params.chr_wsc = 0.0
    params.acc100 = 0.0 params.acc200= 0.0 params.acc300= 0.0
    params.atk100 = 1 params.atk200 = 1 params.atk300 = 1
    params.hybridWS = true
    params.ele = tpz.magic.ele.WATER
    params.skill = tpz.skill.KATANA

    if (USE_ADOULIN_WEAPON_SKILL_CHANGES == true) then
        params.str_wsc = 0.3 params.int_wsc = 0.3
    end

    local damage, criticalHit, tpHits, extraHits = doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)
	if damage > 0 then player:trySkillUp(target, tpz.skill.KATANA, tpHits+extraHits) end
	if damage > 0 then target:tryInterruptSpell(player, tpHits+extraHits) end

    return tpHits, extraHits, criticalHit, damage

end

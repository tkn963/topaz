-----------------------------------------
-- Spell: Sickle Slash
-- Deals critical damage. Chance of critical hit varies with TP
-- Spell cost: 41 MP
-- Monster Type: Vermin
-- Spell Type: Physical (Blunt)
-- Blue Magic Points: 4
-- Stat Bonus: HP-5, MP+15
-- Level: 48
-- Casting Time: 0.5 seconds
-- Recast Time: 20.5 seconds
-- Skillchain Element: Dark (can open Transfixion or Detonation can close Compression or Gravitation)
-- Combos: Store TP
-----------------------------------------
require("scripts/globals/bluemagic")
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------------

function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
    local params = {}
    -- This data should match information on http://wiki.ffxiclopedia.org/wiki/Calculating_Blue_Magic_Damage
    params.tpmod = TPMOD_CRITICAL
    params.attackType = tpz.attackType.PHYSICAL
    params.damageType = tpz.damageType.HTH
    params.scattr = SC_COMPRESSION
    params.numhits = 1
    params.multiplier = 3.1
    params.tp150 = 3.1
    params.tp300 = 3.1
    params.azuretp = 3.1
    params.duppercap = 49
    params.str_wsc = 0.0
    params.dex_wsc = 0.5
    params.vit_wsc = 0.0
    params.agi_wsc = 0.0
    params.int_wsc = 0.0
    params.mnd_wsc = 0.0
    params.chr_wsc = 0.0
	params.attkbonus = 2.0
    params.crit150 = 0.50; params.crit300 = 1.0
    damage = BluePhysicalSpell(caster, target, spell, params)
	local plantoid = (target:getSystem() == 17)
	local lizard = (target:getSystem() == 14)
	
	if plantoid then
		damage = damage * 1.25
	elseif lizard then
		damage = damage * 0.75
	end
    damage = BlueFinalAdjustments(caster, target, spell, damage, params)

    return damage
end

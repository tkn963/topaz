-----------------------------------------
-- Spell: Vertical Cleave
-- Damage varies with TP
-- Spell cost: 86 MP
-- Monster Type: Luminians
-- Spell Type: Physical (Slashing)
-- Blue Magic Points: 3
-- Stat Bonus: VIT+1 HP-5 MP+5
-- Level: 75
-- Casting Time: 0.5 seconds
-- Recast Time: 37.25 seconds
-- Skillchain Element(s): Gravitation (can open/close Darkness with Distortion WSs and spells)
-- Combos: Defense Bonus
-- TODO: Ignores Shadows
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
    params.tpmod = TPMOD_ATTACK
    params.attackType = tpz.attackType.PHYSICAL
    params.damageType = tpz.damageType.SLASHING
    params.scattr = SC_GRAVITATION
    params.numhits = 1
    params.multiplier = 3.5
    params.tp150 = 3.5
    params.tp300 = 3.5
    params.azuretp = 3.5
    params.duppercap = 75
    params.str_wsc = 0.4
    params.dex_wsc = 0.0
    params.vit_wsc = 0.0
    params.agi_wsc = 0.0
    params.int_wsc = 0.0
    params.mnd_wsc = 0.0
    params.chr_wsc = 0.0
	params.attkbonus = 2.0
    params.atk150 = 1.5; params.atk300 = 2.0
    damage = BluePhysicalSpell(caster, target, spell, params)
    damage = BlueFinalAdjustments(caster, target, spell, damage, params)

    return damage
end

-----------------------------------------
-- Spell: Magic Hammer
-- Steals an amount of enemy's MP equal to damage dealt. Ineffective against undead
-- Spell cost: 40 MP
-- Monster Type: Beastmen
-- Spell Type: Magical (Light)
-- Blue Magic Points: 4
-- Stat Bonus: MP-5, MND+2
-- Level: 74
-- Casting Time: 4 seconds
-- Recast Time: 180 seconds
-- Magic Bursts on: Transfixion, Fusion, and Light
-- Combos: Magic Attack Bonus
-- Notes:
-- Modifiers: MND 30%.
-- Affected by Magic Attack Bonus.
-- The bonus from Light Staff/Apollo's Staff affects both accuracy and amount of MP drained.
-- The bonuses from weather/day effects and Korin/Hachirin-no-Obi affect both accuracy and amount of MP drained.
-- Can only drain MP from targets that have MP and cannot drain more MP than the target has.
-- Damage and MP drained are enhanced by both Magic Attack Bonus and Magic Attack from Convergence.
-----------------------------------------
require("scripts/globals/bluemagic")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------------

function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)
    local dmg = utils.clamp(20 + 0.8 * caster:getSkillLevel(tpz.skill.BLUE_MAGIC), 0, 500)
    local multi = 1.5

    if (caster:hasStatusEffect(tpz.effect.AZURE_LORE)) then
        multi = multi + 2.0
    end

    local params = {}
    -- This data should match information on http://wiki.ffxiclopedia.org/wiki/Calculating_Blue_Magic_Damage
    params.attackType = tpz.attackType.MAGICAL
    params.damageType = tpz.damageType.LIGHT
    params.diff = caster:getStat(tpz.mod.MND)-target:getStat(tpz.mod.MND)
    params.attribute = tpz.mod.MND
    params.skillType = tpz.skill.BLUE_MAGIC
    params.multiplier = multi
    params.tMultiplier = 1.0
    params.duppercap = 35
    params.str_wsc = 0.0
    params.dex_wsc = 0.0
    params.vit_wsc = 0.0
    params.agi_wsc = 0.0
    params.int_wsc = 0.0
    params.mnd_wsc = 0.30
    params.chr_wsc = 0.0
    local resist = applyResistance(caster, target, spell, params)
	   
	-- get the resisted damage
    dmg = dmg*resist
    -- add on bonuses (staff/day/weather/jas/mab/etc all go in this function)
	dmg = BlueMagicalSpell(caster, target, spell, params, MND_BASED)
	-- add dmg variance 
	dmg = (dmg * math.random(85, 115)) / 100
	-- add SDT
    local SDT = target:getMod(tpz.mod.SDT_LIGHT)
	
	dmg = dmg * (SDT / 100)
	-- add final adjustments
	dmg = BlueFinalAdjustments(caster, target, spell, dmg, params)
   
   if dmg > 0 and resist >= 0.5  then
		dmg = dmg * BLUE_POWER
		caster:addMP(dmg)
	end


    return dmg
end

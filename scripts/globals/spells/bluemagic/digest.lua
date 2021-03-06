-----------------------------------------
-- Spell: Digest
-- Steals an enemy's HP. Ineffective against undead
-- Spell cost: 20 MP
-- Monster Type: Amorphs
-- Spell Type: Magical (Dark)
-- Blue Magic Points: 2
-- Stat Bonus: HP-5, MP+5
-- Level: 36
-- Casting Time: 4 seconds
-- Recast Time: 90 seconds
-- Magic Bursts on: Compression, Gravitation, Darkness
-- Combos: None
-----------------------------------------
require("scripts/globals/magic")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------------

function onMagicCastingCheck(caster, target, spell)
    return 0
end

function onSpellCast(caster, target, spell)

    local dmg = 20 + caster:getSkillLevel(tpz.skill.BLUE_MAGIC)
    local multi = 1.5
	
    if (caster:hasStatusEffect(tpz.effect.AZURE_LORE)) then
        multi = multi + 2.0
    end
    --get resist multiplier (1x if no resist)
    local params = {}
    params.diff = caster:getStat(tpz.mod.MND)-target:getStat(tpz.mod.MND)
    params.attribute = tpz.mod.MND
    params.skillType = tpz.skill.BLUE_MAGIC
    params.bonus = 1.0
    params.multiplier = multi
    local resist = applyResistance(caster, target, spell, params)
    --get the resisted damage
    dmg = dmg*resist
    --add on bonuses (staff/day/weather/jas/mab/etc all go in this function)
    dmg = addBonuses(caster, spell, target, dmg)
    --add in target adjustment
    dmg = adjustForTarget(target, dmg, spell:getElement())
    --add in final adjustments

    if (dmg < 0) then
        dmg = 0
    end

    if (target:getHP() < dmg) then
        dmg = target:getHP()
    end

    params.attackType = tpz.attackType.MAGICAL
    params.damageType = tpz.damageType.DARK
	local bird = (target:getSystem() == 8)
	local aquan = (target:getSystem() == 2)
	-- add correlation bonus
	if bird then
	 	dmg = dmg * 1.25
	elseif aquan then
		dmg = dmg * 0.75
	end
	-- add SDT
    local SDT = target:getMod(tpz.mod.SDT_DARK)
	
	dmg = dmg * (SDT / 100)
	-- add final adjustments
    dmg = BlueFinalAdjustments(caster, target, spell, dmg, params)
 
 if dmg > 0 and resist >= 0.5  then
		dmg = dmg * BLUE_POWER
		caster:addHP(dmg)
	end


    return dmg
end

this.el_temp_weaken_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Count = 1
	},
	function create()
	{
		this.m.ID = "el_effects.temp_weaken";
		this.m.Name = "Temp Weaken";
		this.m.Description = "This character was weakened in a short period of time.";
		this.m.Icon = "skills/el_temp_weaken_effect.png";
		//this.m.IconMini = "el_temp_weaken_effect_mini";
		this.m.Overlay = "el_temp_weaken_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenBravery * this.m.Count + "[/color] Bravery"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenInitiative * this.m.Count + "[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenMeleeSkill * this.m.Count + "[/color] Melee Skill"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenRangedSkill * this.m.Count + "%[/color] Ranged Skill"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenMeleeDefense * this.m.Count + "[/color] Melee Defense"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenRangedDefense * this.m.Count + "%[/color] Ranged Defense"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Received an additional " + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenDamageReceivedTotalMult * this.m.Count * 100 + "% damage[/color]"
			}
		];
	}

	function onRefresh()
	{
		++this.m.Count;
		this.spawnIcon("el_temp_weaken_effect", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.Bravery -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenBravery * this.m.Count;
		_properties.Initiative -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenInitiative * this.m.Count;
		_properties.MeleeSkill -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenMeleeSkill * this.m.Count;
		_properties.RangedSkill -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenRangedSkill * this.m.Count;
		_properties.MeleeDefense -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenMeleeDefense * this.m.Count;
		_properties.RangedDefense -= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenRangedDefense * this.m.Count;
		_properties.DamageReceivedTotalMult *= (this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FightAndWin.TempWeakenDamageReceivedTotalMult * this.m.Count + 1);
		//this.logInfo("target properties impress by temp weaken:" + this.m.Count);
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

	function onNewRound()
	{
		this.removeSelf();
	}
});


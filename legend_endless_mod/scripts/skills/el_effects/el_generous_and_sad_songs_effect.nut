this.el_generous_and_sad_songs_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_rarity_effects.generous_and_sad_songs";
		this.m.Name = "Generous and Sad Songs";
		this.m.Description = "Magnificent music can elevate one's state.";
		this.m.Icon = "el_skills/generous_and_sad_songs_effect.png";
		//this.m.IconMini = "el_generous_and_sad_songs_effect_mini";
		this.m.Overlay = "el_generous_and_sad_songs_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{		
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.InitiativeOffset + "[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeSkillOffset + "[/color] Melee Skill"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedSkillOffset + "[/color] Ranged Skill"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeDefenseOffset + "[/color] Melee Defense"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedDefenseOffset + "[/color] Ranged Defense"
			}
		]);
		return tooltip;
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.InitiativeOffset;
		_properties.MeleeSkill += this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeSkillOffset;
		_properties.RangedSkill += this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedSkillOffset;
		_properties.MeleeDefense += this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeDefenseOffset;
		_properties.RangedDefense += this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedDefenseOffset;
	}

	function onRoundEnd()
	{
		this.removeSelf();
	}
});


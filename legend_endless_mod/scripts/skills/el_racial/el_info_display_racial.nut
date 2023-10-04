this.el_info_display_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_racial.info_display";
		this.m.Name = "Info Display";
		this.m.Description = "";
		this.m.Icon = "skills/status_effect_108.png";
		this.m.IconMini = "status_effect_108_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function EL_refresh()
	{
		local actor = this.getContainer().getActor();
		local properties = actor.getCurrentProperties();
		local rank = actor.EL_getRankLevel();
		local melee_skill = this.Math.floor(properties.MeleeSkill * (properties.MeleeSkill >= 0 ? properties.MeleeSkillMult : 1.0 / properties.MeleeSkillMult));
		local ranged_skill = this.Math.floor(properties.RangedSkill * (properties.RangedSkill >= 0 ? properties.RangedSkillMult : 1.0 / properties.RangedSkillMult));
		local melee_defense = this.Math.floor(properties.MeleeDefense * (properties.MeleeDefense >= 0 ? properties.MeleeDefenseMult : 1.0 / properties.MeleeDefenseMult));
		local ranged_defense = this.Math.floor(properties.RangedDefense * (properties.RangedDefense >= 0 ? properties.RangedDefenseMult : 1.0 / properties.RangedDefenseMult));
		this.m.Name = "Atk: " + melee_skill + " " + ranged_skill + " Def: " + melee_defense + " " + ranged_defense;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local rank = actor.EL_getRankLevel();
		this.m.Icon = this.Const.EL_NPC.EL_Champion.Icon[rank];
		this.m.IconMini = this.Const.EL_NPC.EL_Champion.IconMini[rank];
	}
});


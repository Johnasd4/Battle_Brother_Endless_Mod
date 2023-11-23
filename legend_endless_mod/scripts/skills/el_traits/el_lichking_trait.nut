this.el_lichking_trait <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_trait.undead";
		this.m.Name = "巫妖王";
		this.m.Icon = "ui/backgrounds/warlock_02.png";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "免疫流血、眩晕、茫然、伤残、毒素、瘴气、恐惧和精神控制。不消耗食物。"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Experience Gain, [color=" + this.Const.UI.Color.PositiveValue + "]+ 40[/color] 决心"
			}
		]);
		return tooltip;
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood = 0;
		_properties.IsAffectedByInjuries = false;
        _properties.IsImmuneToStun = true;
        _properties.IsImmuneToBleeding = true;
        _properties.IsImmuneToPoison = true;
        _properties.IsResistantToMiasma = true;
        _properties.IsImmuneToDaze = true;
		_properties.Bravery += 40;
		_properties.XPGainMult *= 1.25;
	}

	function onCombatStarted()
	{
		local roster = this.World.getPlayerRoster();
		local bros = roster.getAll();
		foreach(bro in bros)
		{
			if(bro != this.getContainer().getActor() && !bro.getSkills().hasSkill("el_trait.undead"))
			{
				bro.getSkills().add(this.new("scripts/skills/el_effects/el_become_undead_effect"));
			}
		}
	}
});
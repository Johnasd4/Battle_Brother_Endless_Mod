this.el_core_skill <- this.inherit("scripts/skills/skill", {
	m = {
		EL_PropertiesXPNeed = [],
		EL_Properties = []
	},
	function create()
	{
		this.m.ID = "el_items.core_skill";
		this.m.Name = "Core Strengthen";
		this.m.Description = "The core used will strengthen your men.";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.Icon = "el_skills/el_core_skill.png";
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			this.m.EL_PropertiesXPNeed.push(1);
			this.m.EL_Properties.push(0);
		}
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = "Hitpoints [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.Hitpoints] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.Hitpoints] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = "Resolve [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.Bravery] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.Bravery] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Stamina [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.Fatigue] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.Fatigue] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "Initiative [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.Initiative] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.Initiative] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/melee_skill.png",
			text = "Melee Skill [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.MeleeSkill] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.MeleeSkill] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = "Ranged Skill [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.RangedSkill] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.RangedSkill] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = "Melee Defense [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.MeleeDefense] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.MeleeDefense] +
				   "[/color] XP)"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "Ranged Defense [color=" + this.Const.UI.Color.PositiveValue + "]+" +
				   this.m.EL_Properties[this.Const.Attributes.RangedDefense] +
				   "[/color] (Next level : [color=" + this.Const.UI.Color.PositiveValue + "]" +
				   EL_PropertiesXPNeed[this.Const.Attributes.RangedDefense] +
				   "[/color] XP)"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += this.m.EL_Properties[this.Const.Attributes.Hitpoints];
		_properties.Bravery += this.m.EL_Properties[this.Const.Attributes.Bravery];
		_properties.Stamina += this.m.EL_Properties[this.Const.Attributes.Fatigue];
		_properties.Initiative += this.m.EL_Properties[this.Const.Attributes.Initiative];
		_properties.MeleeSkill += this.m.EL_Properties[this.Const.Attributes.MeleeSkill];
		_properties.RangedSkill += this.m.EL_Properties[this.Const.Attributes.RangedSkill];
		_properties.MeleeDefense += this.m.EL_Properties[this.Const.Attributes.MeleeDefense];
		_properties.RangedDefense += this.m.EL_Properties[this.Const.Attributes.RangedDefense];
	}

	function onSerialize( _out )
	{
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			_out.writeI32(this.m.EL_PropertiesXPNeed[i]);
			_out.writeI32(this.m.EL_Properties[i]);
		}
	}

	function onDeserialize( _in )
	{
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			this.m.EL_PropertiesXPNeed[i] = _in.readI32();
			this.m.EL_Properties[i] = _in.readI32();
		}
	}

	function EL_addPropertiesXP( _EL_xp, _EL_propertyType ) {
		this.m.EL_PropertiesXPNeed[_EL_propertyType] -= _EL_xp;
		while(this.m.EL_PropertiesXPNeed[_EL_propertyType] <= 0) {
			this.m.EL_Properties[_EL_propertyType] += 1;
			this.m.EL_PropertiesXPNeed[_EL_propertyType] += this.m.EL_Properties[_EL_propertyType] + 1;
		}
	}

});


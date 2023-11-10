this.el_player_ballance_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_racial.player_ballance";
		this.m.Name = "";
		this.m.Icon = "";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
        local base_properties = this.getContainer().getActor().getBaseProperties();
        _properties.MeleeSkill += this.Math.Max(0, base_properties.RangedSkill - base_properties.MeleeSkill - 50);
        _properties.RangedSkill += this.Math.Max(0, base_properties.MeleeSkill - base_properties.RangedSkill - 50);
	}


});


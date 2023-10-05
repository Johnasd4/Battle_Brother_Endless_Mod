this.el_additional_accuracy_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_AdditionalAccuracy = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_AdditionalAccuracy.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]chance to hit + " + this.m.EL_AdditionalAccuracy + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_AdditionalAccuracy <= this.Const.EL_Weapon.EL_Entry.Factor.EL_AdditionalAccuracy.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_AdditionalAccuracy.RandomMinAdditionalAccuracy[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_AdditionalAccuracy.RandomMaxAdditionalAccuracy[this.getItem().m.EL_RankLevel];
		this.m.EL_AdditionalAccuracy = this.Const.EL_Weapon.EL_Entry.Factor.EL_AdditionalAccuracy.BaseAdditionalAccuracy + this.Math.rand(randomMin, randomMax);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.m.IsWeaponSkill)
		{
            local user = this.getContainer().getActor();
			if(_skill.m.IsRanged)
			{
				_properties.RangedSkill += this.m.EL_AdditionalAccuracy;
			}
			else
			{
				_properties.MeleeSkill += this.m.EL_AdditionalAccuracy;
			}
		}
	}
	
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_AdditionalAccuracy);
	}

	function onDeserialize( _in )
	{
		this.m.EL_AdditionalAccuracy = _in.readI32();
	}
});
this.el_ranged_range_max_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_RangeMax = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMax.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Weapon Skill range + " + this.Math.floor(this.m.EL_RangeMax) + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_RangeMax <= this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMax.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMax.RandomMinRangeMax[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMax.RandomMaxRangeMax[this.getItem().m.EL_RankLevel];
		this.m.EL_RangeMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMax.BaseRangeMax + this.Math.rand(randomMin, randomMax);
	}

	function onAfterUpdate( _properties )
	{
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (skill.m.IsWeaponSkill)
			{
				skill.m.MaxRange += this.Math.floor(this.m.EL_RangeMax);
			}
		}
	}

	function EL_strengthen()
	{
		this.m.EL_RangeMax = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_RangeMax.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_RangeMax += this.Const.EL_Weapon.EL_Entry.Factor.EL_RangeMax.RandomMaxRangeMax[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_RangedRangeMax += this.Math.floor(this.m.EL_RangeMax);
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_RangeMax);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangeMax = _in.readF32();
	}
});
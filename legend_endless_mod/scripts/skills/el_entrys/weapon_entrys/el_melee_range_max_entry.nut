this.el_melee_range_max_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_RangeMax = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeRangeMax.ID;
        this.m.EL_RangeMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeRangeMax.RangeMax;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]武器技能射程 + " + this.m.EL_RangeMax + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		_properties.Vision += this.m.EL_RangeMax;
	}

	function onAfterUpdate( _properties )
	{
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (skill.m.IsWeaponSkill)
			{
				skill.m.MaxRange += this.m.EL_RangeMax;
			}
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_MeleeRangeMax += this.m.EL_RangeMax;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_RangeMax);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangeMax = _in.readI32();
	}
});
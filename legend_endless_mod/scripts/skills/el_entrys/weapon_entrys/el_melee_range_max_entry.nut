this.el_melee_range_max_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_RangeMaxAddition = 0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeRangeMax.ID;
        this.m.EL_RangeMaxAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeRangeMax.RangeMax;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Weapon Skill range + " + this.m.EL_RangeMaxAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[6];
	}

	function onUpdate( _properties )
	{
		this.el_weapon_entry.onUpdate(_properties);
		_properties.Vision += this.m.EL_RangeMaxAddition;
	}

	function onAfterUpdate( _properties )
	{
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (skill.m.IsWeaponSkill)
			{
				skill.m.MaxRange += this.m.EL_RangeMaxAddition;
			}
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_RangeMaxAddition += this.m.EL_RangeMaxAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_RangeMaxAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangeMaxAddition = _in.readI32();
	}
});
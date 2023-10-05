this.el_ranged_range_max_vision_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_RangeMaxAndVisionAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMaxAndVision.ID;
        this.m.EL_RangeMaxAndVisionAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedRangeMaxAndVision.RangeMaxAndVision;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Weapon Skill range and Vision + " + this.m.EL_RangeMaxAndVisionAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[6];
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Vision += this.m.EL_RangeMaxAndVisionAddition;
	}

	function onAfterUpdate( _properties )
	{
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (skill.m.IsWeaponSkill)
			{
				skill.m.MaxRange += this.m.EL_RangeMaxAndVisionAddition;
			}
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_RangeMaxAndVisionAddition += this.m.EL_RangeMaxAndVisionAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_RangeMaxAndVisionAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangeMaxAndVisionAddition = _in.readI32();
	}
});
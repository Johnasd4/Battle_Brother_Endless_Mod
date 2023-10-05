this.el_hitpoints_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_HitpointsAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_Hitpoints.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Hitpoints + " + this.m.EL_HitpointsAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_HitpointsAddition <= this.Const.EL_Armor.EL_Entry.Factor.EL_Hitpoints.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_Hitpoints.RandomMinHitpoints[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_Hitpoints.RandomMaxHitpoints[this.getItem().m.EL_RankLevel];
		this.m.EL_HitpointsAddition = this.Const.EL_Armor.EL_Entry.Factor.EL_Hitpoints.BaseHitpoints + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Hitpoints += this.m.EL_HitpointsAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_HitpointsAddition += this.m.EL_HitpointsAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_HitpointsAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_HitpointsAddition = _in.readI32();
	}
});
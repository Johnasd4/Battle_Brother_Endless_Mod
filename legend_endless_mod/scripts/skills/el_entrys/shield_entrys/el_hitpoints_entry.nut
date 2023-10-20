this.el_hitpoints_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_Hitpoints = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Hitpoints + " + this.m.EL_Hitpoints + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_Hitpoints <= this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.RandomMinHitpoints[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.RandomMaxHitpoints[this.getItem().m.EL_RankLevel];
		this.m.EL_Hitpoints = this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.BaseHitpoints + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_Hitpoints = this.Const.EL_Shield.EL_Entry.EntryStrengthenMult * this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_Hitpoints += this.Const.EL_Shield.EL_Entry.Factor.EL_Hitpoints.RandomMaxHitpoints[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += this.Math.floor(0.01 * this.m.EL_Hitpoints * this.getContainer().getActor().getBaseProperties().Hitpoints);
	}
	

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_Hitpoints += this.m.EL_Hitpoints;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_Hitpoints);
	}

	function onDeserialize( _in )
	{
		this.m.EL_Hitpoints = _in.readI32();
	}
});
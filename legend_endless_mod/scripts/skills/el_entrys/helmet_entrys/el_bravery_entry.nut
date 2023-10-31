this.el_bravery_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_Bravery = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]决心 + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Bravery) + " (" + this.m.EL_Bravery + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]决心 + " + this.m.EL_Bravery + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_Bravery <= this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.RandomMinBravery[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.RandomMaxBravery[this.getItem().m.EL_RankLevel];
		this.m.EL_Bravery = this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.BaseBravery + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_Bravery = this.Const.EL_Helmet.EL_Entry.EntryStrengthenMult * this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_Bravery += this.Const.EL_Helmet.EL_Entry.Factor.EL_Bravery.RandomMaxBravery[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Bravery);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_Bravery += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Bravery);
	}

    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_Bravery);

	}

	function onDeserialize( _in )
	{
		this.m.EL_Bravery = _in.readI32();
	}
});
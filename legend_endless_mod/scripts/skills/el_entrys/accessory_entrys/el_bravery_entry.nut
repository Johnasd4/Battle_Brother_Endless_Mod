this.el_bravery_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_BraveryAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_Bravery.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Resolve + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_BraveryAddition) + " (" + this.m.EL_BraveryAddition + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Resolve + " + this.m.EL_BraveryAddition + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_BraveryAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_Bravery.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_Bravery.RandomMinBravery[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_Bravery.RandomMaxBravery[this.getItem().m.EL_RankLevel];
		this.m.EL_BraveryAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_Bravery.BaseBravery + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Bravery += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_BraveryAddition);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_BraveryAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_BraveryAddition);
	}

    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_BraveryAddition);
		this.el_accessory_entry.onSerialize(_out);

	}

	function onDeserialize( _in )
	{
		this.m.EL_BraveryAddition = _in.readI32();
		this.el_accessory_entry.onDeserialize(_in);
	}
});
this.el_xp_gain_mult_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_XPGainMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Experience Gain + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMultAddition * 100) * 0.01 + "% (" + this.m.EL_XPGainMultAddition + "%)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Experience Gain + " + this.m.EL_XPGainMultAddition + "%[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_XPGainMultAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.RandomMinXPGainMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.RandomMaxXPGainMult[this.getItem().m.EL_RankLevel];
		this.m.EL_XPGainMultAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.BaseXPGainMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.XPGainMult *= (1.0 + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMultAddition));
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_XPGainMultAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMultAddition * 100) * 0.01;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_XPGainMultAddition);
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_XPGainMultAddition = _in.readF32();
		this.m.EL_CurrentLevel = _in.readF32();
	}
});
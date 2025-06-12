this.el_xp_gain_mult_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_XPGainMult = 0.0
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
				text = "[color=" + colour + "]经验获取 + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMult * 100) * 0.01 + "% (" + this.m.EL_XPGainMult + "%)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]经验获取 + " + this.m.EL_XPGainMult + "%[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_XPGainMult <= this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.RandomMinXPGainMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.RandomMaxXPGainMult[this.getItem().m.EL_RankLevel];
		this.m.EL_XPGainMult = this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.BaseXPGainMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_XPGainMult = this.Const.EL_Accessory.EL_Entry.EntryStrengthenMult * this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_XPGainMult += this.Const.EL_Accessory.EL_Entry.Factor.EL_XPGainMult.RandomMaxXPGainMult[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= (1.0 + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMult) * 0.01);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_XPGainMult += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_XPGainMult * 100) * 0.01;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_XPGainMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_XPGainMult = _in.readF32();
	}
});
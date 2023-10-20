this.el_stamina_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_Stamina = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Fatigue + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Stamina) + " (" + this.m.EL_Stamina + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Fatigue + " + this.m.EL_Stamina + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_Stamina <= this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.RandomMinStamina[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.RandomMaxStamina[this.getItem().m.EL_RankLevel];
		this.m.EL_Stamina = this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.BaseStamina + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_Stamina = this.Const.EL_Accessory.EL_Entry.EntryStrengthenMult * this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_Stamina += this.Const.EL_Accessory.EL_Entry.Factor.EL_Stamina.RandomMaxStamina[this.Const.EL_Item.Type.Normal] / 2;
		}
	}


	function onUpdate( _properties )
	{
		_properties.Stamina += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Stamina);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_Stamina += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_Stamina);
	}

    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_Stamina);
	}

	function onDeserialize( _in )
	{
		this.m.EL_Stamina = _in.readI32();
	}
});
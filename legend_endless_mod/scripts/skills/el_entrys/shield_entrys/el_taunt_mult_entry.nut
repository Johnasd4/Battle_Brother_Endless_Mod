this.el_taunt_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_TauntMult = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Character\' threat * " + this.m.EL_TauntMult + "%[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_TauntMult <= this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.RandomMinTauntMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.RandomMaxTauntMult[this.getItem().m.EL_RankLevel];
		this.m.EL_TauntMult = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.BaseTauntMult + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_TauntMult = this.Const.EL_Shield.EL_Entry.EntryStrengthenMult * this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_TauntMult += this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.RandomMaxTauntMult[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= this.m.EL_TauntMult * 0.01;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_TargetAttractionMult *= this.m.EL_TauntMult;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_TauntMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_TauntMult = _in.readF32();
	}
});
this.el_taunt_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_TauntMultAddition = 0.0
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
			text = "[color=" + colour + "]Character\' threat + " + this.m.EL_TauntMultAddition + "%[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_TauntMultAddition <= this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.RandomMinTauntMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.RandomMaxTauntMult[this.getItem().m.EL_RankLevel];
		this.m.EL_TauntMultAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_TauntMult.BaseTauntMult + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.TargetAttractionMult *= (1.0 + this.m.EL_TauntMultAddition * 0.01);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_TargetAttractionMultAddition += this.m.EL_TauntMultAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_TauntMultAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_TauntMultAddition = _in.readF32();
	}
});
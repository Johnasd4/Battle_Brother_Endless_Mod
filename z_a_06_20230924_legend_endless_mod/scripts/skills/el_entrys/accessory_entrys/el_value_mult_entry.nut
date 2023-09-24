this.el_value_mult_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_ValueMultAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_ValueMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Value + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ValueMultAddition) + "%[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ValueMultAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_ValueMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_ValueMult.RandomMinValueMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_ValueMult.RandomMaxValueMult[this.getItem().m.EL_RankLevel];
		this.m.EL_ValueMultAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_ValueMult.BaseValueMult + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.Value *= (1.0 + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ValueMultAddition) * 0.01);
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ValueMultAddition);
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ValueMultAddition = _in.readI32();
		this.m.EL_CurrentLevel = _in.readF32();
	}
});
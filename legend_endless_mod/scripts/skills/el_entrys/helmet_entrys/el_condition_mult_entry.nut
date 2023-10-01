this.el_condition_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ConditionMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_ConditionMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Durability + " + this.m.EL_ConditionMultAddition + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ConditionMultAddition <= this.Const.EL_Helmet.EL_Entry.Factor.EL_ConditionMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_ConditionMult.RandomMinConditionMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_ConditionMult.RandomMaxConditionMult[this.getItem().m.EL_RankLevel];
		this.m.EL_ConditionMultAddition = this.Const.EL_Helmet.EL_Entry.Factor.EL_ConditionMult.BaseConditionMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.ConditionMax = this.Math.ceil(_item.m.ConditionMax * (1.0 + this.m.EL_ConditionMultAddition * 0.01));
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_ConditionMultAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ConditionMultAddition = _in.readF32();
	}
});
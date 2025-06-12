this.el_shield_reduce_damage_received_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ShieldDamageReceivedMult = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]承受劈盾伤害 - " + this.m.EL_ShieldDamageReceivedMult + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ShieldDamageReceivedMult <= this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.RandomMinShieldDamageReceivedMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.RandomMaxShieldDamageReceivedMult[this.getItem().m.EL_RankLevel];
		this.m.EL_ShieldDamageReceivedMult = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.BaseShieldDamageReceivedMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_ShieldDamageReceivedMult = (1.0 - this.Math.pow(1.0 - this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.ColourRange[this.Const.EL_Item.Type.Legendary] * 0.01, this.Const.EL_Shield.EL_Entry.EntryStrengthenMult)) * 100;
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_ShieldDamageReceivedMult += this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDamageReceivedMult.RandomMaxShieldDamageReceivedMult[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_ShieldDamageReceivedMult += this.m.EL_ShieldDamageReceivedMult;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ShieldDamageReceivedMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ShieldDamageReceivedMult = _in.readI32();
	}
});
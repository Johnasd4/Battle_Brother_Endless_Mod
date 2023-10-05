this.el_reduce_damage_received_mult_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_ReduceDamageReceivedMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_ReduceDamageReceivedMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Receive Damage - " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ReduceDamageReceivedMultAddition * 100) * 0.01 + "% (" + this.m.EL_ReduceDamageReceivedMultAddition + "%)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Receive Damage - " + this.m.EL_ReduceDamageReceivedMultAddition + "%[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ReduceDamageReceivedMultAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_ReduceDamageReceivedMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_ReduceDamageReceivedMult.RandomMinReduceDamageReceivedMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_ReduceDamageReceivedMult.RandomMaxReduceDamageReceivedMult[this.getItem().m.EL_RankLevel];
		this.m.EL_ReduceDamageReceivedMultAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_ReduceDamageReceivedMult.BaseReduceDamageReceivedMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.DamageReceivedTotalMult *= 1.0 - this.m.EL_CurrentLevel * this.m.EL_ReduceDamageReceivedMultAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_DamageReceivedMultAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ReduceDamageReceivedMultAddition * 100) * 0.01;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_ReduceDamageReceivedMultAddition);
		this.el_accessory_entry.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ReduceDamageReceivedMultAddition = _in.readF32();
		this.el_accessory_entry.onDeserialize(_in);
	}
});
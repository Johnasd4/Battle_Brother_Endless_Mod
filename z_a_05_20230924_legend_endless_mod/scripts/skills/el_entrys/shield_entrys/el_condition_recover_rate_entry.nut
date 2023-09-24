this.el_condition_recover_rate_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ConditionRecoverRateAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_ConditionRecoverRate.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Recover " + this.m.EL_ConditionRecoverRateAddition + "% Durability each turn[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ConditionRecoverRateAddition <= this.Const.EL_Shield.EL_Entry.Factor.EL_ConditionRecoverRate.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMinConditionRecoverRate[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMaxConditionRecoverRate[this.getItem().m.EL_RankLevel];
		this.m.EL_ConditionRecoverRateAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_ConditionRecoverRate.BaseConditionRecoverRate + this.Math.rand(randomMin, randomMax) * 0.01;
	}

    function onTurnStart()
	{
        local shield = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
        local condition_recover = this.Math.round(shield.getConditionMax() * this.m.EL_ConditionRecoverRateAddition);
        shield.setCondition(this.Math.min(shield.getConditionMax(), shield.getCondition() + condition_recover));
		this.logInfo("shield entry-turn recover conditon:" + condition_recover);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_ShieldConditionRecoverRateAddition += this.m.EL_ConditionRecoverRateAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_ConditionRecoverRateAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ConditionRecoverRateAddition = _in.readF32();
	}
});
this.el_condition_recover_rate_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_ConditionRecoverRateAddition = 0.0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_ConditionRecoverRate.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Recover " + this.m.EL_ConditionRecoverRateAddition + "% Weapon Durability each turn[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ConditionRecoverRateAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_ConditionRecoverRate.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMinConditionRecoverRate[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMaxConditionRecoverRate[this.getItem().m.EL_RankLevel];
		this.m.EL_ConditionRecoverRateAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_ConditionRecoverRate.BaseConditionRecoverRate + this.Math.rand(randomMin, randomMax) * 0.01;
	}

    function onTurnStart()
	{
        local weapon = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if(weapon != null)
		{
			local condition_recover = this.Math.round(weapon.getConditionMax() * this.m.EL_ConditionRecoverRateAddition * 0.01);
			weapon.setCondition(this.Math.min(weapon.getConditionMax(), weapon.getCondition() + condition_recover));
			//this.logInfo("weapon entry-turn recover conditon:" + condition_recover);
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_WeaponConditionRecoverRateAddition += this.m.EL_ConditionRecoverRateAddition;
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
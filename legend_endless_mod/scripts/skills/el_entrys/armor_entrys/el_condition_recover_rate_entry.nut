this.el_condition_recover_rate_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_ConditionRecoverRate = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]恢复 " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ConditionRecoverRate * 100) * 0.01 + "% (" + this.m.EL_ConditionRecoverRate + "%) 耐久每回合[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]恢复 " + this.m.EL_ConditionRecoverRate + "% 耐久每回合[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ConditionRecoverRate <= this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMinConditionRecoverRate[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMaxConditionRecoverRate[this.getItem().m.EL_RankLevel];
		this.m.EL_ConditionRecoverRate = this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.BaseConditionRecoverRate + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_ConditionRecoverRate = this.Const.EL_Armor.EL_Entry.EntryStrengthenMult * this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_ConditionRecoverRate += this.Const.EL_Armor.EL_Entry.Factor.EL_ConditionRecoverRate.RandomMaxConditionRecoverRate[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

    function onTurnStart()
	{
        local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);		
		if(body != null)
		{
			local condition_recover = this.Math.round(body.getConditionMax() * this.m.EL_CurrentLevel * this.m.EL_ConditionRecoverRate * 0.01);
			body.setCondition(this.Math.min(body.getConditionMax(), body.getCondition() + condition_recover));
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_ArmorConditionRecoverRate += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_ConditionRecoverRate * 100) * 0.01;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_ConditionRecoverRate);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ConditionRecoverRate = _in.readF32();
	}
});
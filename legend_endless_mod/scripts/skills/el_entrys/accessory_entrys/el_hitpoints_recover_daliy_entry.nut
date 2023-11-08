this.el_hitpoints_recover_daliy_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_HitpointsRecoverDaliy = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]恢复 " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_HitpointsRecoverDaliy * 100) * 0.01 + "% (" + this.m.EL_HitpointsRecoverDaliy + ")% 生命值每日[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]恢复 " + this.m.EL_HitpointsRecoverDaliy + "% 生命值每日[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_HitpointsRecoverDaliy <= this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.RandomMinHitpointsRecoverDaily[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.RandomMaxHitpointsRecoverDaily[this.getItem().m.EL_RankLevel];
		this.m.EL_HitpointsRecoverDaliy = this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.BaseHitpointsRecoverDaily + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_HitpointsRecoverDaliy = this.Const.EL_Accessory.EL_Entry.EntryStrengthenMult * this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_HitpointsRecoverDaliy += this.Const.EL_Accessory.EL_Entry.Factor.EL_HitpointsRecoverDaliy.RandomMaxHitpointsRecoverDaily[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function EL_onNewDay( _item )
	{
		if(_item != null)
		{
			local condition_recover = this.Math.round(_item.getConditionMax() * this.m.EL_CurrentLevel * this.m.EL_HitpointsRecoverDaliy * 0.01);
			_item.setCondition(this.Math.min(_item.getConditionMax(), _item.getCondition() + condition_recover));
			//this.logInfo("_item entry-daliy recover conditon:" + condition_recover);
		}
	}

	function onNewDay()
	{
		local actor = this.getContainer().getActor();
		if(actor != null)
		{
        	local recover_hitpoint = this.Math.round(actor.getHitpointsMax() * this.m.EL_CurrentLevel * this.m.EL_HitpointsRecoverDaliy * 0.01);
			actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + recover_hitpoint));
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_HitpointsRecoverDaliy += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_HitpointsRecoverDaliy * 100) * 0.01;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_HitpointsRecoverDaliy);
	}

	function onDeserialize( _in )
	{
		this.m.EL_HitpointsRecoverDaliy = _in.readF32();
	}
});
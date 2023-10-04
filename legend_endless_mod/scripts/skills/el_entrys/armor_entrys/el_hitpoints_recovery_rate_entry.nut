this.el_hitpoints_recovery_rate_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_HitpointsRecoveryRateAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_HitpointsRecoveryRate.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Health Recovery per turn" + this.m.EL_HitpointsRecoveryRateAddition + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_HitpointsRecoveryRateAddition <= this.Const.EL_Armor.EL_Entry.Factor.EL_HitpointsRecoveryRate.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_HitpointsRecoveryRate.RandomMinHitpointsRecoveryRate[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_HitpointsRecoveryRate.RandomMaxHitpointsRecoveryRate[this.getItem().m.EL_RankLevel];
		this.m.EL_HitpointsRecoveryRateAddition = this.Const.EL_Armor.EL_Entry.Factor.EL_HitpointsRecoveryRate.BaseHitpointsRecoveryRate + this.Math.rand(randomMin, randomMax) * 0.01;
	}

    function onTurnStart()
	{
        local actor = this.getContainer().getActor();
        actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(actor.getHitpointsMax() * this.m.EL_HitpointsRecoveryRateAddition * 0.01)));
    }

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_HitpointsRecoveryRateAddition += this.m.EL_HitpointsRecoveryRateAddition;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_HitpointsRecoveryRateAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_HitpointsRecoveryRateAddition = _in.readF32();
	}
});
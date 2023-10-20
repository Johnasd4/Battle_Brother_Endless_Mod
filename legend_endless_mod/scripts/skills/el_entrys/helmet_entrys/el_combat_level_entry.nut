this.el_combat_level_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_CombatLevel = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]CombatLevel + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_CombatLevel * 100) * 0.01 + " (" + this.m.EL_CombatLevel + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]CombatLevel + " + this.m.EL_CombatLevel + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_CombatLevel <= this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.RandomMinCombatLevel[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.RandomMaxCombatLevel[this.getItem().m.EL_RankLevel];
		this.m.EL_CombatLevel = this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.BaseCombatLevel + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_CombatLevel = this.Const.EL_Helmet.EL_Entry.EntryStrengthenMult * this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_CombatLevel += this.Const.EL_Helmet.EL_Entry.Factor.EL_CombatLevel.RandomMaxCombatLevel[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function onUpdate( _properties )
	{
		_properties.EL_CombatLevel += this.m.EL_CurrentLevel * this.m.EL_CombatLevel;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_CombatLevel += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_CombatLevel * 100) * 0.01;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_CombatLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_CombatLevel = _in.readF32();
	}
});
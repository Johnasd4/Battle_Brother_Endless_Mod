this.el_combat_level_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_CombatLevelAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_CombatLevel.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]CombatLevel + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_CombatLevelAddition * 100) * 0.01 + " (" + this.m.EL_CombatLevelAddition + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]CombatLevel + " + this.m.EL_CombatLevelAddition + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_CombatLevelAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_CombatLevel.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_CombatLevel.RandomMinCombatLevel[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_CombatLevel.RandomMaxCombatLevel[this.getItem().m.EL_RankLevel];
		this.m.EL_CombatLevelAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_CombatLevel.BaseCombatLevel + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.EL_CombatLevel += this.m.EL_CurrentLevel * this.m.EL_CombatLevelAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_CombatLevelAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_CombatLevelAddition * 100) * 0.01;
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_CombatLevelAddition);
		this.el_accessory_entry.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.EL_CombatLevelAddition = _in.readF32();
		this.el_accessory_entry.onDeserialize(_in);
	}
});
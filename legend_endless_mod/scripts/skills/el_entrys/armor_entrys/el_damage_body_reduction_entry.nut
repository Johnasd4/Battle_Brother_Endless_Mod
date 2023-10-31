this.el_damage_body_reduction_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_DamageBodyArmorReduction = 0.0,
		EL_Level = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]身体护甲固定减伤 + " + this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_DamageBodyArmorReduction 
																						 * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction))
											+ "% (" + this.Math.ceil(this.m.EL_DamageBodyArmorReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction)) + ")(面板)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]身体护甲固定减伤 + " + this.Math.ceil(this.m.EL_DamageBodyArmorReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction)) + "(面板)[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DamageBodyArmorReduction <= this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.RandomMinDamageBodyArmorReduction[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.RandomMaxDamageBodyArmorReduction[this.getItem().m.EL_RankLevel];
		this.m.EL_DamageBodyArmorReduction = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.BaseDamageBodyArmorReduction + this.Math.rand(randomMin, randomMax) * 0.1;
	}

	function EL_strengthen()
	{
		this.m.EL_DamageBodyArmorReduction = this.Const.EL_Armor.EL_Entry.EntryStrengthenMult * this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_DamageBodyArmorReduction += this.Const.EL_Armor.EL_Entry.Factor.EL_DamageBodyArmorReduction.RandomMaxDamageBodyArmorReduction[this.Const.EL_Item.Type.Normal] / 2 * 0.1;
		}
	}

	function EL_onItemUpdate( _item )
	{
		this.m.EL_Level = _item.m.EL_CurrentLevel;
        _item.m.EL_DamageBodyArmorReduction += this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_DamageBodyArmorReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageBodyArmorReduction));
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DamageBodyArmorReduction);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DamageBodyArmorReduction = _in.readF32();
	}
});
this.el_damage_regular_reduction_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_DamageRegularReduction = 0.0,
		EL_Level = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Equipment hitpoints fixation reduces damage + " + this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_DamageRegularReduction 
																							* (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction))
											+ "% (" + this.Math.ceil(this.m.EL_DamageRegularReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction)) + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Equipment hitpoints fixation reduces damage + " + this.Math.ceil(this.m.EL_DamageRegularReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction)) + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DamageRegularReduction <= this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.RandomMinDamageRegularReduction[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.RandomMaxDamageRegularReduction[this.getItem().m.EL_RankLevel];
		this.m.EL_DamageRegularReduction = this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.BaseDamageRegularReduction + this.Math.rand(randomMin, randomMax) * 0.1;
	}

	function EL_strengthen()
	{
		this.m.EL_DamageRegularReduction = this.Const.EL_Armor.EL_Entry.EntryStrengthenMult * this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_DamageRegularReduction += this.Const.EL_Armor.EL_Entry.Factor.EL_DamageRegularReduction.RandomMaxDamageRegularReduction[this.Const.EL_Item.Type.Normal] / 2 * 0.1;
		}
	}

	function EL_onItemUpdate( _item )
	{
		this.m.EL_Level = _item.m.EL_Level;
        _item.m.EL_DamageRegularReduction += this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_DamageRegularReduction * (1.0 + this.m.EL_Level * this.Const.EL_Armor.EL_LevelFactor.DamageRegularReduction));
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DamageRegularReduction);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DamageRegularReduction = _in.readF32();
	}
});
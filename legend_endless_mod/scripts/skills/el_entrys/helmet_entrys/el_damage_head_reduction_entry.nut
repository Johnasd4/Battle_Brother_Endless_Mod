this.el_damage_head_reduction_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_DamageHeadArmorReduction = 0.0,
		EL_Bonus = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]头部护甲固定减伤 + " + this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_Bonus)
											+ " (" + this.Math.ceil(this.m.EL_Bonus) + ")(面板)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]头部护甲固定减伤 + " + this.Math.ceil(this.m.EL_Bonus) + "(面板)[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DamageHeadArmorReduction * 0.1 <= this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.RandomMinDamageHeadArmorReduction[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.RandomMaxDamageHeadArmorReduction[this.getItem().m.EL_RankLevel];
		this.m.EL_DamageHeadArmorReduction = this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.BaseDamageHeadArmorReduction + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_DamageHeadArmorReduction = this.Const.EL_Helmet.EL_Entry.EntryStrengthenMult * this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_DamageHeadArmorReduction += this.Const.EL_Helmet.EL_Entry.Factor.EL_DamageHeadArmorReduction.RandomMaxDamageHeadArmorReduction[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function EL_onItemUpdate( _item )
	{
		this.m.EL_Bonus = this.m.EL_DamageHeadArmorReduction * 0.2 * (1.0 + _item.m.EL_CurrentLevel * this.Const.EL_Helmet.EL_LevelFactor.DamageHeadArmorReduction);
        _item.m.EL_DamageHeadArmorReduction += this.Math.ceil(this.m.EL_CurrentLevel * this.m.EL_Bonus);
	}

    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DamageHeadArmorReduction);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DamageHeadArmorReduction = _in.readF32();
	}
});
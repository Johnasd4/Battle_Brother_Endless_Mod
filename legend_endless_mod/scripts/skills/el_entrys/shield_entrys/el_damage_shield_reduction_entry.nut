this.el_damage_shield_reduction_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_DamageShieldReduction = 0,
		EL_Level = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]盾牌固定减伤 + " + this.Math.ceil(this.m.EL_DamageShieldReduction * (1.0 + this.m.EL_Level * this.Const.EL_Shield.EL_LevelFactor.DamageShieldReduction)) + "(面板)[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DamageShieldReduction <= this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.RandomMinDamageShieldReduction[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.RandomMaxDamageShieldReduction[this.getItem().m.EL_RankLevel];
		this.m.EL_DamageShieldReduction = this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.BaseDamageShieldReduction + this.Math.rand(randomMin, randomMax) * 0.1;
	}

	function EL_strengthen()
	{
		this.m.EL_DamageShieldReduction = this.Const.EL_Shield.EL_Entry.EntryStrengthenMult * this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_DamageShieldReduction += this.Const.EL_Shield.EL_Entry.Factor.EL_DamageShieldReduction.RandomMaxDamageShieldReduction[this.Const.EL_Item.Type.Normal] / 2 * 0.1;
		}
	}

	function EL_onItemUpdate( _item )
	{
		this.m.EL_Level = _item.m.EL_CurrentLevel;
        _item.m.EL_DamageShieldReduction += this.Math.ceil(this.m.EL_DamageShieldReduction * (1.0 + this.m.EL_Level * this.Const.EL_Shield.EL_LevelFactor.DamageShieldReduction));
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_DamageShieldReduction);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DamageShieldReduction = _in.readI32();
	}
});
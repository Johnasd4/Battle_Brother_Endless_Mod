this.el_stamina_modifier_mult_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_StaminaModifierMult = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]装备重量 - " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_StaminaModifierMult * 100) * 0.01 + "% (" + this.m.EL_StaminaModifierMult + ")%(面板)[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]装备重量 - " + this.m.EL_StaminaModifierMult + "%(面板)[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_StaminaModifierMult <= this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.RandomMinStaminaModifierMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.RandomMaxStaminaModifierMult[this.getItem().m.EL_RankLevel];
		this.m.EL_StaminaModifierMult = this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.BaseStaminaModifierMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_StaminaModifierMult = this.Const.EL_Armor.EL_Entry.EntryStrengthenMult * this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_StaminaModifierMult += this.Const.EL_Armor.EL_Entry.Factor.EL_StaminaModifierMult.RandomMaxStaminaModifierMult[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.StaminaModifier = this.Math.floor(_item.m.StaminaModifier * (1.0 - this.m.EL_CurrentLevel * this.m.EL_StaminaModifierMult * 0.01));
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_StaminaModifierMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_StaminaModifierMult = _in.readF32();
	}
});
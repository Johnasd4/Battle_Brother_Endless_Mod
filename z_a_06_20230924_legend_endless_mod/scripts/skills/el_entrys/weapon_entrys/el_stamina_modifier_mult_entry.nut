this.el_stamina_modifier_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_StaminaModifierMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_StaminaModifierMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Weight - " + this.m.EL_StaminaModifierMultAddition + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_StaminaModifierMultAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_StaminaModifierMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_StaminaModifierMult.RandomMinStaminaModifierMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_StaminaModifierMult.RandomMaxStaminaModifierMult[this.getItem().m.EL_RankLevel];
		this.m.EL_StaminaModifierMultAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_StaminaModifierMult.BaseStaminaModifierMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.StaminaModifier *= (1.0 - this.m.EL_StaminaModifierMultAddition);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_WeaponStaminaModifierMultAddition += this.m.EL_StaminaModifierMultAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_StaminaModifierMultAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_StaminaModifierMultAddition = _in.readF32();
	}
});
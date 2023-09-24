this.el_stamina_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_StaminaAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Armor.EL_Entry.Factor.EL_Stamina.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Fatigue + " + this.m.EL_StaminaAddition + "[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_StaminaAddition <= this.Const.EL_Armor.EL_Entry.Factor.EL_Stamina.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Armor.EL_Entry.Factor.EL_Stamina.RandomMinStamina[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Armor.EL_Entry.Factor.EL_Stamina.RandomMaxStamina[this.getItem().m.EL_RankLevel];
		this.m.EL_StaminaAddition = this.Const.EL_Armor.EL_Entry.Factor.EL_Stamina.BaseStamina + this.Math.rand(randomMin, randomMax);
	}


	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Stamina += this.m.EL_StaminaAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_StaminaAddition += this.m.EL_StaminaAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_StaminaAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_StaminaAddition = _in.readI32();
	}
});
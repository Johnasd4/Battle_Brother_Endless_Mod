this.el_armor_damage_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ArmorDamageMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_ArmorDamageMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Additional " + this.m.EL_ArmorDamageMultAddition + "% effective against armor[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ArmorDamageMultAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_ArmorDamageMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_ArmorDamageMult.RandomMinArmorDamageMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_ArmorDamageMult.RandomMaxArmorDamageMult[this.getItem().m.EL_RankLevel];
		this.m.EL_ArmorDamageMultAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_ArmorDamageMult.BaseArmorDamageMult + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.ArmorDamageMult = _item.m.EL_BaseWithRankArmorDamageMult + this.m.EL_ArmorDamageMultAddition * 0.01;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_ArmorDamageMultAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ArmorDamageMultAddition = _in.readF32();
	}
});
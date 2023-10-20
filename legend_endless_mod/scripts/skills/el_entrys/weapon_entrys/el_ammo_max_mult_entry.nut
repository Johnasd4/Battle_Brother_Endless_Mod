this.el_ammo_max_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_AmmoMaxMult = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Equipment Ammo + " + this.m.EL_AmmoMaxMult + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_AmmoMaxMult <= this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.RandomMinAmmoMaxMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.RandomMaxAmmoMaxMult[this.getItem().m.EL_RankLevel];
		this.m.EL_AmmoMaxMult = this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.BaseAmmoMaxMult + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_AmmoMaxMult = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_AmmoMaxMult += this.Const.EL_Weapon.EL_Entry.Factor.EL_AmmoMaxMult.RandomMaxAmmoMaxMult[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.AmmoMax = this.Math.ceil(_item.m.AmmoMax * (1.0 + this.m.EL_AmmoMaxMult * 0.01));
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_AmmoMaxMult);
	}

	function onDeserialize( _in )
	{
		this.m.EL_AmmoMaxMult = _in.readI32();
	}
});
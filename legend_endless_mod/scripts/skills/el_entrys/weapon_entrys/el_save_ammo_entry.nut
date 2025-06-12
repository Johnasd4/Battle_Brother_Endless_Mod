this.el_save_ammo_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_SaveAmmoChance = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]" + this.m.EL_SaveAmmoChance + "%不消耗弹药[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_SaveAmmoChance <= this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.RandomMinSaveAmmoChance[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.RandomMaxSaveAmmoChance[this.getItem().m.EL_RankLevel];
		this.m.EL_SaveAmmoChance = this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.BaseSaveAmmoChance + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function EL_strengthen()
	{
		this.m.EL_SaveAmmoChance = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_SaveAmmoChance += this.Const.EL_Weapon.EL_Entry.Factor.EL_SaveAmmo.RandomMaxSaveAmmoChance[this.Const.EL_Item.Type.Normal] / 2 * 0.01;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_SaveAmmo += this.m.EL_SaveAmmoChance;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_SaveAmmoChance);
	}

	function onDeserialize( _in )
	{
		this.m.EL_SaveAmmoChance = _in.readI32();
	}
});
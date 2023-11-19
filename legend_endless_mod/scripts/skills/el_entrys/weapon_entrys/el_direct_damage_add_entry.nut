this.el_direct_damage_add_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_DirectDamageAdd = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]忽视盔甲效果增加基础数值的 " + this.m.EL_DirectDamageAdd + "% (面板)[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DirectDamageAdd <= this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.RandomMinDirectDamageAdd[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.RandomMaxDirectDamageAdd[this.getItem().m.EL_RankLevel];
		this.m.EL_DirectDamageAdd = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.BaseDirectDamageAdd + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_DirectDamageAdd = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_DirectDamageAdd += this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.RandomMaxDirectDamageAdd[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.DirectDamageAdd += _item.m.EL_BaseNoRankDirectDamageAdd + this.m.EL_DirectDamageAdd * 0.0001;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DirectDamageAdd);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DirectDamageAdd = _in.readF32();
	}
});
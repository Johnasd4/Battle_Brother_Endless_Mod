this.el_direct_damage_add_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_DirectDamageAddAddition = 0.0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Additional " + this.m.EL_DirectDamageAddAddition + "% of damage ignores armor[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DirectDamageAddAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.RandomMinDirectDamageAdd[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.RandomMaxDirectDamageAdd[this.getItem().m.EL_RankLevel];
		this.m.EL_DirectDamageAddAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_DirectDamageAdd.BaseDirectDamageAdd + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.DirectDamageAdd = _item.m.EL_BaseWithRankDirectDamageAdd + this.m.EL_DirectDamageAddAddition * 0.01;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DirectDamageAddAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DirectDamageAddAddition = _in.readF32();
	}
});
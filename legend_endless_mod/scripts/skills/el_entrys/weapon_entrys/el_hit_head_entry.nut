this.el_hit_head_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_HitHeadAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_HitHead.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Chance to hit the head + " + this.m.EL_HitHeadAddition + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_HitHeadAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_HitHead.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_HitHead.RandomMinHitHead[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_HitHead.RandomMaxHitHead[this.getItem().m.EL_RankLevel];
		this.m.EL_HitHeadAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_HitHead.BaseHitHead + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.ChanceToHitHead = _item.m.EL_BaseWithRankChanceToHitHead + this.m.EL_HitHeadAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_WeaponHitHeadAddition += this.m.EL_HitHeadAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_HitHeadAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_HitHeadAddition = _in.readI32();
	}
});
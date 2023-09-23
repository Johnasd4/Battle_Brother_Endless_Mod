this.el_shield_double_defense_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ShieldDoubleDefenseAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDoubleDefense.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Shield Melee Defense and Ranged Defense + " + this.m.EL_ShieldDoubleDefenseAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_ShieldDoubleDefenseAddition <= this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDoubleDefense.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDoubleDefense.RandomMinShieldDoubleDefense[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDoubleDefense.RandomMaxShieldDoubleDefense[this.getItem().m.EL_RankLevel];
		this.m.EL_ShieldDoubleDefenseAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_ShieldDoubleDefense.BaseShieldDoubleDefense + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.MeleeDefense += this.m.EL_ShieldDoubleDefenseAddition;
        _item.m.RangedDefense += this.m.EL_ShieldDoubleDefenseAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_ShieldDoubleDefenseAddition += this.m.EL_ShieldDoubleDefenseAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_ShieldDoubleDefenseAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ShieldDoubleDefenseAddition = _in.readI32();
	}
});
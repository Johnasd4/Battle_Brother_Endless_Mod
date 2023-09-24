this.el_ranged_defense_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_RangedDefenseAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_RangedDefense.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Ranged Defense + " + this.m.EL_RangedDefenseAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_RangedDefenseAddition <= this.Const.EL_Shield.EL_Entry.Factor.EL_RangedDefense.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_RangedDefense.RandomMinRangedDefense[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_RangedDefense.RandomMaxRangedDefense[this.getItem().m.EL_RankLevel];
		this.m.EL_RangedDefenseAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_RangedDefense.BaseRangedDefense + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.RangedDefense += this.m.EL_RangedDefenseAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_RangedDefenseAddition += this.m.EL_RangedDefenseAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_RangedDefenseAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangedDefenseAddition = _in.readI32();
	}
});
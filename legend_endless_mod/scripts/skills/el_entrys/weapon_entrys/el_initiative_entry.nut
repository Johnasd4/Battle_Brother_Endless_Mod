this.el_initiative_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_Initiative = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]主动值 + " + this.m.EL_Initiative + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_Initiative <= this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.RandomMinInitiative[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.RandomMaxInitiative[this.getItem().m.EL_RankLevel];
		this.m.EL_Initiative = this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.BaseInitiative + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_Initiative = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_Initiative += this.Const.EL_Weapon.EL_Entry.Factor.EL_Initiative.RandomMaxInitiative[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += this.m.EL_Initiative;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_Initiative += this.m.EL_Initiative;
	}

    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_Initiative);
	}

	function onDeserialize( _in )
	{
		this.m.EL_Initiative = _in.readI32();
	}
});
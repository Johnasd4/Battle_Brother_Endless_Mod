this.el_initiative_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_InitiativeAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_Initiative.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Initiative + " + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_InitiativeAddition) + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_InitiativeAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_Initiative.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_Initiative.RandomMinInitiative[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_Initiative.RandomMaxInitiative[this.getItem().m.EL_RankLevel];
		this.m.EL_InitiativeAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_Initiative.BaseInitiative + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Initiative += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_InitiativeAddition);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_InitiativeAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_InitiativeAddition);
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_InitiativeAddition);
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_InitiativeAddition = _in.readI32();
		this.m.EL_CurrentLevel = _in.readF32();
	}
});
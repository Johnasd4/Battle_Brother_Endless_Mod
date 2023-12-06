this.el_immue_bleeding_poisoned_fire_miasma_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {},
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_ImmueBleedingPoisonedFireMiasma.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]免疫流血，中毒，火焰，瘴气[/color]"
		};
		
		if(this.m.EL_CurrentLevel != 1)
		{
			result.text += "[color=" + this.Const.EL_Item.Type.Normal + "] (暂不生效)[/color]";
		}
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_CurrentLevel)
		{
            _properties.IsImmuneToBleeding = true;
            _properties.IsImmuneToPoison = true;
            _properties.IsImmuneToFire = true;
            _properties.IsResistantToMiasma = true;
		}
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		if(this.m.EL_CurrentLevel == 1)
		{
			_EL_totalEntry.m.EL_ImmueBleedingPoisonedFireMiasma = true;
		}
	}

    function onSerialize( _out )
	{
		this.el_accessory_entry.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.el_accessory_entry.onDeserialize(_in);
	}
});
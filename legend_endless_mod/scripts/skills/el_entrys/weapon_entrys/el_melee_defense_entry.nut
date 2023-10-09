this.el_melee_defense_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_MeleeDefenseAddition = 0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeDefense.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Melee Defense + " + this.m.EL_MeleeDefenseAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_MeleeDefenseAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeDefense.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeDefense.RandomMinMeleeDefense[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeDefense.RandomMaxMeleeDefense[this.getItem().m.EL_RankLevel];
		this.m.EL_MeleeDefenseAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeDefense.BaseMeleeDefense + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_weapon_entry.onUpdate(_properties);
		_properties.MeleeDefense += this.m.EL_MeleeDefenseAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_MeleeDefenseAddition += this.m.EL_MeleeDefenseAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_MeleeDefenseAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_MeleeDefenseAddition = _in.readI32();
	}
});
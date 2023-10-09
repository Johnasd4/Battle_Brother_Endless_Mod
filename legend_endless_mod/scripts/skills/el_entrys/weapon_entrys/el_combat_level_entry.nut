this.el_combat_level_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_CombatLevelAddition = 0.0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_CombatLevel.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]CombatLevel + " + this.m.EL_CombatLevelAddition + "[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_CombatLevelAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_CombatLevel.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_CombatLevel.RandomMinCombatLevel[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_CombatLevel.RandomMaxCombatLevel[this.getItem().m.EL_RankLevel];
		this.m.EL_CombatLevelAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_CombatLevel.BaseCombatLevel + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onUpdate( _properties )
	{
		this.el_weapon_entry.onUpdate(_properties);
		_properties.EL_CombatLevel += this.m.EL_CombatLevelAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_CombatLevelAddition += this.m.EL_CombatLevelAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_CombatLevelAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_CombatLevelAddition = _in.readF32();
	}
});
this.el_melee_skill_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_MeleeSkill = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]近战技能 + " + this.m.EL_MeleeSkill + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_MeleeSkill <= this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.RandomMinMeleeSkill[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.RandomMaxMeleeSkill[this.getItem().m.EL_RankLevel];
		this.m.EL_MeleeSkill = this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.BaseMeleeSkill + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_MeleeSkill = this.Const.EL_Weapon.EL_Entry.EntryStrengthenMult * this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_MeleeSkill += this.Const.EL_Weapon.EL_Entry.Factor.EL_MeleeSkill.RandomMaxMeleeSkill[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += this.m.EL_MeleeSkill;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_MeleeSkill += this.m.EL_MeleeSkill;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_MeleeSkill);
	}

	function onDeserialize( _in )
	{
		this.m.EL_MeleeSkill = _in.readI32();
	}
});
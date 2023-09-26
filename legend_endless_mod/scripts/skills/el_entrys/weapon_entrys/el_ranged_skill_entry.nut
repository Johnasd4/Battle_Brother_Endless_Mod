this.el_ranged_skill_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_RangedSkillAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedSkill.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Ranged Skill + " + this.m.EL_RangedSkillAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_RangedSkillAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedSkill.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedSkill.RandomMinRangedSkill[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedSkill.RandomMaxRangedSkill[this.getItem().m.EL_RankLevel];
		this.m.EL_RangedSkillAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_RangedSkill.BaseRangedSkill + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.RangedSkill += this.m.EL_RangedSkillAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_RangedSkillAddition += this.m.EL_RangedSkillAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_RangedSkillAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_RangedSkillAddition = _in.readI32();
	}
});
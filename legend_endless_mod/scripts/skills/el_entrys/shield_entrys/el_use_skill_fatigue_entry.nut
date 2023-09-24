this.el_use_skill_fatigue_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_UseSkillfatigueAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Shield.EL_Entry.Factor.EL_UseSkillfatigue.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Shield skills build up " + this.m.EL_UseSkillfatigueAddition + " less fatigue.[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_UseSkillfatigueAddition <= this.Const.EL_Shield.EL_Entry.Factor.EL_UseSkillfatigue.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Shield.EL_Entry.Factor.EL_UseSkillfatigue.RandomMinUseSkillfatigue[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Shield.EL_Entry.Factor.EL_UseSkillfatigue.RandomMaxUseSkillfatigue[this.getItem().m.EL_RankLevel];
		this.m.EL_UseSkillfatigueAddition = this.Const.EL_Shield.EL_Entry.Factor.EL_UseSkillfatigue.BaseUseSkillfatigue + this.Math.rand(randomMin, randomMax);
	}

	function EL_onItemUpdate( _item )
	{
        _item.m.FatigueOnSkillUse = _item.m.EL_BaseWithRankFatigueOnSkillUse - this.m.EL_UseSkillfatigueAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_ShieldUseSkillfatigueAddition += this.m.EL_UseSkillfatigueAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_UseSkillfatigueAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_UseSkillfatigueAddition = _in.readI32();
	}
});
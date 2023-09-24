this.el_fatigue_recover_entry <- this.inherit("scripts/skills/el_entrys/accessory_entrys/el_accessory_entry", {
	m = {
        EL_FatigueRecoverAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_FatigueRecover.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Fatigue Recovery 1 turn + " +  this.Math.round(this.m.EL_CurrentLevel * this.m.EL_FatigueRecoverAddition) + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_FatigueRecoverAddition <= this.Const.EL_Accessory.EL_Entry.Factor.EL_FatigueRecover.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_FatigueRecover.RandomMinFatigueRecover[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_FatigueRecover.RandomMaxFatigueRecover[this.getItem().m.EL_RankLevel];
		this.m.EL_FatigueRecoverAddition = this.Const.EL_Accessory.EL_Entry.Factor.EL_FatigueRecover.BaseFatigueRecover + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.EL_FatigueRecoveryRate += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_FatigueRecoverAddition);
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_FatigueRecoveryRateAddition += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_FatigueRecoverAddition);
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_FatigueRecoverAddition);
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_FatigueRecoverAddition = _in.readI32();
		this.m.EL_CurrentLevel = _in.readF32();
	}
});
this.el_agility_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.agility";
		this.m.Name = "Agility";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.Const.EL_NPCOther.EL_NPCBuff.Agility.ActionPointsOffset[this.m.EL_RankLevel];
	}

});


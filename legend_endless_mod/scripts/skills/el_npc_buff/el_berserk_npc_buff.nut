this.el_berserk_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.berserk";
		this.m.Name = "Berserk";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Berserk.DamageDirectMult[this.m.EL_RankLevel];
	}

});


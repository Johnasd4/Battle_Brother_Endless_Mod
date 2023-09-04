this.el_bravery_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buffs", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.bravery";
		this.m.Name = "Bravery";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += this.Const.EL_NPC.EL_NPCBuff.Bravery.BraveryOffset[this.m.EL_RankLevel];
	}

});


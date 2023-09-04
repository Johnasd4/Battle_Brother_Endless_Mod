this.el_tank_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.tank";
		this.m.Name = "Tank";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= this.Const.EL_NPC.EL_NPCBuff.Tank.HitpointsMult[this.m.EL_RankLevel];
		_properties.ArmorMult[this.Const.BodyPart.Body] *= this.Const.EL_NPC.EL_NPCBuff.Tank.ArmorMult[this.m.EL_RankLevel];
		_properties.ArmorMult[this.Const.BodyPart.Head] *= this.Const.EL_NPC.EL_NPCBuff.Tank.ArmorMult[this.m.EL_RankLevel];
	}

});


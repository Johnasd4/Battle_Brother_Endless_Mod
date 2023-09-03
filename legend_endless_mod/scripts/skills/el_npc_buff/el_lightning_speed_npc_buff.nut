this.el_lightning_speed_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.lightning_speed";
		this.m.Name = "Lightning Speed";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += this.Const.EL_NPC.EL_NPCBuff.LightningSpeed.InitiativeOffset[this.m.EL_RankLevel];
	}

});


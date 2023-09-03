this.el_stamina_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.stamina";
		this.m.Name = "Stamina";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		_properties.Stamina += this.Const.EL_NPC.EL_NPCBuff.Stamina.StaminaOffset[this.m.EL_RankLevel];
	}

});


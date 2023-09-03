this.el_weapon_master_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.weapon_master";
		this.m.Name = "Weapon Master";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
        _properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.WeaponMaster.MeleeSkillOffset[this.m.EL_RankLevel];
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.WeaponMaster.RangedSkillOffset[this.m.EL_RankLevel];
	}

});


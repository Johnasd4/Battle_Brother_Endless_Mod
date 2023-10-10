this.el_berserker_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.berserker";
		this.m.Name = "Berserker";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local stack = this.Math.floor(10 - (actor.getHitpointsPct() * 0.1));
		if(stack != 0) {
			this.m.Name = "Berserker(x" + stack + ")";
		}
		else {
			this.m.Name = "Berserker";
		}
		_properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.DamageMultPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
		_properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.MeleeSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.RangedSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
	}

});


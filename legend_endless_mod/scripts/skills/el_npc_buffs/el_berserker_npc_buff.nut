this.el_berserker_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.berserker";
		this.m.Name = "狂战士";
		this.m.Description = "";
	}

	function onCombatStarted()
	{
		this.m.Name = "狂战士";
	}

	function onCombatFinished()
	{
		this.m.Name = "狂战士";
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local stack = this.Math.floor(10 - (actor.getHitpointsPct() * 10));
		if(stack != 0) {
			this.m.Name = "狂战士(x" + stack + ")";
		}
		else {
			this.m.Name = "狂战士";
		}
		_properties.DamageTotalMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.DamageMultPurStack[this.m.EL_RankLevel] * stack;
		_properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.MeleeSkillOffsetPurStack[this.m.EL_RankLevel] * stack;
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Berserker.RangedSkillOffsetPurStack[this.m.EL_RankLevel] * stack;
	}

});


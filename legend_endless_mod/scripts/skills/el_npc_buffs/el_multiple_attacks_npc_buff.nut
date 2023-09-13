this.el_multiple_attacks_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.multiple_attacks";
		this.m.Name = "Multiple Attacks";
		this.m.Description = "";
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
        local actor = this.getContainer().getActor();
        if(actor.isTurnStarted && !actor.isWaitActionSpent && _skill.isAttack()) {
            local temp_damage_direct_mult = _properties.DamageDirectMult;
            _properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Factor.MultipleAttacks.DamageDirectMult[this.m.EL_RankLevel];
            local targets = this.Tactical.Entities.getAllInstances();
            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if(!t.isAlliedWith(actor) && this.isInRange(t.getTile())) {
                        skill.useForFree(t.getTile());
                    }
                }
            }
            _properties.DamageDirectMult = temp_damage_direct_mult;
        }
	}
});


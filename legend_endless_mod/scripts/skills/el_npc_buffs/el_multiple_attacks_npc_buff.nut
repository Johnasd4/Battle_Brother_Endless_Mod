this.el_multiple_attacks_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_IsExtraAttack = false
    },
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
        if(actor.isTurnStarted && !actor.isWaitActionSpent && _skill.isAttack() && !_skill.isRanged() && !this.m.EL_IsExtraAttack) {

            local targets = this.Tactical.Entities.getAllInstances();
            this.m.EL_IsExtraAttack = true;
            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if(!t.isAlliedWith(actor) && skill.isInRange(t.getTile())) {
                        skill.useForFree(t.getTile());
                    }
                }
            }
            this.m.EL_IsExtraAttack = false;

        }
        if(this.m.EL_IsExtraAttack) {
            _properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Factor.MultipleAttacks.DamageDirectMult[this.m.EL_RankLevel];
        }
	}
});


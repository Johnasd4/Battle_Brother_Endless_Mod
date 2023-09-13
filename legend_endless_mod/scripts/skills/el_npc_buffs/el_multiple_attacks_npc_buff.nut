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
        this.logInfo("actor.isTurnStarted " + actor.isTurnStarted);
        this.logInfo("!actor.isWaitActionSpent " + (!actor.isWaitActionSpent));
        this.logInfo("_skill.isAttack() " + _skill.isAttack());
        this.logInfo("!_skill.isRanged() " + (!_skill.isRanged()));
        this.logInfo("!this.m.EL_IsExtraAttack " + (!this.m.EL_IsExtraAttack));
        this.logInfo("actor.isTurnStarted " + actor.isTurnStarted);
        if(actor.isTurnStarted && !actor.isWaitActionSpent && _skill.isAttack() && !_skill.isRanged() && !this.m.EL_IsExtraAttack) {

            local targets = this.Tactical.Entities.getAllInstances();
            this.m.EL_IsExtraAttack = true;
            local affect_targets = [];
            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if(!t.isAlliedWith(actor) && _skill.isInRange(t.getTile())) {
                        affect_targets.push(t);
                    }
                }
            }
            for(local i = 0; i < affect_targets.len(); ++i) {
                _skill.useForFree(affect_targets[i].getTile());
            }
            this.m.EL_IsExtraAttack = false;

        }
        if(this.m.EL_IsExtraAttack) {
            _properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Factor.MultipleAttacks.DamageDirectMult[this.m.EL_RankLevel];
        }
	}
});


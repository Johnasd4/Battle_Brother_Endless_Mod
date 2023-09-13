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
        if(_skill.isAttack() && !_skill.isRanged() && !this.m.EL_IsExtraAttack) {

            this.logInfo("multiple attack");

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
                if (actor.getFatigue() + _skill.getFatigueCost() < actor.getFatigueMax())
                {
                    _skill.useForFree(affect_targets[i].getTile());
                    actor.setFatigue(actor.getFatigue() + _skill.getFatigueCost());
                }
            }
            this.m.EL_IsExtraAttack = false;

        }
        if(this.m.EL_IsExtraAttack) {
            _properties.DamageDirectMult *= this.Const.EL_NPC.EL_NPCBuff.Factor.MultipleAttacks.DamageDirectMult[this.m.EL_RankLevel];
        }
	}
});


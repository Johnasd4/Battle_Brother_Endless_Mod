this.el_retaliation_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
		EL_IsRetaliate = false
	},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.retaliation";
		this.m.Name = "反击";
		this.m.Description = "";
	}

	function EL_getAttackSkill(_EL_distance)
	{
		local ret;
		local ap = 999;
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (!skill.isActive() || !skill.isAttack() || !skill.isTargeted() || skill.isIgnoredAsAOO() || skill.isDisabled() || !skill.isUsable() || skill.isRanged())
			{
				continue;
			}

			if (_EL_distance < skill.getMinRange() || _EL_distance > skill.getMaxRange())
			{
				continue;
			}

			if (skill.getActionPointCost() < ap)
			{
				ret = skill;
				ap = skill.getActionPointCost();
			}
		}

		return ret;
	}

	function EL_attackBack(_EL_attacker) {
		local actor = this.getContainer().getActor();
		if(_EL_attacker == null || _EL_attacker.isDying() || !_EL_attacker.isAlive() || _EL_attacker.isAlliedWith(actor)) {
			return;
		}
		local attacker_retaliation_skill = _EL_attacker.getSkills().getSkillByID("el_npc_buffs.retaliation");
		if(attacker_retaliation_skill != null && attacker_retaliation_skill.m.EL_IsRetaliate == true) {
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.Retaliation.AttackChance[this.m.EL_RankLevel]) {
            if(actor == null || actor.isDying() || !actor.isAlive() || actor.getSkills().hasSkill("effects.stunned") || actor.getCurrentProperties().IsStunned) {
                return;
            }
            local skill = this.EL_getAttackSkill(actor.getTile().getDistanceTo(_EL_attacker.getTile()));
            if (skill != null && (actor.getFatigue() + skill.getFatigueCost() < actor.getFatigueMax()))
            {
				this.m.EL_IsRetaliate = true;
				for(local i = 0; i < this.Const.EL_NPC.EL_NPCBuff.Factor.Retaliation.RetaliationNum[this.m.EL_RankLevel]; ++i) {
					if(_EL_attacker != null && !_EL_attacker.isDying() && _EL_attacker.isAlive()) {
						if(actor != null && !actor.isDying() && actor.isAlive()) {
							skill.useForFree(_EL_attacker.getTile());
						}
					}
				}
				this.m.EL_IsRetaliate = false;
				actor.setFatigue(actor.getFatigue() + skill.getFatigueCost());
            }
        }
	}

	function onDamageReceived( _attacker, _skill, _properties )
	{
		EL_attackBack(_attacker);
	}

	function onMissed( _attacker, _skill )
	{
		EL_attackBack(_attacker);
	}

});


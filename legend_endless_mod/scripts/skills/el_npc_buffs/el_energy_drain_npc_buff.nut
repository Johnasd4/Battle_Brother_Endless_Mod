this.el_energy_drain_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.energy_drain";
		this.m.Name = "Energy Drain";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local user = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive() || skill.isAttack());
		{
			return;
		}

        local fatigue = _targetEntity.getFatigue();
		this.applyFatigueDamage(_targetEntity, _skill.getActionPointCost() * this.Const.EL_NPC.EL_NPCBuff.Factor.EnergyDrain.FatiguePurActionPoint[this.m.EL_RankLevel]);
		local fatigue_drain = _targetEntity.getFatigue() - fatigue;
		user.setFatigue(this.Math.max(0, user.getFatigue() - fatigue_drain));
	}

});


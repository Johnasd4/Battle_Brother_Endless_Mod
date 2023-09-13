this.el_life_drain_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.life_drain";
		this.m.Name = "Life Drain";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local user = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive() || skill.isAttack());
		{
			return;
		}
        local hitpoints = _targetEntity.getHitpoints();
        local damage = _skill.getActionPointCost() *
                       this.Const.EL_NPC.EL_NPCBuff.Factor.LifeDrain.HitpointsPurActionPoint[this.m.EL_RankLevel] *
                       (1 + this.Const.EL_NPC.EL_NPCBuff.Factor.LifeDrain.HitpointsMultPurCombatLevel * user.EL_getNPCLevel());
        local hit_info = clone this.Const.Tactical.HitInfo;
        hit_info.DamageRegular = final_damage;
        hit_info.DamageDirect = 1.0;
        hit_info.BodyPart = this.Const.BodyPart.Body;
        hit_info.BodyDamageMult = 1.0;
        hit_info.FatalityChanceMult = 0.0;
        t.onDamageReceived(user, this, hit_info);
        local current_hitpoints = this.Math.max(0, _targetEntity.getHitpoints());
        if(current_hitpoints < hitpoints) {
            local hitpoints_drain = hitpoints - current_hitpoints;
        }
		user.setHitpoints(this.Math.max(user.getHitpointsMax(), user.getHitpoints() + hitpoints_drain * this.Const.EL_NPC.EL_NPCBuff.Factor.LifeDrain.RecoverMult));
	}

});


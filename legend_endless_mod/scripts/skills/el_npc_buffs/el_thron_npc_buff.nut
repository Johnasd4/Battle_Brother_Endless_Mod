this.el_thron_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.thron";
		this.m.Name = "Thron";
		this.m.Description = "";
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
        if(_attacker == null || _attacker.isDying() || !_attacker.isAlive()) {
            return;
        }
        local actor = this.getContainer().getActor();
        local damage = this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageBase * (1 + actor.EL_getCombatLevel() * this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageMultPurCombatLevel) * this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageRate[this.m.EL_RankLevel]);

        local hit_info = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage;
		hitInfo.DamageArmor = damage;
        hit_info.DamageDirect = 0;
        hit_info.BodyPart = _hitInfo.BodyPart;
        hit_info.BodyDamageMult = 1.0;
        hit_info.FatalityChanceMult = 0.0;
        _attacker.onDamageReceived(actor, this, hit_info);

        if (!_attacker.isHiddenToPlayer())
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " has been rebounded!");
        }
	}

});


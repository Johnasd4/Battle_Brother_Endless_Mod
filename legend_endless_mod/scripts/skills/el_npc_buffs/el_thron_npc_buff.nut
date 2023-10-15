this.el_thron_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
		EL_IsThron = false
	},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.thron";
		this.m.Name = "Thron";
		this.m.Description = "";
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
        local actor = this.getContainer().getActor();
        if(_attacker == null || _attacker.isDying() || !_attacker.isAlive() || _attacker == actor || this.m.EL_IsThron) {
            return;
        }
        local damage = this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageBase * (1 + actor.EL_getCombatLevel() * this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageMultPurCombatLevel) * this.Const.EL_NPC.EL_NPCBuff.Factor.Thron.DamageRate[this.m.EL_RankLevel]);
        local hit_info = clone this.Const.Tactical.HitInfo;
		hit_info.DamageRegular = damage;
		hit_info.DamageArmor = damage;
        hit_info.DamageDirect = 0;
        hit_info.BodyPart = _hitInfo.BodyPart;
        hit_info.BodyDamageMult = 1.0;
        hit_info.FatalityChanceMult = 0.0;
        this.m.EL_IsThron = true;
        _attacker.onDamageReceived(actor, this, hit_info);
        this.m.EL_IsThron = false;
        if (!_attacker.isHiddenToPlayer())
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " has been rebounded!");
        }
	}

});


this.el_wither_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.wither";
		this.m.Name = "Wither";
		this.m.Description = "";
	}

	function onTurnEnd()
	{
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
        local damage = this.Math.round((this.Const.EL_NPC.EL_NPCBuff.Factor.Wither.DamageBase * (1 + actor.EL_getCombatLevel() * this.Const.EL_NPC.EL_NPCBuff.Factor.Wither.DamageMultPurCombatLevel)) * this.Const.EL_NPC.EL_NPCBuff.Factor.Wither.DamageRate[this.m.EL_RankLevel]);
        local affect_targets = [];
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if(t != null && !t.isAlliedWith(actor) && !t.isDying() && t.isAlive()) {
                    local distance = actor.getTile().getDistanceTo(t.getTile());
                    if(distance <= this.Const.EL_NPC.EL_NPCBuff.Factor.Wither.MaxDistance) {
                        affect_targets.push(t);
                    }
                }
            }
        }

        for(local i = 0; i < affect_targets.len(); ++i) {
            if(affect_targets[i] == null || affect_targets[i].isDying() || !affect_targets[i].isAlive()) {
                continue;
            }
            local distance = actor.getTile().getDistanceTo(affect_targets[i].getTile());
            local damage_persent = this.Math.pow(this.Const.EL_NPC.EL_NPCBuff.Factor.Wither.DamageDecayRatePurTile, (distance - 1));
			local hit_info = clone this.Const.Tactical.HitInfo;
			hit_info.DamageRegular = this.Math.round(damage_persent * damage);
			hit_info.DamageDirect = 1;
			hit_info.BodyPart = this.Const.BodyPart.Body;
			hit_info.BodyDamageMult = 1.0;
			hit_info.FatalityChanceMult = 0.0;
			affect_targets[i].onDamageReceived(actor, this, hit_info);

        }

        if (!actor.isHiddenToPlayer())
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " explodes and dealt huge damage to everyone near!");
        }
	}
});


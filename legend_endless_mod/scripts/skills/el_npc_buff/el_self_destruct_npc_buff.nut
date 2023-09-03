this.el_self_destruct_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.self_destruct";
		this.m.Name = "Self Destruct";
		this.m.Description = "";
	}

	function onDeath( _fatalityType )
	{
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
        local damage = this.Math.round(actor.getHitpointsMax() * this.Const.EL_NPC.EL_NPCBuff.SelfDestruct.DamageRate[this.m.EL_RankLevel]);
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                local damage_persent = 1 - (actor.getTile().getDistanceTo(t.getTile()) - 1) * this.Const.EL_NPC.EL_NPCBuff.SelfDestruct.DamageDecayRatePurTile;

                if(damage_persent > 0) {
                    local final_damage = this.Math.Round(damage_persent * damage * 0.5);
                    local body_hit_info = clone this.Const.Tactical.HitInfo;
                    body_hit_info.DamageRegular = final_damage;
                    body_hit_info.DamageDirect = 1.0;
                    body_hit_info.BodyPart = this.Const.BodyPart.Body;
                    body_hit_info.BodyDamageMult = 1.0;
                    body_hit_info.FatalityChanceMult = 0.0;
                    body_hit_info.Injuries = this.Const.Injury.BurningBody;
                    this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, body_hit_info);
                    local head_hit_info = clone this.Const.Tactical.HitInfo;
                    head_hit_info.DamageRegular = final_damage;
                    head_hit_info.DamageDirect = 1.0;
                    head_hit_info.BodyPart = this.Const.BodyPart.Head;
                    head_hit_info.BodyDamageMult = 1.0;
                    head_hit_info.FatalityChanceMult = 0.0;
                    head_hit_info.Injuries = this.Const.Injury.BurningHead;
                    this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, head_hit_info);
                }
            }
        }
        if (!actor.isHiddenToPlayer())
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " explodes and dealt huge damage to everyone near!");
        }
	}

});


this.el_exploding_ammo_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.RangeState
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.exploding_ammo";
		this.m.Name = "Exploding Ammo";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        if(!skill.isRanged()) {
            return;
        }
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
        local damage = this.Math.floor((this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.DamageBase * (1 + actor.EL_getCombatLevel() * this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.DamageMultPurCombatLevel)) * this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.DamageRate[this.m.EL_RankLevel]);
        local affect_targets = [_targetEntity];
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if(t != null && !t.isDying() && t.isAlive()) {
                    local distance = _targetEntity.getTile().getDistanceTo(t.getTile());
                    if(distance <= this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.MaxDistance) {
                        affect_targets.push(t);
                    }
                }
            }
        }

        for(local i = 0; i < affect_targets.len(); ++i) {
            if(affect_targets[i]== null || affect_targets[i].isDying() || !affect_targets[i].isAlive()) {
                continue;
            }
            local distance = actor.getTile().getDistanceTo(affect_targets[i].getTile());
            //this.logInfo("distance " + i + " " + distance);
            local damage_persent = this.Math.pow(this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.DamageDecayRatePurTile, (distance - 1));
            local final_damage = this.Math.ceil(damage_persent * damage);

            local main_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
            if(main_hand != null) {
                main_hand.setCondition(this.Math.max(0, main_hand.getCondition() - this.Math.floor(main_hand.getConditionMax() * this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.WeaponShieldDamageRate[this.m.EL_RankLevel] * damage_persent)));
            }
            local off_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
            if(off_hand != null) {
                off_hand.setCondition(this.Math.max(0, off_hand.getCondition() - this.Math.floor(off_hand.getConditionMax() * this.Const.EL_NPC.EL_NPCBuff.Factor.ExplodingAmmo.WeaponShieldDamageRate[this.m.EL_RankLevel] * damage_persent)));
            }

            if(affect_targets[i]!= null && !affect_targets[i].isDying() && affect_targets[i].isAlive()) {
                local body_hit_info = clone this.Const.Tactical.HitInfo;
                body_hit_info.DamageRegular = final_damage;
                body_hit_info.DamageArmor = final_damage;
                body_hit_info.DamageDirect = 0;
                body_hit_info.BodyPart = this.Const.BodyPart.Body;
                body_hit_info.BodyDamageMult = 1.0;
                body_hit_info.FatalityChanceMult = 0.0;
                body_hit_info.Injuries = this.Const.Injury.BurningBody;
                affect_targets[i].onDamageReceived(this.getContainer().getActor(), this, body_hit_info);
            }

            if(affect_targets[i]!= null && !affect_targets[i].isDying() && affect_targets[i].isAlive()) {
                local head_hit_info = clone this.Const.Tactical.HitInfo;
                head_hit_info.DamageRegular = final_damage;
                head_hit_info.DamageArmor = final_damage;
                head_hit_info.DamageDirect = 0;
                head_hit_info.BodyPart = this.Const.BodyPart.Head;
                head_hit_info.BodyDamageMult = 1.0;
                head_hit_info.FatalityChanceMult = 0.0;
                head_hit_info.Injuries = this.Const.Injury.BurningHead;
                affect_targets[i].onDamageReceived(this.getContainer().getActor(), this, head_hit_info);
            }

        }

        if (!actor.isHiddenToPlayer())
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " ammo explodes and hit everyone near!");
        }
	}

});


this.el_undead_dagger_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_effect.goblin_tuchun_crossbow";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

    function onTargetKilled ( _targetEntity, _skill )
	{
		if(!_skill.m.IsWeaponSkill)
		{
			this.logInfo("not weapon skill");
			return;
		}
		if(_targetEntity != null)
		{
			local targets = this.Tactical.Entities.getAllInstances();
        	local damage = this.Math.floor((this.Const.EL_NPC.EL_NPCBuff.Factor.SelfDestruct.DamageBase * (1 + _targetEntity.EL_getCombatLevel() * this.Const.EL_NPC.EL_NPCBuff.Factor.SelfDestruct.DamageMultPurCombatLevel)) * this.Const.EL_NPC.EL_NPCBuff.Factor.SelfDestruct.DamageRate[_targetEntity.EL_getRankLevel()]);
			if(_targetEntity.EL_isNonHumanoid()) {
				local level_ups = _targetEntity.EL_getLevel();
				if(level_ups > this.Const.EL_NPC.EL_LevelUp.MaxXPLevel) {
					level_ups = this.Const.EL_NPC.EL_LevelUp.MaxXPLevel + (level_ups - this.Const.EL_NPC.EL_LevelUp.MaxXPLevel) * this.Const.EL_NPC.EL_LevelUp.PropertiesLevelUpMultAfterMaxXPLevel;
				}
				level_ups -= this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset;
				if(level_ups < 0) {
					level_ups = 0;
				}
				damage = this.Math.floor(damage / (1.0 + this.Const.EL_NPC.EL_LevelUp.LevelUpDamageMult * level_ups));
			}
			local affect_targets = [];
			foreach( tar in targets )
			{
				foreach( t in tar )
				{
					if(t != null && !t.isAlliedWith(this.getContainer().getActor()) && !t.isDying() && t.isAlive()) {
						local distance = _targetEntity.getTile().getDistanceTo(t.getTile());
						if(distance <= this.Const.EL_NPC.EL_NPCBuff.Factor.SelfDestruct.MaxDistance) {
							affect_targets.push(t);
						}
					}
				}
			}

			for(local i = 0; i < affect_targets.len(); ++i) {
				if(affect_targets[i]== null || affect_targets[i].isDying() || !affect_targets[i].isAlive()) {
					continue;
				}
				local distance = _targetEntity.getTile().getDistanceTo(affect_targets[i].getTile());
				//this.logInfo("distance " + i + " " + distance);
				local damage_persent = this.Math.pow(this.Const.EL_NPC.EL_NPCBuff.Factor.SelfDestruct.DamageDecayRatePurTile, (distance - 1));
				local final_damage = this.Math.ceil(damage_persent * damage);

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
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " 爆炸了!");
		}
		else
		{
			this.logInfo("_targetEntity null");
		}
	}
});


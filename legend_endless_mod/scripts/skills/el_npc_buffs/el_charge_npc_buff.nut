this.el_charge_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.charge";
		this.m.Name = "Charge";
		this.m.Description = "";
        this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knock_to_tile = _targetTile.getNextTile(dir);

			if (knock_to_tile.IsEmpty && knock_to_tile.Level - _targetTile.Level <= 1)
			{
				return knock_to_tile;
			}
		}

		local alt_dir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(alt_dir))
		{
			local knock_to_tile = _targetTile.getNextTile(alt_dir);

			if (knock_to_tile.IsEmpty && knock_to_tile.Level - _targetTile.Level <= 1)
			{
				return knock_to_tile;
			}
		}

		alt_dir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(alt_dir))
		{
			local knock_to_tile = _targetTile.getNextTile(alt_dir);

			if (knock_to_tile.IsEmpty && knock_to_tile.Level - _targetTile.Level <= 1)
			{
				return knock_to_tile;
			}
		}

		return null;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        local user = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive());
		{
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.Charge.Chance[this.m.EL_RankLevel]) {

            _targetEntity.getSkills().add(this.new("scripts/skills/effects/legend_dazed_effect"));
            local potentialInjuries = [];
            for(local i = 0; i < this.Const.EL_NPC.EL_NPCBuff.Factor.Charge.InjuryNum[this.m.EL_RankLevel]; ++i) {
				foreach( inj in _hitInfo.Injuries )
				{
					if (inj.Threshold * _hitInfo.InjuryThresholdMult * this.Const.Combat.InjuryThresholdMult * this.m.CurrentProperties.ThresholdToReceiveInjuryMult * bonus <= damage / (this.getHitpointsMax() * 1.0))
					{
						if (!this.m.Skills.hasSkill(inj.ID) && this.m.ExcludedInjuries.find(inj.ID) == null)
						{
							potentialInjuries.push(inj.Script);
						}
					}
				}

				local appliedInjury = false;

				while (potentialInjuries.len() != 0)
				{
					local r = this.Math.rand(0, potentialInjuries.len() - 1);
					local injury = this.new("scripts/skills/" + potentialInjuries[r]);

					if (injury.isValid(this))
					{
						this.m.Skills.add(injury);

						if (this.isPlayerControlled() && this.isKindOf(this, "player"))
						{
							this.worsenMood(this.Const.MoodChange.Injury, "Suffered an injury");

							if (("State" in this.World) && this.World.State != null && this.World.Ambitions.hasActiveAmbition() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_sacrifice")
							{
								this.World.Statistics.getFlags().increment("OathtakersInjuriesSuffered");
							}
						}

						if (this.isPlayerControlled() || !this.isHiddenToPlayer())
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage and suffers " + injury.getNameOnly() + "!");
						}

						appliedInjury = true;
						break;
					}
					else
					{
						potentialInjuries.remove(r);
					}
				}
            }


            local target_tile = _targetEntity.getTile();

            local knock_to_tile = this.findTileToKnockBackTo(user.getTile(), target_tile);

            if (knock_to_tile == null)
            {
                return;
            }
            if (_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab || _targetEntity.getCurrentProperties().IsRooted)
            {
                return;
            }

            if (!user.isHiddenToPlayer() && (target_tile.IsVisibleForPlayer || knock_to_tile.IsVisibleForPlayer))
            {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_targetEntity));
            }

            local skills = _targetEntity.getSkills();
            skills.removeByID("effects.shieldwall");
            skills.removeByID("effects.spearwall");
            skills.removeByID("effects.riposte");

            if (this.m.SoundOnHit.len() != 0)
            {
                this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, user.getPos());
            }

            _targetEntity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
            local damage = this.Math.max(0, this.Math.abs(knock_to_tile.Level - target_tile.Level) - 1) * this.Const.Combat.FallingDamage;

            if (damage == 0)
            {
                this.Tactical.getNavigator().teleport(_targetEntity, knock_to_tile, null, null, true);
            }
            else
            {
                local p = this.getContainer().getActor().getCurrentProperties();
                local tag = {
                    Attacker = user,
                    Skill = this,
                    HitInfo = clone this.Const.Tactical.HitInfo,
                    HitInfoBash = null
                };
                tag.HitInfo.DamageRegular = damage;
                tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
                tag.HitInfo.DamageDirect = 1.0;
                tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
                tag.HitInfo.BodyDamageMult = 1.0;
                tag.HitInfo.FatalityChanceMult = 1.0;

                this.Tactical.getNavigator().teleport(_targetEntity, knock_to_tile, this.onKnockedDown, tag, true);
            }
            return;
        }
	}

});


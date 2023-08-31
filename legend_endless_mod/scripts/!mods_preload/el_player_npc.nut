local gt = getroottable();

::mods_registerMod("el_player_npc", 1, "el_player_npc");
::mods_queue(null, "el_world", function ()
{

	::mods_hookExactClass("entity/tactical/actor", function(o){

		o.m.EL_RankLevel <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize( _out );
			_out.writeI32(this.m.EL_RankLevel);
			//this.logInfo("this.EL_RankLevel : " + this.m.EL_RankLevel);
		}
		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize( _in );
			this.m.EL_RankLevel = _in.readI32();
			//this.logInfo("this.EL_RankLevel : " + this.m.EL_RankLevel);
		}


		local onTurnStart = o.onTurnStart;
		o.onTurnStart = function() {
			onTurnStart();
			if (!this.isAlive())
			{
				return;
			}
			this.m.Fatigue -= this.Math.floor(this.m.CurrentProperties.Stamina / this.Const.EL_PlayerNPC.EL_ExtraFatigueRecovery.DivFactor + this.Const.EL_PlayerNPC.EL_ExtraFatigueRecovery.Offset);
			if(this.m.Fatigue < 0) {
				this.m.Fatigue = 0;
			}
			if(this.m.Fatigue > this.getFatigueMax()) {
				this.m.Fatigue = this.getFatigueMax();
			}
			return;
		}

		o.EL_getRankLevel <- function ()
		{
			return this.m.EL_RankLevel;
		}
		o.EL_setRankLevel <- function (_EL_RankLevel)
		{
			this.m.EL_RankLevel = _EL_RankLevel;
		}
		o.EL_getCombatLevel <- function ()
		{
			return this.m.CurrentProperties.EL_CombatLevel;
		}
		o.EL_setCombatLevel <- function (_EL_CombatLevel)
		{
			this.m.BaseProperties.EL_CombatLevel = _EL_CombatLevel;
		}

		o.getXPValue = function() {
			return this.Const.EL_PlayerNPC.EL_XPValue.Offset + this.EL_getCombatLevel() * this.Const.EL_PlayerNPC.EL_XPValue.Mult;
		}


        o.getXP <- function() {
            return this.m.XP;
        }

		o.checkMorale = function(_change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false)
		{

			if (this.isAlive() && !this.isDying())
			{
				if (_change > 0)
				{
					local acSkill = this.m.Skills.getSkillByID("perk.legend_assured_conquest");
					if (acSkill != null)
					{
						_difficulty += acSkill.getBonusResAtPositiveMoraleCheck();
					}
				}

				if (_change < 0)
				{
					local familyPride = this.m.Skills.getSkillByID("perk.ptr_family_pride");
					if (familyPride != null && this.m.MoraleState <= familyPride.getMinMoraleState())
					{
						return false;
					}

					if (_type == this.Const.MoraleCheckType.MentalAttack)
					{
						local tsSkill = this.m.Skills.getSkillByID("perk.ptr_trauma_survivor");
						if (tsSkill != null)
						{
							_difficulty += tsSkill.getBonusRes();
						}
					}
					else
					{
						local bulwark = this.m.Skills.getSkillByID("perk.ptr_bulwark");
						if (bulwark != null)
						{
							_difficulty += bulwark.getBonus();
						}
					}
				}
			}

			if (!this.isAlive() || this.isDying())
			{
				return false;
			}

			if (this.m.MoraleState == this.Const.MoraleState.Ignore)
			{
				return false;
			}

			if (_change > 0 && this.m.MoraleState == this.Const.MoraleState.Confident)
			{
				return false;
			}

			if (_change < 0 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
			{
				return false;
			}

			if (_change > 0 && this.m.MoraleState >= this.m.MaxMoraleState)
			{
				return false;
			}

			if (_change == 1 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
			{
				return false;
			}

			if (this.isAlive() && !this.isDying())
			{
				if (_change < 0)
				{
					if (this.m.MoraleState <= this.Const.EL_PlayerNPC.EL_RankToMoraleMin[this.m.EL_RankLevel])
					{
						return false;
					}
				}
			}

			local myTile = this.getTile();

			if (this.isPlayerControlled() && _change > 0 && (myTile.SquareCoords.X == 0 || myTile.SquareCoords.Y == 0 || myTile.SquareCoords.X == 31 || myTile.SquareCoords.Y == 31))
			{
				return false;
			}

			_difficulty = _difficulty * this.getCurrentProperties().MoraleEffectMult;
			local bravery = (this.getBravery() + this.getCurrentProperties().MoraleCheckBravery[_type]) * this.getCurrentProperties().MoraleCheckBraveryMult[_type];

			local head_count_gap = 0;
			local threatBonus = 0;
			for( local i = 0; i != 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = myTile.getNextTile(i);

					if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
					{
						if (tile.getEntity().isAlliedWith(this))
						{
							head_count_gap += this.Math.pow(this.Const.EL_PlayerNPC.EL_Morale.HeadCount.Factor1, tile.getEntity().m.EL_RankLevel - this.m.EL_RankLevel);
						}
						else
						{
							head_count_gap -= this.Math.pow(this.Const.EL_PlayerNPC.EL_Morale.HeadCount.Factor1, tile.getEntity().m.EL_RankLevel - this.m.EL_RankLevel);
							threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
						}
					}
				}
			}
			local head_count_bouns = this.Const.EL_PlayerNPC.EL_Morale.HeadCount.Factor3 * this.Math.pow(head_count_gap, this.Const.EL_PlayerNPC.EL_Morale.HeadCount.Factor2);


			if (_change > 0)
			{
				if (this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
				{
					if (this.Math.rand(1, 100) > this.m.CurrentProperties.RerollMoraleChance || this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
					{
						return false;
					}
				}
			}
			else if (_change < 0)
			{
				if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
				{
					return false;
				}

				if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
				{
					return false;
				}
			}
			else if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
			{
				return true;
			}
			else if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - head_count_bouns - threatBonus))
			{
				return true;
			}
			else
			{
				return false;
			}

			local oldMoraleState = this.m.MoraleState;
			this.m.MoraleState = this.Math.min(this.Const.MoraleState.Confident, this.Math.max(0, this.m.MoraleState + _change));
			this.m.FleeingRounds = 0;

			if (this.m.MoraleState == this.Const.MoraleState.Confident && oldMoraleState != this.Const.MoraleState.Confident && ("State" in this.World) && this.World.State != null && this.World.Ambitions.hasActiveAmbition() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie")
			{
				this.World.Statistics.getFlags().increment("OathtakersBrosConfident");
			}

			if (oldMoraleState == this.Const.MoraleState.Fleeing && this.m.IsActingEachTurn)
			{
				this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());

				if (this.isPlayerControlled() || !this.isHiddenToPlayer())
				{
					if (_noNewLine)
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " has rallied");
					}
					else
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " has rallied");
					}
				}
			}
			else if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
			{
				this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());
				this.m.Skills.removeByID("effects.shieldwall");
				this.m.Skills.removeByID("effects.spearwall");
				this.m.Skills.removeByID("effects.riposte");
				this.m.Skills.removeByID("effects.return_favor");
				this.m.Skills.removeByID("effects.indomitable");
			}

			local morale = this.getSprite("morale");

			if (this.Const.MoraleStateBrush[this.m.MoraleState].len() != 0)
			{
				if (this.m.MoraleState == this.Const.MoraleState.Confident)
				{
					morale.setBrush(this.m.ConfidentMoraleBrush);
				}
				else
				{
					morale.setBrush(this.Const.MoraleStateBrush[this.m.MoraleState]);
				}

				morale.Visible = true;
			}
			else
			{
				morale.Visible = false;
			}

			if (this.isPlayerControlled() || !this.isHiddenToPlayer())
			{
				if (_noNewLine)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
				}
				else
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
				}

				if (_showIconBeforeMoraleIcon != "")
				{
					this.Tactical.spawnIconEffect(_showIconBeforeMoraleIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
				}

				if (_change > 0)
				{
					this.Tactical.spawnIconEffect(this.Const.Morale.MoraleUpIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
				}
				else
				{
					this.Tactical.spawnIconEffect(this.Const.Morale.MoraleDownIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
				}
			}

			this.m.Skills.update();
			this.setDirty(true);

			if (this.m.MoraleState == this.Const.MoraleState.Fleeing && this.Tactical.TurnSequenceBar.getActiveEntity() != this)
			{
				this.Tactical.TurnSequenceBar.pushEntityBack(this.getID());
			}

			if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
			{
				local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

				if (actors != null)
				{
					foreach( a in actors )
					{
						if (a.getID() != this.getID())
						{
							a.onOtherActorFleeing(this);
						}
					}
				}
			}
			return true;
		}

		o.onDamageReceived = function( _attacker, _skill, _hitInfo )
		{
			if (!this.isAlive() || !this.isPlacedOnMap())
			{
				return 0;
			}

			if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
			{
				return 0;
			}

			if (typeof _attacker == "instance")
			{
				_attacker = _attacker.get();
			}

			if (_attacker != null && _attacker.isAlive() && _attacker.isPlayerControlled() && !this.isPlayerControlled())
			{
				this.setDiscovered(true);
				this.getTile().addVisibilityForFaction(this.Const.Faction.Player);
				this.getTile().addVisibilityForCurrentEntity();
			}

			if (this.m.Skills.hasSkill("perk.steel_brow"))
			{
				_hitInfo.BodyDamageMult = 1.0;
			}

			local p = this.m.Skills.buildPropertiesForBeingHit(_attacker, _skill, _hitInfo);
			this.m.Items.onBeforeDamageReceived(_attacker, _skill, _hitInfo, p);
			local dmgMult = p.DamageReceivedTotalMult;

			if (_skill != null)
			{
				dmgMult = dmgMult * (_skill.isRanged() ? p.DamageReceivedRangedMult : p.DamageReceivedMeleeMult);
			}

			_hitInfo.DamageRegular -= p.DamageRegularReduction;
			_hitInfo.DamageArmor -= p.DamageArmorReduction;
			_hitInfo.DamageRegular *= p.DamageReceivedRegularMult * dmgMult;
			_hitInfo.DamageArmor *= p.DamageReceivedArmorMult * dmgMult;
			local armor = 0;
			local armorDamage = 0;

			if (_hitInfo.DamageDirect < 1.0)
			{
				armor = p.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart];
				armorDamage = this.Math.min(armor, _hitInfo.DamageArmor);
				armor = armor - armorDamage;
				_hitInfo.DamageInflictedArmor = this.Math.max(0, armorDamage);
			}

			_hitInfo.DamageFatigue *= p.FatigueEffectMult;
			this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult * this.m.CurrentProperties.FatigueLossOnAnyAttackMult));
			local damage = 0;
			damage = damage + this.Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect * p.DamageReceivedDirectMult - armor * this.Const.Combat.ArmorDirectDamageMitigationMult);

			if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
			{
				damage = damage + this.Math.max(0, _hitInfo.DamageRegular * this.Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect * p.DamageReceivedDirectMult) - armorDamage);
			}

			damage = damage * _hitInfo.BodyDamageMult;
			damage = this.Math.max(0, this.Math.max(this.Math.round(damage), this.Math.min(this.Math.round(_hitInfo.DamageMinimum), this.Math.round(_hitInfo.DamageMinimum * p.DamageReceivedTotalMult))));
			_hitInfo.DamageInflictedHitpoints = damage;
			this.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

			if (armorDamage > 0 && !this.isHiddenToPlayer() && _hitInfo.IsPlayingArmorSound)
			{
				local armorHitSound = this.m.Items.getAppearance().ImpactSound[_hitInfo.BodyPart];

				if (armorHitSound.len() > 0)
				{
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, this.getPos());
				}

				if (damage < this.Const.Combat.PlayPainSoundMinDamage)
				{
					this.playSound(this.Const.Sound.ActorEvent.NoDamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] * this.m.SoundVolumeOverall);
				}
			}

			if (damage > 0)
			{
				if (!this.m.IsAbleToDie && damage >= this.m.Hitpoints)
				{
					this.m.Hitpoints = 1;
				}
				else
				{
					this.m.Hitpoints = this.Math.round(this.m.Hitpoints - damage);
				}
			}

			if (this.m.Hitpoints <= 0)
			{
				local lorekeeperPotionEffect = this.m.Skills.getSkillByID("effects.lorekeeper_potion");

				if (lorekeeperPotionEffect != null && (!lorekeeperPotionEffect.isSpent() || lorekeeperPotionEffect.getLastFrameUsed() == this.Time.getFrame()))
				{
					this.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
					this.m.Hitpoints = this.getHitpointsMax();
					lorekeeperPotionEffect.setSpent(true);
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " is reborn by the power of the Lorekeeper!");
				}
				else
				{
					local nineLivesSkill = this.m.Skills.getSkillByID("perk.nine_lives");

					if (nineLivesSkill != null && (!nineLivesSkill.isSpent() || nineLivesSkill.getLastFrameUsed() == this.Time.getFrame()))
					{
						this.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
						this.m.Hitpoints = this.Math.rand(11, 15);
						nineLivesSkill.setSpent(true);
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " has nine lives!");
					}
				}
			}

			local fatalityType = this.Const.FatalityType.None;

			if (this.m.Hitpoints <= 0)
			{
				this.m.IsDying = true;

				if (_skill != null)
				{
					if (_skill.getChanceDecapitate() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceDecapitate() * _hitInfo.FatalityChanceMult)
					{
						fatalityType = this.Const.FatalityType.Decapitated;
					}
					else if (_skill.getChanceSmash() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceSmash() * _hitInfo.FatalityChanceMult)
					{
						fatalityType = this.Const.FatalityType.Smashed;
					}
					else if (_skill.getChanceDisembowel() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Body && this.Math.rand(1, 100) <= _skill.getChanceDisembowel() * _hitInfo.FatalityChanceMult)
					{
						fatalityType = this.Const.FatalityType.Disemboweled;
					}
				}
			}

			if (_hitInfo.DamageDirect < 1.0)
			{
				local overflowDamage = _hitInfo.DamageArmor;

				if (this.m.BaseProperties.Armor[_hitInfo.BodyPart] != 0)
				{
					overflowDamage = overflowDamage - this.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.BaseProperties.ArmorMult[_hitInfo.BodyPart];
					this.m.BaseProperties.Armor[_hitInfo.BodyPart] = this.Math.max(0, this.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.BaseProperties.ArmorMult[_hitInfo.BodyPart] - _hitInfo.DamageArmor);
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s armor is hit for [b]" + this.Math.floor(_hitInfo.DamageArmor) + "[/b] damage");
				}

				if (overflowDamage > 0)
				{
					this.m.Items.onDamageReceived(overflowDamage, fatalityType, _hitInfo.BodyPart == this.Const.BodyPart.Body ? this.Const.ItemSlot.Body : this.Const.ItemSlot.Head, _attacker);
				}
			}

			if (this.getFaction() == this.Const.Faction.Player && _attacker != null && _attacker.isAlive())
			{
				this.Tactical.getCamera().quake(_attacker, this, 5.0, 0.16, 0.3);
			}

			if (damage <= 0 && armorDamage >= 0)
			{
				if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
				{
					local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
					local recoverMult = 1.0;
					this.Tactical.getShaker().cancel(this);
					this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectArmorHitColor, this.Const.Combat.ShakeEffectArmorHitHighlight, this.Const.Combat.ShakeEffectArmorHitFactor, this.Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
				}

				this.m.Skills.update();
				this.setDirty(true);
				return 0;
			}

			if (damage >= this.Const.Combat.SpawnBloodMinDamage)
			{
				this.spawnBloodDecals(this.getTile());
			}

			if (this.m.Hitpoints <= 0)
			{
				this.spawnBloodDecals(this.getTile());
				this.kill(_attacker, _skill, fatalityType);
			}
			else
			{
				if (damage >= this.Const.Combat.SpawnBloodEffectMinDamage)
				{
					local mult = this.Math.maxf(0.75, this.Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
					this.spawnBloodEffect(this.getTile(), mult);
				}

				if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && _attacker != null && _attacker.getID() != this.getID())
				{
					local mult = damage / this.getHitpointsMax();

					if (mult >= 0.75)
					{
						this.Sound.play(this.Const.Sound.ArenaBigHit[this.Math.rand(0, this.Const.Sound.ArenaBigHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
					else if (mult >= 0.25 || this.Math.rand(1, 100) <= 20)
					{
						this.Sound.play(this.Const.Sound.ArenaHit[this.Math.rand(0, this.Const.Sound.ArenaHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
				}

				if (this.m.CurrentProperties.IsAffectedByInjuries && this.m.IsAbleToDie && damage >= this.Const.Combat.InjuryMinDamage && this.m.CurrentProperties.ThresholdToReceiveInjuryMult != 0 && _hitInfo.InjuryThresholdMult != 0 && _hitInfo.Injuries != null)
				{
					local potentialInjuries = [];
					local bonus = _hitInfo.BodyPart == this.Const.BodyPart.Head ? 1.25 : 1.0;

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

					if (!appliedInjury)
					{
						if (damage > 0 && !this.isHiddenToPlayer())
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
						}
					}
				}
				else if (damage > 0 && !this.isHiddenToPlayer())
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
				}

				local damage_persent = damage / this.getHitpointsMax() * 100;

				if (this.m.MoraleState != this.Const.MoraleState.Ignore && this.getCurrentProperties().IsAffectedByLosingHitpoints)
				{
					while(damage_persent >= this.Const.EL_PlayerNPC.EL_Morale.Hit.PersentPurCheck) {
						if (!this.isPlayerControlled() || !this.m.Skills.hasSkill("effects.berserker_mushrooms"))
						{
							local offset = this.Const.EL_PlayerNPC.EL_Morale.Hit.Factor2 * this.Math.pow(this.getHitpoints() / this.getHitpointsMax() * 100 / this.Const.EL_PlayerNPC.EL_Morale.Hit.Factor1, this.Const.EL_PlayerNPC.EL_Morale.Hit.Factor3);
							this.checkMorale(-1, offset - (_attacker != null && _attacker.getID() != this.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), this.Const.MoraleCheckType.Default, "", true);
						}
						damage_persent -= this.Const.EL_PlayerNPC.EL_Morale.Hit.PersentPurCheck;
					}
				}

				this.m.Skills.onAfterDamageReceived();

				if (damage >= this.Const.Combat.PlayPainSoundMinDamage && this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() > 0)
				{
					local volume = 1.0;

					if (damage < this.Const.Combat.PlayPainVolumeMaxDamage)
					{
						volume = damage / this.Const.Combat.PlayPainVolumeMaxDamage;
					}

					this.playSound(this.Const.Sound.ActorEvent.DamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] * this.m.SoundVolumeOverall * volume, this.m.SoundPitch);
				}

				this.m.Skills.update();
				this.onUpdateInjuryLayer();

				if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
				{
					local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
					local recoverMult = this.Math.minf(1.5, this.Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));
					this.Tactical.getShaker().cancel(this);
					this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
				}

				this.setDirty(true);
			}

			return damage;
		}


		o.onOtherActorDeath = function( _killer, _victim, _skill ) {
			if (!this.m.IsAlive || this.m.IsDying)
			{
				return;
			}

			if (_victim.getXPValue() <= 1)
			{
				return;
			}
			local difficulty = this.Const.EL_PlayerNPC.EL_Morale.Death.BaseOffset +
							   this.Const.EL_PlayerNPC.EL_Morale.Death.RankFactor * (this.EL_getRankLevel() - _victim.EL_getRankLevel()) +
							   this.Math.pow(this.Const.EL_PlayerNPC.EL_Morale.Death.CombatLevelFactor, this.Math.abs(this.EL_getCombatLevel() - _victim.EL_getCombatLevel())) * (this.EL_getCombatLevel() - _victim.EL_getCombatLevel()) +
							   this.Math.pow(_victim.getTile().getDistanceTo(this.getTile()), this.Const.EL_PlayerNPC.EL_Morale.Death.DistanceFactor);
			if (_victim.getFaction() == this.getFaction() && _victim.getCurrentProperties().TargetAttractionMult >= 0.5 && this.getCurrentProperties().IsAffectedByDyingAllies)
			{
				this.checkMorale(-1, difficulty, this.Const.MoraleCheckType.Default, "", true);
			}
			else if (this.getAlliedFactions().find(_victim.getFaction()) == null)
			{
				this.checkMorale(1, difficulty);
			}
		}

		o.onOtherActorFleeing = function( _actor )
		{
			if (!this.m.IsAlive || this.m.IsDying)
			{
				return;
			}

			if (this.m.CurrentProperties.IsAffectedByFleeingAllies)
			{
				local difficulty = this.Const.EL_PlayerNPC.EL_Morale.Fleeing.BaseOffset +
								   this.Const.EL_PlayerNPC.EL_Morale.Fleeing.RankFactor * (this.EL_getRankLevel() - _actor.EL_getRankLevel()) +
								   this.Math.pow(this.Const.EL_PlayerNPC.EL_Morale.Fleeing.CombatLevelFactor, this.Math.abs(this.EL_getCombatLevel() - _actor.EL_getCombatLevel())) * (this.EL_getCombatLevel() - _actor.EL_getCombatLevel()) +
								   this.Math.pow(_actor.getTile().getDistanceTo(this.getTile()), this.Const.EL_PlayerNPC.EL_Morale.Fleeing.DistanceFactor);
				this.checkMorale(-1, difficulty);
			}
		}

		o.onMovementFinish = function( _tile )
		{
			this.m.IsMoving = true;
			this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.getFaction());

			if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getID())
			{
				this.Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
			}

			this.setZoneOfControl(_tile, this.hasZoneOfControl());

			if (!this.m.IsExertingZoneOfOccupation)
			{
				_tile.addZoneOfOccupation(this.getFaction());
				this.m.IsExertingZoneOfOccupation = true;
			}

			if (this.Const.Tactical.TerrainEffect[_tile.Type].len() > 0 && !this.m.Skills.hasSkill(this.Const.Tactical.TerrainEffectID[_tile.Type]))
			{
				this.m.Skills.add(this.new(this.Const.Tactical.TerrainEffect[_tile.Type]));
			}

			if (_tile.IsHidingEntity)
			{
				this.m.Skills.add(this.new(this.Const.Movement.HiddenStatusEffect));
			}

			local numOfEnemiesAdjacentToMe = _tile.getZoneOfControlCountOtherThan(this.getAlliedFactions());

			if (this.m.CurrentMovementType == this.Const.Tactical.MovementType.Default)
			{
				if (this.m.MoraleState != this.Const.MoraleState.Fleeing)
				{
					for( local i = 0; i != 6; i = ++i )
					{
						if (!_tile.hasNextTile(i))
						{
						}
						else
						{
							local otherTile = _tile.getNextTile(i);

							if (!otherTile.IsOccupiedByActor)
							{
							}
							else
							{
								local otherActor = otherTile.getEntity();
								local numEnemies = otherTile.getZoneOfControlCountOtherThan(otherActor.getAlliedFactions());
								if(otherActor.m.MaxEnemiesThisTurn < numEnemies) {
									otherActor.m.MaxEnemiesThisTurn = numEnemies;
								}
								for(local j = 0; j < 6; ++j) {
									if (otherTile.hasNextTile(j))
									{
										local temp_tile = otherTile.hasNextTile(j);
										local temp_actor = temp_tile.getEntity();
										if (!temp_actor.isAlliedWith(otherActor))
										{
											local difficulty = this.Const.EL_PlayerNPC.EL_Morale.Move.BaseOffset +
															   this.Const.EL_PlayerNPC.EL_Morale.Move.RankFactor * (otherActor.EL_getRankLevel() - temp_actor.EL_getRankLevel()) +
															   this.Math.pow(this.Const.EL_PlayerNPC.EL_Morale.Move.CombatLevelFactor, this.Math.abs(otherActor.EL_getCombatLevel() - temp_actor.EL_getCombatLevel())) * (otherActor.EL_getCombatLevel() - temp_actor.EL_getCombatLevel());
											otherActor.checkMorale(-1, difficulty);

										}
									}
								}
							}
						}
					}
				}
			}
			else if (this.m.CurrentMovementType == this.Const.Tactical.MovementType.Involuntary)
			{
				if (this.m.MaxEnemiesThisTurn < numOfEnemiesAdjacentToMe)
				{
					local difficulty = 40.0;
					this.checkMorale(-1, difficulty);
				}
			}

			this.m.CurrentMovementType = this.Const.Tactical.MovementType.Default;
			this.m.MaxEnemiesThisTurn = this.Math.max(1, numOfEnemiesAdjacentToMe);

			if (this.isPlayerControlled() && this.getMoraleState() > this.Const.MoraleState.Breaking && this.getMoraleState() != this.Const.MoraleState.Ignore && (_tile.SquareCoords.X == 0 || _tile.SquareCoords.Y == 0 || _tile.SquareCoords.X == 31 || _tile.SquareCoords.Y == 31))
			{
				local change = this.getMoraleState() - this.Const.MoraleState.Breaking;
				this.checkMorale(-change, -1000);
			}

			if (this.m.IsEmittingMovementSounds && this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() != 0)
			{
				local sound = this.Const.Tactical.TerrainMovementSound[_tile.Subtype][this.Math.rand(0, this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() - 1)];
				this.Sound.play("sounds/" + sound.File, sound.Volume * this.Const.Sound.Volume.TacticalMovement * this.Math.rand(90, 100) * 0.01, this.getPos(), sound.Pitch * this.Math.rand(95, 105) * 0.01);
			}

			this.spawnTerrainDropdownEffect(_tile);

			if (_tile.Properties.Effect != null && _tile.Properties.Effect.IsAppliedOnEnter)
			{
				_tile.Properties.Effect.Callback(_tile, this);
			}

			this.m.Skills.update();
			this.m.Items.onMovementFinished();
			this.setDirty(true);
			this.m.IsMoving = false;
		}

		o.getDefense = function( _attackingEntity, _skill, _properties )
		{
			local malus = 0;
			local d = 0;

			if (!this.m.CurrentProperties.IsImmuneToSurrounding)
			{
				malus = _attackingEntity != null ? this.Math.max(0, _attackingEntity.getCurrentProperties().SurroundedBonus * _attackingEntity.getCurrentProperties().SurroundedBonusMult - this.getCurrentProperties().SurroundedDefense) * this.getSurroundedCount() : this.Math.max(0, 5 - this.getCurrentProperties().SurroundedDefense) * this.getSurroundedCount();
			}

			if (_skill.isRanged())
			{
				d = _properties.getRangedDefense();
			}
			else
			{
				d = _properties.getMeleeDefense();
			}

			if (!_skill.isRanged())
			{
				d = d - malus;
			}

			return d;
		}


	});

	::mods_hookExactClass("skills/special/morale_check", function( o )
	{
		o.onUpdate = function(_properties) {
			this.m.IsHidden = this.m.Container.getActor().getMoraleState() == this.Const.MoraleState.Steady;
			this.m.Name = this.Const.MoraleStateName[this.m.Container.getActor().getMoraleState()];
			local state = this.m.Container.getActor().getMoraleState();
			_properties.Bravery += this.Const.EL_PlayerNPC.EL_Morale.Effect.BraveryOffset[state];
			_properties.Initiative += this.Const.EL_PlayerNPC.EL_Morale.Effect.InitiativeOffset[state];
			_properties.MeleeSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeSkillOffset[state];
			_properties.RangedSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedSkillOffset[state];
			_properties.MeleeDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeDefenseOffset[state];
			_properties.RangedDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedDefenseOffset[state];

			_properties.FatigueOnSkillUse += this.Const.EL_PlayerNPC.EL_Morale.Effect.FatigueOnSkillUseOffset[state];

			_properties.DamageDirectMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageDirectMult[state];
			_properties.DamageReceivedDirectMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageReceivedDirectMult[state];
			switch(state)
			{
			case this.Const.MoraleState.Confident:
				this.m.Icon = "skills/status_effect_14.png";
				this.m.IconMini = "status_effect_14_mini";
				break;

			case this.Const.MoraleState.Wavering:
				this.m.Icon = "skills/status_effect_02_c.png";
				this.m.IconMini = "status_effect_02_c_mini";
				break;

			case this.Const.MoraleState.Breaking:
				this.m.Icon = "skills/status_effect_02_b.png";
				this.m.IconMini = "status_effect_02_b_mini";
				break;

			case this.Const.MoraleState.Fleeing:
				this.m.Icon = "skills/status_effect_02_a.png";
				this.m.IconMini = "status_effect_02_a_mini";
				break;

			case this.Const.MoraleState.Ignore:
				this.m.Icon = "";
				this.m.IconMini = "";
				this.m.Name = "";
				this.m.IsHidden = true;
				break;
			}
		}
	});

	::mods_hookNewObject("entity/tactical/player", function( o )
	{
		o.getXPValue = function() {
			return this.actor.getXPValue();
		}
	});


});

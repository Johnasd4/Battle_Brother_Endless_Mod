local gt = getroottable();

::mods_registerMod("el_player_npc", 1, "el_player_npc");
::mods_queue(null, "el_world", function ()
{

	::mods_hookNewObject("entity/tactical/actor", function(o){

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

		o.onDamageReceived = function ( _attacker, _skill, _hitInfo )
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
			this.logInfo("dmgMult before " + dmgMult);
			if(_attacker.EL_getCombatLevel() > this.EL_getCombatLevel()) {
				dmgMult *= this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, this.Math.abs(_attacker.EL_getCombatLevel() - this.EL_getCombatLevel()));
				//this.logInfo("attackEntity combat level extra damage mult" + (this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, this.Math.abs(_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()))));
			}
			else {
				dmgMult /= this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, this.Math.abs(_attacker.EL_getCombatLevel() - this.EL_getCombatLevel()));
				//this.logInfo("attackEntity combat level decrease damage mult" + (this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, this.Math.abs(_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()))));
			}
			this.logInfo("dmgMult after " + dmgMult);


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

				if (this.m.MoraleState != this.Const.MoraleState.Ignore && damage >= this.Const.Morale.OnHitMinDamage && this.getCurrentProperties().IsAffectedByLosingHitpoints)
				{
					if (!this.isPlayerControlled() || !this.m.Skills.hasSkill("effects.berserker_mushrooms"))
					{
						this.checkMorale(-1, this.Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpoints() / this.getHitpointsMax()) - (_attacker != null && _attacker.getID() != this.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), this.Const.MoraleCheckType.Default, "", true);
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


	});

	::mods_hookNewObject("entity/tactical/player", function( o )
	{
		o.getXPValue = function() {
			return this.actor.getXPValue();
		}
	});


	::mods_hookClass("skills/skill", function(o) {
		while(!("attackEntity" in o)) o = o[o.SuperName];
		o.m.EL_IsNPCBuff <- false;

		o.EL_isNPCBuff <- function() {
			return this.m.EL_IsNPCBuff;
		}

		o.attackEntity = function( _user, _targetEntity, _allowDiversion = true )
		{
			if (_targetEntity.isRock())
			{
				if (_user.getSkills().hasSkill("perk.legend_specialist_pickaxe_damage"))
				{
					local r = this.Math.rand(0, 99);

					if (r == 99)
					{
						local loot = this.new("scripts/items/trade/uncut_gems_item");
						loot.drop(_targetEntity().getTile());
					}
					else if (r <= 5)
					{
						local loot = this.new("scripts/items/trade/salt_item");
						loot.drop(_targetEntity().getTile());
					}
					else if (r <= 15 && r > 5)
					{
						local loot = this.new("scripts/items/trade/peat_bricks_item");
						loot.drop(_targetEntity().getTile());
					}
				}

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}

				local tile = _targetEntity.getTile();
				local x = tile.X;
				local y = tile.Y;
				this.Tactical.getTile(x, y).removeObject();
				return true;
			}

			if (_targetEntity.isSticks())
			{
				local r = this.Math.rand(0, 4);

				if (r == 1 && _user.getSkills().hasSkill("perk.legend_specialist_woodaxe_damage"))
				{
					local loot = this.new("scripts/items/trade/legend_raw_wood_item");
					loot.drop(_targetEntity.getTile());
				}

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}

				local tile = _targetEntity.getTile();
				local x = tile.X;
				local y = tile.Y;
				this.Tactical.getTile(x, y).removeObject();
				return true;
			}

			if (_targetEntity.isSupplies())
			{
				local r = this.Math.rand(1, 100);

				if (r == 1)
				{
					local loot = this.new("scripts/items/supplies/ammo_small_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 2)
				{
					local loot = this.new("scripts/items/supplies/armor_parts_small_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 3)
				{
					local loot = this.new("scripts/items/supplies/medicine_small_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r >= 4 && r < 6)
				{
					local loot = this.new("scripts/items/supplies/ground_grains_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r >= 7 && r < 9)
				{
					if (this.Math.rand(1, 8) == 8)
					{
						local loot = this.new("scripts/items/supplies/legend_cooking_spices_item");
						loot.drop(_targetEntity.getTile());
					}
				}

				if (r == 10)
				{
					local loot = this.new("scripts/items/supplies/legend_fresh_fruit_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 11)
				{
					local loot = this.new("scripts/items/supplies/strange_meat_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 12)
				{
					local loot = this.new("scripts/items/supplies/legend_human_parts");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 13)
				{
					local loot = this.new("scripts/items/supplies/legend_fresh_meat_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 14)
				{
					local loot = this.new("scripts/items/supplies/beer_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 15)
				{
					local loot = this.new("scripts/items/supplies/bandage_item");
					loot.drop(_targetEntity.getTile());
				}

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}

				local tile = _targetEntity.getTile();
				local x = tile.X;
				local y = tile.Y;
				this.Tactical.getTile(x, y).removeObject();
				return false;
			}

			if (_targetEntity.isTree())
			{
				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}

				local tile = _targetEntity.getTile();
				local x = tile.X;
				local y = tile.Y;
				this.Tactical.getTile(x, y).removeObject();
				this.Tactical.getTile(x, y).spawnObject("entity/tactical/objects/tree_sticks");
				return true;
			}

			if (_targetEntity.isBush())
			{
				local r = this.Math.rand(0, 99);

				if (r <= 25 && _user.getSkills().hasSkill("perk.legend_specialist_sickle_damage"))
				{
					local loot = this.new("scripts/items/supplies/roots_and_berries_item");
					loot.drop(_targetEntity.getTile());
				}

				if (r == 99 && _user.getSkills().hasSkill("perk.legend_specialist_sickle_damage"))
				{
					local loot = this.new("scripts/items/misc/mysterious_herbs_item");
					loot.drop(_targetEntity.getTile());
				}

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}

				local tile = _targetEntity.getTile();
				local x = tile.X;
				local y = tile.Y;
				this.Tactical.getTile(x, y).removeObject();
				return false;
			}

			if (_targetEntity != null && !_targetEntity.isAlive())
			{
				return false;
			}

			local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
			local userTile = _user.getTile();
			local astray = false;

			if (_allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
			{
				local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), _user.getFaction());

				if (blockedTiles.len() != 0 && this.Math.rand(1, 100) <= this.Math.ceil(this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult * 100))
				{
					_allowDiversion = false;
					astray = true;
					_targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
				}
			}

			if (!_targetEntity.isAttackable())
			{
				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

					if (_user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
					{
						this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}
				}

				return false;
			}

			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
			local defense = _targetEntity.getDefense(_user, this, defenderProperties);
			local levelDifference = _targetEntity.getTile().Level - _user.getTile().Level;
			local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
			local toHit = 0;
			local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
			toHit = toHit + skill;
			toHit = toHit - defense;

			if (this.m.IsRanged)
			{
				toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
			}

			if (levelDifference < 0)
			{
				toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
			}
			else
			{
				toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
			}

			local shieldBonus = 0;
			local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
			{
				shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);

				if (!this.m.IsShieldRelevant)
				{
					toHit = toHit + shieldBonus;
				}

				if (_targetEntity.getSkills().hasSkill("effects.shieldwall"))
				{
					if (!this.m.IsShieldwallRelevant)
					{
						toHit = toHit + shieldBonus;
					}

					shieldBonus = shieldBonus * 2;
				}
			}

			toHit = toHit * properties.TotalAttackToHitMult;
			toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);

			if (this.m.IsRanged && !_allowDiversion && this.m.IsShowingProjectile)
			{
				toHit = toHit - 15;
				properties.DamageTotalMult *= 0.75;
			}
			//this.logInfo("attackEntity combat level extra hit chance" + ((_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()) * this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.HitChangeFactor, this.Math.abs(_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()))));
			toHit += (_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()) * this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.HitChangeFactor, this.Math.abs(_user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()));

			if (defense > -100 && skill > -100)
			{
				toHit = this.Math.max(5, this.Math.min(95, toHit));
			}

			_targetEntity.onAttacked(_user);

			if (this.m.IsDoingAttackMove && !_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
			{
				this.Tactical.getShaker().cancel(_user);

				if (this.m.IsDoingForwardMove)
				{
					this.Tactical.getShaker().shake(_user, _targetEntity.getTile(), 5);
				}
				else
				{
					local otherDir = _targetEntity.getTile().getDirectionTo(_user.getTile());

					if (_user.getTile().hasNextTile(otherDir))
					{
						this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(otherDir), 6);
					}
				}
			}

			if (!_targetEntity.isAbleToDie() && _targetEntity.getHitpoints() == 1)
			{
				toHit = 0;
			}

			if (!this.isUsingHitchance())
			{
				toHit = 100;
			}

			local r = this.Math.rand(1, 100);

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == 0)
			{
				if (_user.isPlayerControlled())
				{
					r = this.Math.max(1, r - 5);
				}
				else if (_targetEntity.isPlayerControlled())
				{
					r = this.Math.min(100, r + 5);
				}
			}

			local isHit = r <= toHit;

			if (!_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
			{
				local rolled = r;
				this.Tactical.EventLog.log_newline();

				if (astray)
				{
					if (this.isUsingHitchance())
					{
						if (isHit)
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
						}
						else
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
						}
					}
					else
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
					}
				}
				else if (this.isUsingHitchance())
				{
					if (isHit)
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
					}
					else
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
					}
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
				}
			}

			if (isHit && this.Math.rand(1, 100) <= _targetEntity.getCurrentProperties().RerollDefenseChance)
			{
				r = this.Math.rand(1, 100);
				isHit = r <= toHit;

				if (!isHit)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_targetEntity) + " got lucky.");
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_targetEntity) + " wasn\'t lucky enough.");
				}
			}

			if (isHit)
			{
				this.getContainer().setBusy(true);
				local info = {
					Skill = this,
					Container = this.getContainer(),
					User = _user,
					TargetEntity = _targetEntity,
					Properties = properties,
					DistanceToTarget = distanceToTarget
				};

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || !_targetEntity.isHiddenToPlayer()))
				{
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
					local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledTargetHit, info);

					if (this.m.SoundOnHit.len() != 0)
					{
						this.Time.scheduleEvent(this.TimeUnit.Virtual, time + this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
							Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
							Pos = _targetEntity.getPos()
						});
					}
				}
				else
				{
					if (this.m.SoundOnHit.len() != 0)
					{
						this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
					}

					if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && toHit <= 15)
					{
						this.Sound.play(this.Const.Sound.ArenaShock[this.Math.rand(0, this.Const.Sound.ArenaShock.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}

					this.onScheduledTargetHit(info);
				}

				return true;
			}
			else
			{
				local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
				_targetEntity.onMissed(_user, this, this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2);
				this.m.Container.onTargetMissed(this, _targetEntity);
				local prohibitDiversion = false;

				if (_allowDiversion && this.m.IsRanged && !_user.isPlayerControlled() && this.Math.rand(1, 100) <= 25 && distanceToTarget > 2)
				{
					local targetTile = _targetEntity.getTile();

					for( local i = 0; i < this.Const.Direction.COUNT; i = i )
					{
						if (!targetTile.hasNextTile(i))
						{
						}
						else
						{
							local tile = targetTile.getNextTile(i);

							if (tile.IsEmpty)
							{
							}
							else if (tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_user))
							{
								prohibitDiversion = true;
								break;
							}
						}

						i = ++i;
					}
				}

				if (_allowDiversion && this.m.IsRanged && !(this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2) && !prohibitDiversion && distanceToTarget > 2)
				{
					this.divertAttack(_user, _targetEntity);
				}
				else if (this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2)
				{
					local info = {
						Skill = this,
						User = _user,
						TargetEntity = _targetEntity,
						Shield = shield
					};

					if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
					{
						local divertTile = _targetEntity.getTile();
						local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
						local time = 0;

						if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
						{
							time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
						}

						this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onShieldHit, info);
					}
					else
					{
						this.onShieldHit(info);
					}
				}
				else
				{
					if (this.m.SoundOnMiss.len() != 0)
					{
						this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
					}

					if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
					{
						local divertTile = _targetEntity.getTile();
						local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

						if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
						{
							this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
						}
					}

					if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
					{
						if (toHit >= 90 || _targetEntity.getHitpointsPct() <= 0.1)
						{
							this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaBigMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
						}
						else if (this.Math.rand(1, 100) <= 20)
						{
							this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
						}
					}
				}

				return false;
			}
		}

		o.getHitchance = function( _targetEntity )
		{

			if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
			{
				return 0;
			}

			local user = this.m.Container.getActor();
			local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);

			if (!this.isUsingHitchance())
			{
				return 100;
			}

			local allowDiversion = this.m.IsRanged && this.m.MaxRangeBonus > 1;
			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
			local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
			local defense = _targetEntity.getDefense(user, this, defenderProperties);
			local levelDifference = _targetEntity.getTile().Level - user.getTile().Level;
			local distanceToTarget = user.getTile().getDistanceTo(_targetEntity.getTile());
			local toHit = skill - defense;

			if (this.m.IsRanged)
			{
				toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
			}

			if (levelDifference < 0)
			{
				toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
			}
			else
			{
				toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
			}

			if (!this.m.IsShieldRelevant)
			{
				local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

				if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
				{
					local shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);
					toHit = toHit + shieldBonus;

					if (!this.m.IsShieldwallRelevant && _targetEntity.getSkills().hasSkill("effects.shieldwall"))
					{
						toHit = toHit + shieldBonus;
					}
				}
			}

			toHit = toHit * properties.TotalAttackToHitMult;
			toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);
			local userTile = user.getTile();

			if (allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
			{
				local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), user.getFaction(), true);

				if (blockedTiles.len() != 0)
				{
					local blockChance = this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult;
					toHit = this.Math.floor(toHit * (1.0 - blockChance));
				}
			}

			local EL_combat_level_extra_chance = (user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()) * this.Math.pow(1.04, this.Math.abs(user.EL_getCombatLevel() - _targetEntity.EL_getCombatLevel()));

			toHit += EL_combat_level_extra_chance;
			//this.logInfo("getHitchance combat level extra hit chance" + EL_combat_level_extra_chance);
			return this.Math.max(5, this.Math.min(95, toHit));
		}

		o.applyFatigueDamage = function( _targetEntity, _damage )
		{
			local user = this.m.Container.getActor();
			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
			local damage_mult = 1;
			if(user.EL_getCombatLevel() > defenderProperties.EL_CombatLevel) {
				damage_mult *= this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, user.EL_getCombatLevel() - defenderProperties.EL_CombatLevel);
			}
			else {
				damage_mult /= this.Math.pow(this.Const.EL_PlayerNPC.EL_CombatLevel.DamageFactor, defenderProperties.EL_CombatLevel - user.EL_getCombatLevel());
			}
			_targetEntity.setFatigue(_targetEntity.getFatigue() + _damage * defenderProperties.FatigueEffectMult * damage_mult);

		}


	});



});

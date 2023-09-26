local gt = this.getroottable();

if (!("EL_Accessory" in gt.Const))
{
	gt.Const.EL_Accessory <- {};
}

gt.Const.EL_Accessory <- {
	EL_RankValue = [
		1,
		2,
		5,
		12,
		25
	],
	EL_LevelFactor = {
		Value = 0.04
	},
	EL_Essence = {
		LevelFactor = 0.04,
		PowFactor = 3,
		SlotFactor = 1
		UpgradeFactor = 1,
		DisassembleFactor = 1,
		RecraftFactor = 1
	},
	EL_DroppedChance = [
		4,
		10,
		40,
		100
	],
	EL_ValidAccessory = [
		"accessory/legendary/cursed_crystal_skull"
		"accessory/special/legend_oms_fate_item",
		"accessory/special/legend_oms_ledger_item",
		"accessory/special/legend_oms_paw_item",
		"accessory/special/legend_oms_rib_item",
		"accessory/alp_trophy_item",
		"accessory/ghoul_trophy_item",
		"accessory/goblin_trophy_item",
		"accessory/hexen_trophy_item",
		"accessory/legend_demon_banshee_trophy_item",
		"accessory/legend_demonalp_trophy_item",
		"accessory/legend_hexen_leader_trophy_item",
		"accessory/legend_wolfsbane_necklace_item",
		"accessory/oathtaker_skull_01_item",
		"accessory/oathtaker_skull_02_item",
		"accessory/orc_trophy_item",
		"accessory/sergeant_badge_item",
		"accessory/undead_trophy_item",
		"el_accessory/el_core_item"
	],
	EL_NormalAccessoryList = [
		"accessory/alp_trophy_item",
		"accessory/hexen_trophy_item",
		"accessory/ghoul_trophy_item"
	],
	EL_SeniorAccessoryList = [
		"accessory/goblin_trophy_item",
		"accessory/orc_trophy_item",
		"accessory/undead_trophy_item",
		"accessory/legend_demon_banshee_trophy_item",
		"accessory/legend_demonalp_trophy_item",
		"accessory/legend_hexen_leader_trophy_item",
		"accessory/legend_wolfsbane_necklace_item",
	],
	EL_RarityEntry = {
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_bloody_cutting_entry"
				},
				// {
				// 	Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_bloody_knock_entry"
				// },
				// {
				// 	Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_circle_of_life_entry"
				// },
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_faith_of_the_rock_entry"
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_fight_and_win_entry"
				},
				// {
				// 	Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_massacre_desire_entry"
				// },
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_master_feat_entry"
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/rarity_entrys/el_toxic_blade_thrust_entry"
				}
			]
		}
		RarityEntryChane = [
			1,
			10,
			100,
			1000,
		],
		Factor = {
			EL_BloodyCutting = {
				TargetHealthLossExtraDamageFactor = 0.5,
				BleedingFactor = 1.0
			},
			EL_BloodyKnock = {
				DamageMult = 5
			},
			EL_CircleofLife = {
				HitpointsRecover = 0.2,
				FatigueRecover = 0.2,
				ArmorConditonRecover = 0.2,
				HelmetConditonRecover = 0.2,
				RiseNum = 1,
				FatigueDrainPercent = [
					1.0,
					0.2,
					0.05
				],
				HitpointsDrainPercent = [
					0.2,
					0.04,
					0.01
				]
			},
			EL_FaithOfTheRock = {
				TargetAttractionMult = 1000
			},
			EL_FightAndWin = {
				WeakenBravery = 5,
				WeakenInitiative = 10,
				WeakenMeleeSkill = 5,
				WeakenRangedSkill = 5,
				WeakenMeleeDefense = 5,
				WeakenRangedDefense = 5,
				WeakenDamageReceivedTotalMult = 0.05,
				TempWeakenBravery = 20,
				TempWeakenInitiative = 30,
				TempWeakenMeleeSkill = 20,
				TempWeakenRangedSkill = 20,
				TempWeakenMeleeDefense = 20,
				TempWeakenRangedDefense = 20,
				TempWeakenDamageReceivedTotalMult = 0.2
			},
			EL_MassacreDesire = {
				DamageMult = 0.1
			},
			EL_MasterFeat = {
				SkillFactor = 1,
				DamageFactor = 0.01,
				MeleeDefenseFactor = 1,
				RangedDefenseFactor = 1
			},
			EL_ToxicBladeThrust = {
				DamageBonus = 0.25,
				DebuffNum = [
					3,
					2,
					1
				]
			}
		}
	}
	EL_Entry = {
		Pool = {
			Entrys = [
                {
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_action_point_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
                {
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_bravery_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_combat_level_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_damage_mult_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_fatigue_recover_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_hitpoints_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_hitpoints_recovery_rate_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_immue_bleeding_poisoned_fire_miasma_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_immue_grab_knock_twirl_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_immue_overwhelm_dazed_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_immue_stun_root_disarm_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_immue_surrounded_riposte_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) {
						if(_EL_item.m.EL_RankLevel >= 2 && _entryLevel >= 1)
						{
							return true;
						}
						return false;
					}
                    function EL_ifNeedRemove(_entryLevel) {
                        if(_entryLevel != 1)
						{
							return true;
						}
						return false;
                    }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_initiative_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_reduce_damage_received_mult_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_stamina_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_value_mult_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				},
				{
					Scripts = "scripts/skills/el_entrys/accessory_entrys/el_xp_gain_mult_entry",
					function EL_ifEligible(_EL_item, _entryLevel = 1) { return true; }
                    function EL_ifNeedRemove(_entryLevel) { return false; }
				}
			],
		},
		EntryNumFactor = {
			NormalAccessory = [
				0.01,
                0.03,
                0.06,
                0.1
			]
		},
		Factor = {
            EL_ActionPoint = {
				ID = "accessory_entry.action_point",
				ActionPoint = 1
			},
            EL_Bravery = {
				ID = "accessory_entry.bravery",
				BaseBravery = 7,
				RandomMinBravery = [
					1,
					1,
					4,
					7,
					15
				],
				RandomMaxBravery = [
					6,
					9,
					12,
					15,
					15
				],
				ColourRange = [
					10,
					13,
					16,
					19
				]
			},
			EL_CombatLevel = {
				ID = "accessory_entry.combat_level",
				BaseCombatLevel = 1,
				RandomMinCombatLevel = [
					1,
					1,
					41,
					81,
					200
				],
				RandomMaxCombatLevel = [
					80,
					120,
					160,
					200,
					200
				],
				ColourRange = [
					1.4,
					1.8,
					2.2,
					2.6
				]
			},
			EL_DamageMult = {
				ID = "accessory_entry.damage_mult",
				BaseDamageMult = 16.66,
				RandomMinDamageMult = [
					1,
					1,
					334,
					667,
					1666
				],
				RandomMaxDamageMult = [
					666,
					1000,
					1333,
					1666,
					1666
				],
				ColourRange = [
					20,
					23.33,
					26.66,
					30
				]
			},
			EL_FatigueRecover = {
				ID = "accessory_entry.fatigue_recover",
				BaseFatigueRecover = 1,
				RandomMinFatigueRecover = [
					1,
					1,
					2,
					3,
					5
				],
				RandomMaxFatigueRecover = [
					2,
					3,
					4,
					5,
					5
				],
				ColourRange = [
					2,
					3,
					4,
					5
				]
			},
			EL_Hitpoints = {
				ID = "accessory_entry.hitpoints",
				BaseHitpoints = 12,
				RandomMinHitpoints = [
					1,
					1,
					6,
					11,
					25
				],
				RandomMaxHitpoints = [
					10,
					15,
					20,
					25,
					25
				],
				ColourRange = [
					17,
					22,
					27,
					32
				]
			},
			EL_HitpointsRecoveryRate = {
				ID = "accessory_entry.hitpoints_recovery_rate",
				BaseHitpointsRecoveryRate = 5,
				RandomMinHitpointsRecoveryRate = [
					1,
					1,
					201,
					401,
					1000
				],
				RandomMaxHitpointsRecoveryRate = [
					400,
					600,
					800,
					1000,
					1000
				],
				ColourRange = [
					7,
					9,
					11,
					13
				]
			},
			EL_ImmueBleedingPoisonedFireMiasma = {
				ID = "accessory_entry.immue_bleeding_poisoned_fire_miasma",
			},
			EL_ImmueGrabKnockTwirl = {
				ID = "accessory_entry.immue_grab_knock_twirl",
			},
			EL_ImmueOverwhelmDazed = {
				ID = "accessory_entry.immue_overwhelm_dazed",
			},
			EL_ImmueStunRootDisarm = {
				ID = "accessory_entry.immue_stun_root_disarm",
			},
			EL_ImmueSurroundedRiposte = {
				ID = "accessory_entry.immue_surrounded_riposte",
			},
			EL_Initiative = {
				ID = "accessory_entry.initiative",
				BaseInitiative = 15,
				RandomMinInitiative = [
					1,
					1,
					7,
					13,
					30
				],
				RandomMaxInitiative = [
					12,
					18,
					24,
					30,
					30
				],
				ColourRange = [
					21,
					27,
					33,
					39
				]
			},
			EL_ReduceDamageReceivedMult = {
				ID = "accessory_entry.reduce_damage_received_mult",
				BaseReduceDamageReceivedMult = 16.66,
				RandomMinReduceDamageReceivedMult = [
					1,
					1,
					334,
					667,
					1666
				],
				RandomMaxReduceDamageReceivedMult = [
					666,
					1000,
					1333,
					1666,
					1666
				],
				ColourRange = [
					20,
					23.33,
					26.66,
					30
				]
			},
			EL_Stamina = {
				ID = "accessory_entry.stamina",
				BaseStamina = 12,
				RandomMinStamina = [
					1,
					1,
					6,
					11,
					25
				],
				RandomMaxStamina = [
					10,
					15,
					20,
					25,
					25
				],
				ColourRange = [
					17,
					22,
					27,
					32
				]
			},
			EL_ValueMult = {
				ID = "accessory_entry.value_mult",
				BaseValueMult = 500,
				RandomMinValueMult = [
					1,
					1,
					201,
					401,
					1000
				],
				RandomMaxValueMult = [
					400,
					600,
					800,
					1000,
					1000
				],
				ColourRange = [
					700,
					900,
					1100,
					1300
				]
			},
			EL_XPGainMult = {
				ID = "accessory_entry.xp_gain_mult",
				BaseXPGainMult = 10,
				RandomMinXPGainMult = [
					1,
					1,
					401,
					801,
					2000
				],
				RandomMaxXPGainMult = [
					800,
					1200,
					1600,
					2000,
					2000
				],
				ColourRange = [
					14,
					18,
					22,
					26
				]
			}
		}
	},
	function EL_assignItemEntrys( _EL_item, _entryNum ) {
		local index_pool = [];
		for(local i = 0; i < this.Const.EL_Accessory.EL_Entry.Pool.Entrys.len(); ++i) {
			if(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item, _entryNum)) {
				index_pool.push(i);
			}
		}
		for(local i = 1; i < _entryNum && index_pool.len() != 0; --_entryNum) {
			local r = this.Math.rand(0, index_pool.len() - 1);
			//this.logInfo("accessory"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			_EL_item.EL_addEntryList(this.new(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[index_pool[r]].Scripts));
			index_pool.remove(r);
		}
		if((_entryNum != 0 || _EL_item.EL_getLevel()) && index_pool.len() != 0)
		{
			if(_entryNum != 1)
			{
				for(local i = index_pool.len() - 1; i > 0; --i) {
					//this.logInfo("index_pool size:"+index_pool.len()+"index_pool:"+index_pool[i]);
					if(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[index_pool[i]].EL_ifNeedRemove(_entryNum))
					{
						index_pool.remove(i);
					}
				}
			}
			local r = this.Math.rand(0, index_pool.len() - 1);
			//this.logInfo("accessory final"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			local entry = this.new(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			entry.EL_setCurrentLevel(_entryNum);
			//this.logInfo(_entryNum);
			_EL_item.EL_addEntryList(entry);
		}
	},

	function EL_assignItemRarityEntry( _EL_item, EL_additionalRarityChance = 0 ) {
		local r = this.Math.rand(1, 100000) + EL_additionalRarityChance;
		if(r <= this.Const.EL_Accessory.EL_RarityEntry.RarityEntryChane[_EL_item.m.EL_RankLevel])
		{
			//this.logInfo("!!!RarityEntry!!!" + r);
			local r = this.Math.rand(0, this.Const.EL_Accessory.EL_RarityEntry.Pool.Entrys.len() - 1);
			_EL_item.EL_addRarityEntry(this.new(this.Const.EL_Accessory.EL_RarityEntry.Pool.Entrys[r].Scripts));
		}
	},

    function EL_addItemEntry( _EL_item ) {
		local index_pool = [];
		local entryNum = this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[_EL_item.m.EL_RankLevel]
		for(local i = 0; i < this.Const.EL_Accessory.EL_Entry.Pool.Entrys.len(); ++i) {
            if(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item, entryNum)) {
				index_pool.push(i);
			}
		}
		while(index_pool.len() != 0)
		{
			local r = this.Math.rand(0, index_pool.len() - 1);
			local entry = this.new(this.Const.EL_Accessory.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			index_pool.remove(r);
			if(!_EL_item.EL_hasEntry(entry.getID()))
			{
				entry.EL_setCurrentLevel(this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[_EL_item.m.EL_RankLevel]);
				_EL_item.EL_addEntryList(entry);
				break;
			}
		}
	}
};
local gt = this.getroottable();

if (!("EL_Helmet" in gt.Const))
{
	gt.Const.EL_Helmet <- {};
}

gt.Const.EL_Helmet <- {
	EL_RankValue = [
		1,
		2,
		5,
		12,
		25
	]
	EL_RankFactor = {
		StaminaModifierMinMult = 0.75,
		StaminaModifierMaxMult = 1.0,
		ConditionMult = 1.25
	},
	EL_LevelFactor = {
		Condition = 0.04,
		Value = 0.04,
		StaminaModifier = 0.04,
	},
	EL_Essence = {
		LevelFactor = 0.04,
		SlotFactor = 1,
		UpgradeFactor = 1,
		DisassembleFactor = 1,
		RecraftFactor = 1
	},
	EL_RankPropertiesInitFunctions = [
		{
			ifUsable = function( _helmet )
			{
                return true;
			},
			changeValues = function( _helmet, _isReduceWeight = 0 )
			{
				_helmet.m.EL_BaseWithRankConditionMax = _helmet.m.EL_BaseWithRankConditionMax * this.Const.EL_Helmet.EL_RankFactor.ConditionMult;
	            _helmet.m.Condition = _helmet.m.EL_BaseWithRankConditionMax;
			},
			weight = 1
		},
		{
			ifUsable = function( _helmet )
			{
			    return true;
			},
			changeValues = function( _helmet, _isReduceWeight = 0 )
			{
				local StaminaModifierMinMult = (_isReduceWeight) ? this.Const.EL_Helmet.EL_RankFactor.StaminaModifierMinMult : this.Const.EL_Helmet.EL_RankFactor.StaminaModifierMaxMult;
				_helmet.m.EL_BaseWithRankStaminaModifier = this.Math.floor(_helmet.m.EL_BaseWithRankStaminaModifier * this.Const.EL_Helmet.EL_RankFactor.StaminaModifierMinMult);
			},
			weight = 1
		}
	],
	EL_Entry = {
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_bravery_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_combat_level_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_condition_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_condition_recover_daliy_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_condition_recover_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_fatigue_recover_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_hitpoints_recovery_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_hitpoints_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_melee_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_ranged_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_stamina_modifier_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_value_mult_entry",
					function EL_ifEligible(_EL_item) 
					{ 
						if(_EL_item.m.EL_RankLevel > 1)
						{
							return true;
						} 
						return false;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/helmet_entrys/el_vision_entry",
					function EL_ifEligible(_EL_item) { return true; }
				}
			],
		},
		EntryNum = {
			NormalHelmet = [
				0,
				1,
				2,
				3,
				3
			]
		},
		Factor = {
			EL_Bravery = {
				ID = "helmet_entry.bravery",
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
				ID = "helmet_entry.combat_level",
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
			EL_ConditionMult = {
				ID = "helmet_entry.condition_mult",
				BaseConditionMult = 25,
				RandomMinConditionMult = [
					1,
					1,
					1001,
					2001,
					5000
				],
				RandomMaxConditionMult = [
					2000,
					3000,
					4000,
					5000,
					5000
				],
				ColourRange = [
					35,
					45,
					55,
					65
				]
			},
			EL_ConditionRecoverDaliy = {
				ID = "helmet_entry.condition_recover_daliy",
				BaseConditionRecoverDaliy = 25,
				RandomMinConditionRecoverDaliy = [
					1,
					1,
					1001,
					2001,
					5000
				],
				RandomMaxConditionRecoverDaliy = [
					2000,
					3000,
					4000,
					5000,
					5000
				],
				ColourRange = [
					35,
					45,
					55,
					65
				]
			},
			EL_ConditionRecoverRate = {
				ID = "helmet_entry.condition_recover_rate",
				BaseConditionRecoverRate = 5,
				RandomMinConditionRecoverRate = [
					1,
					1,
					201,
					401,
					1000
				],
				RandomMaxConditionRecoverRate = [
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
			EL_FatigueRecover = {
				ID = "helmet_entry.fatigue_recover",
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
				ID = "helmet_entry.hitpoints",
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
				ID = "helmet_entry.hitpoints_recovery_rate",
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
			EL_MeleeDefense = {
				ID = "helmet_entry.melee_defense",
				BaseMeleeDefense = 10,
				RandomMinMeleeDefense = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxMeleeDefense = [
					8,
					12,
					16,
					20,
					20
				],
				ColourRange = [
					14,
					18,
					22,
					26
				]
			},
			EL_RangedDefense = {
				ID = "helmet_entry.ranged_defense",
				BaseRangedDefense = 10,
				RandomMinRangedDefense = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxRangedDefense = [
					8,
					12,
					16,
					20,
					20
				],
				ColourRange = [
					14,
					18,
					22,
					26
				]
			},
			EL_StaminaModifierMult = {
				ID = "helmet_entry.stamina_modifier_mult",
				BaseStaminaModifierMult = 16.66,
				RandomMinStaminaModifierMult = [
					1,
					1,
					333,
					666,
					1666
				],
				RandomMaxStaminaModifierMult = [
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
			EL_ValueMult = {
				ID = "entry.value_mult"
			},
			EL_Vision = {
				ID = "helmet_entry.vision",
				BaseVision = 3,
				RandomMinVision = [
					1,
					1,
					3,
					5,
					9
				],
				RandomMaxVision = [
					4,
					6,
					8,
					9,
					9
				],
				ColourRange = [
					5,
					7,
					9,
					11
				]
			}
		}
	},
	function EL_assignItemEntrys( _EL_item, _entryNum ) {
		local index_pool = [];
		for(local i = 0; i < this.Const.EL_Helmet.EL_Entry.Pool.Entrys.len(); ++i) {
				if(this.Const.EL_Helmet.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item)) {
				index_pool.push(i);
			}
		}
		for(local i = 0; i < _entryNum && index_pool.len() != 0; ++i) {
			local r = this.Math.rand(0, index_pool.len() - 1);
			//this.logInfo("helmet"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			_EL_item.EL_addEntryList(this.new(this.Const.EL_Helmet.EL_Entry.Pool.Entrys[index_pool[r]].Scripts));
			index_pool.remove(r);
		}
	}
};
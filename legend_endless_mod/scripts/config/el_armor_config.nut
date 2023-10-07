local gt = this.getroottable();

if (!("EL_Armor" in gt.Const))
{
	gt.Const.EL_Armor <- {};
}

gt.Const.EL_Armor <- {
	EL_RankValue = [
		1,
		2,
		5,
		12,
		25
	]
	EL_RankFactor = {
		StaminaModifierMinMult = 0.9,
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
			ifUsable = function( _armor )
			{
                return true;
			},
			changeValues = function( _armor, _isReduceWeight = 0 )
			{
				_armor.m.EL_BaseWithRankConditionMax = _armor.m.EL_BaseWithRankConditionMax * this.Const.EL_Armor.EL_RankFactor.ConditionMult;
	            _armor.m.Condition = _armor.m.EL_BaseWithRankConditionMax;
			},
			weight = 1
		},
		{
			ifUsable = function( _armor )
			{
			    return true;
			},
			changeValues = function( _armor, _isReduceWeight = 0 )
			{
				local StaminaModifierMinMult = (_isReduceWeight) ? this.Const.EL_Armor.EL_RankFactor.StaminaModifierMinMult : this.Const.EL_Armor.EL_RankFactor.StaminaModifierMaxMult;
				_armor.m.EL_BaseWithRankStaminaModifier = this.Math.floor(_armor.m.EL_BaseWithRankStaminaModifier * this.Const.EL_Armor.EL_RankFactor.StaminaModifierMinMult);
			},
			weight = 1
		}
	],
	EL_Entry = {
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_combat_level_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_condition_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_condition_recover_daliy_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_condition_recover_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_fatigue_recover_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_hitpoints_recovery_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_hitpoints_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_melee_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_ranged_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_stamina_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_stamina_modifier_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/armor_entrys/el_value_mult_entry",
					function EL_ifEligible(_EL_item) 
					{ 
						if(_EL_item.m.EL_RankLevel > 1)
						{
							return true;
						} 
						return false;
					}
				}
			],
		},
		EntryNum = {
			NormalArmor = [
				0,
				1,
				2,
				3,
				3
			]
		},
		Factor = {
			EL_CombatLevel = {
				ID = "armor_entry.combat_level",
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
				ID = "armor_entry.condition_mult",
				BaseConditionMult = 12.5,
				RandomMinConditionMult = [
					1,
					1,
					501,
					1001,
					1500
				],
				RandomMaxConditionMult = [
					1000,
					1500,
					2000,
					2500,
					2500
				],
				ColourRange = [
					17.5,
					22.5,
					27.5,
					32.5
				]
			},
			EL_ConditionRecoverDaliy = {
				ID = "armor_entry.condition_recover_daliy",
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
				ID = "armor_entry.condition_recover_rate",
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
				ID = "armor_entry.fatigue_recover",
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
				ID = "armor_entry.hitpoints",
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
				ID = "armor_entry.hitpoints_recovery_rate",
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
				ID = "armor_entry.melee_defense",
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
				ID = "armor_entry.ranged_defense",
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
			EL_Stamina = {
				ID = "armor_entry.stamina",
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
			EL_StaminaModifierMult = {
				ID = "armor_entry.stamina_modifier_mult",
				BaseStaminaModifierMult = 10,
				RandomMinStaminaModifierMult = [
					1,
					1,
					401,
					801,
					2000
				],
				RandomMaxStaminaModifierMult = [
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
			},
			EL_ValueMult = {
				ID = "entry.value_mult"
			}
		}
	},
	function EL_assignItemEntrys( _EL_item, _entryNum ) {
		local index_pool = [];
		for(local i = 0; i < this.Const.EL_Armor.EL_Entry.Pool.Entrys.len(); ++i) {
				if(this.Const.EL_Armor.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item)) {
				index_pool.push(i);
			}
		}
		for(local i = 0; i < _entryNum && index_pool.len() != 0; ++i) {
			local r = this.Math.rand(0, index_pool.len() - 1);
			//.logInfo("armor"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			_EL_item.EL_addEntryList(this.new(this.Const.EL_Armor.EL_Entry.Pool.Entrys[index_pool[r]].Scripts));
			index_pool.remove(r);
		}
	}
};
local gt = this.getroottable();

if (!("EL_Shield" in gt.Const))
{
	gt.Const.EL_Shield <- {};
}

gt.Const.EL_Shield <- {
	EL_RankValue = [
		1,
		2,
		5,
		12,
		25
	]
	EL_RankFactor = {
		MeleeDefenseMult = 1.1,
		RangedDefenseMult = 1.1,
		FatigueOnSkillUse = 2,
		StaminaModifierMinMult = 0.7,
		StaminaModifierMaxMult = 1.0,
		ConditionMult = 2
	},
	EL_LevelFactor = {
		Condition = 0.04,
		Value = 0.04,
		MeleeDefense = 0.01,
		RangedDefense = 0.01,
		StaminaModifier = 0.04
	},
	EL_Essence = {
		LevelFactor = 0.04,
		SlotFactor = 5,
		UpgradeFactor = 1,
		DisassembleFactor = 1,
		RecraftFactor = 1
	},
	EL_RankPropertiesInitFunctions = [
		{
			ifUsable = function( _shield )
			{
                return true;
			},
			changeValues = function( _shield, _isReduceWeight = 0 )
			{
				_shield.m.EL_BaseWithRankMeleeDefense = this.Math.ceil(_shield.m.EL_BaseWithRankMeleeDefense * this.Const.EL_Shield.EL_RankFactor.MeleeDefenseMult);
				_shield.m.EL_BaseWithRankRangedDefense = this.Math.ceil(_shield.m.EL_BaseWithRankRangedDefense * this.Const.EL_Shield.EL_RankFactor.RangedDefenseMult);
			},
			weight = 1
		},
		{
			ifUsable = function( _shield )
			{
                return true;    
			},
			changeValues = function( _shield, _isReduceWeight = 0 )
			{
				_shield.m.FatigueOnSkillUse = _shield.m.FatigueOnSkillUse - this.Const.EL_Shield.EL_RankFactor.FatigueOnSkillUse;
				_shield.m.EL_BaseWithRankFatigueOnSkillUse = _shield.m.FatigueOnSkillUse;
			},
			weight = 1
		},
		{
			ifUsable = function( _shield )
			{
			    return true;
			},
			changeValues = function( _shield, _isReduceWeight = 0 )
			{
				local StaminaModifierMinMult = (_isReduceWeight) ? this.Const.EL_Shield.EL_RankFactor.StaminaModifierMinMult : this.Const.EL_Shield.EL_RankFactor.StaminaModifierMaxMult;
				_shield.m.EL_BaseWithRankStaminaModifier = this.Math.floor(_shield.m.EL_BaseWithRankStaminaModifier * this.Const.EL_Shield.EL_RankFactor.StaminaModifierMinMult);
				_shield.m.EL_BaseWithRankConditionMax = _shield.m.EL_BaseWithRankConditionMax * this.Const.EL_Shield.EL_RankFactor.ConditionMult;
	            _shield.m.Condition = _shield.m.EL_BaseWithRankConditionMax;
			},
			weight = 1
		}
	],
	EL_Entry = {
		EL_BaseFactor =  0.5,
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_action_point_entry",
					function EL_ifEligible(_EL_item) 
					{ 
						if(_EL_item.m.EL_RankLevel >= 2)
						{
							return true;
						} 
						return false;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_combat_level_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_condition_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_condition_recover_daliy_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_condition_recover_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_fatigue_recover_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_hitpoints_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_melee_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_ranged_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_shield_double_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_shield_melee_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_shield_ranged_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_stamina_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_stamina_modifier_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_taunt_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_use_skill_fatigue_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/shield_entrys/el_value_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				}
			],
		},
		EntryNum = {
			NormalShield = [
				0,
				2,
				4,
				6,
				6
			]
		},
		Factor = {
			EL_ActionPoint = {
				ID = "shield_entry.action_point",
				ActionPoint = 1
			},
			EL_CombatLevel = {
				ID = "shield_entry.combat_level",
				BaseCombatLevel = 1,
				//此值仅为roll点方便设置为100倍，实际生成后会将最终结果*0.01
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
				ID = "shield_entry.condition_mult",
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
				ID = "shield_entry.condition_recover_daliy",
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
				ID = "shield_entry.condition_recover_rate",
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
				ID = "shield_entry.fatigue_recover",
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
				ID = "shield_entry.hitpoints",
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
			EL_MeleeDefense = {
				ID = "shield_entry.melee_defense",
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
				ID = "shield_entry.ranged_defense",
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
			EL_ShieldDoubleDefense = {
				ID = "shield_entry.shield_double_defense",
				BaseShieldDoubleDefense = 7,
				RandomMinShieldDoubleDefense = [
					1,
					1,
					4,
					7,
					15
				],
				RandomMaxShieldDoubleDefense = [
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
			EL_ShieldMeleeDefense = {
				ID = "shield_entry.shield_melee_defense",
				BaseShieldMeleeDefense = 10,
				RandomMinShieldMeleeDefense = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxShieldMeleeDefense = [
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
			EL_ShieldRangedDefense = {
				ID = "shield_entry.shield_ranged_defense",
				BaseShieldRangedDefense = 10,
				RandomMinShieldRangedDefense = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxShieldRangedDefense = [
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
				ID = "shield_entry.stamina",
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
				ID = "shield_entry.stamina_modifier_mult",
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
			EL_TauntMult = {
				ID = "shield_entry.taunt_mult",
				BaseTauntMult = 200,
				RandomMinTauntMult = [
					1,
					1,
					81,
					161,
					400
				],
				RandomMaxTauntMult = [
					160,
					240,
					320,
					400,
					400
				],
				ColourRange = [
					280,
					360,
					440,
					520
				]
			},
			EL_UseSkillfatigue = {
				ID = "shield_entry.use_skill_fatigue",
				BaseUseSkillfatigue = 0,
				RandomMinUseSkillfatigue = [
					1,
					1,
					2,
					2,
					3
				],
				RandomMaxUseSkillfatigue = [
					1,
					1,
					2,
					3,
					3
				],
				ColourRange = [
					1,
					1,
					2,
					2
				]
			},
			EL_ValueMult = {
				ID = "sheild_entry.value_mult",
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
			}
		}
	},
	function EL_assignItemEntrys( _EL_item, _entryNum ) {
		local index_pool = [];
		for(local i = 0; i < this.Const.EL_Shield.EL_Entry.Pool.Entrys.len(); ++i) {
				if(this.Const.EL_Shield.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item)) {
				index_pool.push(i);
			}
		}
		for(local i = 0; i < _entryNum && index_pool.len() != 0; ++i) {
			local r = this.Math.rand(0, index_pool.len() - 1);
			//this.logInfo("shield"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			_EL_item.EL_addEntryList(this.new(this.Const.EL_Shield.EL_Entry.Pool.Entrys[index_pool[r]].Scripts));
			index_pool.remove(r);
		}
	}
};
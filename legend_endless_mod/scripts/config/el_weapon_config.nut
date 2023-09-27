local gt = this.getroottable();

if (!("EL_Weapon" in gt.Const))
{
	gt.Const.EL_Weapon <- {};
}

gt.Const.EL_Weapon <- {
	EL_RankValue = [
		1,
		2,
		5,
		12,
		25
	]
	EL_RankFactor = {
		RegularDamageMult = 1.25,
		RegularDamageMaxMult = 1.25,
		ArmorDamageMult = 0.5,
		DirectDamageAdd = 0.1,
		FatigueOnSkillUse = 2,
		StaminaModifierMinMult = 0.75,
		StaminaModifierMaxMult = 1.0,
		ConditionMult = 1.25,

		ChanceToHitHead = 25,
		ShieldDamageMult = 1.5,
		AdditionalAccuracy = 20,
		RangeMax = 3,
		Vision = 3,
		AmmoMax = 2,
		AdditionalExplosionRange = 1 
	},
	EL_LevelFactor = {
		Condition = 0.04,
		Value = 0.04,
		RegularDamage = 0.04,
		RegularDamageMax = 0.04,
		StaminaModifier = 0.04,
		ShieldDamage = 0.04,
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
			ifUsable = function( _weapon )
			{
                return true;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.EL_BaseWithRankRegularDamage = this.Math.floor(_weapon.m.EL_BaseWithRankRegularDamage * this.Const.EL_Weapon.EL_RankFactor.RegularDamageMult);
				_weapon.m.EL_BaseWithRankRegularDamageMax = this.Math.floor(_weapon.m.EL_BaseWithRankRegularDamageMax * this.Const.EL_Weapon.EL_RankFactor.RegularDamageMaxMult);
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                return true;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.ArmorDamageMult = _weapon.m.ArmorDamageMult + this.Const.EL_Weapon.EL_RankFactor.ArmorDamageMult;
                _weapon.m.DirectDamageAdd = _weapon.m.DirectDamageAdd + this.Const.EL_Weapon.EL_RankFactor.DirectDamageAdd;
				_weapon.m.EL_BaseWithRankArmorDamageMult = _weapon.m.ArmorDamageMult;
				_weapon.m.EL_BaseWithRankDirectDamageAdd = _weapon.m.DirectDamageAdd;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                if (_weapon.m.ChanceToHitHead > 0)
		        {  
                    return true;
                }
                return false;                
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.ChanceToHitHead = _weapon.m.ChanceToHitHead + this.Const.EL_Weapon.EL_RankFactor.ChanceToHitHead;
				_weapon.m.EL_BaseWithRankChanceToHitHead = _weapon.m.ChanceToHitHead;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                return true;    
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.FatigueOnSkillUse = _weapon.m.FatigueOnSkillUse - this.Const.EL_Weapon.EL_RankFactor.FatigueOnSkillUse;
				_weapon.m.EL_BaseWithRankFatigueOnSkillUse = _weapon.m.FatigueOnSkillUse;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
			    return true;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				local StaminaModifierMinMult = (_isReduceWeight) ? this.Const.EL_Weapon.EL_RankFactor.StaminaModifierMinMult : this.Const.EL_Weapon.EL_RankFactor.StaminaModifierMaxMult;
				_weapon.m.EL_BaseWithRankStaminaModifier = this.Math.floor(_weapon.m.EL_BaseWithRankStaminaModifier * this.Const.EL_Weapon.EL_RankFactor.StaminaModifierMinMult);
				_weapon.m.EL_BaseWithRankConditionMax = _weapon.m.EL_BaseWithRankConditionMax * this.Const.EL_Weapon.EL_RankFactor.ConditionMult;
	            _weapon.m.Condition = _weapon.m.EL_BaseWithRankConditionMax;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon, _isReduceWeight = 0  )
			{
                if (_weapon.m.EL_BaseWithRankShieldDamage >= 16)
		        {
                    return true;
		        }
                return false;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.EL_BaseWithRankShieldDamage = this.Math.ceil(_weapon.m.EL_BaseWithRankShieldDamage * this.Const.EL_Weapon.EL_RankFactor.ShieldDamageMult);
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                if (_weapon.m.EL_BaseWithRankAdditionalAccuracy != 0 || _weapon.isItemType(this.Const.Items.ItemType.RangedWeapon))
		        {
                    return true;    
		        } 
                return false;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.AdditionalAccuracy = _weapon.m.AdditionalAccuracy + this.Const.EL_Weapon.EL_RankFactor.AdditionalAccuracy;
				_weapon.m.EL_BaseWithRankAdditionalAccuracy = _weapon.m.AdditionalAccuracy;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                if (_weapon.isWeaponType(this.Const.Items.WeaponType.Bow) || _weapon.isWeaponType(this.Const.Items.WeaponType.Crossbow))
		        {
                    return true;                    
		        }
                return false;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.RangeMax = _weapon.m.RangeMax + this.Const.EL_Weapon.EL_RankFactor.RangeMax;
                _weapon.m.EL_Vision = _weapon.m.EL_Vision + this.Const.EL_Weapon.EL_RankFactor.Vision;
				_weapon.m.EL_BaseWithRankRangeMax = _weapon.m.RangeMax;
				_weapon.m.EL_BaseWithRankVision = _weapon.m.EL_Vision;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                if (_weapon.isWeaponType(this.Const.Items.WeaponType.Throwing))
		        {
                    return true;                    
		        }
                return false;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.AmmoMax = _weapon.m.AmmoMax * this.Const.EL_Weapon.EL_RankFactor.AmmoMax;
                _weapon.m.Ammo = _weapon.m.AmmoMax;
				_weapon.m.EL_BaseWithRankAmmoMax = _weapon.m.AmmoMax;
			},
			weight = 1
		},
		{
			ifUsable = function( _weapon )
			{
                if (_weapon.isWeaponType(this.Const.Items.WeaponType.Firearm))
		        {
                    return true;                    
		        }
                return false;
			},
			changeValues = function( _weapon, _isReduceWeight = 0  )
			{
				_weapon.m.EL_AdditionalExplosionRange = _weapon.m.EL_AdditionalExplosionRange + this.Const.EL_Weapon.EL_RankFactor.AdditionalExplosionRange;
			},
			weight = 1
		}
	],
	EL_Entry = {
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_action_point_entry",
					function EL_ifEligible(_EL_item) { 
						if(_EL_item.m.EL_RankLevel >= 2)
						{
							return true;
						} 
						return false;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_additional_accuracy_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_armor_damage_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_combat_level_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_recover_daliy_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_recover_rate_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_damage_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_direct_damage_add_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_hit_head_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_melee_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_melee_skill_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_ranged_defense_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_ranged_skill_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_shield_damage_mult_entry",
					function EL_ifEligible(_EL_item) 
					{ 
						if(_EL_item.m.EL_BaseWithRankShieldDamage >= 16)
						{
							return true; 
						}
						return false; 
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_stamina_modifier_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_use_skill_fatigue_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_value_mult_entry",
					function EL_ifEligible(_EL_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_vampire_entry",
					function EL_ifEligible(_EL_item) { return true; }
				}
			],
		},
		EntryNum = {
			OneHanded = [
				0,
				2,
				4,
				6,
				6
			],
			TwoHanded = [
				0,
				4,
				8,
				12,
				12
			]
		},
		Factor = {
			EL_ActionPoint = {
				ID = "weapon_entry.action_point",
				ActionPoint = 1
			},
			EL_AdditionalAccuracy = {
				ID = "weapon_entry.additional_accuracy",
				BaseAdditionalAccuracy = 10,
				RandomMinAdditionalAccuracy = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxAdditionalAccuracy = [
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
			EL_ArmorDamageMult = {
				ID = "weapon_entry.armor_damage_mult",
				BaseArmorDamageMult = 25,
				RandomMinArmorDamageMult = [
					1,
					1,
					11,
					21,
					50
				],
				RandomMaxArmorDamageMult = [
					20,
					30,
					40,
					50,
					50
				],
				ColourRange = [
					35,
					45,
					55,
					65
				]
			},
			EL_CombatLevel = {
				ID = "weapon_entry.combat_level",
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
				ID = "weapon_entry.condition_mult",
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
				ID = "weapon_entry.condition_recover_daliy",
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
				ID = "weapon_entry.condition_recover_rate",
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
			EL_DamageMult = {
				ID = "weapon_entry.damage_mult",
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
			EL_DirectDamageAdd = {
				ID = "weapon_entry.direct_damage_add",
				BaseDirectDamageAdd = 5,
				RandomMinDirectDamageAdd = [
					1,
					1,
					3,
					5,
					10
				],
				RandomMaxDirectDamageAdd = [
					4,
					6,
					8,
					10,
					10
				],
				ColourRange = [
					7,
					9,
					11,
					13
				]
			},
			EL_HitHead = {
				ID = "weapon_entry.hit_head",
				BaseHitHead = 12,
				RandomMinHitHead = [
					1,
					1,
					6,
					11,
					25
				],
				RandomMaxHitHead = [
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
				ID = "weapon_entry.melee_defense",
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
			EL_MeleeSkill = {
				ID = "weapon_entry.melee_skill",
				BaseMeleeSkill = 10,
				RandomMinMeleeSkill = [
					1,
					1,
					5,
					9,
					20
				],
				RandomMaxMeleeSkill = [
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
				ID = "weapon_entry.ranged_defense",
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
			EL_RangedSkill = {
				ID = "weapon_entry.ranged_skill",
				BaseRangedSkill = 12,
				RandomMinRangedSkill = [
					1,
					1,
					6,
					11,
					25
				],
				RandomMaxRangedSkill = [
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
			EL_ShieldDamageMult = {
				ID = "weapon_entry.shield_damage_mult",
				BaseShieldDamageMult = 25,
				RandomMinShieldDamageMult = [
					1,
					1,
					11,
					21,
					50
				],
				RandomMaxShieldDamageMult = [
					20,
					30,
					40,
					50,
					50
				],
				ColourRange = [
					35,
					45,
					55,
					65
				]
			},
			EL_StaminaModifierMult = {
				ID = "weapon_entry.stamina_modifier_mult",
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
			EL_UseSkillfatigue = {
				ID = "weapon_entry.use_skill_fatigue",
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
				ID = "weapon_entry.value_mult",
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
			EL_Vampire = {
				ID = "weapon_entry.vampire",
				BaseVampire = 10,
				RandomMinVampire = [
					1,
					1,
					401,
					801,
					2000
				],
				RandomMaxVampire = [
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
		for(local i = 0; i < this.Const.EL_Weapon.EL_Entry.Pool.Entrys.len(); ++i) {
				if(this.Const.EL_Weapon.EL_Entry.Pool.Entrys[i].EL_ifEligible(_EL_item)) {
				index_pool.push(i);
			}
		}
		for(local i = 0; i < _entryNum && index_pool.len() != 0; ++i) {
			local r = this.Math.rand(0, index_pool.len() - 1);
			//this.logInfo("weapon"+this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			_EL_item.EL_addEntryList(this.new(this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts));
			index_pool.remove(r);
		}
	}
};
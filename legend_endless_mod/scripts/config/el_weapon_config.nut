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
		RegularDamageMult = 1.3,
		RegularDamageMultHalf = 1.14017,
		ArmorDamageMult = 1.1,
		ArmorDamageMultHalf = 1.0488,
		DirectDamageAddMult = 1.1,
		DirectDamageAddMultHalf = 1.0488,
		FatigueOnSkillUse = 2,
		StaminaModifierMult = 0.85,
		StaminaModifierMultHalf = 0.92195,
		ConditionMult = 1.3,
		ConditionMultHalf = 1.14017,

		ChanceToHitHead = 10,
		ShieldDamageMult = 1.5,
		ShieldDamageMultHalf = 1.224744,
		AdditionalAccuracy = 30,
		RangeMax = 2,
		AmmoMaxMult = 2,
		AmmoMaxMultHalf = 1.41421,
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
	EL_EquipmentEssence = {
		LevelFactor = 0.04,
		RankFactor = 3,
		UpgradeLevelFactor = 3,
		UpgradeRankFactor = 3,
		DisassembleFactor = 2.4,
		RecraftFactor = 3,
		SeniorEquipmentEssenceMult = 0.1,
		StrengthenEntryNum = 3,
		OneHandedMinCalculateWeight = -10,
		TwoHandedMinCalculateWeight = -20
	},
	EL_RankPropertiesInitFunctions = [
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.RegularDamageMultHalf : this.Const.EL_Weapon.EL_RankFactor.RegularDamageMult;
				_item.m.EL_BaseWithRankRegularDamage = this.Math.floor(_item.m.EL_BaseWithRankRegularDamage * bonus);
				_item.m.EL_BaseWithRankRegularDamageMax = this.Math.floor(_item.m.EL_BaseWithRankRegularDamageMax * bonus);
			},
			weight = 1
		},
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.DirectDamageAddMultHalf : this.Const.EL_Weapon.EL_RankFactor.DirectDamageAddMult;
                _item.m.DirectDamageAdd = this.Math.ceil(100 * _item.m.DirectDamageAdd * bonus) * 0.01;
				_item.m.EL_BaseWithRankDirectDamageAdd = _item.m.DirectDamageAdd;
			},
			weight = 1
		},
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.ArmorDamageMultHalf : this.Const.EL_Weapon.EL_RankFactor.ArmorDamageMult;
				_item.m.ArmorDamageMult = this.Math.ceil(100 * _item.m.ArmorDamageMult * bonus) * 0.01;
				_item.m.EL_BaseWithRankArmorDamageMult = _item.m.ArmorDamageMult;
			},
			weight = 1
		},
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.FatigueOnSkillUse / 2 : this.Const.EL_Weapon.EL_RankFactor.FatigueOnSkillUse;
				_item.m.FatigueOnSkillUse -= bonus;
				_item.m.EL_BaseWithRankFatigueOnSkillUse = _item.m.FatigueOnSkillUse;
			},
			weight = 1
		},
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.ConditionMultHalf : this.Const.EL_Weapon.EL_RankFactor.ConditionMult;
				_item.m.EL_BaseWithRankConditionMax = this.Math.round(_item.m.EL_BaseWithRankConditionMax * bonus);
			},
			weight = 1
		},
		{
			ifUsable = function( _item ) { return true; },
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.StaminaModifierMultHalf : this.Const.EL_Weapon.EL_RankFactor.StaminaModifierMult;
				_item.m.EL_BaseWithRankStaminaModifier = this.Math.floor(_item.m.EL_BaseWithRankStaminaModifier * bonus);
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (_item.m.ChanceToHitHead == 0) { return false; }
                return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.ChanceToHitHead / 2 : this.Const.EL_Weapon.EL_RankFactor.ChanceToHitHead;
				_item.m.ChanceToHitHead += bonus;
				_item.m.EL_BaseWithRankChanceToHitHead = _item.m.ChanceToHitHead;
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (_item.m.EL_BaseWithRankShieldDamage == 0) { return false; }
                return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.ShieldDamageMultHalf : this.Const.EL_Weapon.EL_RankFactor.ShieldDamageMult;
				_item.m.EL_BaseWithRankShieldDamage = this.Math.round(_item.m.EL_BaseWithRankShieldDamage * bonus);
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (_item.m.EL_BaseWithRankAdditionalAccuracy == 0 && !_item.isItemType(this.Const.Items.ItemType.RangedWeapon)) { return false; }
                return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.AdditionalAccuracy / 2 : this.Const.EL_Weapon.EL_RankFactor.AdditionalAccuracy;
				_item.m.AdditionalAccuracy += bonus;
				_item.m.EL_BaseWithRankAdditionalAccuracy = _item.m.AdditionalAccuracy;
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (!_item.isWeaponType(this.Const.Items.WeaponType.Bow) && !_item.isWeaponType(this.Const.Items.WeaponType.Crossbow)) { return false; }
                return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				//this.logInfo("before _item.m.RangeMax" + _item.m.RangeMax);
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.RangeMax / 2 : this.Const.EL_Weapon.EL_RankFactor.RangeMax;
				_item.m.RangeMax += bonus;
				_item.m.EL_BaseWithRankRangeMax = _item.m.RangeMax;
				//this.logInfo("after _item.m.RangeMax" + _item.m.RangeMax);
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (!_item.isWeaponType(this.Const.Items.WeaponType.Throwing)) { return false; }
                return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				local bonus = _isHalfEffect ? this.Const.EL_Weapon.EL_RankFactor.AmmoMaxMultHalf : this.Const.EL_Weapon.EL_RankFactor.AmmoMaxMult;
				_item.m.AmmoMax = this.Math.ceil(_item.m.AmmoMax * bonus);
                _item.m.Ammo = _item.m.AmmoMax;
				_item.m.EL_BaseWithRankAmmoMax = _item.m.AmmoMax;
			},
			weight = 1
		},
		{
			ifUsable = function( _item )
			{
                if (!_item.isWeaponType(this.Const.Items.WeaponType.Firearm)) { return false; }
				if (!_item.EL_getRankLevel() == this.Const.EL_Item.Type.Premium) { return false; }
				return true;
			},
			changeValues = function( _item, _isHalfEffect = false )
			{
				_item.m.EL_AdditionalExplosionRange = _item.m.EL_AdditionalExplosionRange + this.Const.EL_Weapon.EL_RankFactor.AdditionalExplosionRange;
			},
			weight = 1
		}
	],
	function EL_updateRankLevelProperties( _item ) {
		_item.m.EL_BaseWithRankValue = _item.m.EL_BaseNoRankValue * gt.Const.EL_Weapon.EL_RankValue[_item.m.EL_RankLevel];
		if(_item.m.EL_RankLevel == this.Const.EL_Item.Type.Fine)
		{
			foreach	(func in gt.Const.EL_Weapon.EL_RankPropertiesInitFunctions)
			{
				if(func.ifUsable(_item))
				{
					func.changeValues(_item, true);
				}
			}
		}
		for(local index = this.Const.EL_Item.Type.Fine; index < _item.m.EL_RankLevel; ++index)
		{
			foreach	(func in gt.Const.EL_Weapon.EL_RankPropertiesInitFunctions)
			{
				if(func.ifUsable(_item))
				{
					func.changeValues(_item);
				}
			}
		}
		if(_item.m.EL_RankLevel >= this.Const.EL_Item.Type.Premium && _item.m.EL_RankLevel != this.Const.EL_Item.Type.Legendary)
		{
			local available = [];
			local weightList = [];
			local weightSum = 0;
			foreach	(func in gt.Const.EL_Weapon.EL_RankPropertiesInitFunctions)
			{
				if(func.ifUsable(_item))
				{
					available.push(func.changeValues);
					weightList.push(func.weight);
					weightSum += func.weight;
				}
			}
			if(_item.m.EL_RankPropertiesImproveIndex.len())
			{
				foreach(index in _item.m.EL_RankPropertiesImproveIndex)
				{
					available[index](_item);
					available.remove(index);
				}
			}
			else
			{
				for( local count = 2; count != 0 && available.len() != 0; --count )
				{
					local roll = this.Math.rand(0, weightSum - weightList[0]);
					local number = 0;
					for( local index = 0; index < weightList.len(); ++index )
					{
						if(roll > weightList[index])
						{
							++number;
							roll -= weightList[index];
						}
						else
						{
							break;
						}
					}
					weightSum -= weightList[number];
					weightList.remove(number);
					available[number](_item);
					available.remove(number);
					_item.m.EL_RankPropertiesImproveIndex.push(number);
				}
			}
		}
	},
	EL_ThrowingWeaponList = [
		"weapons/javelin",
		"weapons/throwing_axe",
		"weapons/barbarians/heavy_javelin",
		"weapons/barbarians/heavy_throwing_axe",
		"weapons/greenskins/goblin_spiked_balls",
		"weapons/greenskins/orc_javelin",
		"weapons/named/named_javelin",
		"weapons/named/named_throwing_axe"
	],
	EL_Entry = {
		Pool = {
			Entrys = [
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_action_point_entry",
					function EL_ifEligible(_item) {
						if(_item.m.EL_RankLevel <= 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_additional_accuracy_entry",
					function EL_ifEligible(_item) { 
						if(_item.m.EL_BaseWithRankAdditionalAccuracy == 0 && !_item.isItemType(this.Const.Items.ItemType.RangedWeapon)) 
						{ 
							return false; 
						}
						return true; 
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_ammo_max_mult_entry",
					function EL_ifEligible(_item) { 
						if(!_item.isWeaponType(this.Const.Items.WeaponType.Throwing)) { return false; }
						return true; 
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_armor_damage_mult_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_bravery_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_check_morale_entry",
					function EL_ifEligible(_item) {
						if(_item.m.EL_RankLevel <= 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_combat_level_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_mult_entry",
					function EL_ifEligible(_item) {
						if(_item.getConditionMax() == 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_recover_daliy_entry",
					function EL_ifEligible(_item) {
						if(_item.getConditionMax() == 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_condition_recover_rate_entry",
					function EL_ifEligible(_item) {
						if(_item.getConditionMax() == 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_curse_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_damage_mult_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_direct_damage_add_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_hit_head_entry",
					function EL_ifEligible(_item) { 
						if(_item.m.ChanceToHitHead == 0) 
						{ 
							return false; 
						}
						return true; 
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_initiative_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_melee_range_max_entry",
					function EL_ifEligible(_item) {
						if(!_item.isItemType(this.Const.Items.ItemType.MeleeWeapon) || _item.m.EL_RankLevel <= 1 || _item.m.RangeMax == 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_melee_skill_entry",
					function EL_ifEligible(_item) {
						if(!_item.isItemType(this.Const.Items.ItemType.MeleeWeapon)) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_ranged_range_max_entry",
					function EL_ifEligible(_item) {
						if(!_item.isItemType(this.Const.Items.ItemType.RangedWeapon) || _item.m.EL_RankLevel <= 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_ranged_skill_entry",
					function EL_ifEligible(_item) {
						if(!_item.isItemType(this.Const.Items.ItemType.RangedWeapon)) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_save_ammo_entry",
					function EL_ifEligible(_item) {
						if(!_item.isItemType(this.Const.Items.ItemType.RangedWeapon)) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_shield_damage_mult_entry",
					function EL_ifEligible(_item) {
						if(_item.m.EL_BaseWithRankShieldDamage < 16) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_stamina_modifier_mult_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_use_skill_fatigue_entry",
					function EL_ifEligible(_item) { return true; }
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_value_mult_entry",
					function EL_ifEligible(_item) {
						if(_item.m.EL_RankLevel <= 1) { return false; }
						return true;
					}
				},
				{
					Scripts = "scripts/skills/el_entrys/weapon_entrys/el_vampire_entry",
					function EL_ifEligible(_item) { return true; }
				}
			],
		},
		EntryNum = {
			OneHanded = [
				0,
				1,
				2,
				3,
				4
			],
			TwoHanded = [
				0,
				2,
				4,
				6,
				8
			]
		},
		EntryStrengthenMult = 2.0,
		Factor = {
			EL_ActionPoint = {
				ID = "el_weapon_entry.action_point",
				ActionPoint = 1
			},
			EL_AdditionalAccuracy = {
				ID = "el_weapon_entry.additional_accuracy",
				BaseAdditionalAccuracy = 15,
				RandomMinAdditionalAccuracy = [
					1,
					1,
					4,
					7,
					15
				],
				RandomMaxAdditionalAccuracy = [
					6,
					9,
					12,
					15,
					15
				],
				ColourRange = [
					18,
					21,
					24,
					27,
					30
				]
			},
			EL_AmmoMaxMult = {
				ID = "el_weapon_entry.ammo_max_mult",
				BaseAmmoMaxMult = 50,
				RandomMinAmmoMaxMult = [
					1,
					1,
					11,
					21,
					50
				],
				RandomMaxAmmoMaxMult = [
					20,
					30,
					40,
					50,
					50
				],
				ColourRange = [
					60,
					70,
					80,
					90,
					100
				]
			},
			EL_ArmorDamageMult = {
				ID = "el_weapon_entry.armor_damage_mult",
				BaseArmorDamageMult = 25,
				RandomMinArmorDamageMult = [
					1,
					1,
					6,
					11,
					25
				],
				RandomMaxArmorDamageMult = [
					10,
					15,
					20,
					25,
					25
				],
				ColourRange = [
					30,
					35,
					40,
					45,
					50
				]
			},
            EL_Bravery = {
				ID = "el_weapon_entry.bravery",
				BaseBravery = 15,
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
					18,
					21,
					24,
					27,
					30
				]
			},
			EL_CheckMorale = {
				ID = "el_weapon_entry.check_morle",
				BaseOffset = 50
			},
			EL_CombatLevel = {
				ID = "el_weapon_entry.combat_level",
				BaseCombatLevel = 1.5,
				RandomMinCombatLevel = [
					1,
					1,
					61,
					91,
					150
				],
				RandomMaxCombatLevel = [
					60,
					90,
					120,
					150,
					150
				],
				ColourRange = [
					1.8,
					2.1,
					2.4,
					2.7,
					3.0
				]
			},
			EL_ConditionMult = {
				ID = "el_weapon_entry.condition_mult",
				BaseConditionMult = 25,
				RandomMinConditionMult = [
					1,
					1,
					501,
					1001,
					2500
				],
				RandomMaxConditionMult = [
					1000,
					1500,
					2000,
					2500,
					2500
				],
				ColourRange = [
					30,
					35,
					40,
					45,
					50
				]
			},
			EL_ConditionRecoverDaliy = {
				ID = "el_weapon_entry.condition_recover_daliy",
				BaseConditionRecoverDaliy = 30,
				RandomMinConditionRecoverDaliy = [
					1,
					1,
					1201,
					1801,
					3000
				],
				RandomMaxConditionRecoverDaliy = [
					1200,
					1800,
					2400,
					3000,
					3000
				],
				ColourRange = [
					36,
					42,
					48,
					54,
					60
				]
			},
			EL_ConditionRecoverRate = {
				ID = "el_weapon_entry.condition_recover_rate",
				BaseConditionRecoverRate = 3,
				RandomMinConditionRecoverRate = [
					1,
					1,
					61,
					121,
					300
				],
				RandomMaxConditionRecoverRate = [
					120,
					180,
					240,
					300,
					300
				],
				ColourRange = [
					3.6,
					4.2,
					4.8,
					5.4,
					6
				]
			},
			EL_Curse = {
				ID = "el_weapon_entry.curse",
				BaseCurse = 5,
				RandomMinCurse = [
					1,
					1,
					101,
					201,
					500
				],
				RandomMaxCurse = [
					200,
					300,
					400,
					500,
					500
				],
				ColourRange = [
					6,
					7,
					8,
					9,
					10
				]
			},
			EL_DamageMult = {
				ID = "el_weapon_entry.damage_mult",
				BaseDamageMult = 15,
				RandomMinDamageMult = [
					1,
					1,
					301,
					601,
					1500
				],
				RandomMaxDamageMult = [
					600,
					900,
					1200,
					1500,
					1500
				],
				ColourRange = [
					18,
					21,
					24,
					27,
					30
				]
			},
			EL_DirectDamageAdd = {
				ID = "el_weapon_entry.direct_damage_add",
				BaseDirectDamageAdd = 5,
				RandomMinDirectDamageAdd = [
					1,
					1,
					2,
					3,
					5
				],
				RandomMaxDirectDamageAdd = [
					2,
					3,
					4,
					5,
					5
				],
				ColourRange = [
					6,
					7,
					8,
					9,
					10
				]
			},
			EL_HitHead = {
				ID = "el_weapon_entry.hit_head",
				BaseHitHead = 10,
				RandomMinHitHead = [
					1,
					1,
					3,
					5,
					10
				],
				RandomMaxHitHead = [
					4,
					6,
					8,
					10,
					10
				],
				ColourRange = [
					12,
					14,
					16,
					18,
					20
				]
			},
			EL_Initiative = {
				ID = "el_weapon_entry.initiative",
				BaseInitiative = 30,
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
					36,
					42,
					48,
					54,
					60
				]
			},
			EL_MeleeRangeMax = {
				ID = "el_weapon_entry.melee_range_max",
				RangeMax = 1
			},
			EL_MeleeSkill = {
				ID = "el_weapon_entry.melee_skill",
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
					26,
					30
				]
			},
			EL_RangedRangeMax = {
				ID = "el_weapon_entry.ranged_range_max",
				BaseRangeMax = 2,
				RandomMinRangeMax = [
					0,
					0,
					1,
					1,
					2
				],
				RandomMaxRangeMax = [
					0,
					1,
					1,
					2,
					2
				],
				ColourRange = [
					2,
					2,
					3,
					3,
					4
				]
			},
			EL_RangedSkill = {
				ID = "el_weapon_entry.ranged_skill",
				BaseRangedSkill = 15,
				RandomMinRangedSkill = [
					1,
					1,
					4,
					7,
					15
				],
				RandomMaxRangedSkill = [
					6,
					9,
					12,
					15,
					15
				],
				ColourRange = [
					18,
					21,
					24,
					27,
					30
				]
			},
			EL_SaveAmmo = {
				ID = "el_weapon_entry.save_ammo",
				BaseSaveAmmoChance = 25,
				RandomMinSaveAmmoChance = [
					1,
					1,
					501,
					1001,
					2500
				],
				RandomMaxSaveAmmoChance = [
					1000,
					1500,
					2000,
					2500,
					2500
				],
				ColourRange = [
					30,
					35,
					40,
					45,
					50
				]
			},
			EL_ShieldDamageMult = {
				ID = "el_weapon_entry.shield_damage_mult",
				BaseShieldDamageMult = 50,
				RandomMinShieldDamageMult = [
					1,
					1,
					1001,
					2001,
					5000
				],
				RandomMaxShieldDamageMult = [
					2000,
					3000,
					4000,
					5000,
					5000
				],
				ColourRange = [
					60,
					70,
					80,
					90,
					100
				]
			},
			EL_StaminaModifierMult = {
				ID = "el_weapon_entry.stamina_modifier_mult",
				BaseStaminaModifierMult = 15,
				RandomMinStaminaModifierMult = [
					1,
					1,
					301,
					601,
					1500
				],
				RandomMaxStaminaModifierMult = [
					600,
					900,
					1200,
					1500,
					1500
				],
				ColourRange = [
					18,
					21,
					24,
					27,
					30
				]
			},
			EL_UseSkillfatigue = {
				ID = "el_weapon_entry.use_skill_fatigue",
				BaseUseSkillfatigue = 2,
				RandomMinUseSkillfatigue = [
					0,
					0,
					1,
					1,
					2
				],
				RandomMaxUseSkillfatigue = [
					0,
					1,
					1,
					2,
					2
				],
				ColourRange = [
					2,
					2,
					3,
					3,
					4
				]
			},
			EL_ValueMult = {
				ID = "el_weapon_entry.value_mult"
			},
			EL_Vampire = {
				ID = "el_weapon_entry.vampire",
				BaseVampire = 15,
				RandomMinVampire = [
					1,
					1,
					301,
					601,
					1500
				],
				RandomMaxVampire = [
					600,
					900,
					1200,
					1500,
					1500
				],
				ColourRange = [
					18,
					21,
					24,
					27,
					30
				]
			}
		}
	},
	function EL_assignItemEntrys( _item, _entryNum ) {
		local index_pool = [];
		for(local i = 0; i < this.Const.EL_Weapon.EL_Entry.Pool.Entrys.len(); ++i) {
				if(this.Const.EL_Weapon.EL_Entry.Pool.Entrys[i].EL_ifEligible(_item)) {
				index_pool.push(i);
			}
		}
		while(_item.m.EL_EntryList.len() < _entryNum && index_pool.len() != 0)
		{
			local r = this.Math.rand(0, index_pool.len() - 1);
			local entry = this.new(this.Const.EL_Weapon.EL_Entry.Pool.Entrys[index_pool[r]].Scripts);
			index_pool.remove(r);
			if(!_item.EL_hasEntry(entry.getID()))
			{
				_item.EL_addEntryToList(entry);
			}
		}
	}
};
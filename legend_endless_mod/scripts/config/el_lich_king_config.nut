local gt = this.getroottable();

if (!("EL_LichKing" in gt.Const))
{
	gt.Const.EL_LichKing <- {};
}

gt.Const.EL_LichKing <- {
    SoulEnergy = {
        UpgradeLevelConsumptionFactor = 4,
        UpgradeRankConsumptionFactor = 100,
        RecraftConsumption = 10
    },
    EntityDropNum = {
        RankFactor = [
            1,
            4,
            25
        ],
        LevelFactor = 0.08,
        BaseNum = 1
    },
    SoulEnergyState = {
        InitiativeOffset = 40,
        MeleeSkillOffset = 10,
        ActionPointOffset = 1,
        FatigueOnSkillUseOffset = -0.1,
        DamageTotalMult = 0.1,
        SoulEnergyGianMult = -0.1,
    }
	Accessory = {
        StashModifier = [
            50,
            100,
            150,
            200,
            300
        ],
        StashModifierLevelFactor = 0.01,
        BraveryLevelFactor = 0.25,
        BraveryRankFactor = 1
    },
	Weapon = {
        NormalSkill = {
            AdditionSoulEnergyCost = [
                1,
                2,
                3,
                4,
                5
            ],
            AdditionDamagePersent = [
                0.2,
                0.4,
                0.6,
                0.8,
                1.0
            ],
            MoraleCheck = {
                AdditionMoraleCheckPersent = [
                    0.2,
                    0.4,
                    0.6,
                    0.8,
                    1.0
                ],
                BaseOffset = 50,
                RankFactor = 0,
                CombatLevelFactor = 1.08,
            },
            AoeRange = 1
        },
        DeathSummon = {
			BaseSkillRangeMax = 2,
            SkillRangeMaxRankFactor = 2,
			SkillActionPointCost = 4,
			SkillFatigueCost = 20,
            SoulEnergyCost = [
                1,
                1,
                2,
                2,
                5
            ],
            ControlAbilityCost = [
                10,
                10,
                20,
                20,
                50
            ],
            StrengthenSoulEnergyCostMult = 2,
            SkeletonPool = {
                Normal = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/skeleton_light"
                        ],
                        Weight = 60
                    },
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/skeleton_medium",
                            "scripts/entity/tactical/enemies/skeleton_medium_polearm"
                        ],
                        Weight = 30
                    },
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/skeleton_heavy",
                            "scripts/entity/tactical/enemies/skeleton_heavy_bodyguard",
                            "scripts/entity/tactical/enemies/skeleton_heavy_bodyguard"
                        ],
                        Weight = 10
                    }                
                ],
                Senior = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/skeleton_heavy",
                            "scripts/entity/tactical/enemies/skeleton_heavy_bodyguard",
                            "scripts/entity/tactical/enemies/skeleton_heavy_bodyguard"
                        ],
                        Weight = 40
                    },
                    {
                        Script = "scripts/entity/tactical/enemies/legend_skeleton_gladiator",
                        Weight = 40
                    }, 
                    {
                        Script = "scripts/entity/tactical/enemies/skeleton_priest",
                        Weight = 20
                    }
                ]
            },
            GhostPool = {
                Normal = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/ghost"
                        ],
                        Weight = 95
                    },
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/legend_banshee"
                        ],
                        Weight = 5
                    }               
                ],
                Senior = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/legend_banshee"
                        ],
                        Weight = 100
                    }
                ]
            },
            ZombiePool = {
                Normal = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/zombie",
                            "scripts/entity/tactical/enemies/zombie_bodyguard"
                        ],
                        Weight = 60
                    },
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/zombie_yeoman",
                            "scripts/entity/tactical/enemies/zombie_nomad",
                            "scripts/entity/tactical/enemies/zombie_nomad_bodyguard",
                            "scripts/entity/tactical/enemies/zombie_yeoman_bodyguard"
                        ],
                        Weight = 35
                    },
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/zombie_knight",
                            "scripts/entity/tactical/enemies/zombie_knight_bodyguard",
                        ],
                        Weight = 5
                    }           
                ],
                Senior = [
                    {
                        Script = [
                            "scripts/entity/tactical/enemies/zombie_knight",
                            "scripts/entity/tactical/enemies/zombie_knight_bodyguard",
                        ],
                        Weight = 70
                    },   
                    {
                        Script = "scripts/entity/tactical/enemies/zombie_betrayer",
                        Weight = 30
                    }
                ]
            }
        },
        DeathCoil = {
			BaseSkillRangeMax = 2,
            SkillRangeMaxRankFactor = 2,
			SkillActionPointCost = 4,
			SkillFatigueCost = 20,
            BaseSkillDamage = 100,
            SkillDamageRankFactor = 100,
            SkillDamageLevelFactor = 0.08,
            TreatmentMult = 2,
            SoulEnergyCost = [
                1,
                2,
                3,
                4,
                5
            ],
            StrengthenSoulEnergyCostMult = 2,
            StrengthenSkillRangeMaxMult = 1.5,
            StrengthenDamageMult = 1.5
        }
    },
    Helmet = {
        BaseControlAbilityMax = 50,
        ControlAbilityMaxLevelFactor = 5,
        Dominate = {
			BaseSkillRangeMax = 2,
            SkillRangeMaxRankFactor = 2,
			SkillActionPointCost = 4,
			SkillFatigueCost = 20,
            SoulEnergyCost = [
                1,
                1,
                2,
                2,
                5
            ],
            ControlAbilityCost = [
                10,
                10,
                20,
                20,
                50
            ]
        }
    },
    Armor = {
        Halo = {
			BaseSkillRangeMax = 2,
            SkillRangeMaxRankFactor = 2,
            MeleeSkillOffset = 2,
            RangedSkillOffset = 2,
            MeleeDefenseOffset = 2,
            RangedDefenseOffset = 2
        }

    },
    LichKingSuit = [
        "el_accessory.taelia_present",
        "el_armor.body.ice_armor",
        "el_armor.head.crown_of_rule",
        "el_weapon.frostmourne"
    ],
    function IsLichKingSuit( _item )
    {
        foreach(item_id in this.Const.EL_LichKing.LichKingSuit)
        {
            if(_item.getID() == item_id)
            {
                return true;
            }
        }
        return false;
    }
};
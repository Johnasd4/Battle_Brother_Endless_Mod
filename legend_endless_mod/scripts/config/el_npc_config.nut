local gt = this.getroottable();

if (!("EL_NPC" in gt.Const))
{
	gt.Const.EL_NPC <- {};
}

gt.Const.EL_NPC <- {

    EL_Champion = {
        XP = {
            Offset = [
                0,
                200,
                500
            ],
            Mult = [
                1,
                3,
                10
            ]
        },
        CombatLevelOffset = [
            0,
            3,
            10
        ],
        ActionPointsOffset = [
            0,
            1,
            3
        ],
        DirectDamageMult = [
            1,
            1.2,
            1.5
        ],
        Attributes = {
            HitpointsMult = [1, 1.4, 2],
            Bravery = [0, 40, 100],
            Fatigue = [0, 100, 250],
            Initiative = [0, 40, 100],
            MeleeSkill = [0, 40, 100],
            RangedSkill = [0, 40, 100],
            MeleeDefense = [0, 40, 100],
            RangedDefense = [0, 40, 100],
        },

        Name = [
            "Normal",
            "Elite",
            "Leader"
        ],
        Icon = [
            "el_skills/champion_rank_0.png",
            "el_skills/champion_rank_1.png",
            "el_skills/champion_rank_2.png"
        ],
        IconMini = [
            "champion_rank_0_mini",
            "champion_rank_1_mini",
            "champion_rank_2_mini"
        ]
    },

    EL_LevelUp = {
        LevelUpsOffset = 10,
        LevelUpAttributes = {
            HitpointsMult = 0.05,
            Bravery = 0.5,
            Fatigue = 3,
            Initiative = 4,
            MeleeSkill = 2,
            RangedSkill = 2.5,
            MeleeDefense = 2,
            RangedDefense = 2,
        },
        XPFactor = 1.085
    },

    EL_Troop = {
        StrengthPurPopulation = 20,
        WeakUnitPopulationMult = 3,
        MinLevel = 0,
        MaxLevel = 200,
        MaxTroopNum = 255,
        MaxCombatlevel = 100,
        MinLevelOffset = -10,
        MaxLevelOffset = 0,
        BossTroopMinLeaders = 2,

        ExtraCombatLevel = {
            BossLevel = 10,
            CrticalPoint = 10,
            DivPart1 = 1,
            DivPart2 = 10
        },

        RankResouseMult = [
            1,
            2,
            5
        ],

        RankPopulationMult = [
            1,
            2,
            5
        ],

        TotalResourse = {
            Factor1 = 60,
            Factor2 = 5
        }

        Resourse = {
            MinMult = 70,
            MaxMult = 130,
        },

        BossUnit = [
            this.Const.EntityType.TricksterGod,
            this.Const.EntityType.Kraken,
            this.Const.EntityType.KrakenTentacle,
            this.Const.EntityType.SkeletonLich,
            this.Const.EntityType.SkeletonLichMirrorImage,
            this.Const.EntityType.FlyingSkull,
        ],

        EliteUnit = [
            this.Const.EntityType.BanditWarlord,
            this.Const.EntityType.BanditLeader,
            this.Const.EntityType.LegendSkinGhoul,
            this.Const.EntityType.LegendWhiteDirewolf,
            this.Const.EntityType.LegendWhiteWarwolf,
            this.Const.EntityType.LegendRedbackSpider,
            this.Const.EntityType.LegendRockUnhold,
            this.Const.EntityType.LegendDemonAlp,
            this.Const.EntityType.LegendStollwurm,
            this.Const.EntityType.LegendGreenwoodSchrat,
            this.Const.EntityType.LegendGreenwoodSchratSmall,
            this.Const.EntityType.LegendHexeLeader,
            this.Const.EntityType.Swordmaster,
            this.Const.EntityType.MasterArcher,
            this.Const.EntityType.LegendOrcElite,
            this.Const.EntityType.LegendOrcBehemoth,
            this.Const.EntityType.OrcWarlord,
            this.Const.EntityType.GoblinLeader,
            this.Const.EntityType.NomadLeader,
            this.Const.EntityType.SkeletonPhylactery,
            this.Const.EntityType.SkeletonBoss,
            this.Const.EntityType.ZombieBoss,
            this.Const.EntityType.LegendVampireLord,
            this.Const.EntityType.LegendMummyQueen,
        ],

        WeakUnit = [
            this.Const.EntityType.Peasant,
            this.Const.EntityType.PeasantSouthern
        ]

        Name = [
            "Shadowstrike", "Thunderbolt", "Nightshade", "Ironclad", "Phoenix", "Viper", "Stormbringer", "Warhawk", "Frostbite", "Sentinel",
            "Silverfox", "Havoc", "Spectre", "Blackout", "Razorback", "Serpent", "Thunderstorm", "Crimson Fury", "Ghostwalker", "Avalanche",
            "Nightfall", "Bloodhound", "Stormcrow", "Sabertooth", "Phantom", "Wildfire", "Wraith", "Venom", "Warlock", "Swiftstrike",
            "Omega", "Frostfang", "Ironwolf", "Inferno", "Banshee", "Deathbringer", "Frostfire", "Warpath", "Bladewind", "Thunderclaw",
            "Darkstar", "Nightblade", "Steelheart", "Shadowhunter", "Phoenixfire", "Thunderstrike", "Nightstalker", "Ironhide", "Seraph",
            "Vortex", "Warthog", "Frostnova", "Silverfang", "Spectral", "Blackhawk", "Razorwind", "Havocblade", "Shadowrider", "Stormshadow",
            "Bloodraven", "Thunderwing", "Crimson Viper", "Ghostfire", "Avalanche", "Nightshade", "Sabretooth", "Phantom", "Wildstrike",
            "Wraith", "Warlock", "Swiftshadow", "Omega", "Frostbite", "Ironclaw", "Inferno", "Banshee", "Deathstrike", "Frostfire",
            "Warpath", "Bladefang", "Thunderclaw", "Darkstrike", "Nightshroud", "Steelstorm", "Shadowblade", "Phoenixflare", "Thunderstrike",
            "Nightstalker", "Ironheart", "Seraphim", "Vortex", "Warthog", "Frostnova", "Silverclaw", "Spectral", "Blackfang", "Razorhawk",
            "Havocrider", "Shadowfire", "Thunderstorm", "Shadowstrike", "Thunderbolt", "Nightshade", "Ironclad", "Phoenix", "Viper", "Stormbringer",
            "Silverfox", "Havoc", "Spectre", "Blackout", "Razorback", "Serpent", "Thunderstorm", "Crimson Fury", "Ghostwalker", "Avalanche",
            "Nightfall", "Bloodhound", "Stormcrow", "Sabertooth", "Phantom", "Wildfire", "Wraith", "Venom", "Warlock", "Swiftstrike",
            "Omega", "Frostfang", "Ironwolf", "Inferno", "Banshee", "Deathbringer", "Frostfire", "Warpath", "Bladewind", "Thunderclaw",
            "Darkstar", "Nightblade", "Steelheart", "Shadowhunter", "Phoenixfire", "Thunderstrike", "Nightstalker", "Ironhide", "Seraph",
            "Vortex", "Warthog", "Frostnova", "Silverfang", "Spectral", "Blackhawk", "Razorwind", "Havocblade", "Shadowrider", "Stormshadow",
            "Bloodraven", "Thunderwing", "Crimson Viper", "Ghostfire", "Avalanche", "Nightshade", "Sabretooth", "Phantom", "Wildstrike",
            "Wraith", "Warlock", "Swiftshadow", "Omega", "Frostbite", "Ironclaw", "Inferno", "Banshee", "Deathstrike", "Frostfire",
            "Warpath", "Bladefang", "Thunderclaw", "Darkstrike", "Nightshroud", "Steelstorm", "Shadowblade", "Phoenixflare", "Thunderstrike",
            "Nightstalker", "Ironheart", "Seraphim", "Vortex", "Warthog", "Frostnova", "Silverclaw", "Spectral", "Blackfang", "Razorhawk",
            "Havocrider", "Shadowfire", "Thunderstorm", "Shadowstrike", "Thunderbolt", "Nightshade", "Ironclad", "Phoenix", "Viper",
            "Stormbringer", "Warhawk", "Frostbite", "Sentinel", "Silverfox", "Havoc", "Spectre", "Blackout", "Razorback", "Serpent",
            "Thunderstorm", "Crimson Fury", "Ghostwalker", "Avalanche", "Nightfall", "Bloodhound", "Stormcrow", "Sabertooth", "Phantom",
            "Wildfire", "Wraith", "Venom", "Warlock", "Swiftstrike", "Omega", "Frostfang", "Ironwolf", "Inferno", "Banshee",
            "Deathbringer", "Frostfire", "Warpath", "Bladewind", "Thunderclaw", "Darkstar", "Nightblade", "Steelheart", "Shadowhunter",
            "Phoenixfire", "Thunderstrike", "Nightstalker", "Ironhide", "Seraph", "Vortex", "Warthog", "Frostnova", "Silverfang",
            "Spectral", "Blackhawk", "Razorwind", "Havocblade", "Shadowrider", "Stormshadow", "Bloodraven", "Thunderwing", "Crimson Viper",
            "Ghostfire", "Avalanche", "Nightshade", "Sabretooth", "Phantom", "Wildstrike", "Wraith", "Warlock", "Swiftshadow",
            "Omega", "Frostbite", "Ironclaw", "Inferno", "Banshee", "Deathstrike", "Frostfire", "Warpath", "Bladefang",
            "Thunderclaw", "Darkstrike", "Nightshroud", "Steelstorm", "Shadowblade", "Phoenixflare", "Thunderstrike", "Nightstalker",
            "Ironheart", "Seraphim", "Vortex", "Warthog", "Frostnova", "Silverclaw", "Spectral", "Blackfang", "Razorhawk",
            "Havocrider", "Shadowfire", "Thunderstorm", "Warhawk", "Frostbite", "Sentinel"
        ],
        NamePrefix = [
            "",
            "*",
            "***"
        ],
        NameSuffix = [
            "",
            "*",
            "***"
        ],

        DropIncreaseMultPurWorldLevel = {
            Money = 0.04,
            Food = 0.01,
            Treasure = 0.04,
            Ammo = 0.01,
            ArmorParts = 0.04,
            Medicine = 0.04
        }

        function EL_getTroopInfo(_EL_troop) {
            local ret = {
                troop = _EL_troop,
                EL_BasePopulation = 0,
                EL_ExtraCombatLevel = 0,
                EL_IsBossUnit = false,
                EL_IsEliteUnit = false,
                EL_IsWeakUnit = false
            };
            if(_EL_troop.Strength <= this.Const.EL_NPC.EL_Troop.StrengthPurPopulation) {
                ret.EL_BasePopulation = 1;
            }
            else {
                ret.EL_BasePopulation = this.Math.ceil(_EL_troop.Strength / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation);
            }
            if(this.Const.EL_NPC.EL_Troop.BossUnit.find(_EL_troop.ID)) {
                ret.EL_IsBossUnit = true;
                ret.EL_ExtraCombatLevel = this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.BossLevel;
                return ret;
            }
            if(this.Const.EL_NPC.EL_Troop.EliteUnit.find(_EL_troop.ID)) {
                ret.EL_IsEliteUnit = true;
            }
            else if(this.Const.EL_NPC.EL_Troop.EliteUnit.find(_EL_troop.ID)) {
                ret.EL_IsWeakUnit = true;
            }
            if(_EL_troop.Strength < this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint) {
                ret.EL_ExtraCombatLevel = this.Math.pow((this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint - _EL_troop.Strength) / this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.DivPart1, 0.5);
            }
            else {
                ret.EL_ExtraCombatLevel = this.Math.pow((_EL_troop.Strength - this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint) / this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.DivPart2, 0.5);
            }
            return ret;
        }
    }

    EL_NormalTeam = {
        EliteChance = {
            Factor = {
                Offset = [
                    0,
                    -10,
                    -20,
                    30
                ],
                Mult = [
                    0,
                    1,
                    2,
                    0
                ],
                Range = [
                    10,
                    20,
                    30
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.EliteChance);
            }
        },
        RandomLeaderChance = {
            Factor = {
                Offset = [
                    0,
                    -10,
                    -25,
                    15
                ],
                Mult = [
                    0,
                    0.5,
                    1,
                    0
                ],
                Range = [
                    20,
                    30,
                    40
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance);
            }
        }
        StrongestLeaderChance = {
            Factor = {
                Offset = [
                    100,
                    -15,
                    -35,
                    15
                ],
                Mult = [
                    0,
                    0.5,
                    1,
                    0
                ],
                Range = [
                    30,
                    40,
                    50
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance);
            }
        }
    },

    EL_EliteTeam = {
        EliteTeamChance = {
            Factor = {
                Offset = [
                    0,
                    -2,
                    -5,
                    -9,
                    -14,
                    10
                ],
                Mult = [
                    0,
                    0.1,
                    0.2,
                    0.3,
                    0.4,
                    0
                ],
                Range = [
                    20,
                    30,
                    40,
                    50,
                    60
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance);
            }
        },
        RandomLeaderChance = {
            Factor = {
                Offset = [
                    0,
                    -15,
                    -35,
                    15
                ],
                Mult = [
                    0,
                    0.5,
                    1,
                    0
                ],
                Range = [
                    30,
                    40,
                    50
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_EliteTeam.RandomLeaderChance);
            }
        }
        StrongestLeaderChance = {
            Factor = {
                Offset = [
                    0,
                    -20,
                    -45,
                    0.15
                ],
                Mult = [
                    0,
                    0.5,
                    1,
                    0
                ],
                Range = [
                    40,
                    50,
                    60
                ]
            }
            Table = []
            function EL_getChance(_EL_Index) {
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_EliteTeam.StrongestLeaderChance);
            }
        }
    }

    EL_NPCBuff = {
        Pool = {
            Scripts = [
                "scripts/skills/el_npc_buffs/el_agility_npc_buff",
                "scripts/skills/el_npc_buffs/el_berserk_npc_buff",
                "scripts/skills/el_npc_buffs/el_bravery_npc_buff",
                "scripts/skills/el_npc_buffs/el_charge_npc_buff",
                "scripts/skills/el_npc_buffs/el_endurance_npc_buff",
                "scripts/skills/el_npc_buffs/el_evasion_npc_buff",
                "scripts/skills/el_npc_buffs/el_growth_npc_buff",
                "scripts/skills/el_npc_buffs/el_intimidate_npc_buff",
                "scripts/skills/el_npc_buffs/el_lightning_speed_npc_buff",
                "scripts/skills/el_npc_buffs/el_phoenix_npc_buff",
                "scripts/skills/el_npc_buffs/el_recovery_npc_buff",
                "scripts/skills/el_npc_buffs/el_retaliation_npc_buff",
                "scripts/skills/el_npc_buffs/el_revenge_npc_buff",
                "scripts/skills/el_npc_buffs/el_self_destruct_npc_buff",
                "scripts/skills/el_npc_buffs/el_stamina_npc_buff",
                "scripts/skills/el_npc_buffs/el_stunning_strike_npc_buff",
                "scripts/skills/el_npc_buffs/el_tank_npc_buff",
                "scripts/skills/el_npc_buffs/el_thick_skin_npc_buff",
                "scripts/skills/el_npc_buffs/el_veteran_npc_buff",
                "scripts/skills/el_npc_buffs/el_weapon_master_npc_buff"
            ],
            function EL_assignNPCBuffs(_EL_npc, _EL_rank1Num, _EL_rank2Num) {
                local index_pool = [];
                for(local i = 0; i < this.Const.EL_NPC.EL_NPCBuff.Pool.Scripts.len(); ++i) {
                    index_pool.push(i);
                }
                for(local i = 0; i < _EL_rank1Num && index_pool.len() != 0; ++i) {
                    local r = this.Math.rand(0, index_pool.len() - 1);
                    local skill = this.new(this.Const.EL_NPC.EL_NPCBuff.Pool.Scripts[index_pool[r]]);
                    skill.EL_setRankLevel(1);
                    _EL_npc.getSkills().add(skill);
                    index_pool.remove(r);
                }
                for(local i = 0; i < _EL_rank2Num && index_pool.len() != 0; ++i) {
                    local r = this.Math.rand(0, index_pool.len() - 1);
                    local skill = this.new(this.Const.EL_NPC.EL_NPCBuff.Pool.Scripts[index_pool[r]]);
                    skill.EL_setRankLevel(2);
                    _EL_npc.getSkills().add(skill);
                    index_pool.remove(r);
                }
            }
        },

        BuffNum = {
            HumanoidRank1 = [0, 1, 0],
            HumanoidRank2 = [0, 0, 20],
            NonHumanoidRank1 = [0, 3, 0],
            NonHumanoidRank2 = [0, 0, 20]
        }

        Agility = {
            ActionPointsOffset = [0, 2, 5]
        },
        Berserk = {
            DamageDirectMult = [1, 1.4, 2]
        },
        Bravery = {
            BraveryOffset = [0, 40, 100]
        },
        Charge = {
            KnockBackChance = [0, 40, 100]
        },
        StunningStrike = {
            StunChance = [0, 40, 100]
        },
        Endurance = {
        },
        Evasion = {
            MeleeState = 1,
            RangeState = 2,
            DefenseOffset = [0, 80, 200]
        },
        Growth = {
            DamageMultPurStack = [0, 0.04, 0.1],
            DamageReceivedMultPurStack = [0, 0.04, 0.1],
            MeleeSkillOffsetPurStack = [0 ,0.8, 2],
            RangedSkillOffsetPurStack = [0 ,0.8, 2],
            MeleeDefenseOffsetPurStack = [0 ,0.8, 2],
            RangedDefenseOffsetPurStack = [0 ,0.8, 2],
        },
        Intimidate = {
            MoraleCheckChance = [0, 40, 100],
            BaseOffset = 50,
            RankFactor = 25,
            CombatLevelFactor = 1.04,
            DistanceFactor = 3
        },
        LightningSpeed = {
            InitiativeOffset = [0, 80, 200]
        },
        Phoenix = {
            RiseTimes = [0, 1, 3],
            DamageMultPurStack = 0.1,
            DamageReceivedMultPurStack = 0.1,
            HitPointsMultPurStack = 0.1,
            BraveryOffsetPurStack = 6,
            FatigueOffsetPurStack = 10,
            InitiativeOffsetPurStack = 12,
            MeleeSkillOffsetPurStack = 8,
            RangedSkillOffsetPurStack = 10,
            MeleeDefenseOffsetPurStack = 8,
            RangedDefenseOffsetPurStack = 8,

        },
        Recovery = {
            HitpointsRecoveryRate = [0, 0.08, 0.2],
            ArmorRecoveryRate = [0, 0.08, 0.2],
        },
        Retaliation = {
            AttackChance = [0, 40, 100]
        },
        Revenge = {
            DamageMultPurStack = [0, 0.04, 0.1],
        },
        SelfDestruct = {
            DamageRate = [0, 0.4, 1],
            DamageDecayRatePurTile = 0.2,
        },
        Stamina = {
            StaminaOffset = [0, 80, 200]
        },
        Tank = {
            HitpointsMult = [1, 1.8, 3],
            ArmorMult = [1, 1.8, 3],
        },
        ThickSkin = {
            DamageReceivedMult = [0, 0.8, 2]
        },
        Veteran = {
            CombatLevelOffset = [0, 2, 5]
        },
        WeaponMaster = {
            MeleeSkillOffset = [0, 40, 100],
            RangedSkillOffset = [0, 40, 100]
        }

    }


    EL_Contract = {
        PatmentMultPurWorldLevel = 0.04
    }
};

this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.EliteChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.StrongestLeaderChance);


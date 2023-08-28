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
            LevelToOffsetMult = [
                [0, 2, 3],
                [0, 0.4, 0.6],
                [0, 2, 3],
                [0, 1, 1.5],
                [0, 0.5, 0.75],
                [0, 0.5, 0.75],
                [0, 1, 1.5],
                [0, 1, 1.5]
            ],
            Mult = [
                [0, 1,5, 2.25],
                [0, 1,3, 1.7],
                [0, 1,5, 2.25],
                [0, 1,15, 1.3],
                [0, 1,15, 1.3],
                [0, 1,15, 1.3],
                [0, 1,2, 1.4],
                [0, 1,2, 1.4]
            ]
        },
    },

    EL_LevelUp = {
        LevelUpsOffset = 10,
        LevelUpAttributes = {
            HitpointsMult = 0.05,
            Bravery = 0.5,
            Fatigue = 4,
            Initiative = 2,
            MeleeSkill = 1.5,
            RangedSkill = 2.5,
            MeleeDefense = 2,
            RangedDefense = 2.5,
        },
        XPFactor = 1.085
    },

    EL_Troop = {
        StrengthPurPopulation = 20,
        WeakUnitPopulationMult = 3,
        MinLevel = 0,
        MaxLevel = 200,
        MinLevelOffset = -10,
        MaxLevelOffset = 0,
        BossTroopMinLeaders = 2,

        ExtraCombatLevel = {
            BossLevel = 10,
            CrticalPoint = 10,
            DivPart1 = 0,
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
            Factor1 = 100,
            Factor2 = 3
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
            this.Const.EntityType.SkeletonLichMirrorImage
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
            this.Const.EntityType.FlyingSkull,
            this.Const.EntityType.SkeletonPhylactery,
            this.Const.EntityType.SkeletonBoss,
            this.Const.EntityType.ZombieBoss,
            this.Const.EntityType.LegendVampireLord,
            this.Const.EntityType.LegendMummyQueen
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
        NameSuffix = [
            "",
            "*",
            "***"
        ],

        function EL_getTroopInfo(_EL_troop) {
            local ret = {
                troop = _EL_troop,
                EL_BasePopulation = 0,
                EL_ExtraCombatLevel = 0,
                EL_IsBossUnit = false,
                EL_IsEliteUnit = false,
                EL_IsWeakUnit = false
            };
            if(_EL_troop.Strength <= 20) {
                ret.EL_BasePopulation = 1;
            }
            else {
                ret.EL_BasePopulation = this.Math.ceil((_EL_troop.Strength - 1) / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation);
            }
            if(this.Const.EL_NPC.EL_Troop.BossUnit.find(_EL_troop.ID)) {
                ret.EL_IsBoss = true;
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
                ret.EL_ExtraCombatLevel = this.Math.sqrt((this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint - _EL_troop.Strength) / this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.DivPart1);
            }
            else {
                ret.EL_ExtraCombatLevel = this.Math.sqrt((_EL_troop.Strength - this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint) / this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.DivPart2);
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
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.EliteTeamChance);
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
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance);
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
                return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance);
            }
        }
    }
};

this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.EliteChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.StrongestLeaderChance);


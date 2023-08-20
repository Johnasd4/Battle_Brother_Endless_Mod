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

    EL_Troop = {
        Resourse = {
            MinMult = 70,
            MaxMult = 130,
        },

        SpecialUnit = [
            {
                ID = this.Const.EntityType.Peasant,
                Population = 3
            },
            {
                ID = this.Const.EntityType.PeasantSouthern,
                Population = 3
            }
        ],

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
            this.Const.EntityType.GhostKnight,
            this.Const.EntityType.LegendMummyQueen
        ],


        StrengthPurPopulation = 20,

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


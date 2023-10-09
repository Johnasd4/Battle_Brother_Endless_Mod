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
                2,
                5
            ]
        },
        CombatLevelOffset = [
            0,
            2,
            5
        ],
        ActionPointsOffset = [
            0,
            1,
            3
        ],
        DirectDamageMult = [
            1,
            1.4,
            2
        ],
        Attributes = {
            HitpointsMult = [1, 1.4, 2],
            Bravery = [0, 40, 100],
            Fatigue = [0, 60, 150],
            Initiative = [0, 60, 150],
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
            Fatigue = 0.5,
            Initiative = 4,
            MeleeSkill = 2,
            RangedSkill = 2.5,
            MeleeDefense = 2,
            RangedDefense = 2,
        },

        LevelUpDamageMult = 0.04,
        LevelUpArmorMult = 0.04,
        MaxXPLevel = 100,
        MaxPropertiesLevel = 200,
        XPFactor = 1.085
    },

    EL_Troop = {
        StrengthPurPopulation = 20,
        WeakUnitPopulationMult = 3,
        Rank2LeastStrength = 20,
        MinLevel = 0,
        MaxLevel = 200,
        MaxTroopNum = 70,
        MaxCalculateLevel = 100,
        MinLevelOffset = -10,
        MaxLevelOffset = 0,
        BossTroopMinLeaders = 5,
        BossChance = 1,
        UnitGenerateMinCalculateResourse = 20,
        ExtraBuffRollMax = 40,
        ExtraBuffStrengthMultPurTime = 2,
        EliteUnitEliteChanceMult = 2

        EquipmentEssence = {
            CurrentRankMult = 5,
            NextRankMult = 1,
            DropLevelMult = 0.04,
            DropPowFactor = 2
        }


        ExtraCombatLevel = {
            BossLevel = 10,
            ExtraCombatLevelMax = 5,
            CrticalPoint = 10,
            MultPart1 = 1,
            MultPart2 = 0.1,
            RandomMin = -100,
            RandomMax = 100,
            RandomMult = 0.01
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
            Factor2 = 5
        }

        Resourse = {
            MultPurWorldLevel = 0.5,
            MultBase = 100
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
            this.Const.EntityType.BarbarianChosen,
            this.Const.EntityType.BarbarianMadman,
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
            this.Const.EntityType.SkeletonBoss,
            this.Const.EntityType.ZombieBoss,
            this.Const.EntityType.LegendVampireLord,
            this.Const.EntityType.LegendMummyQueen,
        ],

        WeakUnit = [
            this.Const.EntityType.Peasant,
            this.Const.EntityType.PeasantSouthern,
            this.Const.EntityType.Slave,
            this.Const.EntityType.CaravanDonkey,
            this.Const.EntityType.MilitaryDonkey
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
                ret.EL_ExtraCombatLevel = -this.Math.pow((this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint - _EL_troop.Strength) * this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.MultPart1, 0.5);
            }
            else {
                ret.EL_ExtraCombatLevel = this.Math.pow((_EL_troop.Strength - this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint) * this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.MultPart2, 0.5);
            }
            ret.EL_ExtraCombatLevel = this.Math.min(this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.ExtraCombatLevelMax, this.Math.rand(this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.RandomMin, this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.RandomMax) * this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.RandomMult + ret.EL_ExtraCombatLevel);
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
                    15
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
        EligibleFunction = {
            function EL_ifGhost(_EL_npc) {
                if(_EL_npc.getSkills().hasSkill("racial.ghost")) {
                    return true;
                }
                return false;
            }
            function EL_ifRanged(_EL_npc) {
                local main_hand = _EL_npc.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
                if(main_hand != null && main_hand.isItemType(this.Const.Items.ItemType.RangedWeapon)) {
                    return true;
                }
                return false;
            }
        }

        Pool = [
            {
                Scripts = "scripts/skills/el_npc_buffs/el_berserk_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifGhost(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_charge_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_endurance_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_energy_drain_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_evasion_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_growth_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_intimidate_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_life_drain_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_lightning_speed_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_multiple_attacks_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifRanged(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_phoenix_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_recovery_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_retaliation_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifRanged(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_revenge_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifGhost(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_self_destruct_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifGhost(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_stunning_strike_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_tank_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_thick_skin_npc_buff",
                function EL_ifEligible(_EL_npc) {
                    if(this.Const.EL_NPC.EL_NPCBuff.EligibleFunction.EL_ifGhost(_EL_npc)) { return false; }
                    return true;
                }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_veteran_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            },
            {
                Scripts = "scripts/skills/el_npc_buffs/el_weapon_master_npc_buff",
                function EL_ifEligible(_EL_npc) { return true; }
            }
        ],

        Num = {
            HumanoidRank0 = [0, 0, 0],
            HumanoidRank1 = [0, 1, 0],
            HumanoidRank2 = [0, 0, 1],
            //HumanoidRank2 = [99, 99, 99],
            NonHumanoidRank0 = [0, 0, 0],
            NonHumanoidRank1 = [0, 3, 0],
            NonHumanoidRank2 = [0, 0, 3],
            //NonHumanoidRank2 = [99, 99, 99],
            ExtraBuffRank0 = [1, 0, 0],
            ExtraBuffRank1 = [0, 1, 0],
            ExtraBuffRank2 = [0, 0, 1],
            BossUnitExtraRank1 = 0,
            BossUnitExtraRank2 = 2

        }

        Factor = {
            Berserk = {
                DamageDirectMult = [1.2, 1.4, 2]
            },
            Charge = {
                KnockBackChance = [20, 40, 100]
            },
            StunningStrike = {
                StunChance = [20, 40, 100]
            },
            Endurance = {
            },
            EnergyDrain = {
                FatiguePurActionPoint = [2, 4, 10]
            },
            Evasion = {
                MeleeState = 1,
                RangeState = 2,
                DefenseOffset = [10, 20, 50],
                DefenseOffsetSelectedMult = 4,
            },
            Growth = {
                DamageMultPurStack = [0.02, 0.04, 0.1],
                DamageReceivedMultPurStack = [0.02, 0.04, 0.1],
                MeleeSkillOffsetPurStack = [0.4 ,0.8, 2],
                RangedSkillOffsetPurStack = [0.4 ,0.8, 2],
                MeleeDefenseOffsetPurStack = [0.4 ,0.8, 2],
                RangedDefenseOffsetPurStack = [0.4 ,0.8, 2],
            },
            Intimidate = {
                BraveryOffset = [20, 40, 100],
                MoraleCheckChance = [20, 40, 100],
                BaseOffset = 50,
                RankFactor = 0,
                CombatLevelFactor = 1.04,
                DistanceFactor = 3
            },
            LifeDrain = {
                HitpointsPurActionPoint = [0.5, 1, 2.5],
                HitpointsMultPurCombatLevel = 0.04,
                RecoverMult = 10,
            }
            LightningSpeed = {
                InitiativeOffset = [40, 80, 200],
                ActionPointsOffset = [1, 2, 5]
            },
            MultipleAttacks = {
                DamageDirectMult = [0.2, 0.4, 1]
            }
            Phoenix = {
                RiseTimes = [1, 2, 3],
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
                HitpointsRecoveryRate = [0.04, 0.08, 0.2],
                FatigueRecoveryRate = [0.04, 0.08, 0.2],
                ArmorRecoveryRate = [0.04, 0.08, 0.2],
            },
            Retaliation = {
                AttackChance = [20, 40, 100]
            },
            Revenge = {
                DamageMultPurStack = [0.04, 0.08, 0.2],
            },
            SelfDestruct = {
                DamageBase = 100,
                DamageMultPurCombatLevel = 0.04,
                DamageRate = [0.2, 0.4, 1],
                WeaponShieldDamageRate = [0.1, 0.2, 0.5],
                DamageDecayRatePurTile = 0.5,
                MaxDistance = 2
            },
            Tank = {
                HitpointsMult = [1.4, 1.8, 3],
                Stamina = [40, 80, 200],
                ArmorMult = [1.4, 1.8, 3]
            },
            ThickSkin = {
                DamageReceivedMult = [0.4, 0.8, 2.0]
            },
            Veteran = {
                CombatLevelOffset = [1, 2, 5]
            },
            WeaponMaster = {
                MeleeSkillOffset = [20, 40, 100],
                RangedSkillOffset = [20, 40, 100]
            }
        }

        function EL_assignNPCBuffs(_EL_npc, _EL_rank0Num, _EL_rank1Num, _EL_rank2Num) {
            local index_pool = [];
            local skills = _EL_npc.getSkills();
            for(local i = 0; i < this.Const.EL_NPC.EL_NPCBuff.Pool.len(); ++i) {
                if(this.Const.EL_NPC.EL_NPCBuff.Pool[i].EL_ifEligible(_EL_npc)) {
                    index_pool.push(i);
                }
            }
            for(local i = 0; i < _EL_rank2Num && index_pool.len() != 0; ++i) {
                local r = this.Math.rand(0, index_pool.len() - 1);
                local skill = this.new(this.Const.EL_NPC.EL_NPCBuff.Pool[index_pool[r]].Scripts);
                if(skills.getSkillByID(skill.getID()) == null)
                {
                    skill.EL_setRankLevel(2);
                    skills.add(skill);
                }
                else
                {
                    --i;
                }
                index_pool.remove(r);
            }
            for(local i = 0; i < _EL_rank1Num && index_pool.len() != 0; ++i) {
                local r = this.Math.rand(0, index_pool.len() - 1);
                local skill = this.new(this.Const.EL_NPC.EL_NPCBuff.Pool[index_pool[r]].Scripts);
                if(skills.getSkillByID(skill.getID()) == null)
                {
                    skill.EL_setRankLevel(1);
                    skills.add(skill);
                }
                else
                {
                    --i;
                }
                index_pool.remove(r);
            }
            for(local i = 0; i < _EL_rank0Num && index_pool.len() != 0; ++i) {
                local r = this.Math.rand(0, index_pool.len() - 1);
                local skill = this.new(this.Const.EL_NPC.EL_NPCBuff.Pool[index_pool[r]].Scripts);
                if(skills.getSkillByID(skill.getID()) == null)
                {
                    skill.EL_setRankLevel(0);
                    skills.add(skill);
                }
                else
                {
                    --i;
                }
                index_pool.remove(r);
            }
        }
    }


    EL_Contract = {
        PaymentMultPurWorldLevel = 0.04,
        PaymentMultMaxWorldLevel = 200
    }
};

this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.EliteChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.RandomLeaderChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_NPC.EL_EliteTeam.StrongestLeaderChance);


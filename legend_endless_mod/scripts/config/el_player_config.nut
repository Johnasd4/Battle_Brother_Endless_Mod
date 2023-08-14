local gt = this.getroottable();

if (!("EL_Player" in gt.Const))
{
	gt.Const.EL_Player <- {};
}

gt.Const.EL_Player <- {

    EL_PlayerLevelMax = 100,
    //Part1(level < 11), XP = 200 * level ^ 2
    EL_PlayerLevelPart1 = 11,
    EL_PlayerLevelPart1Factor = 200,
    //Part2, XP(level) = XP(level - 1) * 1.1
    EL_PlayerLevelPart2Factor = 1.1,

    EL_PlayerDisplayHitpointsMax = 600,
    EL_PlayerDisplayBraveryMax = 120,
    EL_PlayerDisplayFatigueMax = 600,
    EL_PlayerDisplayInitiativeMax = 720,
    EL_PlayerDisplayMeleeSkillMax = 500,
    EL_PlayerDisplayRangeSkillMax = 500,
    EL_PlayerDisplayMeleeDefenseMax = 950,
    EL_PlayerDisplayRangeDefenseMax = 950,

    EL_CombatXPMaxDivFactor = 12.0,
    // XP * (1 + (WorldLevel - Level - 5) * 0.2) ^ 2 (Level < WorldLevel - 5)
    EL_CombatXPBelowWorldLevelOffset = 5,
    EL_CombatXPBelowWorldLevelMultFactor = 0.2,
    EL_CombatXPBelowWorldLevelMultFactorMax = 10,
    // XP / (1 + (Level - WorldLevel - 0) * 0.2) ^ 2 (Level > WorldLevel - 0)
    EL_CombatXPOverWorldLevelOffset = 0,
    EL_CombatXPOverWorldLevelMultFactor = 0.2
    EL_CombatXPOverWorldLevelMultFactorMin = 0.1

    EL_PlayerXPMult = [
        1,
        0.333,
        0.1
    ],

    EL_PlayerExtraHiringCostMult = [
        1,
        3,
        10
    ],

    EL_PlayerExtraHiringCostOffset = [
        0,
        3000,
        10000
    ],

    EL_PlayerExtraDailyCostMult = [
        1,
        3,
        10
    ],

    EL_PlayerExtraDailyFoodMult = [
        1,
        2,
        5
    ],

    EL_PlayerExtraCombatLevel = [
        0,
        3,
        10
    ],

    EL_PlayerExtraPerkPoints = [
        0,
        2,
        5
    ],

    EL_PlayerExtraPerkPointFrequency = [
        8,
        6,
        4
    ],

    EL_PlayerExtraPerks = [
        0,
        14,
        35
    ],

    EL_Attributes = {
        Hitpoints = 0,
        Bravery = 1,
        Fatigue = 2,
        Initiative = 3,
        MeleeSkill = 4,
        RangedSkill = 5,
        MeleeDefense = 6,
        RangedDefense = 7,
        COUNT = 8
    },

    EL_LevelUpAttributes = [
        {//Hitpoints
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//Bravery
            Min = [0, 1, 1, 3],
            Max = [1, 1, 2, 4]
        },
        {//Fatigue
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//Initiative
            Min = [3, 4, 5, 5],
            Max = [5, 5, 5, 6]
        },
        {//MeleeSkill
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        },
        {//RangedSkill
            Min = [2, 3, 4, 4],
            Max = [4, 4, 4, 5]
        },
        {//MeleeDefense
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        },
        {//RangedDefense
            Min = [1, 2, 3, 3],
            Max = [3, 3, 3, 4]
        }
    ],

    EL_TryoutCostMultFactor = 7.0,

    EL_HiringCostItemCostMultFactor = 1.0,
    EL_HiringCostLevelMultFactor = 0.04,

    EL_HiringCostPricePart1 = 0.0,
    EL_HiringCostPricePart2 = 100.0,
    EL_HiringCostPricePart3 = 1000.0,
    EL_HiringCostPricePart4 = 10000.0,
    EL_HiringCostPricePart5 = 100000.0,

    EL_HiringCostFactorPart1 = 1.0,
    EL_HiringCostFactorPart2 = 2.0,
    EL_HiringCostFactorPart3 = 10.0,
    EL_HiringCostFactorPart4 = 5.0,
    EL_HiringCostFactorPart5 = 1.0,

    EL_DailyCostLevelMultFactor = 0.04,

    EL_Rank1ChanceWorldLevel = [
        0,
        10,
        20,
        30
    ],

    EL_Rank1ChanceFactor = [
        0,
        1,
        2,
        0
    ],

    EL_Rank1ChanceOffset = [
        50,
        -10,
        -30,
        30
    ],

    EL_Rank2ChanceWorldLevel = [
        0,
        20,
        30,
        40
    ],

    EL_Rank2ChanceFactor = [
        0,
        0.1,
        0.2,
        0
    ],

    EL_Rank2ChanceOffset = [
        50,
        -2,
        -5,
        3
    ]

    EL_TalentMax = 3,

    EL_TalentChance = [
        40,
        70,
        90,
        100
    ],

    EL_RankToTalentBonus = [
        0,
        1,
        2
    ],

    EL_RankToExtraPerks = [
        0,
        20,
        50
    ],

    EL_PerkTreeType = {
        Style = 0,
        Perfession = 1,
        Special = 2,
        Class = 3,
        Defense = 4,
        enemy = 5,
        magic = 6,
        Traits = 7,
        Weapon = 8,
        Count = 9
    },

    EL_PerkTreeRankNeeded = [
        1,
        2,
        2,
        1,
        1,
        0,
        2,
        0,
        0
    ],

    function EL_AddRandomPerkTreeToPlayer( _player, _perk_num ) {
        local type_tree_len = [];
        local type_tree_offset = [];
        local excluded_list = [];
        local total_weight = 0;
        local rank = _player.EL_getRankLevel();
        local background = _player.getBackground();
        type_tree_len.push(gt.Const.Perks.StylesTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.ProfessionTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.SpecialTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.ClassTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.DefenseTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.EnemyTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.MagicTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.TraitsTrees.Tree.len());
        type_tree_len.push(gt.Const.Perks.WeaponTrees.Tree.len());
        if(background.m.CustomPerkTreeMap != null) {
            foreach (category in background.m.CustomPerkTreeMap)
            {
                foreach (tree_in_map in category)
                {
                    excluded_list.push(tree_in_map.ID);
                }
            }
        }

        for(local type_count = 0; type_count < type_tree_len.len(); ++type_count) {
            type_tree_offset.push(total_weight);
            if(rank >= gt.Const.EL_Player.EL_PerkTreeRankNeeded[type_count]) {
                total_weight += type_tree_len[type_count];
            }
        }
        type_tree_offset.push(total_weight);
        if(total_weight == 0){
            return;
        }
        while( _perk_num > 0 ) {
            local roll = this.Math.rand(0, total_weight - 1);
            local tree_list = null;
            local add_tree = null;

            local add_tree_list = [];
            if(roll >= type_tree_offset[0] && roll < type_tree_offset[1]) {
                tree_list = this.Const.Perks.StylesTrees.Tree;
            }
            else if(roll >= type_tree_offset[1] && roll < type_tree_offset[2]) {
                tree_list = this.Const.Perks.ProfessionTrees.Tree;
            }
            else if(roll >= type_tree_offset[2] && roll < type_tree_offset[3]) {
                tree_list = this.Const.Perks.SpecialTrees.Tree;
            }
            else if(roll >= type_tree_offset[3] && roll < type_tree_offset[4]) {
                tree_list = this.Const.Perks.ClassTrees.Tree;
            }
            else if(roll >= type_tree_offset[4] && roll < type_tree_offset[5]) {
                tree_list = this.Const.Perks.DefenseTrees.Tree;
            }
            else if(roll >= type_tree_offset[5] && roll < type_tree_offset[6]) {
                tree_list = this.Const.Perks.EnemyTrees.Tree;
            }
            else if(roll >= type_tree_offset[6] && roll < type_tree_offset[7]) {
                tree_list = this.Const.Perks.MagicTrees.Tree;
            }
            else if(roll >= type_tree_offset[7] && roll < type_tree_offset[8]) {
                tree_list = this.Const.Perks.TraitsTrees.Tree;
            }
            else if(roll >= type_tree_offset[8] && roll < type_tree_offset[9]) {
                tree_list = this.Const.Perks.WeaponTrees.Tree;
            }
            if(tree_list != null){
                foreach (tree in tree_list)
                {
                    if (excluded_list.find(tree.ID) == null)
                    {
                        add_tree_list.push(tree);
                    }
                }
                if (add_tree_list.len() != 0)
                {
                    add_tree = add_tree_list[this.Math.rand(0, add_tree_list.len() - 1)];
                    if (add_tree.Tree.len() != 0)
                    {
                        foreach( perk_level, perk_list in add_tree.Tree )
                        {
                            foreach( perk in perk_list )
                            {
                                if(background.addPerk(perk, perk_level) == true) {
                                    _perk_num -= 1;
                                     //this.logInfo("_perk_num : " + _perk_num);
                                }
                                else {
                                    //this.logInfo("add failed");
                                }
                            }
                        }

                        // background.addPerkGroup(add_tree.Tree);
                        // _perk_num -= add_tree.Tree.len();

                        excluded_list.push(add_tree.ID);

                    }
                }
            }
        }
    }
};

gt.Const.CharacterProperties.EL_CombatLevel <- 0;
local onSerialize = gt.Const.CharacterProperties.onSerialize;
gt.Const.CharacterProperties.onSerialize = function ( _out )
{
    onSerialize( _out );
    _out.writeF32(this.EL_CombatLevel);
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}
local onDeserialize = gt.Const.CharacterProperties.onDeserialize;
gt.Const.CharacterProperties.onDeserialize = function ( _in )
{
    onDeserialize( _in );
    this.EL_CombatLevel = _in.readF32();
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}


while (gt.Const.LevelXP.len() != 0)
{
    gt.Const.LevelXP.pop();
}

for( local level = 1, current_level_exp = 0, level_exp = 0; level <= gt.Const.EL_Player.EL_PlayerLevelMax; ++level )
{
    level_exp += current_level_exp;
    if(level < gt.Const.EL_Player.EL_PlayerLevelPart1) {
        current_level_exp = (2 * level - 1) * gt.Const.EL_Player.EL_PlayerLevelPart1Factor;
    }
    else {
        current_level_exp *= gt.Const.EL_Player.EL_PlayerLevelPart2Factor;
    }
	gt.Const.LevelXP.push(gt.Math.floor(level_exp));
}



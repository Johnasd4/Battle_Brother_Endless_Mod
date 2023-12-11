local gt = this.getroottable();

if (!("EL_NPCOther" in gt.Const))
{
	gt.Const.EL_NPCOther <- {};
}

gt.Const.EL_NPCOther <- {

    EL_ContractsWithAddUnitsToEntity = [
        "contracts/contracts/barbarian_king_contract",
        "contracts/contracts/deliver_item_contract",
        "contracts/contracts/deliver_money_contract",
        "contracts/contracts/destroy_goblin_camp_contract",
        "contracts/contracts/destroy_orc_camp_contract",
        "contracts/contracts/drive_away_bandits_contract",
        "contracts/contracts/drive_away_barbarians_contract",
        "contracts/contracts/drive_away_nomads_contract",
        "contracts/contracts/find_artifact_contract",
        "contracts/contracts/free_greenskin_prisoners_contract",
        "contracts/contracts/hunting_schrats_contract",
        "contracts/contracts/intercept_raiding_parties_contract",
        "contracts/contracts/investigate_cemetery_contract",
        "contracts/contracts/legend_bandit_army_contract",
        "contracts/contracts/legend_barbarian_prisoner_contract",
        "contracts/contracts/legend_hunting_greenwood_schrats_contract",
        "contracts/contracts/legend_hunting_white_direwolf_contract",
        "contracts/contracts/obtain_item_contract",
        "contracts/contracts/privateering_contract",
        "contracts/contracts/raze_attached_location_contract",
        "contracts/contracts/root_out_undead_contract",
    ],

    EL_BossLocation = [
        "entity/world/locations/legendary/black_monolith_location",
        "entity/world/locations/legendary/kraken_cult_location",
        "entity/world/locations/legendary/tundra_elk_location",
        "entity/world/locations/legendary/unique_goblin_city_location",
        "entity/world/locations/legendary/waterwheel_location",
        "entity/world/locations/legendary/witch_hut_location",
        "entity/world/locations/legendary/goblin_city_location",
        "entity/world/locations/legendary/undead_monolith_location",
        "entity/world/locations/legendary/orc_fortress_location",
        "entity/world/locations/legendary/sunken_library_location",
    ],

    EL_getNameFunctionReplace = [
        "entity/tactical/legend_cat",
        "entity/tactical/legend_war_catapult",
        "entity/tactical/legend_warbear",
        "entity/tactical/legend_white_warwolf",
        "entity/tactical/player_corpse_stub",
        "entity/tactical/wardog",
        "entity/tactical/warhound",
        "entity/tactical/warwolf",
        "entity/tactical/enemies/direwolf_high",
        "entity/tactical/enemies/hyena_high",
    ],

    EL_Ghost = {
        GhastlyTouch = {
            BaseOffset = 0,
            RankFactor = 0,
            CombatLevelFactor = 1.08
        },

        HrrificScream = {
            BaseOffset = 50,
            RankFactor = 0,
            CombatLevelFactor = 1.08
        }
    }


};

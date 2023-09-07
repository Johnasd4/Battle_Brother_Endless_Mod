local gt = this.getroottable();

if (!("EL_NPCOther" in gt.Const))
{
	gt.Const.EL_NPCOther <- {};
}

gt.Const.EL_NPCOther <- {

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
        "entity/world/locations/legendary/sunken_library_location"
    ]

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
    ]



};

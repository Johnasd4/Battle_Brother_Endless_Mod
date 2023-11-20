local gt = getroottable();

::mods_registerMod("el_adaption_entity_world_locations_legendary", 1, "el_adaption_entity_world_locations_legendary");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("entity/world/locations/legendary/black_monolith_location", function(o){

        o.onDropLootForPlayer = function( _lootTable )
        {
            this.location.onDropLootForPlayer(_lootTable);
            this.dropArmorParts(this.Math.rand(0, 60), _lootTable);
            this.dropTreasure(this.Math.rand(3, 4), [
                "loot/white_pearls_item",
                "loot/jeweled_crown_item",
                "loot/gemstones_item",
                "loot/golden_chalice_item",
                "loot/ancient_gold_coins_item",
                "misc/legend_ancient_scroll_item"
            ], _lootTable);
            _lootTable.push(this.new("scripts/items/armor/legendary/emperors_armor"));
        }

	});
});

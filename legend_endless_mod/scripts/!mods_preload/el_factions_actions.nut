local gt = getroottable();

::mods_registerMod("el_factions_actions", 1, "el_factions_actions");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("factions/actions/send_caravan_action", function ( o )
	{
        local onExecute = o.onExecute;
        o.onExecute = function(_faction) 	{
            local party;

            if (_faction.hasTrait(this.Const.FactionTrait.OrientalCityState))
            {
                party = _faction.spawnEntity(this.m.Start.getTile(), "Trading Caravan", false, this.Const.World.Spawn.CaravanSouthern, this.m.Start.getResources() * 0.6);
            }
            else
            {
                party = _faction.spawnEntity(this.m.Start.getTile(), "Trading Caravan", false, this.Const.World.Spawn.Caravan, this.m.Start.getResources() * 0.5);
            }

            party.getSprite("banner").Visible = false;
            party.getSprite("base").Visible = false;
            party.setMirrored(true);
            party.setDescription("A trading caravan from " + this.m.Start.getName() + " that is transporting all manner of goods between settlements.");
            party.setFootprintType(this.Const.World.FootprintsType.Caravan);
            party.getFlags().set("IsCaravan", true);
            party.getFlags().set("IsRandomlySpawned", true);

            if (this.World.Assets.m.IsBrigand)
            {
                party.setVisibleInFogOfWar(true);
                party.setImportant(true);
                party.setDiscovered(true);
            }

            if (this.m.Start.getProduce().len() != 0)
            {
                local produce = 3;

                if (::Legends.Mod.ModSettings.getSetting("WorldEconomy").getValue())
                {
                    produce = this.Math.max(3, 3 + this.Math.round(0.025 * this.m.Start.getResources()));
                }

                for( local j = 0; j < produce; j = j )
                {
                    party.addToInventory(this.m.Start.getProduce()[this.Math.rand(0, this.m.Start.getProduce().len() - 1)]);
                    j = ++j;
                }
            }

            party.getLoot().Money = this.Math.rand(0, 100);

            if (this.Math.rand(1, 100) <= 50)
            {
                party.getLoot().ArmorParts = this.Math.rand(0, 10);
            }

            if (this.Math.rand(1, 100) <= 50)
            {
                party.getLoot().Medicine = this.Math.rand(0, 10);
            }

            if (this.Math.rand(1, 100) <= 50)
            {
                party.getLoot().Ammo = this.Math.rand(0, 25);
            }

            if (::Legends.Mod.ModSettings.getSetting("WorldEconomy").getValue())
            {
                local resources = this.Math.max(1, this.Math.round(0.025 * this.m.Start.getResources()));
                this.m.Start.setResources(this.m.Start.getResources() - resources);
                party.setResources(resources);
                local r = this.Math.rand(1, 3);

                for( local j = 0; j < r; j = j )
                {
                    local items = [
                        [
                            0,
                            "supplies/bread_item"
                        ],
                        [
                            0,
                            "supplies/roots_and_berries_item"
                        ],
                        [
                            0,
                            "supplies/dried_fruits_item"
                        ],
                        [
                            0,
                            "supplies/ground_grains_item"
                        ],
                        [
                            0,
                            "supplies/dried_fish_item"
                        ],
                        [
                            0,
                            "supplies/beer_item"
                        ],
                        [
                            0,
                            "supplies/goat_cheese_item"
                        ],
                        [
                            1,
                            "supplies/legend_fresh_fruit_item"
                        ],
                        [
                            1,
                            "supplies/legend_fresh_meat_item"
                        ],
                        [
                            1,
                            "supplies/legend_pie_item"
                        ],
                        [
                            1,
                            "supplies/legend_porridge_item"
                        ],
                        [
                            1,
                            "supplies/legend_pudding_item"
                        ],
                        [
                            0,
                            "supplies/mead_item"
                        ],
                        [
                            0,
                            "supplies/medicine_item"
                        ],
                        [
                            0,
                            "supplies/pickled_mushrooms_item"
                        ],
                        [
                            0,
                            "supplies/preserved_mead_item"
                        ],
                        [
                            0,
                            "supplies/smoked_ham_item"
                        ],
                        [
                            0,
                            "supplies/wine_item"
                        ]
                    ];
                    local item = this.Const.World.Common.pickItem(items);
                    party.addToInventory(item);
                    j = ++j;
                }
            }
            else
            {
                local r = this.Math.rand(1, 4);

                if (r == 1)
                {
                    party.addToInventory("supplies/bread_item");
                }
                else if (r == 2)
                {
                    party.addToInventory("supplies/roots_and_berries_item");
                }
                else if (r == 3)
                {
                    party.addToInventory("supplies/dried_fruits_item");
                }
                else if (r == 4)
                {
                    party.addToInventory("supplies/ground_grains_item");
                }
            }

            local c = party.getController();
            c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
            c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
            local move = this.new("scripts/ai/world/orders/move_order");
            move.setDestination(this.m.Dest.getTile());
            move.setRoadsOnly(true);
            local unload = this.new("scripts/ai/world/orders/unload_order");
            local despawn = this.new("scripts/ai/world/orders/despawn_order");
            c.addOrder(move);
            c.addOrder(unload);
            c.addOrder(despawn);
        }


	});

	::mods_hookExactClass("factions/actions/send_supplies_action", function ( o )
	{
        local onExecute = o.onExecute;
        o.onExecute = function(_faction) 	{
            local spawnParty = this.Const.World.Spawn.NobleCaravan;
            local r = this.Math.rand(1, 100);

            if (r > 75)
            {
                spawnParty = this.Const.World.Spawn.Mercenaries;
            }
            else if (r > 50)
            {
                spawnParty = this.Const.World.Spawn.MixedNobleCaravan;
            }

            r = this.Math.rand(100, 200) * 0.01;
            local party = _faction.spawnEntity(this.m.Start.getTile(), "Supply Caravan", false, spawnParty, r * 100 + this.Math.round(0.1 * this.m.Start.getResources()));
            party.getSprite("body").setBrush(this.Const.World.Spawn.NobleCaravan.Body);
            party.getSprite("base").Visible = false;
            party.setMirrored(true);
            party.setDescription("A caravan with armed escorts transporting provisions, supplies and equipment between settlements.");
            party.setFootprintType(this.Const.World.FootprintsType.Caravan);
            party.getFlags().set("IsCaravan", true);
            party.getFlags().set("IsRandomlySpawned", true);

            if (this.World.Assets.m.IsBrigand)
            {
                party.setVisibleInFogOfWar(true);
                party.setImportant(true);
                party.setDiscovered(true);
            }

            if (this.m.Start.getProduce().len() != 0)
            {
                local produce = 3;

                if (::Legends.Mod.ModSettings.getSetting("WorldEconomy").getValue())
                {
                    produce = this.Math.max(3, 3 + this.Math.round(0.05 * this.m.Start.getResources()));
                }

                for( local j = 0; j < produce; j = j )
                {
                    party.addToInventory(this.m.Start.getProduce()[this.Math.rand(0, this.m.Start.getProduce().len() - 1)]);
                    j = ++j;
                }
            }

            party.getLoot().Money = this.Math.floor(this.Math.rand(0, 100) * r);
            local r = this.Math.rand(1, 3);

            if (r == 1)
            {
                party.getLoot().ArmorParts = this.Math.rand(15 * r, 30 * r);
            }
            else if (r == 2)
            {
                party.getLoot().Medicine = this.Math.rand(10 * r, 20 * r);
            }
            else if (r == 3)
            {
                party.getLoot().Ammo = this.Math.rand(25 * r, 50 * r);
            }

            if (::Legends.Mod.ModSettings.getSetting("WorldEconomy").getValue())
            {
                local resources = this.Math.max(1, this.Math.round(0.05 * this.m.Start.getResources()));
                this.m.Start.setResources(this.m.Start.getResources() - resources);
                party.setResources(resources);
                local r = this.Math.rand(3, 6);

                for( local j = 0; j < r; j = j )
                {
                    local items = [
                        [
                            0,
                            "supplies/bread_item"
                        ],
                        [
                            0,
                            "supplies/roots_and_berries_item"
                        ],
                        [
                            0,
                            "supplies/dried_fruits_item"
                        ],
                        [
                            0,
                            "supplies/ground_grains_item"
                        ],
                        [
                            0,
                            "supplies/dried_fish_item"
                        ],
                        [
                            0,
                            "supplies/beer_item"
                        ],
                        [
                            0,
                            "supplies/goat_cheese_item"
                        ],
                        [
                            1,
                            "supplies/legend_fresh_fruit_item"
                        ],
                        [
                            1,
                            "supplies/legend_fresh_meat_item"
                        ],
                        [
                            1,
                            "supplies/legend_pie_item"
                        ],
                        [
                            1,
                            "supplies/legend_porridge_item"
                        ],
                        [
                            1,
                            "supplies/legend_pudding_item"
                        ],
                        [
                            0,
                            "supplies/mead_item"
                        ],
                        [
                            0,
                            "supplies/medicine_item"
                        ],
                        [
                            0,
                            "supplies/pickled_mushrooms_item"
                        ],
                        [
                            0,
                            "supplies/preserved_mead_item"
                        ],
                        [
                            0,
                            "supplies/smoked_ham_item"
                        ],
                        [
                            0,
                            "supplies/wine_item"
                        ]
                    ];
                    local item = this.Const.World.Common.pickItem(items);
                    party.addToInventory(item);
                    j = ++j;
                }
            }
            else
            {
                local r = this.Math.rand(1, 4);

                if (r == 1)
                {
                    party.addToInventory("supplies/bread_item");
                }
                else if (r == 2)
                {
                    party.addToInventory("supplies/roots_and_berries_item");
                }
                else if (r == 3)
                {
                    party.addToInventory("supplies/dried_fruits_item");
                }
                else if (r == 4)
                {
                    party.addToInventory("supplies/ground_grains_item");
                }
            }

            local c = party.getController();
            c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
            c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
            local move = this.new("scripts/ai/world/orders/move_order");
            move.setDestination(this.m.Dest.getTile());
            move.setRoadsOnly(true);
            local unload = this.new("scripts/ai/world/orders/unload_order");
            local despawn = this.new("scripts/ai/world/orders/despawn_order");
            c.addOrder(move);
            c.addOrder(unload);
            c.addOrder(despawn);
        }


	});

});
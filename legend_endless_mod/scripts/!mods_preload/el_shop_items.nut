local gt = getroottable();

::mods_registerMod("el_shop_items", 1, "el_shop_items");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookExactClass("entity/world/settlements/buildings/marketplace_building", function ( o )
	{
        o.onUpdateShopList = function ()
		{
            local list = [
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/bludgeon"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "weapons/militia_spear"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "weapons/legend_militia_glaive"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/legend_wooden_spear"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "weapons/pitchfork"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/knife"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/legend_shiv"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "weapons/hatchet"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "weapons/legend_shovel"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "weapons/short_bow"
                },
                {
                    R = 15,
                    P = 1.0,
                    S = "weapons/legend_sling"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "weapons/javelin"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "ammo/quiver_of_arrows"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "armor/sackcloth"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "armor/linen_tunic"
                },
                {
                    R = 25,
                    P = 1.0,
                    S = "armor/thick_tunic"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "helmets/straw_hat"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "helmets/hood"
                },
                {
                    R = 80,
                    P = 1.0,
                    S = "weapons/legend_drum"
                },
                {
                    R = 80,
                    P = 1.0,
                    S = "weapons/legend_cat_o_nine_tails"
                },
                {
                    R = 80,
                    P = 1.0,
                    S = "weapons/lute"
                },
                {
                    R = 15,
                    P = 1.0,
                    S = "shields/buckler_shield"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "shields/wooden_shield"
                },
                {
                    R = 25,
                    P = 1.0,
                    S = "accessory/legend_pack_small"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "supplies/ground_grains_item"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "supplies/legend_fresh_fruit_item"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "supplies/legend_fresh_meat_item"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "supplies/roots_and_berries_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "supplies/medicine_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/ammo_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/ammo_small_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "supplies/armor_parts_small_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/armor_parts_small_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "accessory/bandage_item"
                }
            ];

            if (this.m.Settlement.getSize() >= 3)
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/medicine_item"
                });
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                });
            }

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.fishing_huts"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/dried_fish_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.beekeeper"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/mead_item"
                });
            }

            if (this.m.Settlement.getSize() >= 1 && !this.m.Settlement.hasAttachedLocation("attached_location.pig_farm"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/smoked_ham_item"
                });
            }

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.hunters_cabin"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/cured_venison_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.goat_herd"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/goat_cheese_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.orchard"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/dried_fruits_item"
                });
            }

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.mushroom_grove"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/pickled_mushrooms_item"
                });
            }

            if (!this.m.Settlement.hasAttachedLocation("attached_location.wheat_farm"))
            {
                list.push({
                    R = 30,
                    P = 1.0,
                    S = "supplies/bread_item"
                });
            }

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.gatherers_hut"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/roots_and_berries_item"
                });
            }

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.brewery"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/beer_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.winery"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/wine_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3)
            {
                list.push({
                    R = 60,
                    P = 1.0,
                    S = "supplies/cured_rations_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 || this.m.Settlement.isMilitary())
            {
                list.push({
                    R = 90,
                    P = 1.0,
                    S = "accessory/falcon_item"
                });
            }

            if (this.Const.DLC.Unhold && ::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() && (this.m.Settlement.isMilitary() && this.m.Settlement.getSize() >= 3 || this.m.Settlement.getSize() >= 2))
            {
                list.push({
                    R = 65,
                    P = 1.0,
                    S = "misc/paint_set_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_remover_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_black_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_orange_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_blue_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_green_yellow_item"
                });
            }

            if (this.Const.DLC.Unhold)
            {
                list.extend([
                    {
                        R = 90,
                        P = 1.0,
                        S = "weapons/two_handed_wooden_hammer"
                    }
                ]);

                if (this.m.Settlement.isMilitary())
                {
                    list.extend([
                        {
                            R = 80,
                            P = 1.0,
                            S = "weapons/throwing_spear"
                        }
                    ]);
                }
            }

            if (this.Const.DLC.Wildmen)
            {
                list.extend([
                    {
                        R = 50,
                        P = 1.0,
                        S = "weapons/warfork"
                    }
                ]);
            }
            //EL_OVERRIDE
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/alp_trophy_item"
			});
            list.push({
				R = 85,
				P = 1.0,
				S = "accessory/hexen_trophy_item"
			});
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/ghoul_trophy_item"
			});
            list.push({
				R = 0,
				P = 1.0,
				S = "el_misc/el_core_item"
			});

            this.m.Settlement.onUpdateShopList(this.m.ID, list);
            this.fillStash(list, this.m.Stash, 1.0, true);
        }
    });

	::mods_hookExactClass("entity/world/settlements/buildings/marketplace_oriental_building", function ( o )
	{
        o.onUpdateShopList = function ()
		{
            local list = [
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/militia_spear"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "weapons/pitchfork"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "weapons/knife"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "weapons/short_bow"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "weapons/oriental/composite_bow"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "weapons/javelin"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "weapons/oriental/saif"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "weapons/scimitar"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "weapons/oriental/light_southern_mace"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "weapons/oriental/firelance"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "ammo/quiver_of_arrows"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "armor/oriental/cloth_sash"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "armor/oriental/nomad_robe"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "armor/oriental/padded_vest"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "armor/oriental/linothorax"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "helmets/oriental/southern_head_wrap"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "helmets/oriental/southern_head_wrap"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "helmets/oriental/wrapped_southern_helmet"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "helmets/oriental/spiked_skull_cap_with_mail"
                },
                {
                    R = 15,
                    P = 1.0,
                    S = "shields/oriental/southern_light_shield"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/rice_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/rice_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/medicine_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/medicine_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/medicine_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/ammo_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/ammo_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/ammo_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "supplies/armor_parts_item"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "accessory/bandage_item"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "tools/throwing_net"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/legend_earings"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/legend_headband_coin"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "helmets/legend_southern_cloth_headress"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "helmets/legend_southern_veil"
                },
                {
                    R = 80,
                    P = 1.0,
                    S = "helmets/legend_southern_veil_coin"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "helmets/legend_headress_coin"
                }
            ];

            if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.fishing_huts"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/dried_fish_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.goat_herd"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/goat_cheese_item"
                });
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/dried_lamb_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.plantation"))
            {
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "supplies/dates_item"
                });
            }

            if (!this.m.Settlement.hasAttachedLocation("attached_location.wheat_farm"))
            {
                list.push({
                    R = 30,
                    P = 1.0,
                    S = "supplies/bread_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3)
            {
                list.push({
                    R = 60,
                    P = 1.0,
                    S = "supplies/cured_rations_item"
                });
            }

            if (this.m.Settlement.getSize() >= 3 || this.m.Settlement.isMilitary())
            {
                list.push({
                    R = 90,
                    P = 1.0,
                    S = "accessory/falcon_item"
                });
            }

            if (this.Const.DLC.Unhold && ::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() && (this.m.Settlement.isMilitary() && this.m.Settlement.getSize() >= 3 || this.m.Settlement.getSize() >= 2))
            {
                list.push({
                    R = 65,
                    P = 1.0,
                    S = "misc/paint_set_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_remover_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_black_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_orange_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_blue_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_green_yellow_item"
                });
            }

            if (this.Const.DLC.Unhold)
            {
                list.extend([
                    {
                        R = 90,
                        P = 1.0,
                        S = "weapons/two_handed_wooden_hammer"
                    },
                    {
                        R = 80,
                        P = 1.0,
                        S = "weapons/throwing_spear"
                    }
                ]);
            }

            if (this.Const.DLC.Wildmen)
            {
                list.extend([
                    {
                        R = 50,
                        P = 1.0,
                        S = "weapons/warfork"
                    }
                ]);
            }
            
            //EL_OVERRIDE
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/alp_trophy_item"
			});
            list.push({
				R = 85,
				P = 1.0,
				S = "accessory/hexen_trophy_item"
			});
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/ghoul_trophy_item"
			});
            list.push({
				R = 0,
				P = 1.0,
				S = "el_misc/el_core_item"
			});

            this.m.Settlement.onUpdateShopList(this.m.ID, list);
            this.fillStash(list, this.m.Stash, 1.0, true);
        }
    });

	::mods_hookExactClass("entity/world/settlements/buildings/armorsmith_building", function ( o )
	{
        local onUpdateShopList = o.onUpdateShopList;
        o.onUpdateShopList = function ()
		{
            local list = [
                {
                    R = 20,
                    P = 1.0,
                    S = "armor/padded_leather"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "armor/basic_mail_shirt"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "armor/mail_shirt"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "helmets/mail_coif"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/closed_mail_coif"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/nasal_helmet"
                },
                {
                    R = 65,
                    P = 1.0,
                    S = "helmets/kettle_hat"
                },
                {
                    R = 15,
                    P = 1.0,
                    S = "shields/buckler_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/wooden_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/wooden_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/wooden_shield"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "shields/heater_shield"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "shields/legend_tower_shield"
                },
                {
                    R = 45,
                    P = 1.0,
                    S = "shields/kite_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "armor/leather_lamellar"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "armor/mail_hauberk"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "armor/reinforced_mail_hauberk"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "armor/lamellar_harness"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "helmets/padded_nasal_helmet"
                },
                {
                    R = 55,
                    P = 1.0,
                    S = "helmets/padded_kettle_hat"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/padded_flat_top_helmet"
                },
                {
                    R = 80,
                    P = 1.0,
                    S = "tents/tent_scrap"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "armor/leather_lamellar"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "armor/mail_hauberk"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "armor/reinforced_mail_hauberk"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "armor/lamellar_harness"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "helmets/padded_nasal_helmet"
                },
                {
                    R = 55,
                    P = 1.0,
                    S = "helmets/padded_kettle_hat"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/padded_flat_top_helmet"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "armor/scale_armor"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "armor/heavy_lamellar_armor"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/nasal_helmet_with_mail"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/bascinet_with_mail"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/kettle_hat_with_mail"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "helmets/kettle_hat_with_closed_mail"
                },
                {
                    R = 75,
                    P = 1.0,
                    S = "helmets/nasal_helmet_with_closed_mail"
                },
                {
                    R = 45,
                    P = 1.0,
                    S = "helmets/reinforced_mail_coif"
                }
            ];
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_skullcap_01"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_great_helm_01"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_great_bascinet_01"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_great_bascinet_02"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_armet_01"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/legend_enclave_vanilla_kettle_sallet_01"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/wallace_sallet"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/deep_sallet"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/scale_helm"
            });
            list.push({
                R = 80,
                P = 1.0,
                S = "helmets/rondel_helm"
            });

            if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
            {
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/legend_enclave_vanilla_great_bascinet_03"
                });
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/legend_enclave_vanilla_armet_02"
                });
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/legend_enclave_vanilla_kettle_sallet_02"
                });
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/legend_enclave_vanilla_kettle_sallet_03"
                });
            }

            if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
            {
                foreach( i in this.Const.Items.LegendNamedArmorLayers )
                {
                    if (this.Math.rand(1, 100) <= 33)
                    {
                        list.push({
                            R = 99,
                            P = 2.0,
                            S = i
                        });
                    }
                }

                foreach( i in this.Const.Items.LegendNamedHelmetLayers )
                {
                    if (this.Math.rand(1, 100) <= 33)
                    {
                        list.push({
                            R = 99,
                            P = 2.0,
                            S = i
                        });
                    }
                }
            }

            foreach( i in this.Const.Items.NamedArmors )
            {
                if (this.Math.rand(1, 100) <= 33)
                {
                    list.push({
                        R = 99,
                        P = 2.0,
                        S = i
                    });
                }
            }

            foreach( i in this.Const.Items.NamedHelmets )
            {
                if (this.Math.rand(1, 100) <= 33)
                {
                    list.push({
                        R = 99,
                        P = 2.0,
                        S = i
                    });
                }
            }

            if (this.Const.DLC.Unhold)
            {
                list.push({
                    R = 45,
                    P = 1.0,
                    S = "armor/leather_scale_armor"
                });
                list.push({
                    R = 55,
                    P = 1.0,
                    S = "armor/light_scale_armor"
                });
                list.push({
                    R = 90,
                    P = 1.0,
                    S = "armor/noble_mail_armor"
                });
                list.push({
                    R = 60,
                    P = 1.0,
                    S = "armor/sellsword_armor"
                });
                list.push({
                    R = 50,
                    P = 1.0,
                    S = "armor/footman_armor"
                });
                list.push({
                    R = 70,
                    P = 1.0,
                    S = "helmets/sallet_helmet"
                });
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/barbute_helmet"
                });

                if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
                {
                    list.push({
                        R = 60,
                        P = 1.0,
                        S = "misc/paint_set_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_remover_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_black_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_red_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_orange_red_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_white_blue_item"
                    });
                    list.push({
                        R = 75,
                        P = 1.0,
                        S = "misc/paint_white_green_yellow_item"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/metal_plating_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/metal_pauldrons_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/mail_patch_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/leather_shoulderguards_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/leather_neckguard_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/joint_cover_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/heraldic_plates_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/double_mail_upgrade"
                    });
                }
                else
                {
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_metal_plating_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_metal_pauldrons_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_mail_patch_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_leather_shoulderguards_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_leather_neckguard_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_joint_cover_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_heraldic_plates_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_double_mail_upgrade"
                    });
                }
            }

            if (this.Const.DLC.Wildmen && this.m.Settlement.getTile().SquareCoords.Y > this.World.getMapSize().Y * 0.7)
            {
                list.push({
                    R = 70,
                    P = 1.0,
                    S = "helmets/nordic_helmet"
                });
                list.push({
                    R = 70,
                    P = 1.0,
                    S = "helmets/steppe_helmet_with_mail"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "helmets/conic_helmet_with_closed_mail"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "helmets/conic_helmet_with_closed_mail"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "helmets/nordic_helmet_with_closed_mail"
                });
                list.push({
                    R = 80,
                    P = 1.0,
                    S = "helmets/conic_helmet_with_faceguard"
                });
            }
            else
            {
                list.push({
                    R = 70,
                    P = 1.0,
                    S = "helmets/flat_top_helmet"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "helmets/flat_top_with_mail"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "helmets/flat_top_with_closed_mail"
                });
            }
            //EL_OVERRIDE
            list.push({
				R = 70,
				P = 1.0,
				S = "accessory/alp_trophy_item"
			});
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/hexen_trophy_item"
			});
            list.push({
				R = 70,
				P = 1.0,
				S = "accessory/ghoul_trophy_item"
			});
            list.push({
				R = 95,
				P = 3.0,
				S = "accessory/sergeant_badge_item"
			});
            foreach( i in this.Const.EL_Accessory.EL_SeniorAccessoryList )
            {
                list.push({
                    R = 100,
                    P = 8.0,
                    S = i
                });
            }

            this.m.Settlement.onUpdateShopList(this.m.ID, list);
            this.fillStash(list, this.m.Stash, 1.25, false);
        }
    });
    
    ::mods_hookExactClass("entity/world/settlements/buildings/armorsmith_oriental_building", function ( o )
	{
            o.onUpdateShopList = function ()
            {
                local list = [
                {
                    R = 0,
                    P = 1.0,
                    S = "armor/oriental/linothorax"
                },
                {
                    R = 10,
                    P = 1.0,
                    S = "armor/oriental/padded_vest"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "armor/oriental/mail_and_lamellar_plating"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "armor/oriental/padded_mail_and_lamellar_hauberk"
                },
                {
                    R = 35,
                    P = 1.0,
                    S = "armor/oriental/southern_long_mail_with_padding"
                },
                {
                    R = 25,
                    P = 1.0,
                    S = "armor/oriental/southern_mail_shirt"
                },
                {
                    R = 50,
                    P = 1.0,
                    S = "armor/mail_shirt"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "armor/mail_hauberk"
                },
                {
                    R = 70,
                    P = 1.0,
                    S = "armor/scale_armor"
                },
                {
                    R = 85,
                    P = 1.0,
                    S = "armor/lamellar_harness"
                },
                {
                    R = 85,
                    P = 1.0,
                    S = "armor/heavy_lamellar_armor"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/oriental/southern_light_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/oriental/southern_light_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/oriental/southern_light_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/oriental/metal_round_shield"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "shields/oriental/metal_round_shield"
                },
                {
                    R = 40,
                    P = 1.0,
                    S = "helmets/oriental/heavy_lamellar_helmet"
                },
                {
                    R = 0,
                    P = 1.0,
                    S = "helmets/oriental/southern_head_wrap"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "helmets/oriental/southern_helmet_with_coif"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "helmets/oriental/kamy_southern_helmet"
                },
                {
                    R = 20,
                    P = 1.0,
                    S = "helmets/oriental/spiked_skull_cap_with_mail"
                },
                {
                    R = 65,
                    P = 1.0,
                    S = "helmets/oriental/turban_helmet"
                },
                {
                    R = 30,
                    P = 1.0,
                    S = "helmets/oriental/wrapped_southern_helmet"
                },
                {
                    R = 60,
                    P = 1.0,
                    S = "helmets/mail_coif"
                }
            ];

            if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
            {
                foreach( i in this.Const.Items.LegendNamedSouthernArmorLayers )
                {
                    if (this.Math.rand(1, 100) <= 33)
                    {
                        list.push({
                            R = 99,
                            P = 2.0,
                            S = i
                        });
                    }
                }
            }

            foreach( i in this.Const.Items.NamedArmors )
            {
                if (this.Math.rand(1, 100) <= 33)
                {
                    list.push({
                        R = 99,
                        P = 2.0,
                        S = i
                    });
                }
            }

            foreach( i in this.Const.Items.NamedHelmets )
            {
                if (this.Math.rand(1, 100) <= 33)
                {
                    list.push({
                        R = 99,
                        P = 2.0,
                        S = i
                    });
                }
            }

            if (this.Const.DLC.Unhold && ::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
            {
                list.push({
                    R = 60,
                    P = 1.0,
                    S = "misc/paint_set_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_remover_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_black_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_orange_red_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_blue_item"
                });
                list.push({
                    R = 75,
                    P = 1.0,
                    S = "misc/paint_white_green_yellow_item"
                });

                if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
                {
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/metal_plating_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/metal_pauldrons_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/mail_patch_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/leather_shoulderguards_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/leather_neckguard_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/joint_cover_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/heraldic_plates_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "armor_upgrades/double_mail_upgrade"
                    });
                }
                else
                {
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_metal_plating_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_metal_pauldrons_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_mail_patch_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_leather_shoulderguards_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_leather_neckguard_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_joint_cover_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_heraldic_plates_upgrade"
                    });
                    list.push({
                        R = 85,
                        P = 1.25,
                        S = "legend_armor/armor_upgrades/legend_double_mail_upgrade"
                    });
                }
            }
            //EL_OVERRIDE
            list.push({
				R = 70,
				P = 1.0,
				S = "accessory/alp_trophy_item"
			});
            list.push({
				R = 80,
				P = 1.0,
				S = "accessory/hexen_trophy_item"
			});
            list.push({
				R = 70,
				P = 1.0,
				S = "accessory/ghoul_trophy_item"
			});
            list.push({
				R = 95,
				P = 3.0,
				S = "accessory/sergeant_badge_item"
			});
            foreach( i in this.Const.EL_Accessory.EL_SeniorAccessoryList )
            {
                list.push({
                    R = 100,
                    P = 8.0,
                    S = i
                });
            }

            this.m.Settlement.onUpdateShopList(this.m.ID, list);
            this.fillStash(list, this.m.Stash, 1.0, true);
        }
    });

    // ::mods_hookExactClass("entity/world/settlements/buildings/weaponsmith_building", function ( o )
	// {
    //     local onUpdateShopList = o.onUpdateShopList;
    //     o.onUpdateShopList = function ()
	// 	{
    //         onUpdateShopList();
    //         foreach( item in this.m.Stash.getItems() )
    //         {
    //             local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Shop.EL_ShopLevelMax);
    //             local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Shop.EL_ShopLevelInStoreMin), EL_worldLevel);
    //             //this.logInfo("商店物品等级：" + level);
    //             local random = this.Math.rand(1, 1000);
    //             if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 1);
    //                 //this.logInfo("商店物品升阶");
    //             }
    //             else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 2);
    //                 //this.logInfo("商店物品升阶大成功");
    //             }
    //             else
    //             {
    //                 item.EL_generateByRankAndLevel(level, 0);
    //             }
    //         }
    //     }
    // });

    // ::mods_hookExactClass("entity/world/settlements/buildings/weaponsmith_oriental_building", function ( o )
	// {
    //     local onUpdateShopList = o.onUpdateShopList;
    //     o.onUpdateShopList = function ()
	// 	{
    //         onUpdateShopList();
    //         foreach( item in this.m.Stash.getItems() )
    //         {
    //             local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Shop.EL_ShopLevelMax);
    //             local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Shop.EL_ShopLevelInStoreMin), EL_worldLevel);
    //             //this.logInfo("商店物品等级：" + level);
    //             local random = this.Math.rand(1, 1000);
    //             if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 1);
    //                 //this.logInfo("商店物品升阶");
    //             }
    //             else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 2);
    //                 //this.logInfo("商店物品升阶大成功");
    //             }
    //             else
    //             {
    //                 item.EL_generateByRankAndLevel(level, 0);
    //             }
    //         }
    //     }
    // });

    // ::mods_hookExactClass("entity/world/settlements/buildings/fletcher_building", function ( o )
	// {
    //     local onUpdateShopList = o.onUpdateShopList;
    //     o.onUpdateShopList = function ()
	// 	{
    //         onUpdateShopList();
    //         foreach( item in this.m.Stash.getItems() )
    //         {
    //             local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Shop.EL_ShopLevelMax);
    //             local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Shop.EL_ShopLevelInStoreMin), EL_worldLevel);
    //             //this.logInfo("商店物品等级：" + level);
    //             local random = this.Math.rand(1, 1000);
    //             if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 1);
    //                 //this.logInfo("商店物品升阶");
    //             }
    //             else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
    //             {
    //                 item.EL_generateByRankAndLevel(level, 2);
    //                 //this.logInfo("商店物品升阶大成功");
    //             }
    //             else
    //             {
    //                 item.EL_generateByRankAndLevel(level, 0);
    //             }
    //         }
    //     }
    // });

    ::mods_hookBaseClass("entity/world/settlements/buildings/building", function(o) {
		while(!("fillStash" in o)) o = o[o.SuperName];
		o.fillStash = function( _list, _stash, _priceMult, _allowDamagedEquipment = false )
        {
            _stash.clear();
            local rarityMult = this.getSettlement().getModifiers().RarityMult;
            local foodRarityMult = this.getSettlement().getModifiers().FoodRarityMult;
            local medicineRarityMult = this.getSettlement().getModifiers().MedicalPriceMult;
            local mineralRarityMult = this.getSettlement().getModifiers().MineralRarityMult;
            local buildingRarityMult = this.getSettlement().getModifiers().BuildingRarityMult;
            local isTrader = this.World.Retinue.hasFollower("follower.trader");
            local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Shop.EL_ShopLevelMax);
            //this.logInfo("当前世界等级" + EL_worldLevel);
            local EL_coreMaxNum = this.Const.EL_Shop.EL_Core.EL_ShopMaxNum * (1 + EL_worldLevel * this.Const.EL_Shop.EL_ItemNumberLevelFactor);
            local EL_maxNumitems = this.Const.EL_Shop.EL_ShopMaxNumitems * (1 + EL_worldLevel * this.Const.EL_Shop.EL_ItemNumberLevelFactor);
            local EL_maxNum = this.Const.EL_Shop.EL_ShopMaxNum * (1 + EL_worldLevel * this.Const.EL_Shop.EL_ItemNumberLevelFactor);

            foreach( i in _list )
            {
                local r = i.R;
                local p = this.Math.rand(0, 100) * rarityMult;
                //this.logInfo(i.S+" r:"+r+" p:"+p);
                if( p >= r )
                {
                    r = r + p;
                    for( local num = 1; true;  )
                    {
                        p = this.Math.rand(0, 100) * rarityMult;
                        local item;
                        local isHelm = false;
                        local isArmor = false;
                        local isUpgrade = false;
                        local script = i.S;
                        if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
                        {
                            local index = script.find("helmets/");

                            if (index != null && script.find("legend_helmets") == null)
                            {
                                isHelm = true;
                                script = script.slice(index + "helmets/".len());
                            }

                            index = script.find("armor/");

                            if (index != null && script.find("legend_armor") == null)
                            {
                                isArmor = true;
                                script = script.slice(index + "armor/".len());
                            }

                            index = script.find("armor_upgrades/");

                            if (index != null && script.find("legend_armor") == null)
                            {
                                isUpgrade = true;
                                script = script.slice(index + "armor_upgrades/".len());
                            }
                        }


                        if (isHelm)
                        {
                            item = this.Const.World.Common.pickHelmet([
                                [
                                    1,
                                    script
                                ]
                            ]);
                        }
                        else if (isArmor)
                        {
                            item = this.Const.World.Common.pickArmor([
                                [
                                    1,
                                    script
                                ]
                            ]);
                        }
                        else if (isUpgrade)
                        {
                            item = this.Const.World.Common.pickArmorUpgrade([
                                [
                                    1,
                                    script
                                ]
                            ]);
                        }
                        else
                        {
                            item = this.new("scripts/items/" + i.S);
                        }

                        if (item == null)
                        {
                        }
                        local EL_isCore = item.m.Name == "Core";
                        local isFood = item.isItemType(this.Const.Items.ItemType.Food);
                        local isMedicine = item.getID() == "supplies.medicine";
                        local isMineral = item.getID() == "misc.uncut_gems" || item.getID() == "misc.copper_ingots" || item.getID() == "misc.gold_ingots" || item.getID() == "misc.iron_ingots";
                        local isBuilding = item.getID() == "misc.quality_wood" || item.getID() == "misc.copper_ingots" || item.getID() == "misc.tin_ingots" || item.getID() == "misc.iron_ingots";
                        //this.logInfo(" isFood："+isFood+" p："+p+" r:"+r);
                        while (p >= r && num < EL_coreMaxNum)
                        {
                            ++num;
                            //this.logInfo("生成运算中finalNum" + num);
                            //this.logInfo("p=" + p + "r=" + r);
                            if (r != 0 || rarityMult < 1.0 || isFood && foodRarityMult < 1.0 || isMedicine && medicineRarityMult < 1.0 || isMineral && mineralRarityMult < 1.0 || isBuilding && buildingRarityMult < 1.0)
                            {
                                r = r + p;
                            }
                        }
                        if(EL_isCore)
                        {
                            ++num;
                        }
                        
                        //this.logInfo("final p："+p+" r:"+r);
                        num += p / r;
                        num = this.Math.floor(num * (1 + EL_worldLevel * this.Const.EL_Shop.EL_ItemNumberLevelFactor));
                        EL_maxNum = (!isTrader && item.isItemType(this.Const.Items.ItemType.TradeGood)) ? EL_maxNumitems : EL_maxNum;
                        EL_maxNum = EL_isCore ? EL_coreMaxNum : EL_maxNum;
                        EL_maxNum = (num > EL_maxNum) ? EL_maxNum : num;
                        
                        //this.logInfo("生成运算中EL_maxNum" + EL_maxNum);
                        for(local index = 0; index < EL_maxNum; ++index)
                        {
                            if (isHelm)
                            {
                                item = this.Const.World.Common.pickHelmet([
                                    [
                                        1,
                                        script
                                    ]
                                ]);
                            }
                            else if (isArmor)
                            {
                                item = this.Const.World.Common.pickArmor([
                                    [
                                        1,
                                        script
                                    ]
                                ]);
                            }
                            else if (isUpgrade)
                            {
                                item = this.Const.World.Common.pickArmorUpgrade([
                                    [
                                        1,
                                        script
                                    ]
                                ]);
                            }
                            else if (EL_isCore)
                            {
			                    local xp_level = EL_worldLevel;
                                local r = this.Math.rand(1, 100000);
                                local core_rank = 0;
                                if(r < this.Const.EL_Shop.EL_CoreRank3Chance.EL_getChance(this.World.Assets.m.EL_WorldLevel) * 1000)
                                {
                                    core_rank = 3;
                                }
                                else if(r < this.Const.EL_Shop.EL_CoreRank2Chance.EL_getChance(this.World.Assets.m.EL_WorldLevel) * 1000)
                                {
                                    core_rank = 2;
                                }
                                else if(r < this.Const.EL_Shop.EL_CoreRank1Chance.EL_getChance(this.World.Assets.m.EL_WorldLevel) * 1000)
                                {
                                    core_rank = 1;
                                }
                                else
                                {
                                    core_rank = 0;
                                    xp_level = this.Math.rand(this.Math.max(1 ,EL_worldLevel - this.Const.EL_Shop.EL_ShopLevelInStoreMin), EL_worldLevel + this.Const.EL_Shop.EL_ShopLevelInStoreMax);
                                }
                                item = this.new("scripts/items/el_misc/el_core_rank_" + core_rank + "_item");
                                local core_xp = this.Const.EL_Shop.EL_Core.XPOffset - this.Math.pow(this.Math.rand(this.Math.pow(this.Const.EL_Shop.EL_Core.XPMin[core_rank], 2), this.Math.pow(this.Const.EL_Shop.EL_Core.XPMax[core_rank], 2)), 0.5);
                                //this.logInfo("core_xp:" + core_xp);
                                core_xp *= this.Math.pow(this.Const.EL_NPC.EL_LevelUp.XPFactor, this.Math.max(1, xp_level - this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset));
                                //this.logInfo("xp_level:" + xp_level);
                                //this.logInfo("mult:" + this.Math.pow(this.Const.EL_NPC.EL_LevelUp.XPFactor, this.Math.max(1, xp_level - this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset)));
                                item.EL_generateCoreXPByActorXP(core_xp);
                            }
                            else
                            {
                                item = this.new("scripts/items/" + i.S);
                            }
                            //this.logInfo("item ID:"+item.getID());
                            
                            if (!isFood || p * foodRarityMult >= i.R)
                            {
                                if (!isMedicine || p * medicineRarityMult >= i.R)
                                {
                                    if (!isMineral || p * mineralRarityMult >= i.R)
                                    {
                                        if (!isBuilding || p * buildingRarityMult >= r)
                                        {
                                            local items = [
                                                item
                                            ];

                                            if (isArmor || isHelm)
                                            {
                                                local upgrades = item.getUpgrades();

                                                foreach( i, u in upgrades )
                                                {
                                                    if (u != 1)
                                                    {
                                                        continue;
                                                    }

                                                    local upgrade = item.getUpgrade(i);
                                                    upgrade.m.Armor = null;
                                                    items.push(upgrade);
                                                    item.m.Upgrades[i] = null;
                                                }
                                            }
                                        
                                            foreach( item in items )
                                            {
                                                if (_allowDamagedEquipment && item.getConditionMax() > 1)
                                                {
                                                    local random = this.Math.rand(1, 100);
                                                    if (random <= 50)
                                                    {
                                                        local condition = this.Math.rand(item.getConditionMax() * 0.4, item.getConditionMax() * 0.9);
                                                        item.setCondition(condition);
                                                    }
                                                }
                                                item.setPriceMult(i.P * _priceMult);
                                                _stash.add(item);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break;
                        
                    }
                }
            }
            _stash.sort();
        }
	});
});

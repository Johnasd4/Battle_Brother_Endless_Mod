local gt = getroottable();

::mods_registerMod("el_ballance_items_weapons_legendary", 1, "el_ballance_items_weapons_legendary");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("items/weapons/legendary/legend_mage_swordstaff", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

    });

	::mods_hookNewObject("items/weapons/legendary/lightbringer_sword", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

    });


	::mods_hookNewObject("items/weapons/legendary/obsidian_dagger", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

    });




});

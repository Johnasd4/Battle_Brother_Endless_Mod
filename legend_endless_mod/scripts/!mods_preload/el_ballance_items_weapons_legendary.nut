local gt = getroottable();

::mods_registerMod("el_ballance_items_weapons_legendary", 1, "el_ballance_items_weapons_legendary");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/weapons/legendary/legend_mage_swordstaff", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

    });

	::mods_hookExactClass("items/weapons/legendary/lightbringer_sword", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

        o.getTooltip = function()
        {
            local result = this.weapon.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Inflicts an additional [color=" + this.Const.UI.Color.DamageValue + "]5%[/color] targets current hitpoints + [color=" + this.Const.UI.Color.DamageValue + "]20[/color] damage that ignores armor. The lightning won't hit the same target and will pass on until no targets left."
            });
            return result;
        }



    });


	::mods_hookExactClass("items/weapons/legendary/obsidian_dagger", function(o){

        local create = o.create;
        o.create = function()
        {
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }

    });




});

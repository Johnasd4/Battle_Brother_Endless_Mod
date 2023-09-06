local gt = getroottable();

::mods_registerMod("el_ballance_items_legend_armor_armor", 1, "el_ballance_items_legend_armor_armor");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("items/legend_armor/armor/legend_armor_hexe_leader_cloak_upgrade", function(o){

        o.getTooltip = function()
        {
            local result = this.legend_armor_upgrade.getTooltip();
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] and increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color]"
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] and increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color]"
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            _properties.Bravery += 15;
        }


    });


});

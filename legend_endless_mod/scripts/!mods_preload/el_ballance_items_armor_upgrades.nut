local gt = getroottable();

::mods_registerMod("el_ballance_items_armor_upgrades", 1, "el_ballance_items_armor_upgrades");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/armor_upgrades/legend_hexe_leader_cloak_upgrade", function(o){

        o.getTooltip = function()
        {
            local result = this.armor_upgrade.getTooltip();
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] and increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+25[/color]"
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reduces any ranged damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] and increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+25[/color]"
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            _properties.Bravery += 25;
        }


    });


});

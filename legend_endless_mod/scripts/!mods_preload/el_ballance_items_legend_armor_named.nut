local gt = getroottable();

::mods_registerMod("el_ballance_items_legend_armor_named", 1, "el_ballance_items_legend_armor_named");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("items/legend_armor/named/legend_armor_cloak_emperors", function(o){

        o.getTooltip = function()
        {
            result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]"
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]"
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            _properties.Bravery += 5;
        }


    });

	::mods_hookNewObject("items/legend_armor/named/legend_armor_cloak_rich", function(o){

        o.getTooltip = function()
        {
            result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+2[/color]"
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+2[/color]"
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            _properties.Bravery += 2;
        }


    });

	::mods_hookNewObject("items/legend_armor/named/legend_armor_named_tabard", function(o){

        o.getTooltip = function()
        {
            result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color]"
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase the Resolve of the wearer by [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color]"
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            _properties.Bravery += 3;
        }


    });


});

local gt = getroottable();

::mods_registerMod("el_ballance_items_legend_armor_runes", 1, "el_ballance_items_legend_armor_runes");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/legend_armor/runes/legend_rune_safety", function(o){

        o.getTooltip = function()
        {
            local result = this.legend_armor_upgrade.getTooltip();
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "This item has the power of the rune sigil of Safety:\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus1 + "[/color] Hitpoints.\n[color=" + this.Const.UI.Color.PositiveValue + "]-" + this.m.RuneBonus2 + "%[/color] Damage received."
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "This item has the power of the rune sigil of Safety:\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus1 + "[/color] Hitpoints.\n[color=" + this.Const.UI.Color.PositiveValue + "]-" + this.m.RuneBonus2 + "%[/color] Damage received."
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            this.legend_armor_upgrade.onUpdateProperties(_properties);
            _properties.Hitpoints += this.m.RuneBonus1;
            _properties.DamageReceivedTotalMult *= 1.0 - this.m.RuneBonus2 * 1.0 / 100.0;
        }


    });



});

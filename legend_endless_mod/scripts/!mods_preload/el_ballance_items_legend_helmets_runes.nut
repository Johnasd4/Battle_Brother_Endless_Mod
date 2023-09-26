local gt = getroottable();

::mods_registerMod("el_ballance_items_legend_helmets_runes", 1, "el_ballance_items_legend_helmets_runes");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("items/legend_helmets/runes/legend_rune_bravery", function(o){

        o.getTooltip = function()
        {
            local result = this.legend_helmet_upgrade.getTooltip();
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "This item has the power of the rune sigil of Bravery:\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus1 + "[/color] Resolve.\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus2 + "[/color] Resolve at all morale checks."
            });
            return result;
        }

        o.onArmorTooltip = function( _result )
        {
            _result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "This item has the power of the rune sigil of Bravery:\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus1 + "[/color] Resolve.\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RuneBonus2 + "[/color] Resolve at all morale checks."
            });
        }

        o.onUpdateProperties = function( _properties )
        {
            this.legend_helmet_upgrade.onUpdateProperties(_properties);
            _properties.Bravery += this.m.RuneBonus1;
            _properties.MoraleCheckBravery[0] += this.m.RuneBonus2;
            _properties.MoraleCheckBravery[1] += this.m.RuneBonus2;
            _properties.MoraleCheckBravery[2] += this.m.RuneBonus2;
        }


    });



});

local gt = getroottable();

::mods_registerMod("el_ballance_items_armor_named", 1, "el_ballance_items_armor_named");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("items/armor/named/legend_named_warlock_cloak", function(o){

        o.getTooltip = function()
        {
            local result = this.named_armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Melee skill when at confident morale."
            });
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Melee defense when at confident morale."
            });
            result.push({
                id = 8,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Ranged defense when at confident morale."
            });
            result.push({
                id = 9,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase max hitpoints by [color=" + this.Const.UI.Color.PositiveValue + "] +20[/color]."
            });
            return result;
        }

        o.onUpdateProperties = function( _properties )
        {
            this.named_armor.onUpdateProperties(_properties);
            _properties.Hitpoints += 20;

            if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident)
            {
                _properties.MeleeSkill += 10;
                _properties.MeleeDefense += 10;
                _properties.RangedDefense += 10;
            }
        }


    });

});

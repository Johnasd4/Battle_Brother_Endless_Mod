local gt = getroottable();

::mods_registerMod("el_ballance_items_tools", 1, "el_ballance_items_tools");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/tools/player_banner", function(o){

        o.getTooltip = function()
        {
            local result = this.weapon.getTooltip();
            result.push({
                id = 10,
                type = "text",
                icon = "ui/icons/bravery.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.EL_getResolveBonus() + "[/color]"
            });
            result.push({
                id = 10,
                type = "text",
                icon = "ui/icons/special.png",
                text = "At a range of " + this.EL_getRange() + " tiles or less, " +
                       "allies [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.EL_getAllyBonus() + "[/color] resolve, " +
                       "enemies [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.EL_getEnemyBonus() + "[/color] resolve. " +
                       "The auras is effected by the the resolve of the character holding this standard."
            });
            return result;
        }

        o.EL_getRange <- function()
        {
            return 4 + this.m.EL_RankLevel;
        }

        o.EL_getCalculateBravery <- function()
        {
            local actor = null;
            if (this.getContainer() != null)
            {
                if (this.getContainer().getActor() != null)
                {
                    actor = this.getContainer().getActor();
                }
            }
            if(actor == null) {
                return 0;
            }
            local bravery = actor.getBravery();
            local calculate_bravery = 0;
            local limit = 100;
            local efficient = 1;
            while(bravery >= limit) {
                bravery -= limit;
                calculate_bravery += limit * efficient;
                efficient *= 0.5;
                limit += 2;
            }
            calculate_bravery += bravery * efficient;
            return calculate_bravery;
        }

        o.EL_getAllyBonus <- function()
        {
            return this.Math.floor(this.EL_getCalculateBravery() * (0.1 + 0.05 * this.m.EL_RankLevel));
        }

        o.EL_getEnemyBonus <- function()
        {
            local mult = 0.05 * this.m.EL_RankLevel;
            switch(this.m.EL_RankLevel) {
                case 0:
                    mult += 0;
                    break;
                case 1:
                    mult += 0.01;
                    break;
                case 2:
                    mult += 0.03;
                    break;
                case 3:
                    mult += 0.06;
                    break;
                case 4:
                    mult += 0.1;
                    break;
            }
            return this.Math.floor(this.EL_getCalculateBravery() * mult);
        }

        o.EL_getResolveBonus <- function()
        {
            return this.m.EL_Level * this.m.EL_RankLevel * 0.25;
        }

        o.onUpdateProperties <- function( _properties )
        {
            this.weapon.onUpdateProperties(_properties);
            _properties.Bravery += this.EL_getResolveBonus();

        }


    });



});

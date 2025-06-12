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
                text = "距离 " + this.EL_getRange() + " 以内, " +
                       "友军 [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.EL_getAllyBonus() + "[/color] 决心，" +
                       "敌军 [color=" + this.Const.UI.Color.NegativeValue + "]-" + this.EL_getEnemyBonus() + "[/color] 决心。" +
                       "光环的效果受到持有者的决心影响。"
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
        //EL_OVERRIDE
        o.EL_getAllyBonus <- function()
        {
            local skill = null;
            if(this.getContainer() != null && this.getContainer().getActor() != null)
            {
                skill = this.getContainer().getActor().getSkills().getSkillByID("el_rarity_entry.proof_of_kingly_way");
            }
            if(skill != null && skill.EL_isUsable())
            {
                return this.Math.floor(this.EL_getCalculateBravery() * this.Const.EL_Rarity_Entry.Factor.EL_ProofOfKinglyWay.BraveryMult);
            }
            return this.Math.floor(this.EL_getCalculateBravery() * (0.1 + 0.05 * this.m.EL_RankLevel));
        }

        o.EL_getEnemyBonus <- function()
        {
            local skill = null;
            if(this.getContainer() != null && this.getContainer().getActor() != null)
            {
                skill = this.getContainer().getActor().getSkills().getSkillByID("el_rarity_entry.proof_of_kingly_way");
            }
            if(skill != null && skill.EL_isUsable())
            {
                return this.Math.floor(this.EL_getCalculateBravery() * this.Const.EL_Rarity_Entry.Factor.EL_ProofOfKinglyWay.BraveryMult);
            }
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
            return this.m.EL_CurrentLevel * this.m.EL_RankLevel * 0.25;
        }

        o.onUpdateProperties <- function( _properties )
        {
            this.weapon.onUpdateProperties(_properties);
            _properties.Bravery += this.EL_getResolveBonus();

        }


    });



});

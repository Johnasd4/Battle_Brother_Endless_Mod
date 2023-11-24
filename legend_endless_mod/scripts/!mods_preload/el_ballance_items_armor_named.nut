local gt = getroottable();

::mods_registerMod("el_ballance_items_armor_named", 1, "el_ballance_items_armor_named");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/armor/named/legend_named_warlock_cloak", function(o){

        o.getTooltip = function()
        {
            local result = this.named_armor.getTooltip();
            result.push({
                id = 9,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase max hitpoints by [color=" + this.Const.UI.Color.PositiveValue + "] +20%[/color]."
            });
            result.push({
                id = 11,
                type = "text",
                icon = "ui/icons/bravery.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve when confident."
            });
            result.push({
                id = 12,
                type = "text",
                icon = "ui/icons/initiative.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Initiative when confident."
            });
            result.push({
                id = 13,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Skill when confident."
            });
            result.push({
                id = 14,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Skill when confident."
            });
            result.push({
                id = 15,
                type = "text",
                icon = "ui/icons/melee_defense.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Defense when confident."
            });
            result.push({
                id = 16,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Defense when confident."
            });
            result.push({
                id = 17,
                type = "text",
                icon = "ui/icons/fatigue.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]-1[/color] Fatigue Cost when confident."
            });
            result.push({
                id = 18,
                type = "text",
                icon = "ui/icons/damage_dealt.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Damage Dealt when confident."
            });
            result.push({
                id = 19,
                type = "text",
                icon = "ui/icons/damage_received.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]-10%[/color] Damage Received when confident."
            });
            return result;
        }

        o.onUpdateProperties = function( _properties )
        {
            this.named_armor.onUpdateProperties(_properties);
            _properties.Hitpoints += this.Math.floor(0.2 * this.getContainer().getActor().getBaseProperties().Hitpoints);

            if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident)
            {
                _properties.Bravery += this.Const.EL_PlayerNPC.EL_Morale.Effect.BraveryOffset[this.Const.MoraleState.Confident];
                _properties.Initiative += this.Const.EL_PlayerNPC.EL_Morale.Effect.InitiativeOffset[this.Const.MoraleState.Confident];
                _properties.MeleeSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeSkillOffset[this.Const.MoraleState.Confident];
                _properties.RangedSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedSkillOffset[this.Const.MoraleState.Confident];
                _properties.MeleeDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeDefenseOffset[this.Const.MoraleState.Confident];
                _properties.RangedDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedDefenseOffset[this.Const.MoraleState.Confident];

                _properties.FatigueOnSkillUse += this.Const.EL_PlayerNPC.EL_Morale.Effect.FatigueOnSkillUseOffset[this.Const.MoraleState.Confident];

                _properties.DamageTotalMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageTotalMult[this.Const.MoraleState.Confident];
                _properties.DamageReceivedTotalMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageReceivedTotalMult[this.Const.MoraleState.Confident];
            }
        }


    });

});

local gt = getroottable();

::mods_registerMod("el_skills_injury_ballance", 1, "el_skills_injury_ballance");
::mods_queue(null, "el_player_npc", function ()
{


	::mods_hookNewObject("skills/injury_permanent/broken_arm_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Resolve"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/xp_received.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Experience Gain"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25[/color] Initiative"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Bravery += 15;
            _properties.XPGainMult *= 0.75;
            _properties.Initiative -= 25;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/broken_elbow_joint_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Melee Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Ranged Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Melee Defense"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 20;
            _properties.RangedSkill -= 20;
            _properties.MeleeDefense -= 30;
            _properties.IsContentWithBeingInReserve = true;
        }

	});


	::mods_hookNewObject("skills/injury_permanent/broken_knee_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40[/color] Melee Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40[/color] Ranged Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40[/color] Initiative"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeDefense -= 40;
            _properties.RangedDefense -= 40;
            _properties.Initiative -= 40;
            _properties.IsContentWithBeingInReserve = true;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/collapsed_lung_part_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40[/color] Fatigue"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Stamina -= 40;
            _properties.IsContentWithBeingInReserve = true;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/legend_burned_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/vision.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] Vision"
                },
                {
                    id = 8,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Reduces the Resolve of any opponent engaged in melee by [color=" + this.Const.UI.Color.NegativeValue + "]-15[/color]"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 10;
            _properties.RangedSkill -= 10;
            _properties.MeleeDefense -= 10;
            _properties.RangedDefense -= 10;
            _properties.Vision -= 1;
            _properties.Threat += 10;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/legend_scarred_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/health.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Hitpoints"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Max Fatigue"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] chance to survive if struck down and not killed by a fatality"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.SurviveWithInjuryChanceMult *= 2.27;
            _properties.HitpointsMult *= 0.9;
            _properties.Stamina -= 10;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/maimed_foot_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/action_points.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] Additional Action Point per tile moved"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Initiative"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MovementAPCostAdditional += 1;
            _properties.Initiative -= 20;
            _properties.IsContentWithBeingInReserve = true;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/missing_ear_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Initiative"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Initiative -= 10;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/missing_eye_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Ranged Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/vision.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Vision"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.RangedSkill -= 50;
            _properties.Vision -= 2;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/missing_finger_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 5;
            _properties.RangedSkill -= 5;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/missing_nose_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Max Fatigue"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Stamina -= 10;
        }

	});

	::mods_hookNewObject("skills/injury_permanent/traumatized_injury", function(o){

        o.getTooltip = function()
        {
            local ret = [
                {
                    id = 1,
                    type = "title",
                    text = this.getName()
                },
                {
                    id = 2,
                    type = "description",
                    text = this.getDescription()
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40[/color] Resolve"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Initiative"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            this.addTooltipHint(ret);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Bravery -= 40;
            _properties.Initiative -= 30;
            _properties.IsContentWithBeingInReserve = true;
        }

	});

});

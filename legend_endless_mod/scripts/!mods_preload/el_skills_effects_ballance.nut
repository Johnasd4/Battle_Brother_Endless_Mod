local gt = getroottable();

::mods_registerMod("el_skills_effects_ballance", 1, "el_skills_effects_ballance");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("skills/effects/bleeding_effect", function(o){

        o.getDescription = function()
        {
            return "This character is bleeding profusely from a recently received wound and will lose [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.ceil(this.m.Damage * this.getContainer().getActor().getBaseProperties().Hitpoints / 100) + "[/color] hitpoints each turn for [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] more turn(s).";
        }

        o.applyDamage = function()
        {
            if (this.m.LastRoundApplied != this.Time.getRound())
            {
                this.m.LastRoundApplied = this.Time.getRound();
                local actor = this.getContainer().getActor();
                this.spawnIcon("status_effect_01", actor.getTile());
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.m.Damage * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0);
                hitInfo.DamageRegular =
                hitInfo.DamageDirect = 1.0;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.BodyDamageMult = 1.0;
                hitInfo.FatalityChanceMult = 0.0;
                actor.onDamageReceived(this.getAttacker(), this, hitInfo);

                if (--this.m.TurnsLeft <= 0)
                {
                    this.removeSelf();
                }
            }
        }

	});

	::mods_hookNewObject("skills/effects/dazed_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25[/color] Max Fatigue"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();

            if (!actor.getCurrentProperties().IsImmuneToDaze)
            {
                _properties.DamageTotalMult *= 0.75;
                _properties.Initiative -= 25;
                _properties.Stamina -= 25;

                if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
                {
                    actor.getSprite("status_stunned").setBrush("bust_dazed");
                    actor.getSprite("status_stunned").Visible = true;
                    actor.setDirty(true);
                }
            }
            else
            {
                this.removeSelf();
            }
        }

	});

	::mods_hookNewObject("skills/effects/distracted_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.DamageTotalMult *= 0.65;
            _properties.Initiative -= 35;

            if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
            {
                actor.getSprite("status_stunned").setBrush("bust_distracted");
                actor.getSprite("status_stunned").Visible = true;
                actor.setDirty(true);
            }
        }

	});

	::mods_hookNewObject("skills/effects/insect_swarm_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Ranged Skill"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Melee Defense"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Ranged Defense"
                },
                {
                    id = 14,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 50;
            _properties.RangedSkill -= 50;
            _properties.MeleeDefense -= 50;
            _properties.RangedDefense -= 50;
            _properties.Initiative -= 50;
        }

	});

	::mods_hookNewObject("skills/effects/legend_apothecary_mushrooms_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 10 * this.m.TurnsLeft + "%[/color] Damage in Melee"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 10 * this.m.TurnsLeft + "[/color] Melee Defense"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 10 * this.m.TurnsLeft + "[/color] Ranged Defense"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/morale.png",
                    text = "No morale check triggered upon losing hitpoints"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeDefense += 10 * this.m.TurnsLeft;
            _properties.RangedDefense += 10 * this.m.TurnsLeft;
        }

	});

	::mods_hookNewObject("skills/effects/legend_baffled_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Max Fatigue"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.DamageTotalMult *= 0.85;
            _properties.Initiative -= 15;
            _properties.Stamina -= 15;

            if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
            {
                actor.getSprite("status_stunned").setBrush("bust_dazed");
                actor.getSprite("status_stunned").Visible = true;
                actor.setDirty(true);
            }
        }

	});

	::mods_hookNewObject("skills/effects/legend_beer_buzz_effect", function(o){

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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Resolve"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Ranged Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-6[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-6[/color] Ranged Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-12[/color] Initiative"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Bravery += 3;
            _properties.MeleeSkill += 3;
            _properties.RangedSkill += 3;
            _properties.MeleeDefense -= 6;
            _properties.RangedDefense -= 6;
            _properties.Initiative -= 12;
        }

	});

	::mods_hookNewObject("skills/effects/legend_dazed_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Max Fatigue"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.DamageTotalMult *= 0.5;
            _properties.Initiative -= 50;
            _properties.Stamina -= 50;

            if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
            {
                actor.getSprite("status_stunned").setBrush("bust_dazed");
                actor.getSprite("status_stunned").Visible = true;
                actor.setDirty(true);
            }
        }

	});


	::mods_hookNewObject("skills/effects/legend_demon_hound_aura_effect", function(o){

        o.getTooltip = function()
        {
            local penalty = this.m.Penalty;
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty * 100 + "[/color] Initative"
                }
            ];
        }

        o.onAfterUpdate = function( _properties )
        {
            local penalty = this.getPenalty(_properties);

            if (penalty == 0)
            {
                return;
            }

            _properties.Initiative -= penalty;
            this.m.Penalty = penalty;
            this.m.IsHidden = false;
        }

	});

	::mods_hookNewObject("skills/effects/legend_grappled_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Fatigue recovered per turn"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Maximum Fatigue"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Melee Defense"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.Stamina -= 50;
            _properties.MeleeDefense -= 50;
            _properties.FatigueRecoveryRate -= 20;

            if (!actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
            {
                actor.getSprite("status_stunned").setBrush("bust_dazed");
                actor.getSprite("status_stunned").Visible = true;
                actor.setDirty(true);
            }
        }

	});

	::mods_hookNewObject("skills/effects/legend_mead_warmth_effect", function(o){

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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+9[/color] Resolve"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+9[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+9[/color] Ranged Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-18[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-18[/color] Ranged Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-36[/color] Initiative"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Bravery += 9;
            _properties.MeleeSkill += 9;
            _properties.RangedSkill += 9;
            _properties.MeleeDefense -= 18;
            _properties.RangedDefense -= 18;
            _properties.Initiative -= 36;
        }

	});

	::mods_hookNewObject("skills/effects/legend_motivated_effect", function(o){

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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Damage"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Resolve"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeDamageMult *= 1.1;
            _properties.MeleeSkill += 5;
            _properties.RangedSkill += 5;
            _properties.Bravery += 15;
        }

	});


	::mods_hookNewObject("skills/effects/legend_transformed_bear_effect", function(o){

        o.getTooltip = function()
        {
            local ret = this.legend_transformed_effect.getTooltip();
            local actor = this.getContainer().getActor();
            ret.extend([
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/health.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(200 * (1 + actor.getCurrentProperties().EL_getCombatLevel() * 0.04)) + "[/color] hitpoints"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] Melee Defense"
                }
            ]);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Hitpoints += this.Math.floor(200 * (1 + _properties.EL_CombatLevel * 0.04));
            _properties.MeleeDefense += 50;
        }

	});

	::mods_hookNewObject("skills/effects/legend_transformed_boar_effect", function(o){

        o.getTooltip = function()
        {
            local ret = this.legend_transformed_effect.getTooltip();
            local actor = this.getContainer().getActor();
            ret.extend([
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/health.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(100 * (1 + actor.getCurrentProperties().EL_getCombatLevel() * 0.04)) + "[/color] hitpoints"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(100 * (1 + actor.getCurrentProperties().EL_getCombatLevel() * 0.04)) + "[/color] Maximum Fatigue"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/health.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] stamina recovery rate"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25[/color] Resolve"
                }
            ]);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.FatigueRecoveryRateMult *= 2.0;
            _properties.Stamina += 100 * (1 + _properties.EL_CombatLevel * 0.04)
            _properties.Hitpoints += 100 * (1 + _properties.EL_CombatLevel * 0.04)
            _properties.Bravery += 25;
        }

	});

	::mods_hookNewObject("skills/effects/legend_transformed_rat_effect", function(o){

        o.getTooltip = function()
        {
            local ret = this.legend_transformed_effect.getTooltip();
            local actor = this.getContainer().getActor();
            ret.extend([
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] action points"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Poison bite"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Resolve"
                }
            ]);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.ActionPoints += 3;
            _properties.Bravery -= 50;
        }

	});

	::mods_hookNewObject("skills/effects/legend_transformed_wolf_effect", function(o){

        o.getTooltip = function()
        {
            local ret = this.legend_transformed_effect.getTooltip();
            local actor = this.getContainer().getActor();
            ret.extend([
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]-1[/color] AP per tile moved"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]-50[/color] fatigue cost per tile moved"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/health.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(100 * (1 + actor.getCurrentProperties().EL_getCombatLevel() * 0.04)) + "[/color] hitpoints"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100[/color] Melee Defense"
                }
            ]);
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MovementAPCostAdditional += -1;
            _properties.MovementFatigueCostMult *= 0.5;
            _properties.Hitpoints += 100 * (1 + _properties.EL_CombatLevel * 0.04)
            _properties.MeleeDefense += 100;
        }

	});

	::mods_hookNewObject("skills/effects/legend_wine_tipsy_effect", function(o){

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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+6[/color] Resolve"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+6[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+6[/color] Ranged Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-12[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-12[/color] Ranged Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-24[/color] Initiative"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Bravery += 6;
            _properties.MeleeSkill += 6;
            _properties.RangedSkill += 6;
            _properties.MeleeDefense -= 12;
            _properties.RangedDefense -= 12;
            _properties.Initiative -= 24;
        }

	});

	::mods_hookNewObject("skills/effects/lone_wolf_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Melee Skill"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Ranged Skill"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Melee Defense"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Ranged Defense"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Resolve"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                this.m.IsHidden = true;
                return;
            }

            local actor = this.getContainer().getActor();
            local myTile = actor.getTile();
            local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
            local isAlone = true;

            foreach( ally in allies )
            {
                if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
                {
                    continue;
                }

                if (ally.getTile().getDistanceTo(myTile) <= 2)
                {
                    isAlone = false;
                    break;
                }
            }

            if (isAlone)
            {
                this.m.IsHidden = false;
                _properties.MeleeSkill += 15;
                _properties.RangedSkill += 15;
                _properties.MeleeDefense += 15;
                _properties.RangedDefense += 15;
                _properties.Bravery += 15;
            }
            else
            {
                this.m.IsHidden = true;
            }
        }

	});

	::mods_hookNewObject("skills/effects/net_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 9,
                    type = "text",
                    icon = "ui/icons/action_points.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Unable to move[/color]"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45[/color] Ranged Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.IsRooted = true;
            _properties.MeleeDefense -= 45;
            _properties.RangedDefense -= 45;
            _properties.Initiative -= 45;
        }

	});

	::mods_hookNewObject("skills/effects/overwhelmed_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 5 + "[/color] Melee Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 5 + "[/color] Ranged Skill"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 5 * this.m.Count;
            _properties.RangedSkill -= 5 * this.m.Count;
        }

	});

	::mods_hookNewObject("skills/effects/ptr_arrow_to_the_knee_debuff_effect", function(o){

        o.getTooltip = function()
        {
            local tooltip = this.skill.getTooltip();
            local defenseMalus = this.m.TurnsLeft * this.m.DefMalusPercentagePerTurnLeft;
            local APMalus = this.m.TurnsLeft * this.m.MovementAPCostAdditionalPerTurnLeft;
            tooltip.extend(
                [
                    {
                        id = 10,
                        type = "text",
                        icon = "ui/icons/melee_defense.png",
                        text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + defenseMalus + "[/color] Melee Defense"
                    },
                    {
                        id = 10,
                        type = "text",
                        icon = "ui/icons/ranged_defense.png",
                        text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + defenseMalus + "[/color] Ranged Defense"
                    },
                    {
                        id = 10,
                        type = "text",
                        icon = "ui/icons/action_points.png",
                        text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + APMalus + "[/color] additional Action Points per tile moved"
                    },
                    {
                        id = 10,
                        type = "text",
                        icon = "ui/icons/action_points.png",
                        text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turns remaining. This effect will reduce in intensity with fewer turns remaining."
                    }
                ]
            );

            return tooltip;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeDefense -= this.m.TurnsLeft * this.m.DefMalusPercentagePerTurnLeft;
            _properties.RangedDefense -= this.m.TurnsLeft * this.m.DefMalusPercentagePerTurnLeft;
            _properties.MovementAPCostAdditional += this.m.TurnsLeft * this.m.MovementAPCostAdditionalPerTurnLeft;
        }

	});

	::mods_hookNewObject("skills/effects/ptr_sweeping_strikes_debuff_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Malus + "[/color] Melee Skill"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= this.m.Malus;
        }

	});

	::mods_hookNewObject("skills/effects/rooted_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 9,
                    type = "text",
                    icon = "ui/icons/action_points.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Unable to move[/color]"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35[/color] Ranged Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.IsRooted = true;
            _properties.MeleeDefense -= 35;
            _properties.RangedDefense -= 35;
            _properties.Initiative -= 35;
        }

	});

	::mods_hookNewObject("skills/effects/shellshocked_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Initiative"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Resolve"
                },
                {
                    id = 14,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Melee Skill"
                },
                {
                    id = 15,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Ranged Skill"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Melee Defense"
                },
                {
                    id = 17,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "[/color] Ranged Defense"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.DamageTotalMult *= 1.0 - 0.05 * this.m.TurnsLeft;
            _properties.Initiative -= 5 * this.m.TurnsLeft;
            _properties.Bravery -= 5 * this.m.TurnsLeft;
            _properties.MeleeSkill -= 5 * this.m.TurnsLeft;
            _properties.RangedSkill -= 5 * this.m.TurnsLeft;
            _properties.MeleeDefense -= 5 * this.m.TurnsLeft;
            _properties.RangedDefense -= 5 * this.m.TurnsLeft;
        }

	});

	::mods_hookNewObject("skills/effects/smoke_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Ranged Skill"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100[/color] Ranged Defense"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Not affected by Zones of Control"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local tile = this.getContainer().getActor().getTile();

            if (tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
            {
                this.removeSelf();
            }
            else
            {
                _properties.RangedSkill -= 50;
                _properties.RangedDefense += 100;
            }
        }

	});

	::mods_hookNewObject("skills/effects/staggered_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.Initiative -= 50;
        }

	});

	::mods_hookNewObject("skills/effects/str_covering_ally_effect", function(o){

        o.getTooltip = function()
        {
            local tooltip = this.skill.getTooltip();

            tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/melee_defense.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SelfDefenseMalusPercentage + "[/color] Melee Defense"
            });

            tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SelfDefenseMalusPercentage + "[/color] Ranged Defense"
            });

            tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SelfSkillMalusPercentage + "[/color] Melee Skill"
            });

            tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.SelfSkillMalusPercentage + "[/color] Ranged Skill"
            });

            return tooltip;
        }

        o.onUpdate = function( _properties )
        {
            if (this.m.Ally == null || this.m.Ally.isNull() || !this.m.Ally.isPlacedOnMap() || this.m.Ally.getFlags().get("Devoured") == true)
            {
                this.removeSelf();
                return;
            }

            local actor = this.getContainer().getActor();
            if (actor.m.IsMoving)
            {
                this.removeSelf();
            }

            local isCoverStillValid = true;
            if (actor.getCurrentProperties().IsRooted || actor.getCurrentProperties().IsStunned || actor.getFlags().get("Devoured") == true || !actor.isArmedWithShield())
            {
                isCoverStillValid = false;
            }

            if (actor.getTile().getDistanceTo(this.m.Ally.getTile()) > 1)
            {
                isCoverStillValid = false;
            }

            if (!isCoverStillValid)
            {
                if (!this.getContainer().getActor().isHiddenToPlayer())
                {
                    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " is no longer providing cover to " + this.Const.UI.getColorizedEntityName(this.m.Ally));
                }
                this.removeSelf();
                this.onRemoved();
                return;
            }
            local skillMalus = this.m.SelfSkillMalusPercentage;
            local defMalus = this.m.SelfDefenseMalusPercentage;
            _properties.MeleeDefense -= defMalus;
            _properties.RangedDefense -= defMalus;
            _properties.MeleeSkill -= skillMalus;
            _properties.RangedSkill -= skillMalus;
        }

	});


	::mods_hookNewObject("skills/effects/web_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 9,
                    type = "text",
                    icon = "ui/icons/action_points.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Unable to move[/color]"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/direct_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Twice as much damage received by a Webknecht\'s attack will ignore armor[/color]"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Damage"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Melee Defense"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Ranged Defense"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.IsRooted = true;
            _properties.DamageTotalMult *= 0.5;
            _properties.MeleeDefense -= 50;
            _properties.RangedDefense -= 50;
            _properties.Initiative -= 50;
            _properties.TargetAttractionMult *= 1.5;
        }

	});

	::mods_hookNewObject("skills/effects/whipped_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 24 + "[/color] Melee Skill"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 28 + "[/color] Ranged Skill"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 10 + "[/color] Resolve"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 18 + "[/color] Initiative"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 10 + "[/color] Melee Defense"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 10 + "[/color] Ranged Defense"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill += 24;
            _properties.RangedSkill += 28;
            _properties.Bravery -= 10;
            _properties.MeleeDefense += 10;
            _properties.RangedDefense += 10;
            _properties.Initiative += 18;
            local actor = this.getContainer().getActor();
            actor.getSprite("status_sweat").setBrush(this.m.TurnsLeft > 1 ? "bust_slave_whipped" : "bust_slave_whipped_expiring");
            actor.setDirty(true);
        }

	});

	::mods_hookNewObject("skills/effects/withered_effect", function(o){

        o.getTooltip = function()
        {
            return [
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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/regular_damage.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.TurnsLeft * 10 + "%[/color] Damage"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.TurnsLeft * 10 + "[/color] Initiative"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.TurnsLeft * 10 + "[/color] Max Fatigue"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/fatigue.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.TurnsLeft * 5 + "[/color] Fatigue Recovery per turn"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            local actor = this.getContainer().getActor();
            _properties.DamageTotalMult *= 1.0 - this.m.TurnsLeft * 0.1;
            _properties.Initiative -= this.m.TurnsLeft * 10;
            _properties.Stamina -= this.m.TurnsLeft * 10;
            _properties.FatigueRecoveryRate -= this.m.TurnsLeft * 5;

            if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
            {
                actor.getSprite("status_stunned").setBrush("bust_withered");
                actor.getSprite("status_stunned").Visible = true;
                actor.setDirty(true);
            }
        }

	});

});

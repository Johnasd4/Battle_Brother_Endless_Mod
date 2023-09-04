local gt = getroottable();

::mods_registerMod("el_skills_traits_ballance", 1, "el_skills_traits_ballance");
::mods_queue(null, "el_player_npc", function ()
{


	::mods_hookNewObject("skills/traits/addict_trait", function(o){

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
                }
            ];
            local time = 0.0;

            if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
            {
                time = this.World.State.getCombatStartTime();
            }
            else
            {
                time = this.Time.getVirtualTimeF();
            }

            local isAffected = time - this.getContainer().getActor().getFlags().get("PotionLastUsed") >= 5.0 * this.World.getTime().SecondsPerDay;

            if (isAffected)
            {
                ret.push({
                    id = 11,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve"
                });
                ret.push({
                    id = 12,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Skill"
                });
                ret.push({
                    id = 13,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Skill"
                });
                ret.push({
                    id = 14,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Defense"
                });
                ret.push({
                    id = 15,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Defense"
                });
            }
            else
            {
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Currently no effect because drugs were consumed within the last 5 days"
                });
            }

            return ret;
        }

        o.onUpdate = function( _properties )
        {
            local time = 0.0;

            if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
            {
                time = this.World.State.getCombatStartTime();
            }
            else
            {
                time = this.Time.getVirtualTimeF();
            }

            local isAffected = time - this.getContainer().getActor().getFlags().get("PotionLastUsed") >= 7.0 * this.World.getTime().SecondsPerDay;

            if (isAffected)
            {
                _properties.Bravery -= 10;
                _properties.MeleeSkill -= 10;
                _properties.RangedSkill -= 10;
                _properties.MeleeDefense -= 10;
                _properties.RangedDefense -= 10;
            }
        }

	});


	::mods_hookNewObject("skills/traits/fear_beasts_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve when in battle with beasts"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill when in battle with beasts"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill when in battle with beasts"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingBeasts = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Beasts || enemy.getType() == this.Const.EntityType.BarbarianUnhold || enemy.getType() == this.Const.EntityType.BarbarianUnholdFrost)
                {
                    fightingBeasts = true;
                    break;
                }
            }

            if (fightingBeasts)
            {
                _properties.Bravery -= 10;
                _properties.MeleeSkill -= 5;
                _properties.RangedSkill -= 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/fear_greenskins_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve when in battle with greenskins"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill when in battle with greenskins"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill when in battle with greenskins"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingGreenskins = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Orcs || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Goblins)
                {
                    fightingGreenskins = true;
                    break;
                }
            }

            if (fightingGreenskins)
            {
                _properties.Bravery -= 10;
                _properties.MeleeSkill -= 5;
                _properties.RangedSkill -= 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/fear_nobles_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve when in battle with nobles"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill when in battle with nobles"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill when in battle with nobles"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.NobleHouse).getID()) != 0)
            {
                _properties.Bravery -= 10;
                _properties.MeleeSkill -= 5;
                _properties.RangedSkill -= 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/fear_undead_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve when in battle with undead"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill when in battle with undead"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill when in battle with undead"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingUndead = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Undead)
                {
                    fightingUndead = true;
                    break;
                }
            }

            if (fightingUndead)
            {
                _properties.Bravery -= 10;
                _properties.MeleeSkill -= 5;
                _properties.RangedSkill -= 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/hate_beasts_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve when in battle with beasts"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill when in battle with beasts"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill when in battle with beasts"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingBeasts = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Beasts || enemy.getType() == this.Const.EntityType.BarbarianUnhold || enemy.getType() == this.Const.EntityType.BarbarianUnholdFrost)
                {
                    fightingBeasts = true;
                    break;
                }
            }

            if (fightingBeasts)
            {
                _properties.Bravery += 10;
                _properties.MeleeSkill += 5;
                _properties.RangedSkill += 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/hate_greenskins_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve when in battle with greenskins"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill when in battle with greenskins"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill when in battle with greenskins"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingGreenskins = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Orcs || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Goblins)
                {
                    fightingGreenskins = true;
                    break;
                }
            }

            if (fightingGreenskins)
            {
                _properties.Bravery += 10;
                _properties.MeleeSkill += 5;
                _properties.RangedSkill += 5;
            }
        }

	});


	::mods_hookNewObject("skills/traits/hate_nobles_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve when in a battle against nobles"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill when in a battle against nobles"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill when in a battle against nobles"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.NobleHouse).getID()) != 0)
            {
                _properties.Bravery += 10;
                _properties.MeleeSkill += 5;
                _properties.RangedSkill += 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/hate_undead_trait", function(o){

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
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve when in battle with undead"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill when in battle with undead"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill when in battle with undead"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (!this.getContainer().getActor().isPlacedOnMap())
            {
                return;
            }

            local fightingUndead = false;
            local enemies = this.Tactical.Entities.getAllHostilesAsArray();

            foreach( enemy in enemies )
            {
                if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Undead)
                {
                    fightingUndead = true;
                    break;
                }
            }

            if (fightingUndead)
            {
                _properties.Bravery += 10;
                _properties.MeleeSkill += 5;
                _properties.RangedSkill += 5;
            }
        }

	});

	::mods_hookNewObject("skills/traits/legend_prosthetic_eye", function(o){

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
                    id = 11,
                    type = "text",
                    icon = "ui/icons/vision.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Vision"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/bravery.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+7[/color] Resolve"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.RangedSkill -= 50;
            _properties.Vision -= 2;
            _properties.Bravery += 7;
        }

	});

	::mods_hookNewObject("skills/traits/legend_prosthetic_finger", function(o){

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
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Melee Skill"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Ranged Skill"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 2;
            _properties.RangedSkill -= 2;
        }

	});

	::mods_hookNewObject("skills/traits/legend_prosthetic_foot", function(o){

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
                    icon = "ui/icons/special.png",
                    text = "Builds up [color=" + this.Const.UI.Color.NegativeValue + "]3[/color] more fatigue for each tile travelled"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MovementFatigueCostAdditional += 3;
            _properties.Initiative -= 10;
        }

	});


	::mods_hookNewObject("skills/traits/legend_prosthetic_forearm", function(o){

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
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Melee Defense"
                },
                {
                    id = 16,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Is always content with being in reserve"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeSkill -= 10;
            _properties.RangedSkill -= 10;
            _properties.MeleeDefense -= 15;
        }

	});

	::mods_hookNewObject("skills/traits/legend_prosthetic_hand", function(o){

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
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Defense when using a shield"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Defense when using a shield"
                },
                {
                    id = 12,
                    type = "text",
                    icon = "ui/icons/melee_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Skill when NOT using a shield"
                },
                {
                    id = 13,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Skill when NOT using a shield"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (this.newhandShield())
            {
                _properties.MeleeDefense -= 10;
                _properties.RangedDefense -= 10;
            }

            if (!this.newhandShield())
            {
                _properties.MeleeSkill -= 10;
                _properties.RangedSkill -= 10;
            }
        }

	});

	::mods_hookNewObject("skills/traits/legend_prosthetic_leg", function(o){

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
                    id = 7,
                    type = "text",
                    icon = "ui/icons/melee_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Melee Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Ranged Defense"
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/initiative.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Initiative"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.MeleeDefense -= 15;
            _properties.RangedDefense -= 15;
            _properties.Initiative -= 20;
        }

	});


	::mods_hookNewObject("skills/traits/legend_prosthetic_nose", function(o){

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
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Max Fatigue"
                }
            ];
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            _properties.Stamina -= 5;
        }

	});

	::mods_hookNewObject("skills/traits/night_owl_trait", function(o){

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
                    icon = "ui/icons/vision.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Vision during Night time"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Ranged Skill during Night time"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_defense.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Ranged Defense during Night time"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            if (this.getContainer().hasSkill("special.night") && _properties.IsAffectedByNight == true)
            {
                _properties.Vision += 1;
                _properties.RangedSkill += 15;
                _properties.RangedDefense += 15;
            }
        }

	});

	::mods_hookNewObject("skills/traits/pragmatic_trait", function(o){

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
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill"
                },
                {
                    id = 10,
                    type = "text",
                    icon = "ui/icons/ranged_skill.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill"
                },
                {
                    id = 11,
                    type = "text",
                    icon = "ui/icons/chance_to_hit_head.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Chance To Hit Head"
                }
            ];
        }

        o.onUpdate = function( _properties )
        {
            _properties.HitChance[this.Const.BodyPart.Head] -= 20;
            _properties.MeleeSkill += 5;
            _properties.RangedSkill += 5;
        }

	});

	::mods_hookNewObject("skills/traits/teamplayer_trait", function(o){

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
                    icon = "ui/icons/special.png",
                    text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] lower chance to inflict friendly fire"
                }
            ];
        }

        function onAnySkillUsed( _skill, _targetEntity, _properties )
        {
            if (_skill.isAttack() && _targetEntity != null && _targetEntity.getID() != this.getContainer().getActor().getID() && _targetEntity.getFaction() == this.getContainer().getActor().getFaction())
            {
                _properties.MeleeSkill -= 50;
                _properties.RangedSkill -= 50;
            }
        }

	});

});

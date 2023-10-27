local gt = getroottable();

::mods_registerMod("el_ballance_skills_special", 1, "el_ballance_skills_special");
::mods_queue(null, "el_player_npc", function ()
{


	::mods_hookExactClass("skills/special/legend_rain_effect", function(o){

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
            ret.push({
                id = 11,
                type = "text",
                icon = "ui/icons/vision.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] Vision"
            });
            ret.push({
                id = 12,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Skill"
            });
            ret.push({
                id = 12,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Defense"
            });
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            if (_properties.IsAffectedByRain)
            {
                _properties.Vision -= 1;
                _properties.RangedSkill -= 10;
                _properties.RangedDefense += 10;
            }
        }

	});

	::mods_hookExactClass("skills/special/morale_check", function( o )
	{
		o.onUpdate = function(_properties) {
			this.m.IsHidden = this.m.Container.getActor().getMoraleState() == this.Const.MoraleState.Steady;
			this.m.Name = this.Const.MoraleStateName[this.m.Container.getActor().getMoraleState()];
			local state = this.m.Container.getActor().getMoraleState();
			_properties.Bravery += this.Const.EL_PlayerNPC.EL_Morale.Effect.BraveryOffset[state];
			_properties.Initiative += this.Const.EL_PlayerNPC.EL_Morale.Effect.InitiativeOffset[state];
			_properties.MeleeSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeSkillOffset[state];
			_properties.RangedSkill += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedSkillOffset[state];
			_properties.MeleeDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.MeleeDefenseOffset[state];
			_properties.RangedDefense += this.Const.EL_PlayerNPC.EL_Morale.Effect.RangedDefenseOffset[state];

			_properties.FatigueOnSkillUse += this.Const.EL_PlayerNPC.EL_Morale.Effect.FatigueOnSkillUseOffset[state];

			_properties.DamageDirectMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageDirectMult[state];
			_properties.DamageReceivedTotalMult *= this.Const.EL_PlayerNPC.EL_Morale.Effect.DamageReceivedTotalMult[state];
			switch(state)
			{
			case this.Const.MoraleState.Confident:
				this.m.Icon = "skills/status_effect_14.png";
				this.m.IconMini = "status_effect_14_mini";
				break;

			case this.Const.MoraleState.Wavering:
				this.m.Icon = "skills/status_effect_02_c.png";
				this.m.IconMini = "status_effect_02_c_mini";
				break;

			case this.Const.MoraleState.Breaking:
				this.m.Icon = "skills/status_effect_02_b.png";
				this.m.IconMini = "status_effect_02_b_mini";
				break;

			case this.Const.MoraleState.Fleeing:
				this.m.Icon = "skills/status_effect_02_a.png";
				this.m.IconMini = "status_effect_02_a_mini";
				break;

			case this.Const.MoraleState.Ignore:
				this.m.Icon = "";
				this.m.IconMini = "";
				this.m.Name = "";
				this.m.IsHidden = true;
				break;
			}
		}

		o.getTooltip = function()
		{
			switch(this.m.Container.getActor().getMoraleState())
			{
			case this.Const.MoraleState.Confident:
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = "We\'ll be victorious! This character is confident that victory will be his."
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Initiative"
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Skill"
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Skill"
					},
					{
						id = 15,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Defense"
					},
					{
						id = 16,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Defense"
					},
					{
						id = 17,
						type = "text",
						icon = "ui/icons/fatigue.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]-21[/color] Fatigue Cost"
					},
					{
						id = 18,
						type = "text",
						icon = "ui/icons/damage_dealt.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Damage Dealt"
					},
					{
						id = 19,
						type = "text",
						icon = "ui/icons/damage_received.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]-10%[/color] Damage Received"
					}
				];
				return ret;

			case this.Const.MoraleState.Wavering:
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = "Uh oh. This character is wavering and unsure if the battle will turn out to his advantage."
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Initiative"
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Skill"
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Skill"
					},
					{
						id = 15,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Defense"
					},
					{
						id = 16,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Defense"
					},
					{
						id = 17,
						type = "text",
						icon = "ui/icons/fatigue.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+1[/color] Fatigue Cost"
					},
					{
						id = 18,
						type = "text",
						icon = "ui/icons/damage_dealt.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Damage Dealt"
					},
					{
						id = 19,
						type = "text",
						icon = "ui/icons/damage_received.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+10%[/color] Damage Received"
					}
				];
				return ret;

			case this.Const.MoraleState.Breaking:
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = "We can\'t win this! This character\'s morale is breaking and he is close to fleeing the battlefield."
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Resolve"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Initiative"
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-320[/color] Melee Skill"
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Ranged Skill"
					},
					{
						id = 15,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Melee Defense"
					},
					{
						id = 16,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Ranged Defense"
					},
					{
						id = 17,
						type = "text",
						icon = "ui/icons/fatigue.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+2[/color] Fatigue Cost"
					},
					{
						id = 18,
						type = "text",
						icon = "ui/icons/damage_dealt.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Damage Dealt"
					},
					{
						id = 19,
						type = "text",
						icon = "ui/icons/damage_received.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+20%[/color] Damage Received"
					}
				];
				return ret;

			case this.Const.MoraleState.Fleeing:
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = "Run for your lives! This character has lost it and is fleeing the battlefield in panic."
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Resolve"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Initiative"
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Melee Skill"
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Ranged Skill"
					},
					{
						id = 15,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Melee Defense"
					},
					{
						id = 16,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Ranged Defense"
					},
					{
						id = 17,
						type = "text",
						icon = "ui/icons/fatigue.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+3[/color] Fatigue Cost"
					},
					{
						id = 18,
						type = "text",
						icon = "ui/icons/damage_dealt.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] Damage Dealt"
					},
					{
						id = 19,
						type = "text",
						icon = "ui/icons/damage_received.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]+30%[/color] Damage Received"
					}
					{
						id = 16,
						type = "text",
						icon = "ui/icons/special.png",
						text = "Acts at the end of the round"
					}
				];
				return ret;
			}
		}

	});

	::mods_hookExactClass("skills/special/night_effect", function(o){

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
            ret.push({
                id = 11,
                type = "text",
                icon = "ui/icons/vision.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Vision"
            });
            ret.push({
                id = 12,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Ranged Skill"
            });
            ret.push({
                id = 13,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Ranged Defense"
            });
            return ret;
        }

        o.onUpdate = function( _properties )
        {
            this.m.IsHidden = !_properties.IsAffectedByNight;

            if (_properties.IsAffectedByNight && !this.getContainer().hasSkill("trait.night_owl"))
            {
                _properties.Vision -= 2;
                _properties.RangedSkill -= 30;
                _properties.RangedDefense -= 30;
            }

            if (_properties.IsAffectedByNight && this.getContainer().hasSkill("trait.night_owl"))
            {
                _properties.Vision -= 1;
                _properties.RangedSkill -= 15;
                _properties.RangedDefense -= 15;
            }
        }

	});







});

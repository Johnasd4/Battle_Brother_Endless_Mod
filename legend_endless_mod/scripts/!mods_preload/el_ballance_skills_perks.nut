local gt = getroottable();

::mods_registerMod("el_ballance_skills_perks", 1, "el_ballance_skills_perks");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/perks/perk_anticipation", function ( o )
	{

		o.getDescription <- function()
		{
			return "By watching your opponent/\'s aim, you have more time to react.\n\nWhen being attacked with ranged weapons, gain [color=" + this.Const.UI.Color.PositiveValue + "]+5 Ranged Defense[/color] as additional Ranged Defense per tile that the attacker is away, and always at least [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] to Ranged Defense.";
		}

		o.onBeingAttacked = function( _attacker, _skill, _properties )
		{
			local actor = this.getContainer().getActor();
            if(actor != null && !actor.isDying() && actor.isAlive()) {
				local dist = _attacker.getTile().getDistanceTo(actor.getTile());
				_properties.RangedDefense += this.Math.max(10, this.Math.floor(dist * 5));
            }

		}
	});

	::mods_hookExactClass("skills/perks/perk_battle_forged", function ( o )
	{

		o.getReductionPercentage = function()
		{
			local armor = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) + this.getContainer().getActor().getArmor(this.Const.BodyPart.Body);
			return this.Math.floor((1 - 100/(100 + armor * 0.05)) * 10000) * 0.01;
		}

	});

	::mods_hookExactClass("skills/perks/perk_colossus", function ( o )
	{

		o.getDescription <- function()
		{
			return "Bring it on! Hitpoints are increased by [color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color], which also reduces the chance to sustain debilitating injuries when being hit.";
		}


		o.onUpdate = function( _properties )
		{
			_properties.Hitpoints += this.Math.floor(0.25 * this.getContainer().getActor().getBaseProperties().Hitpoints);
		}

	});

	::mods_hookExactClass("skills/perks/perk_fortified_mind", function ( o )
	{

		o.getDescription <- function()
		{
			return "An iron will is not swayed from the true path easily. Resolve is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color].";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 15;
		}

	});

	::mods_hookExactClass("skills/perks/perk_horse_hippology", function ( o )
	{

		o.getDescription <- function()
		{
			return "Knowledge of horse physiology allows for better diet, exercise and care. Increases hitpoints by +25%";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Hitpoints += this.Math.floor(0.25 * this.getContainer().getActor().getBaseProperties().Hitpoints);
		}

	});

	::mods_hookExactClass("skills/perks/perk_horse_impulsion", function ( o )
	{

		o.getDescription <- function()
		{
			return "Effective leverage of equestrian physiology relaxes the spinal column and allows the hindquarters to engage effectively. Increases Initiative by +30";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Initiative += 30;
		}

	});

	::mods_hookExactClass("skills/perks/perk_horse_leg_control", function ( o )
	{

		o.getDescription <- function()
		{
			return "it is not possible to hold the reins while firing a bow. Horse and rider must learn to communicate through the rider\'s legs. Increases ranged attack in battle by +25";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 25;
		}

	});

	::mods_hookExactClass("skills/perks/perk_horse_longeing", function ( o )
	{

		o.getDescription <- function()
		{
			return "Time spent working on a long rope helps build trust between horse and rider. Increases resolve by +15";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 15;
		}

	});

	::mods_hookExactClass("skills/perks/perk_horse_tempi_change", function ( o )
	{

		o.getDescription <- function()
		{
			return "the most challenging form of lead change, a tempi change requires shifting back and forth between lead legs. This form of training can allow the horse to change lead leg according to the situation, useful when under fire. Increases ranged defense by +25";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 25;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_alert", function ( o )
	{

		o.getDescription <- function()
		{
			return "Pay close attention at all times, surveying the surroundings and assessing every clue for an insight. Gain [color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Initiative.";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Initiative += 30;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_ammo_binding", function ( o )
	{

		o.getDescription <- function()
		{
			return "Expertise in making ammunition lets you strip it down to pack the parts for storage, it also lets you draw out arrows faster. Increases maximum ammunition storage by [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] and Ranged skill by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color].";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 5;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_ammo_bundles", function ( o )
	{

		o.getDescription <- function()
		{
			return "Using blankets and ropes to group large bundles of ammunition together you are able to carry far more. These bundles can also be used to shield yourself from enemy fire. Increases maximum ammunition storage by [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] and Ranged Defense by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 5;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_assured_conquest", function ( o )
	{

		o.getDescription <- function()
		{
			return "Your confidence affects your performance. Gain [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] melee skill, ranged skill, melee defense and ranged defense when at confident morale. This bonuses reduces as your morale state decreases. [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]at Steady, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] when breaking and [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] when fleeing.";
		}

		o.onUpdate = function( _properties )
		{
			if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident)
			{
				_properties.RangedSkill += 10;
				_properties.MeleeSkill += 10;
				_properties.MeleeDefense += 10;
				_properties.RangedDefense += 10;
			}

			if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Steady)
			{
				_properties.RangedSkill += 5;
				_properties.MeleeSkill += 5;
				_properties.MeleeDefense += 5;
				_properties.RangedDefense += 5;
			}

			if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Breaking)
			{
				_properties.RangedSkill -= 5;
				_properties.MeleeSkill -= 5;
				_properties.MeleeDefense -= 5;
				_properties.RangedDefense -= 5;
			}

			if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				_properties.RangedSkill -= 10;
				_properties.MeleeSkill -= 10;
				_properties.MeleeDefense -= 10;
				_properties.RangedDefense -= 10;
			}
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_balance", function ( o )
	{

		o.getBonus = function()
		{
			local actor = this.getContainer().getActor();
			local bodyitem = actor.getBodyItem();

			if (bodyitem == null)
			{
				return 0;
			}

			local armorFatPen = actor.getItems().getStaminaModifier([
				::Const.ItemSlot.Body,
				::Const.ItemSlot.Head
			]) * -1;
			armorFatPen /= (1 + actor.EL_getCombatLevel() * 0.04);
			local bonus = this.m.BonusMax - this.Math.abs(armorFatPen - 35) / 2;
			local currIni = actor.getInitiative();

			if (currIni < armorFatPen * 2)
			{
				bonus = bonus - (armorFatPen * 2 - currIni) / 10;
			}

			return this.Math.max(this.m.BonusMin, bonus);
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_bloodbath", function ( o )
	{

		o.getTooltip = function()
		{
			local bleeders = this.getBleeders();
			local bonus = bleeders * 100;
			local tooltip = this.skill.getTooltip();

			if (bleeders > 0.8)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "There are a lot of characters bleeding, giving a bonus of [color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] to resolve and fatigue"
				});
			}
			else if (bleeders > 0.5)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "There are some characters bleeding, giving a bonus of [color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] to resolve and fatigue"
				});
			}
			else if (bleeders > 0.3)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "There are a few characters bleeding, giving a bonus of [color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] to resolve and fatigue"
				});
			}

			return tooltip;
		}

		o.onUpdate = function( _properties )
		{
			local bonus = this.getBleeders();
			_properties.Bravery += bonus * 100;
			_properties.Stamina += bonus * 100;
		}

	});

	::mods_hookExactClass("skills/legend_favoured_enemy_skill", function ( o )
	{

		o.getTooltip = function()
		{
			local stats = this.getTotalKillStats();
			local resp = [
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
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + stats.HitChance + "%[/color] Melee Skill due to being a favored enemy"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + stats.HitChance + "%[/color] Range Skill due to being a favored enemy"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/damage_dealt.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((stats.HitMult - 1.0) * 100.0) + "%[/color] Max Damage due to being a favored enemy"
				}
			];

			if (this.m.BraveryMult > 1)
			{
				resp.push({
					id = 15,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.BraveryMult - 1.0) * 100.0) + "[/color] Resolve due to being a favored enemy"
				});
			}

			resp.push({
				id = 15,
				type = "hint",
				icon = "ui/icons/special.png",
				text = stats.Kills + " favored enemy kills"
			});
			return resp;
		}

		o.onUpdate = function( _properties )
		{
			if (this.m.BraveryMult == 1.0)
			{
				return;
			}

			if (!("Entities" in this.Tactical))
			{
				return;
			}

			if (this.Tactical.Entities == null)
			{
				return;
			}

			local actors = this.Tactical.Entities.getAllInstancesAsArray();

			foreach( a in actors )
			{
				foreach( vt in this.m.ValidTypes )
				{
					if (a.getType() == vt)
					{
						_properties.Bravery += this.m.BraveryMult * 100 - 100;
						return;
					}
				}
			}
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_freedom_of_movement", function ( o )
	{

		o.getTooltip = function()
		{
			local tooltip = this.skill.getTooltip();
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gain hit point damage reduction proportional to the difference between your current initiative and your attacker\'s."
			});
			return tooltip;
		}

		o.onBeforeDamageReceived = function( _attacker, _skill, _hitInfo, _properties )
		{
			if (_attacker == null || _attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			{
				return;
			}

			local ourCurrentInitiative = this.getContainer().getActor().getInitiative();
			local enemyCurrentInitiative = _attacker.getInitiative();
			local bonus = 1;

			if (ourCurrentInitiative > enemyCurrentInitiative)
			{
				local diff = (ourCurrentInitiative - enemyCurrentInitiative) / 100.0;
				bonus = 1 / (1 + diff);
			}

			_properties.DamageReceivedRegularMult *= bonus;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_lithe", function ( o )
	{
		o.isHidden <- function()
		{
			return this.getContainer().hasSkill("perk.nimble") || (::Math.floor(this.getHitpointsDamageReduction() * 100) >= 100 && ::Math.floor(this.getArmorDamageReduction() * 100) >= 100);
		}

		o.getTooltip = function()
		{
			local actor = this.getContainer().getActor();
			local tooltip = this.skill.getTooltip();
			local hpBonus = ::Math.round(this.getHitpointsDamageReduction() * 100);
			if (hpBonus < 100)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Damage to hitpoints from attacks is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]" + (100-hpBonus) + "%[/color]"
				});
			}
			local armorBonus = ::Math.round(this.getArmorDamageReduction() * 100);
			if (armorBonus < 100)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Damage to armor from attacks is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]" + (100-armorBonus) + "%[/color]"
				});
			}

			if (hpBonus >= 100 && armorBonus >= 100)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character\'s body and head armor are too heavy to gain any benefit from being lithe[/color]"
				});
			}
			tooltip.push({
				id = 6,
				type = "hint",
				text = "Armor weight between [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(25 * (1 + 0.04 * actor.EL_getCombatLevel())) + "[/color] ~ [color=" + this.Const.UI.Color.PositiveValue + "]" +
					   this.Math.floor(35 * (1 + 0.04 * actor.EL_getCombatLevel())) + "[/color] best fit."
			});
			return tooltip;
		}

		o.getHitpointsDamageReduction <- function()
		{
			local actor = this.getContainer().getActor();
			local fat = this.getContainer().getActor().getItems().getStaminaModifier([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]) / (1 + 0.04 * actor.EL_getCombatLevel());
			fat = ::Math.min(0, fat + 35);
			return ::Math.minf(1.0, 1.0 - 0.3 + this.Math.pow(this.Math.abs(fat), 1.23) * 0.01);
		}

		o.getArmorDamageReduction <- function()
		{
			local actor = this.getContainer().getActor();
			local fat = this.getContainer().getActor().getItems().getStaminaModifier([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]) / (1 + 0.04 * actor.EL_getCombatLevel());
			fat = ::Math.min(0, fat + 35);
			return ::Math.minf(1.0, 1.0 - 0.15 + this.Math.pow(this.Math.abs(fat), 1.23) * 0.01);
		}

		o.onBeforeDamageReceived <- function ( _attacker, _skill, _hitInfo, _properties )
		{
			if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			{
				return;
			}

			if (this.getContainer().hasSkill("perk.nimble")) return;

			_properties.DamageReceivedRegularMult *= this.getHitpointsDamageReduction();
			_properties.DamageReceivedArmorMult *= this.getArmorDamageReduction();
		}

	});


	::mods_hookExactClass("skills/perks/perk_legend_med_ingredients", function ( o )
	{

		o.getDescription <- function()
		{
			return "Learning the plants of the healing trade allows you to fashion crude healing supplies from common ingredients. Unlocks crafting bandages and medicine. Also increases maximum medicine storage by 10 and resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color].";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 5;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_med_packages", function ( o )
	{

		o.getDescription <- function()
		{
			return "Not all of a plant is required for healing, your knowledge of the active ingredients lets you throw away excess leaves and roots.Your knowledge of medicines lets you repack them into more efficient packages. Increases maximum medicine storage by 30 and resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 5;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_muscularity", function ( o )
	{

		o.getDescription <- function()
		{
			return "Put your full weight into every blow and gain [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] of your current hitpoints as additional minimum and maximum damage.";
		}

		o.onUpdate = function( _properties )
		{
			local bodyHealth = this.getContainer().getActor().getHitpoints();
			_properties.DamageRegularMin += this.Math.floor(bodyHealth * 0.1);
			_properties.DamageRegularMax += this.Math.floor(bodyHealth * 0.1);
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_pacifist", function ( o )
	{

		o.getDescription <- function()
		{
			return "Fighting is a brutal thuggish pastime, most folk prefer a life without frequent bouts of extreme violence.  This character does not count towards your party strength when determining game difficulty. They will gain [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] resolve. They become content with being in reserve, and will grow unhappy if they are in more than half of the battles your company takes.";
		}

		o.onUpdate = function( _properties )
		{
			_properties.IsContentWithBeingInReserve = true;
			_properties.Bravery += 10;
		}

	});

	::mods_hookExactClass("skills/perks/perk_legend_perfect_fit", function ( o )
	{

		o.getBonus = function()
		{
			local actor = this.getContainer().getActor();
			local bodyitem = actor.getBodyItem();

			if (bodyitem == null)
			{
				return 0;
			}

			local armorFatPen = -1 * actor.getItems().getStaminaModifier([
				::Const.ItemSlot.Body,
				::Const.ItemSlot.Head
			]);
			armorFatPen /= (1 + 0.04 * actor.EL_getCombatLevel());
			local maxFat = actor.getFatigueMax();
			local armorFatPenMult = 0;

			if (armorFatPen * 2 <= maxFat)
			{
				armorFatPenMult = 1;
			}
			else
			{
				armorFatPenMult = this.Math.maxf(0, 1 - 0.01 * this.Math.pow(armorFatPen - maxFat / 2.0, 2.44));
			}

			return this.m.BonusMax * armorFatPenMult;
		}

		o.getInitiativeBonus = function( _bonus )
		{
			local actor = this.getContainer().getActor();
			return this.Math.floor(0.01 * _bonus * actor.getItems().getStaminaModifier([
				::Const.ItemSlot.Body,
				::Const.ItemSlot.Head
			]) * -1 / (1 + 0.04 * actor.EL_getCombatLevel()));
		}


	});

	::mods_hookExactClass("skills/perks/perk_legend_specialist_cult_armor", function ( o )
	{

		o.getResolveBonus = function()
		{
			local actor = this.getContainer().getActor();
			local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local cultItems = [];

			if (item != null)
			{
				if (item.isItemType(this.Const.Items.ItemType.Cultist))
				{
					cultItems.push(item);
				}

				if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() && ::MSU.isKindOf(item, "legend_armor"))
				{
					foreach( upgrade in item.m.Upgrades )
					{
						if (upgrade != null && upgrade.isItemType(this.Const.Items.ItemType.Cultist))
						{
							cultItems.push(upgrade);
						}
					}
				}
			}

			if (cultItems.len() > 0)
			{
				return this.Math.floor((actor.getHitpointsMax() - actor.getHitpoints()) / actor.getHitpointsMax() * 100);
			}

			return 0;
		}
	});

	::mods_hookExactClass("skills/perks/perk_lone_wolf", function ( o )
	{

		o.getDescription <- function()
		{
			return "I work best alone. With no ally within 2 tiles of distance, gain a [color=" + this.Const.UI.Color.PositiveValue + "]15[/color] bonus to Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Resolve.";
		}
	});

	::mods_hookExactClass("skills/perks/perk_nimble", function ( o )
	{

		o.getTooltip = function()
		{
			local actor = this.getContainer().getActor();
			local fm = this.Math.round(this.getChance() * 100);
			local tooltip = this.skill.getTooltip();

			if (fm < 100)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "]" + fm + "%[/color] of any damage to hitpoints from attacks"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character\'s body and head armor are too heavy as to gain any benefit from being nimble[/color]"
				});
			}
			tooltip.push({
				id = 6,
				type = "hint",
				text = "Armor weight below [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(15 * (1 + 0.04 * actor.EL_getCombatLevel())) + "[/color] best fit."
			});
			return tooltip;
		}

		o.getChance = function ()
		{
			local fat = 0;
			local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local actor = this.getContainer().getActor();

			if (body != null)
			{
				fat = fat + body.getStaminaModifier();
			}

			if (head != null)
			{
				fat = fat + head.getStaminaModifier();
			}

			fat /= (1 + actor.EL_getCombatLevel() * 0.04);
			fat = this.Math.min(0, fat + 15);
			local ret = this.Math.minf(1.0, 1.0 - 0.6 + this.Math.pow(this.Math.abs(fat), 1.23) * 0.01);
			return ret;
		}
	});

	::mods_hookExactClass("skills/perks/perk_ptr_bulwark", function ( o )
	{
		o.m.ArmorPercentageAsBonus = 1;

	});

	::mods_hookExactClass("skills/perks/perk_ptr_cull", function ( o )
	{
		local create = o.create;
		o.create = function()
		{
			create();
			this.m.Description = "Deals 200% damage when targets hitpoints persent is below 30%.";
		}

		o.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
		}

		o.onAnySkillUsed <- function ( _skill, _targetEntity, _properties )
		{
			if (_targetEntity != null && _targetEntity.isAttackable() && _targetEntity.getHitpointsPct() <= 0.3)
			{
				_properties.DamageTotalMult *= 2;
			}
		}

	});


	::mods_hookExactClass("skills/perks/perk_ptr_dent_armor", function ( o )
	{
		o.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			local actor = this.getContainer().getActor();
			if (!_skill.isAttack() || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(actor))
			{
				return;
			}

			local targetArmorItem = _bodyPart == this.Const.BodyPart.Head ? _targetEntity.getHeadItem() : _targetEntity.getBodyItem();
			if (targetArmorItem == null)
			{
				return;
			}
			local weapon = actor.getMainhandItem();
			if (!this.isEnabled(_skill, weapon))
			{
				return;
			}

			local isTwoHanded = this.m.IsForceTwoHanded || (weapon != null && weapon.isItemType(this.Const.Items.ItemType.TwoHanded));

			local roll = this.Math.rand(1, 100);
			if (roll <= this.m.ChanceOneHanded || (roll <= this.m.ChanceTwoHanded && isTwoHanded))
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/ptr_dented_armor_effect"));
			}
		}
	});

	::mods_hookExactClass("skills/perks/perk_ptr_fruits_of_labor", function ( o )
	{

		o.getDescription <- function()
		{
			return "You\'ve quickly realized that your years of hard labor give you an edge in mercenary work!\n\n[color=" + this.Const.UI.Color.Passive + "][u]Passive:[/u][/color]\n• Hitpoints, Maximum Fatigue, and Initiative are increased by [color=" + this.Const.UI.Color.PositiveValue + "]+12[/color] each.";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Hitpoints += 12;
			_properties.Stamina += 12;
			_properties.Initiative += 12;
		}

	});

	::mods_hookExactClass("skills/perks/perk_ptr_flail_spinner", function ( o )
	{

		o.spinFlail = function(_skill, _targetTile)
		{
			local targetEntity = _targetTile.getEntity();
			if (targetEntity == null)
			{
				return;
			}

			if (this.m.IsSpinningFlail || this.Math.rand(1,100) > this.m.Chance)
			{
				return;
			}

			local user = this.getContainer().getActor();

			if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == user.getID())
			{
				if (!user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
				{
					this.getContainer().setBusy(true);
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, function ( perk )
					{
						targetEntity = _targetTile.getEntity();
						if (targetEntity!= null && !targetEntity.isDying() && targetEntity.isAlive())
						{
							this.logDebug("[" + user.getName() + "] is Spinning The Flail on target [" + targetEntity.getName() + "] with skill [" + _skill.getName() + "]");
							if (!user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
							{
								this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " is Spinning the Flail");
							}

							perk.m.IsSpinningFlail = true;

							local isAbleToDie = targetEntity.m.IsAbleToDie;
							if (!user.isPlayerControlled())
							{
								targetEntity.m.IsAbleToDie = false;
							}

							_skill.useForFree(_targetTile);

							if (!user.isPlayerControlled())
							{
								targetEntity.m.IsAbleToDie = isAbleToDie;
							}

							perk.m.IsSpinningFlail = false;
						}

						this.getContainer().setBusy(false);

					}.bindenv(this), this);
				}
				else
				{
					if (targetEntity.isAlive())
					{
						this.logDebug("[" + user.getName() + "] is Spinning The Flail on target [" + targetEntity.getName() + "] with skill [" + _skill.getName() + "]");
						this.m.IsSpinningFlail = true;

						local isAbleToDie = targetEntity.m.IsAbleToDie;
						if (!user.isPlayerControlled())
						{
							targetEntity.m.IsAbleToDie = false;
						}

						_skill.useForFree(_targetTile);

						if (!user.isPlayerControlled())
						{
							targetEntity.m.IsAbleToDie = isAbleToDie;
						}

						this.m.IsSpinningFlail = false;
					}
				}
			}
		}
	});

	::mods_hookExactClass("skills/perks/perk_ptr_know_their_weakness", function ( o )
	{
		if("getMeleeBonus" in o) {
			o.getTooltip = function()
			{
				local tooltip = this.skill.getTooltip();

				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.getMeleeBonus() + "[/color] Melee Skill"
				});

				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.getRangedBonus() + "[/color] Ranged Skill"
				});

				return tooltip;
			}

			o.onUpdate = function( _properties )
			{
				_properties.MeleeSkill += this.getMeleeBonus();
				_properties.RangedSkill += this.getMeleeBonus();
			}
		}
	});

	::mods_hookExactClass("skills/perks/perk_ptr_through_the_ranks", function ( o )
	{

		o.getDescription <- function()
		{
			return "Ranged attacks have a [color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] reduced chance to inflict friendly fire.";
		}


		o.onAnySkillUsed = function( _skill, _targetEntity, _properties )
		{
			if (_skill.isAttack() && _targetEntity != null && _targetEntity.getID() != this.getContainer().getActor().getID() && _targetEntity.getFaction() == this.getContainer().getActor().getFaction())
			{
				_properties.RangedSkill -= this.m.Bonus;
			}
		}
	});


	::mods_hookExactClass("skills/perks/perk_ptr_tunnel_vision", function ( o )
	{

		o.getTooltip = function()
		{
			local tooltip = this.skill.getTooltip();

			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.VisionBonus + "[/color] Vision"
			});

			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.SkillBonus + "[/color] Melee Skill"
			});

			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.SkillBonus + "[/color] Ranged Skill"
			});

			return tooltip;
		}

		o.onUpdate = function( _properties )
		{
			this.m.IsHidden = true;
			if (!this.World.getTime().IsDaytime && this.getContainer().getActor().isPlacedOnMap())
			{
				this.m.IsHidden = false;
				_properties.MeleeSkill += this.m.SkillBonus;
				_properties.MeleeDefense += this.m.SkillBonus;
			}
		}
	});

	::mods_hookExactClass("skills/perks/perk_ptr_utilitarian", function ( o )
	{

		o.getTooltip = function()
		{
			local tooltip = this.skill.getTooltip();
			local fat = this.getTotalArmorFat();
			local actor = this.getContainer().getActor();
			local meleeSkillBonus = this.getMeleeSkillBonus(fat);
			if (meleeSkillBonus > 0)
			{
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + meleeSkillBonus + "[/color] Melee Skill"
				});
			}
			else if (meleeSkillBonus < 0)
			{
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + meleeSkillBonus + "[/color] Melee Skill"
				});
			}

			local fatReductionBonus = this.getFatigueReductionBonus(fat);
			if (fatReductionBonus > 0)
			{
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Skills build up [color=" + this.Const.UI.Color.PositiveValue + "]-" + fatReductionBonus + "%[/color] Fatigue"
				});
			}
			else if (fatReductionBonus < 0)
			{
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "Skills build up [color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.abs(fatReductionBonus) + "%[/color] Fatigue"
				});
			}

			local damageBonus = this.getDamageBonus(fat);
			if (damageBonus > 0)
			{
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/damage_dealt.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + damageBonus + "%[/color] Melee Damage"
				});
			}
			tooltip.push({
				id = 6,
				type = "hint",
				text = "The limit weight is [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(15 * (1 + 0.04 * actor.EL_getCombatLevel())) + "[/color]."
			});
			return tooltip;
		}

		o.onUpdate = function( _properties )
		{
			if (!this.isEnabled())
			{
				return;
			}
			this.m.PivotFat = this.Math.floor(15 * (1 + _properties.EL_CombatLevel * 0.04));
			this.m.FatReductionMaxBonus = this.Math.floor(15 * (1 + _properties.EL_CombatLevel * 0.04));
			local fat = this.getTotalArmorFat();

			_properties.MeleeSkill += this.getMeleeSkillBonus(fat);
			_properties.FatigueEffectMult *= 1.0 - this.getFatigueReductionBonus(fat) * 0.01;
			_properties.MeleeDamageMult *= 1.0 + this.getDamageBonus(fat) * 0.01;
		}
	});

	gt.Const.EL_Config.EL_modStrings();
});

gt.Const.EL_Config.EL_modStrings <- function()
{
	local el_new_perk_description = [
        {
            ID = "perk.anticipation",
            tooltip = "By watching your opponent/\'s aim, you have more time to react.\n\nWhen being attacked with ranged weapons, gain [color=" + this.Const.UI.Color.PositiveValue + "]+5 Ranged Defense[/color] as additional Ranged Defense per tile that the attacker is away, and always at least [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] to Ranged Defense."
        },
        {
            ID = "perk.colossus",
            tooltip = "Bring it on! Hitpoints are increased by [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color], which also reduces the chance to sustain debilitating injuries when being hit."
        },
        {
            ID = "perk.fortified_mind",
            tooltip = "An iron will is not swayed from the true path easily. Resolve is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color]."
        },
        {
            ID = "perk.legend_horse_hippology",
            tooltip = "Knowledge of horse physiology allows for better diet, exercise and care. Increases hitpoints by +25"
        },
        {
            ID = "perk.legend_horse_impulsion",
            tooltip = "Effective leverage of equestrian physiology relaxes the spinal column and allows the hindquarters to engage effectively. Increases Initiative by +30"
        },
        {
            ID = "perk.legend_horse_leg_control",
            tooltip = "it is not possible to hold the reins while firing a bow. Horse and rider must learn to communicate through the rider\'s legs. Increases ranged attack in battle by +25"
        },
        {
            ID = "perk.legend_horse_longeing",
            tooltip = "Time spent working on a long rope helps build trust between horse and rider. Increases resolve by +15"
        },
        {
            ID = "perk.legend_horse_tempi_change",
            tooltip = "the most challenging form of lead change, a tempi change requires shifting back and forth between lead legs. This form of training can allow the horse to change lead leg according to the situation, useful when under fire. Increases ranged defense by +25"
        },
        {
            ID = "perk.legend_alert",
            tooltip = "Pay close attention at all times, surveying the surroundings and assessing every clue for an insight. Gain [color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Initiative."
        },
        {
            ID = "perk.legend_ammo_binding",
            tooltip = "Expertise in making ammunition lets you strip it down to pack the parts for storage, it also lets you draw out arrows faster. Increases maximum ammunition storage by [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] and Ranged skill by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]."
        },
        {
            ID = "perk.legend_ammo_bundles",
            tooltip = "Using blankets and ropes to group large bundles of ammunition together you are able to carry far more. These bundles can also be used to shield yourself from enemy fire. Increases maximum ammunition storage by [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] and Ranged Defense by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]"
        },
        {
            ID = "perk.legend_assured_conquest",
            tooltip = "Your confidence affects your performance. Gain [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] melee skill, ranged skill, melee defense and ranged defense when at confident morale. This bonuses reduces as your morale state decreases. [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]at Steady, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] when breaking and [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] when fleeing."
        },
        {
            ID = "perk.legend_med_ingredients",
            tooltip = "Learning the plants of the healing trade allows you to fashion crude healing supplies from common ingredients. Unlocks crafting bandages and medicine. Also increases maximum medicine storage by 10 and resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]."
        },
        {
            ID = "perk.legend_med_packages",
            tooltip = "Not all of a plant is required for healing, your knowledge of the active ingredients lets you throw away excess leaves and roots.Your knowledge of medicines lets you repack them into more efficient packages. Increases maximum medicine storage by 30 and resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]"
        },
        {
            ID = "perk.legend_muscularity",
            tooltip = "Put your full weight into every blow and gain [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] of your current hitpoints as additional minimum and maximum damage."
        },
        {
            ID = "perk.legend_pacifist",
            tooltip = "Fighting is a brutal thuggish pastime, most folk prefer a life without frequent bouts of extreme violence.  This character does not count towards your party strength when determining game difficulty. They will gain [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] resolve. They become content with being in reserve, and will grow unhappy if they are in more than half of the battles your company takes."
        },
        {
            ID = "perk.lone_wolf",
            tooltip = "I work best alone. With no ally within 2 tiles of distance, gain a [color=" + this.Const.UI.Color.PositiveValue + "]15[/color] bonus to Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Resolve."
        },
        {
            ID = "perk.ptr_fruits_of_labor",
            tooltip = "You\'ve quickly realized that your years of hard labor give you an edge in mercenary work!\n\n[color=" + this.Const.UI.Color.Passive + "][u]Passive:[/u][/color]\n• Hitpoints, Maximum Fatigue, and Initiative are increased by [color=" + this.Const.UI.Color.PositiveValue + "]+12[/color] each."
        },
        {
            ID = "perk.ptr_through_the_ranks",
            tooltip = "Ranged attacks have a [color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] reduced chance to inflict friendly fire."
        },
		{
            ID = "perk.brawny",
            tooltip = "The fatigue and initiative penalty from wearing armor, helmet, weapon and shield is reduced by [color=" + this.Const.UI.Color.NegativeValue + "]30%[/color]."
        },
        {
            ID = "perk.ptr_bulwark",
            tooltip = "\'Not much to be afraid of behind a suit of plate!\'\n\n[color=" + this.Const.UI.Color.Passive + "][u]Passive:[/u][/color]\n• Resolve is increased by [color=" + this.Const.UI.Color.PositiveValue + "]1%[/color] of the combined current durability of head and body armor.\n• This bonus is [color=" + this.Const.UI.Color.PositiveValue + "]doubled[/color] against negative morale checks except mental attacks."
        },
    ]

    foreach( i, perk in gt.Const.Perks.PerkDefObjects )
    {
        foreach(adjust_perk in el_new_perk_description)
        {
            if (perk.ID == adjust_perk.ID)
            {
                perk.Tooltip = adjust_perk.tooltip;
                break;
            }
        }
    }
}

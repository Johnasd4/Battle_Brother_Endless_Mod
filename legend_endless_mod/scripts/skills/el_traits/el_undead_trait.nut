this.el_undead_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		InjuryType = this.Math.rand(1, 4)
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "el_trait.undead";
		this.m.Name = "亡灵生物";
		this.m.Icon = "ui/traits/rotting_flesh_trait.png";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "免疫流血、眩晕、茫然、伤残、毒素、瘴气、恐惧和精神控制。不消耗食物，不再需要工资。"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]- 50%[/color] 主动值, [color=" + this.Const.UI.Color.NegativeValue + "]- 2[/color] 行动点, [color=" + this.Const.UI.Color.PositiveValue + "]+ 20[/color] 决心"
			}
		]);
		return tooltip;
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood = 0;
		_properties.IsAffectedByInjuries = false;
        _properties.IsImmuneToStun = true;
        _properties.IsImmuneToBleeding = true;
        _properties.IsImmuneToPoison = true;
        _properties.IsResistantToMiasma = true;
        _properties.IsImmuneToDaze = true;
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
		_properties.InitiativeMult *= 0.5;
        _properties.ActionPoints -= 2;
		_properties.Bravery += 50;
		_properties.DailyWageMult = 0;
	}
	
	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.m.rawset("InjuryType", this.m.InjuryType);
		actor.m.BloodType = this.Const.BloodType.Dark;
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.getFlags().add("undead");
		actor.getFlags().add("zombie_minion");
		local body_blood = actor.getSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = true;
		local body_dirt = actor.getSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		actor = actor.get();
		local rage = actor.addSprite("status_rage");
		rage.setBrush("mind_control");
		rage.Visible = false;

		if (this.isKindOf(actor, "player"))
		{
			actor.improveMood = function ( _change, _text = "" )
			{
			};
			actor.worsenMood = function ( _change, _text = "" )
			{
			};
		}

		actor.onUpdateInjuryLayer = function ()
		{
			local injury = this.getSprite("injury");
			local injury_body = this.getSprite("injury_body");
			local p = this.m.Hitpoints / this.getHitpointsMax();

			if (p > 0.5)
			{
				if (!injury.HasBrush || injury.getBrush().Name != "zombify_0" + this.m.InjuryType)
				{
					injury.setBrush("zombify_0" + this.m.InjuryType);
				}
			}
			else if (!injury.HasBrush || injury.getBrush().Name != "zombify_0" + this.m.InjuryType + "_injured")
			{
				injury.setBrush("zombify_0" + this.m.InjuryType + "_injured");
			}

			if (p > 0.5)
			{
				injury_body.setBrush("zombify_body_01");
			}
			else
			{
				injury_body.setBrush("zombify_body_02");
			}

			injury.Visible = true;
			injury_body.Visible = true;
			this.setDirty(true);
		};
		local sw_onFactionChanged = actor.onFactionChanged;
		actor.onFactionChanged = function ()
		{
			sw_onFactionChanged();
			local flip = !this.isAlliedWithPlayer();
			this.getSprite("injury_body").setHorizontalFlipping(!flip);
			this.getSprite("status_rage").setHorizontalFlipping(flip);
		};

		if (this.m.IsNew)
		{
			this.onApplyAppearance();
			this.m.IsNew = false;
		}

		actor.onFactionChanged();
		actor.onUpdateInjuryLayer();
	}	
	
	function onApplyAppearance()
	{
		local actor = this.getContainer().getActor();
		local hairColor = this.Const.HairColors.Zombie[this.Math.rand(0, this.Const.HairColors.Zombie.len() - 1)];
		local sprite = actor.getSprite("head");
		sprite.Saturation = 0.5;
		sprite.varySaturation(0.2);
		sprite.Color = this.createColor("#c1ddaa");
		sprite.varyColor(0.05, 0.05, 0.05);
		local body = actor.getSprite("body");
		body.Color = sprite.Color;
		body.Saturation = sprite.Saturation;
		local beard = actor.getSprite("beard");
		local hair = actor.getSprite("hair");

		if (this.Math.rand(1, 100) <= 50)
		{
			if (this.m.InjuryType == 4)
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.ZombieExtended[this.Math.rand(0, this.Const.Beards.ZombieExtended.len() - 1)]);
				beard.setBrightness(0.9);
			}
			else
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.Zombie[this.Math.rand(0, this.Const.Beards.Zombie.len() - 1)]);
			}

			if (this.Math.rand(0, this.Const.Hair.Zombie.len()) != this.Const.Hair.Zombie.len())
			{
				hair.setBrush("hair_" + hairColor + "_" + this.Const.Hair.Zombie[this.Math.rand(0, this.Const.Hair.Zombie.len() - 1)]);
			}
			else
			{
				hair.resetBrush();
			}
		}

		if (hairColor != "grey")
		{
			beard.varyColor(0.1, 0.1, 0.1);
			hair.Color = beard.Color;
		}
		else
		{
			beard.varyBrightness(0.1);
		}

		local beard_top = actor.getSprite("beard_top");

		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Color = beard.Color;
		}
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.m.BloodType = this.Const.BloodType.Dark;
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/zombie_idle_14.wav",
			"sounds/enemies/zombie_idle_15.wav",
			"sounds/enemies/zombie_idle_16.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/zombie_hurt_01.wav",
			"sounds/enemies/zombie_hurt_02.wav",
			"sounds/enemies/zombie_hurt_03.wav",
			"sounds/enemies/zombie_hurt_04.wav",
			"sounds/enemies/zombie_hurt_05.wav",
			"sounds/enemies/zombie_hurt_06.wav",
			"sounds/enemies/zombie_hurt_07.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/zombie_death_01.wav",
			"sounds/enemies/zombie_death_02.wav",
			"sounds/enemies/zombie_death_03.wav",
			"sounds/enemies/zombie_death_04.wav",
			"sounds/enemies/zombie_death_05.wav",
			"sounds/enemies/zombie_death_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/zombie_bite_01.wav",
			"sounds/enemies/zombie_bite_02.wav",
			"sounds/enemies/zombie_bite_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/zombie_bite_01.wav",
			"sounds/enemies/zombie_bite_02.wav",
			"sounds/enemies/zombie_bite_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/zombie_idle_01.wav",
			"sounds/enemies/zombie_idle_02.wav",
			"sounds/enemies/zombie_idle_03.wav",
			"sounds/enemies/zombie_idle_04.wav",
			"sounds/enemies/zombie_idle_05.wav",
			"sounds/enemies/zombie_idle_06.wav",
			"sounds/enemies/zombie_idle_07.wav",
			"sounds/enemies/zombie_idle_08.wav",
			"sounds/enemies/zombie_idle_09.wav",
			"sounds/enemies/zombie_idle_10.wav",
			"sounds/enemies/zombie_idle_11.wav",
			"sounds/enemies/zombie_idle_12.wav",
			"sounds/enemies/zombie_idle_13.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/zombie_bite_01.wav",
			"sounds/enemies/zombie_bite_02.wav",
			"sounds/enemies/zombie_bite_03.wav"
		];
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.BloodType = this.Const.BloodType.Red;
		actor.m.MoraleState = this.Const.MoraleState.Steady;
		actor.getFlags().remove("undead");
		actor.getFlags().remove("zombie_minion");
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.InjuryType);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.InjuryType = _in.readU8();
	}
});


this.el_become_undead_effect <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {
		EL_ConversionProgress = 0,
		EL_IfConversion = false
	},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "el_effect.become_undead";
		this.m.Name = "亡灵化";
		this.m.Icon = "ui/perks/surpress_urges.png";
	}
	
	function getName()
	{
		return this.m.Name + "(" + this.m.EL_ConversionProgress + "%)";
	}
	
	function isHidden()
	{
		return this.m.EL_ConversionProgress == 0;
	}

	function getPrice()
	{
		local mult = this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()];
		mult = mult * (1.0 + (this.getContainer().getActor().getLevel() - 1) * 0.1);
		local p = this.Math.pow(this.m.EL_ConversionProgress, 2) * mult;
		p = this.Math.round(p * 0.1) * 10;
		return p;
	}

	function getTooltip()
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
				icon = "ui/icons/special.png",
				text = "每经历一场厮杀，侵蚀度增长3%，根据受伤情况额外增长侵蚀度"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "每天侵蚀度自然衰退10%"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "侵蚀度超过50%后被击倒会有90%的概率在战后被霜之哀伤的力量转化为亡者，继续为巫妖王战斗"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "侵蚀度超过100%后会直接被霜之哀伤的力量转化为亡者！"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "神殿也许对此有办法"
			}
		];
		return ret;
	}

	function onDeath( _fatalityType )
	{
		if(_fatalityType == this.Const.FatalityType.Unconscious)
		{
			this.m.EL_IfConversion = true;
		}
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_ConversionProgress > 50)
		{
			_properties.SurviveWithInjuryChanceMult *= 2.72;
		}
	}

	function onNewDay()
	{
		this.m.EL_ConversionProgress = this.Math.max(0, this.m.EL_ConversionProgress - 10);
	}

	function onCombatFinished()
	{
		this.m.EL_ConversionProgress = this.Math.min(100, this.m.EL_ConversionProgress + 3 + this.Math.floor((1 - this.getContainer().getActor().getHitpointsPct()) * 15));
		if(this.m.EL_IfConversion || this.m.EL_ConversionProgress >= 100)
		{
			this.getContainer().add(this.new("scripts/skills/el_traits/el_undead_trait"));
			this.removeSelf();
		}
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.m.EL_ConversionProgress);
	}

	function onDeserialize( _in )
	{
		this.m.EL_ConversionProgress = _in.readU32();
	}
});
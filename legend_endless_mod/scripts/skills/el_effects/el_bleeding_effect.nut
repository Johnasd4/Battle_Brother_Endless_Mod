this.el_bleeding_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		Damage = 5,
		LastRoundApplied = 0,
        BodyPart = null,
		Actor = null
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		this.m.Damage = _d;
	}

	function setActor( _a )
	{
		this.m.Actor = ::MSU.asWeakTableRef(_a);
	}

	function create()
	{
		this.m.ID = "effects.bleeding";
		this.m.Name = "血意诅咒";
		this.m.KilledString = "Bled to death";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Overlay = "bleed";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "这个角色因最近受到的奇异割裂伤而大量流血，每回合将失去 [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Damage + "[/color]% 生命值和护甲值，持续 [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] 回合.";
	}

	function getAttacker()
	{
		if (!::Legends.Mod.ModSettings.getSetting("BleedKiller").getValue())
		{
			return this.getContainer().getActor();
		}

		if (::MSU.isNull(this.m.Actor))
		{
			return this.getContainer().getActor();
		}

		if (this.m.Actor.getID() != this.getContainer().getActor().getID())
		{
			if (this.m.Actor.isAlive() && this.m.Actor.isPlacedOnMap())
			{
				return this.m.Actor;
			}
		}

		return this.getContainer().getActor();
	}

	function applyDamage()
	{
        if (this.m.LastRoundApplied != this.Time.getRound())
        {
            this.m.LastRoundApplied = this.Time.getRound();
            local actor = this.getContainer().getActor();
            this.spawnIcon("status_effect_01", actor.getTile());
            local hitInfo = clone this.Const.Tactical.HitInfo;
            hitInfo.DamageArmor = this.Math.ceil(this.m.Damage * actor.getArmorMax(this.m.BodyPart) * 0.01 * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0));
			this.logInfo("bodypart:" + this.m.BodyPart + " DamageArmor:" + hitInfo.DamageArmor);
            hitInfo.DamageRegular = this.Math.ceil(this.m.Damage * actor.getBaseProperties().Hitpoints * 0.01 * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0));
            hitInfo.DamageDirect = 0.99;
            hitInfo.BodyPart = this.m.BodyPart;
            hitInfo.BodyDamageMult = 1.0;
            hitInfo.FatalityChanceMult = 0.0;
            actor.onDamageReceived(this.getAttacker(), this, hitInfo);

            if (--this.m.TurnsLeft <= 0)
            {
                this.removeSelf();
            }
        }
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " had his bleeding wound quickly close thanks to his unnatural physiology");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.getContainer().hasSkill("trait.bleeder"))
			{
				++this.m.TurnsLeft;
			}
		}
	}

	function onUpdate( _properties )
	{
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

	function EL_setBodyPart( _bodyPart )
	{
		this.m.BodyPart = _bodyPart;
	}

});
this.el_charm_skill <- this.inherit("scripts/skills/skill", {
	m = {
        Slaves = []
    },
	function create()
	{
		this.m.ID = "el_actives.charm";
		this.m.Name = "魅惑";
		this.m.Description = "魅惑一个敌人，使其为你而战两回合，成功率由双方决心而定。";
		this.m.Icon = "skills/entice.png";
		this.m.IconDisabled = "skills/entice_bw.png";
		this.m.Overlay = "entice";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
	}
    
    function removeSlave( _entityID )
	{
        local i = this.m.Slaves.find(_entityID);

		if (i != null)
		{
			this.m.Slaves.remove(i);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}
    
    function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		return ret;
	}

    function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
		{
			return 0;
		}

		local user = this.m.Container.getActor();
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
		local skill = properties.Bravery * properties.BraveryMult;
		local defense = defenderProperties.Bravery * defenderProperties.BraveryMult;
		local toHit = skill - defense;

		return this.Math.max(5, this.Math.min(95, toHit));
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local target = _targetTile.getEntity();
        local roll = this.Math.rand(1, 100);
        local isHit = getHitchance(target) > roll;

        if (isHit)
        {
            local tag = {
                User = _user,
                TargetTile = _targetTile
            };
            this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
            this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " 使用" + this.getName() + "成功魅惑了" + this.Const.UI.getColorizedEntityName(target) + "两回合 ( 几率： " + this.Math.min(95, this.Math.max(5, getHitchance(target))) + ", 掷骰： " + roll + ")");
        }
        else
        {
            this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " 对" + this.Const.UI.getColorizedEntityName(target) + " 使用了" + this.getName() + "但失败了 (Chance： " + this.Math.min(95, this.Math.max(5, getHitchance(target))) + ", 掷骰： " + roll + ")");
        }
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
		{
            this.m.Slaves.push(target.getID());
			local charmed = this.new("scripts/skills/effects/charmed_effect");
			charmed.setMasterFaction(this.Const.Faction.PlayerAnimals);
			charmed.setMaster(this);
			target.getSkills().add(charmed);
        }.bindenv(this), this);
	}

    function onDeath( _fatalityType )
	{
		foreach( id in this.m.Slaves )
		{
			local e = this.Tactical.getEntityByID(id);

			if (e != null)
			{
				e.getSkills().removeByID("effects.charmed");
			}
		}

		this.m.Slaves = [];
	}
});


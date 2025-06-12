this.el_lichking_death_summon <- this.inherit("scripts/skills/skill", {
	m = {
        EL_RankLevel = 0,
		EL_SoulEnergyCost = 0
	},
	function create()
	{
		this.m.ID = "el_actives.lichking_death_summon";
		this.m.Name = "死亡召唤";
		this.m.Description = "在一个空地块使用，将有召唤骷髅或幽灵。在一个存在尸体的地块使用，将召唤一个僵尸。召唤强大生物的概率将随着你决心的提升而上升。";
		this.m.Icon = "skills/raisedead2.png";
		this.m.IconDisabled = "skills/raisedead2_bw.png";
		this.m.Overlay = "raisedead2";
		this.m.SoundOnUse = [
			"sounds/combat/meat_01.wav",
			"sounds/combat/meat_02.wav",
			"sounds/combat/meat_03.wav",
			"sounds/combat/meat_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsHidden = false;
		this.m.IsRanged = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = this.Const.EL_LichKing.Weapon.DeathSummon.SkillActionPointCost;
		this.m.FatigueCost =  this.Const.EL_LichKing.Weapon.DeathSummon.SkillFatigueCost;
		this.m.MinRange = 1;

		this.m.EL_SoulEnergyCost = this.Const.EL_LichKing.Weapon.DeathSummon.SoulEnergyCost[this.m.EL_RankLevel];
	}
    
	function isUsable()
	{
        return this.World.Assets.EL_getSoulEnergy() < this.m.EL_SoulEnergyCost || !EL_canControlMoreEntity() ? false : this.skill.isUsable();
	}

	function getCostString()
	{
		return "[i]使用花费" + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " AP " + this.m.EL_SoulEnergyCost + "灵魂能量[/color][/b] 并增加" + (this.isAffordableBasedOnFatiguePreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getFatigueCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getFatigueCost()) + " Fatigue[/color][/b][/i]\n";
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]召唤一只新生亡灵占用 " + this.Const.EL_LichKing.Weapon.DeathSummon.ControlAbilityCost[this.m.EL_RankLevel] + "点支配能力。[/color]"
		});
        if(EL_isInStrengthenForm())
        {
			ret.push({
				id = 7,
				type = "text",
			    icon = "ui/icons/special.png",
				text = "当前处于“黑暗强化”状态，每次使用消耗的灵魂能量增加为 " + this.Const.EL_LichKing.Weapon.DeathSummon.StrengthenSoulEnergyCostMult * 100 + "%，将会召唤高阶亡灵生物。"
			});
        }
		if(!EL_canControlMoreEntity())
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]当前支配能力已满，强行使用召唤将会使最先控制的亡灵失去控制，变为野生亡灵。（不分敌我）[/color]"
			});
		}
		return ret;
	}
    
	function EL_isInStrengthenForm()
	{
        return this.getContainer().hasSkill("el_effect.lichking_strengthen");
	}
    
	function EL_canControlMoreEntity()
	{
		local helmet = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
        return (helmet.EL_getControlAbility() + this.Const.EL_LichKing.Weapon.DeathSummon.ControlAbilityCost[this.m.EL_RankLevel]) < helmet.EL_getControlAbilityMax();
	}
	
	function EL_getBraveryBonus()
	{
		// local bravery = this.getContainer().getActor().getBravery() - 100;
		// local offset = 20;
		// local bonus = 0;
		// local bravery_need = 10.0;
		// while(bravery > bravery_need) {
		// 	++bonus;
		// 	bravery -= bravery_need;
		// 	bravery_need *= 2.0;
		// }
		// return 0.01 * (100 + ((bravery / bravery_need) + bonus) * offset);
		return 1 + 0.01 * (this.getContainer().getActor().getBravery() - 100) / 2;
	}
	
	function getScript( _has_corpse )
	{
		if(_has_corpse)
		{
			if(EL_isInStrengthenForm())
			{
				local random_max = 0;
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior.len(); ++i)
				{
					random_max += this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior[i].Weight;
				}
				local r = this.Math.rand(1, random_max) * EL_getBraveryBonus();
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior.len(); ++i)
				{
					if(r = this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior.len() - 1)
					{
						r = -1;
					}
					if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior[i].Weight)
					{
						r -= this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior[i].Weight;
						continue;
					}
					local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Script.len() - 1);
					return this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Senior[i].Script[random];
				}
			}
			else
			{
				local random_max = 0;
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal.len(); ++i)
				{
					random_max += this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Weight;
				}
				local r = this.Math.rand(1, 100) * EL_getBraveryBonus();
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal.len(); ++i)
				{
					if(r = this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal.len() - 1)
					{
						r = -1;
					}
					if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Weight)
					{
						r -= this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Weight;
						continue;
					}
					local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Script.len() - 1);
					return this.Const.EL_LichKing.Weapon.DeathSummon.ZombiePool.Normal[i].Script[random];
				}
			}
		}
		if(this.Math.rand(1, 100) < 60)
		{
			if(EL_isInStrengthenForm())
			{
				local random_max = 0;
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior.len(); ++i)
				{
					random_max += this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior[i].Weight;
				}
				local r = this.Math.rand(1, random_max) * EL_getBraveryBonus();
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior.len(); ++i)
				{
					if(r = this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior.len() - 1)
					{
						r = -1;
					}
					if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior[i].Weight)
					{
						r -= this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior[i].Weight;
						continue;
					}
					local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Script.len() - 1);
					return this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Senior[i].Script[random];
				}
			}
			else
			{
				local random_max = 0;
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal.len(); ++i)
				{
					random_max += this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal[i].Weight;
				}
				local r = this.Math.rand(1, 100) * EL_getBraveryBonus();
				for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal.len(); ++i)
				{
					if(r = this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal.len() - 1)
					{
						r = -1;
					}
					if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal[i].Weight)
					{
						r -= this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal[i].Weight;
						continue;
					}
					local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Script.len() - 1);
					return this.Const.EL_LichKing.Weapon.DeathSummon.SkeletonPool.Normal[i].Script[random];
				}
			}
		}
		if(EL_isInStrengthenForm())
		{
			local random_max = 0;
			for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior.len(); ++i)
			{
				random_max += this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior[i].Weight;
			}
			local r = this.Math.rand(1, random_max) * EL_getBraveryBonus();
			for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior.len(); ++i)
			{
				if(r = this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior.len() - 1)
				{
					r = -1;
				}
				if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior[i].Weight)
				{
					r -= this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior[i].Weight;
					continue;
				}
				local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Script.len() - 1);
				return this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Senior[i].Script[random];
			}
		}
		else
		{
			local random_max = 0;
			for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal.len(); ++i)
			{
				random_max += this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Weight;
			}
			local r = this.Math.rand(1, 100) * EL_getBraveryBonus();
			for(local i = 0; i < this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal.len(); ++i)
			{
				if(r = this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal.len() - 1)
				{
					r = -1;
				}
				if(r >= this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Weight)
				{
					r -= this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Weight;
					continue;
				}
				local random = this.Math.rand(0, this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Script.len() - 1);
				return this.Const.EL_LichKing.Weapon.DeathSummon.GhostPool.Normal[i].Script[random];
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.EL_SoulEnergyCost = EL_isInStrengthenForm() ? this.Const.EL_LichKing.Weapon.DeathSummon.StrengthenSoulEnergyCostMult * this.Const.EL_LichKing.Weapon.DeathSummon.SoulEnergyCost[this.m.EL_RankLevel] : this.Const.EL_LichKing.Weapon.DeathSummon.SoulEnergyCost[this.m.EL_RankLevel];
		local range_item = this.Const.EL_LichKing.Weapon.DeathCoil.BaseSkillRangeMax + this.m.EL_RankLevel * this.Const.EL_LichKing.Weapon.DeathSummon.SkillRangeMaxRankFactor;
		local range_hitpoints = this.Const.EL_LichKing.Weapon.DeathCoil.BaseSkillRangeMax + this.Math.floor(this.getContainer().getActor().getHitpointsMax() / 100);
		this.m.MaxRange = this.Math.min(range_item, range_hitpoints);
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}
		return true;
	}

    function EL_setRankLevel( _EL_rankLevel )
	{
        this.m.EL_RankLevel = _EL_rankLevel;
    }

	function onUse( _user, _targetTile )
	{
        this.World.Assets.EL_addSoulEnergy(-this.m.EL_SoulEnergyCost);
		local script = this.getScript(_targetTile.Properties.has("Corpse"));
		local entity = this.Const.World.Common.EL_addEntityByScript(script, _targetTile, this.Const.Faction.Player, this.Math.floor(this.m.EL_RankLevel * 0.5), _user.EL_getLevel());
		this.logInfo("script:" + script);
		local helmet = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		helmet.EL_addEntityToControlList(entity, this.Const.EL_LichKing.Weapon.DeathSummon.ControlAbilityCost[this.m.EL_RankLevel], entity.getAIAgent());
		
		entity.riseFromGround();
		entity.getFlags().add("IsSummoned", true);
		entity.getFlags().add("Summoner", _user);
		entity.m.IsSummoned = true;
		local ai = this.new("scripts/ai/tactical/player_agent");
		ai.setActor(_user);
		entity.setAIAgent(ai);
		entity.m.IsControlledByPlayer = true;
		entity.setActionPoints(entity.getActionPointsMax());
		this.spawnIcon("status_effect_01", this.getContainer().getActor().getTile());
		return true;
	}
});
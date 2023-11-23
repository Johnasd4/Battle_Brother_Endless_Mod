this.el_lichking_dominate <- this.inherit("scripts/skills/skill", {
	m = {
        EL_RankLevel = 0,
		EL_SoulEnergyCost = 0
	},
	function create()
	{
		this.m.ID = "el_actives.lichking_dominate";
		this.m.Name = "支配亡灵";
		this.m.Description = "对敌方使用";
		this.m.Icon = "skills/channeled_power.png";
		this.m.IconDisabled = "skills/channeled_power_bw.png";
		this.m.Overlay = "channeled_power";
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
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsHidden = false;
		this.m.IsRanged = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = this.Const.EL_LichKing.Helmet.Dominate.SkillActionPointCost;
		this.m.FatigueCost =  this.Const.EL_LichKing.Helmet.Dominate.SkillFatigueCost;
		this.m.MinRange = 1;

		this.m.EL_SoulEnergyCost = this.Const.EL_LichKing.Helmet.Dominate.SoulEnergyCost[this.m.EL_RankLevel];
	}
    
	function isUsable()
	{
        return this.World.Assets.EL_getSoulEnergy() < this.m.EL_SoulEnergyCost ? false : this.skill.isUsable();
	}

	function getCostString()
	{
		return "[i]使用花费" + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " AP " + this.m.EL_SoulEnergyCost + "灵魂能量[/color][/b] 并增加" + (this.isAffordableBasedOnFatiguePreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getFatigueCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getFatigueCost()) + " Fatigue[/color][/b][/i]\n";
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		switch(this.m.EL_RankLevel)
		{
		case 0:
		case 1:
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "目前仅可控制普通亡灵。"
			});
			break;
		case 2:
		case 3:
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "目前可控制普通与精英亡灵。"
			});
			break;
		case 4:
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "目前可控制所有亡灵。"
			});
			break;
		}
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "支配一名敌方普通亡灵占用 " + this.Const.EL_LichKing.Helmet.Dominate.ControlAbilityCost[0] + "点支配能力。精英亡灵： " + this.Const.EL_LichKing.Helmet.Dominate.ControlAbilityCost[2] + "点、首领亡灵： " + this.Const.EL_LichKing.Helmet.Dominate.ControlAbilityCost[4] + "点"
		});
		if(!EL_canControlMoreEntity())
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]当前支配能力已满，强行使用支配将会使最先控制的亡灵失去控制，变为野生亡灵。（不分敌我）[/color]"
			});
		}
		return ret;
	}
    
	function EL_canControlMoreEntity()
	{
		local helmet = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
        return (helmet.EL_getControlAbility() + this.Const.EL_LichKing.Helmet.Dominate.ControlAbilityCost[this.m.EL_RankLevel]) < helmet.EL_getControlAbilityMax();
	}

	function onAfterUpdate( _properties )
	{
		this.m.EL_SoulEnergyCost = this.Const.EL_LichKing.Helmet.Dominate.SoulEnergyCost[this.m.EL_RankLevel];
		local range_item = this.Const.EL_LichKing.Helmet.Dominate.BaseSkillRangeMax + this.m.EL_RankLevel * this.Const.EL_LichKing.Helmet.Dominate.SkillRangeMaxRankFactor;
		local range_hitpoints = this.Const.EL_LichKing.Helmet.Dominate.BaseSkillRangeMax + this.Math.floor(this.getContainer().getActor().getHitpointsMax() / 100);
		this.m.MaxRange = this.Math.min(range_item, range_hitpoints);
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		local target = _targetTile.getEntity();
		local user = this.getContainer().getActor();

		if (target == null || target.isAlliedWith(user) || !EL_isUndead(target) || target.EL_getRankLevel() > this.Math.floor(this.m.EL_RankLevel * 0.5))
		{
			return false;
		}
		return true;
	}

    function EL_isUndead( _actor )
    {
		if(_actor.getSkills().hasSkill("el_trait.undead"))
		{
			return true;
		}
		foreach(valid_type in this.Const.EL_Weapon.EL_Entry.Factor.EL_SpecialAttackUndead.ValidEntity)
		{
			if(_actor.getType() == valid_type)
			{
				return true;
			}
		}
        return false;
    }

    function EL_setRankLevel( _EL_rankLevel )
	{
        this.m.EL_RankLevel = _EL_rankLevel;
    }

	function onUse( _user, _targetTile )
	{
        this.World.Assets.EL_addSoulEnergy(-this.m.EL_SoulEnergyCost);
		local target_entity = _targetTile.getEntity();
		local helmet = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		helmet.EL_addEntityToControlList(target_entity, 1, target_entity.getAIAgent());//this.Const.EL_LichKing.Helmet.Dominate.ControlAbilityCost[target_entity.EL_getRankLevel()]

		target_entity.setFaction(this.Const.Faction.Player);
		local ai = this.new("scripts/ai/tactical/player_agent");
		ai.setActor(_user);
		target_entity.m.IsSummoned = true;
		target_entity.setAIAgent(ai);
		target_entity.m.IsControlledByPlayer = true;
	}
});
this.el_lichking_strengthen <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_actives.lichking_strengthen";
		this.m.Name = "开启黑暗强化";
		this.m.Description = "主动拥抱死亡，让这种力量浸入你的身体与灵魂，以此换取超越限度的强大力量。接下来每次攻击都会额外消耗灵魂能量，换取额外效果。";
		this.m.Icon = "skills/active_176_sw.png";
		this.m.IconDisabled = "skills/active_176_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/barbarian_fury_01.wav",
			"sounds/enemies/dlc4/barbarian_fury_02.wav",
			"sounds/enemies/dlc4/barbarian_fury_03.wav",
			"sounds/enemies/dlc4/barbarian_fury_04.wav",
			"sounds/enemies/dlc4/barbarian_fury_05.wav",
			"sounds/enemies/dlc4/barbarian_fury_06.wav",
			"sounds/enemies/dlc4/barbarian_fury_07.wav",
			"sounds/enemies/dlc4/barbarian_fury_08.wav",
			"sounds/enemies/dlc4/barbarian_fury_09.wav",
			"sounds/enemies/dlc4/barbarian_fury_10.wav",
			"sounds/enemies/dlc4/barbarian_fury_11.wav",
			"sounds/enemies/dlc4/barbarian_fury_12.wav"
			];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}
    
	function EL_isInStrengthenForm()
	{
        return  this.getContainer().hasSkill("el_effect.lichking_strengthen");
	}

	function isUsable()
	{
		return true;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
        local rank_level = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).EL_getRankLevel();
        ret.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = "常规攻击会额外消耗" + this.Const.EL_LichKing.Weapon.NormalSkill.AdditionSoulEnergyCost[rank_level] + "点灵魂能量，对伤害目标及其周围一格内的所有敌人造成相当于本次攻击" + this.Const.EL_LichKing.Weapon.NormalSkill.AdditionDamagePersent[rank_level] * 100 + "%的伤害，此额外伤害必中且触发一次士气判定。"
        });
        ret.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = "“死亡召唤”会消耗" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSoulEnergyCostMult + "倍的灵魂能量，使召唤单位模板增强。"
        });
        ret.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = "“死亡缠绕”会消耗" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSoulEnergyCostMult + "倍的灵魂能量，使施法范围与伤害/治疗效果提升为" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSkillRangeMaxMult * 100 + "%。"
        });

		return ret;
	}

	function getCostString()
	{
		return "";
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInGreatSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
        //生效加入图标变化
        if(EL_isInStrengthenForm())
        {
			this.m.Name = "开启黑暗强化";
			this.m.Icon = "skills/active_176_sw.png";
            this.getContainer().removeByID("el_effect.lichking_strengthen");
        }
        else
        {
			this.m.Name = "关闭黑暗强化";
			this.m.Icon = "skills/active_176.png";
            this.m.Container.add(this.new("scripts/skills/el_effects/el_lichking_strengthen_effect"));
        }
		return true;
	}

});
this.el_archaeologist_trait <- this.inherit("scripts/skills/skill", {
	m = {
		LastEventDay = 1
	},
	function create()
	{
		this.m.ID = "el_trait.el_archaeologist";
		this.m.Name = "世界真相";
		this.m.Description = "世界真相会带来一些神秘的变化。";
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
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
			}
		];
		local factor;
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HitpointsMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "生命值" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Bravery);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "决心" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Fatigue);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "疲劳" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Initiative);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "主动值" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeSkill);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "近战攻击" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedSkill);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "远程攻击" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDefense);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "近战防御" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDefense);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "远程防御" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Vision);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "视野" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.XPGainMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "经验获取" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedArmorMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "护甲受到伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedDirectMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "穿甲受到伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedRangedMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "受到远程伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedMeleeMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "受到近战伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedTotalMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "受到所有伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDamageMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "近战伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDamageMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "远程伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageArmorMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "护甲伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageDirectMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "穿甲伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageTotalMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "所有伤害" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.BodyArmorMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "身体护甲" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		factor = this.Math.round((this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HeadArmorMult - 1) * 100);
		if (factor != 0) {
			ret.push({
				id = 7,
				type = "text",
				text = "头部护甲" + (factor >= 0 ? "[color=#006400]+" : "[color=#640000]-") + " " + this.Math.abs(factor) + "%" + "[/color]"
			})
		}
		return ret;
	}

	function onNewDay()
	{
		local day = this.World.getTime().Days;
		if (day > this.m.LastEventDay && day % 5 == 0)
		{
			this.m.LastEventDay = day;
			this.World.Events.fire("event.el_archaeologist_world_truth");
		}
	}
});
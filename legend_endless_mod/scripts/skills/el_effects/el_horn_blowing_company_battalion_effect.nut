this.el_horn_blowing_company_battalion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_rarity_effects.horn_blowing_company_battalion";
		this.m.Name = "吹角连营";
		this.m.Description = "激昂的乐曲能唤醒战意。";
		this.m.Icon = "el_skills/horn_blowing_company_battalion_effect.png";
		//this.m.IconMini = "el_horn_blowing_company_battalion_effect_mini";
		this.m.Overlay = "el_horn_blowing_company_battalion_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 5,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageMult * 100 + "%[/color] Damage Dealt"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-" + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageReceivedMult * 100 + "%[/color] Damage Received"
			}
		]);
		return tooltip;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.0 + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageMult;
		_properties.DamageReceivedTotalMult *= 1.0 - this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageReceivedMult;
	}

	function onRoundEnd()
	{
		this.removeSelf();
	}
});


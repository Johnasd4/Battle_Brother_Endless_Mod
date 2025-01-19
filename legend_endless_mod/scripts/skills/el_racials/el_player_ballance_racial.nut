this.el_player_ballance_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_racial.player_ballance";
		this.m.Name = "";
		this.m.Icon = "";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdateGlobalFactor( _properties )
	{
		local base_properties = this.getContainer().getActor().getBaseProperties();
		_properties.Hitpoints += this.Math.floor(this.Const.EL_GlobalFactor.EL_PlayerAttributes.HitpointsMult * base_properties.Hitpoints);
        _properties.Bravery += this.Const.EL_GlobalFactor.EL_PlayerAttributes.Bravery;
        _properties.Stamina += this.Const.EL_GlobalFactor.EL_PlayerAttributes.Fatigue;
        _properties.Initiative += this.Const.EL_GlobalFactor.EL_PlayerAttributes.Initiative;
        _properties.MeleeSkill += this.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeSkill;
        _properties.RangedSkill += this.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedSkill;
		_properties.MeleeDefense += this.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeDefense;
		_properties.RangedDefense += this.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedDefense;
		_properties.InitiativeForTurnOrderAdditional += this.Const.EL_GlobalFactor.EL_PlayerAttributes.InitiativeForTurnOrderAdditional;
		_properties.Vision += this.Const.EL_GlobalFactor.EL_PlayerAttributes.Vision;
		_properties.MovementAPCostAdditional += this.Const.EL_GlobalFactor.EL_PlayerAttributes.MovementAPCostAdditional;
		_properties.MovementFatigueCostAdditional += this.Const.EL_GlobalFactor.EL_PlayerAttributes.MovementFatigueCostAdditional;
		_properties.DamageReceivedArmorMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedArmorMult;
		_properties.DamageReceivedDirectMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedDirectMult;
		_properties.DamageReceivedRangedMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedRangedMult;
		_properties.DamageReceivedMeleeMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedMeleeMult;
		_properties.DamageReceivedTotalMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedTotalMult;
		_properties.MeleeDamageMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeDamageMult;
		_properties.RangedDamageMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedDamageMult;
		_properties.DamageArmorMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageArmorMult;
		_properties.DamageDirectMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageDirectMult;
		_properties.DamageTotalMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageTotalMult;
		_properties.BodyArmorMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.BodyArmorMult;
		_properties.HeadArmorMult *= this.Const.EL_GlobalFactor.EL_PlayerAttributes.HeadArmorMult;
	}

	function onUpdate( _properties )
	{
        local base_properties = this.getContainer().getActor().getBaseProperties();
        _properties.MeleeSkill += this.Math.max(0, base_properties.RangedSkill - base_properties.MeleeSkill - 50);
        _properties.RangedSkill += this.Math.max(0, base_properties.MeleeSkill - base_properties.RangedSkill - 50);
        _properties.MeleeDefense += this.Math.max(0, base_properties.RangedDefense - base_properties.MeleeDefense - 50);
        _properties.RangedDefense += this.Math.max(0, base_properties.MeleeDefense - base_properties.RangedDefense - 50);

		this.onUpdateGlobalFactor(_properties);
	}

});


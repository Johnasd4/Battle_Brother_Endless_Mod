this.el_bone_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.bone_spear";
		this.m.Name = "骸骨战矛";
		this.m.Description = "一杆浑然天成的骨矛。它聚集着尸山血海般的怨气，面对它的生物将面临无法抵抗的精神压力。";
		this.m.IconLarge = "weapons/melee/bone_spear.png";
		this.m.Icon = "weapons/melee/bone_spear_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Spear;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_spear_03";
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		for(local i = 0; i < result.len(); ++i)
		{
			if(result[i].type == "text" && result[i].text == "——————————————")
			{
				result.insert(i, {
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "命中目标时强制降低目标的士气。"
				});
				break;
			}
		}
		return result;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
        this.weapon.onDamageDealt(_target, _skill, _hitInfo);
		if (_target == null || !_target.isAlive() || _target.isDying() || !_skill.m.IsWeaponSkill)
		{
			return;
		}
        if(_target.getMoraleState() != this.Const.MoraleState.Ignore && _target.m.MoraleState > this.Const.EL_PlayerNPC.EL_RankToMoraleMin[_target.m.EL_RankLevel])
        {
            _target.setMoraleState(this.Math.max(this.Const.MoraleState.Fleeing, _target.getMoraleState() - 1));
        }
	}
});
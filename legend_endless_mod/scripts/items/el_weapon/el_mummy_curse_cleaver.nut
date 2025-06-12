this.el_mummy_curse_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.mummy_curse_cleaver";
		this.m.Name = "木乃伊诅咒弯刀";
		this.m.Description = "有着毁灭性力量的大型锋利金属刀。木乃伊所隐藏的神秘图腾，拥有诡异力量的诅咒战刃。";
		this.m.IconLarge = "weapons/melee/mummy_curse_cleaver.png";
		this.m.Icon = "weapons/melee/mummy_curse_cleaver_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Cleaver;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_scimitar_01";
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -12;
		this.m.Value = 0;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
        this.addSkill(this.new("scripts/skills/el_effects/el_mummy_curse_cleaver_effect"));
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		for(local i = 0; i < result.len(); ++i)
		{
			if(result[i].type == "text" && result[i].text == "——————————————")
			{
				result.insert(i, {
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "持有者攻击被诅咒目标时获得双倍伤害收益。"
				});
				result.insert(i, {
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "命中时目标会附加一层“木乃伊的诅咒”。"
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
        _target.getSkills().add(this.new("scripts/skills/effects/mummy_curse_effect"));
	}
});
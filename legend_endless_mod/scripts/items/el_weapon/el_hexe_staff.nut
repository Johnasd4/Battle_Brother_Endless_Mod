this.el_hexe_staff <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.hexe_staff";
		this.m.Name = "女巫节杖";
		this.m.Description = "A twisted staff made from withered roots";
		this.m.IconLarge = "weapons/melee/hexe_staff.png";
		this.m.Icon = "weapons/melee/hexe_staff_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Staff | this.Const.Items.WeaponType.MagicStaff;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_staff_04";
		this.m.ShieldDamage = 0;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -6;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 0.3;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = -0.1;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/legend_staff_bash");
		s.m.Icon = "skills/staff_bash_gnarled.png";
		s.m.IconDisabled = "skills/staff_bash_gnarled_bw.png";
		this.addSkill(s);
		local t = this.new("scripts/skills/actives/legend_staff_knock_out");
		t.m.Icon = "skills/staff_knock_out_gnarled.png";
		t.m.IconDisabled = "skills/staff_knock_out_gnarled_bw.png";
		this.addSkill(t);
		this.addSkill(this.new("scripts/skills/el_actives/el_charm_skill"));
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
					text = "装备后获得“魅惑”技能。"
				});
				break;
			}
		}
		return result;
	}

});


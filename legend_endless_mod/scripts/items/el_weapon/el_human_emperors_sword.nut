this.el_human_emperors_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.human_emperors_sword";
		this.m.Name = "人皇剑";
		this.m.Description = "这是一把古老的传说之剑。拥有他的人便是命定的领袖，肩负着众生的期盼，是屹立不倒的顶梁柱。\n挽狂澜于既倒 扶大厦之将倾！";
		this.m.IconLarge = "weapons/melee/human_emperors_sword.png";
		this.m.Icon = "weapons/melee/human_emperors_sword_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_two_handed_02";
		this.m.Value = 0;
		this.m.ShieldDamage = 16;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -15;
		this.m.RegularDamage = 85;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
        for(local i = 0; i < result.len(); ++i)
		{
			if(result[i].type == "text" && result[i].text == "——————————————")
			{
				result.insert(i, {
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "战场上的每个友军会为你提供2%伤害2%减伤1点近攻1点近防1点远防加成。"
				});
				break;
			}
		}
		return result;
	}

    function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/overhead_strike"));
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);

        this.addSkill(this.new("scripts/skills/el_effects/el_human_emperors_effect"));
	}
});


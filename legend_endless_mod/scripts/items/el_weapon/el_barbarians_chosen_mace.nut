this.el_barbarians_chosen_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.barbarians_chosen_mace";
		this.m.Name = "野蛮人神赐之棍";
		this.m.Description = "一个装有头盖骨的大棍子。无论敌人穿什么样的盔甲，受到这种武器的打击会让其神志不清，陷入茫然。野蛮人的神灵赐福了这把武器，使他拥有了难以想象的强大杀伤力。";
		this.m.IconLarge = "weapons/melee/barbarians_chosen_mace.png";
		this.m.Icon = "weapons/melee/barbarians_chosen_mace_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Mace;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_06";
		this.m.Value = 0;
		this.m.ShieldDamage = 20;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 50 * 2.0;
		this.m.RegularDamageMax = 70 * 2.0;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.5;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cudgel_skill");
		skill.m.Icon = "skills/active_178.png";
		skill.m.IconDisabled = "skills/active_178_sw.png";
		skill.m.Overlay = "active_178";
		this.addSkill(skill);
		skill = this.new("scripts/skills/el_actives/el_strengthen_strike_down_skill");
		skill.m.Icon = "skills/active_179.png";
		skill.m.IconDisabled = "skills/active_179_sw.png";
		skill.m.Overlay = "active_179";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
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
					text = "你的“击倒”技能将额外击晕目标1回合"
				});
				break;
			}
		}
		return result;
	}

});


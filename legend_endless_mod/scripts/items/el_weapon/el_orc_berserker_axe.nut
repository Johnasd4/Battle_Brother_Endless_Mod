this.el_orc_berserker_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.orc_berserker_axe";
		this.m.Name = "兽人狂暴战斧";
		this.m.Description = "一把巨大而粗糙的双头战斧，随伤痕累累，但却是不少部落的文化象征，只有真正地猛士能拿起他。";
		this.m.IconLarge = "weapons/melee/orc_berserker_axe.png";
		this.m.Icon = "weapons/melee/orc_berserker_axe_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Axe;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_orc_weapon_01";
		this.m.Value = 0;
		this.m.ShieldDamage = 42;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -34;
		this.m.RegularDamage = 90;
		this.m.RegularDamageMax = 120;
		this.m.ArmorDamageMult = 1.6;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
		this.m.FatigueOnSkillUse = 5;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/split_man");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/round_swing");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);


		skill = this.new("scripts/skills/el_actives/el_charge_slash");
		this.addSkill(skill);
	}
});


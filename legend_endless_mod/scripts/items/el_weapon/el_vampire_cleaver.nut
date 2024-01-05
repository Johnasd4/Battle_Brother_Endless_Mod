this.el_vampire_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.vampire_cleaver";
		this.m.Name = "吸血鬼战刃";
		this.m.Description = "这种神秘的武器重量和大小都像一只大型动物的腿。它的外侧弯曲边缘暴露出一种锋利感，使它在摆动时能在空中呼啸而过，独特的放血槽使它成为敌人的噩梦。";
		this.m.IconLarge = "weapons/melee/vampire_cleaver.png";
		this.m.Icon = "weapons/melee/vampire_cleaver_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Cleaver;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_great_khopesh";
		this.m.Condition = 54.0;
		this.m.ConditionMax = 54.0;
		this.m.StaminaModifier = -18;
		this.m.Value = 0;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.25;
		this.m.FatigueOnSkillUse = 5;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.FatigueCost = 15;
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
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
					text = "使用武器命中目标时将造成的血量伤害用于恢复自身生命值，造成的护甲伤害用于恢复自身对应部位护甲值。"
				});
				break;
			}
		}
		return result;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
        this.weapon.onDamageDealt(_target, _skill, _hitInfo);
		if (!_skill.m.IsWeaponSkill)
		{
			return;
		}
		local actor = this.m.Container.getActor();
        local vampire_hitpoints_number = this.Math.round(_hitInfo.DamageInflictedHitpoints);
        local vampire_condition_number = this.Math.round(_hitInfo.DamageInflictedArmor);
		this.logInfo("vampire_hitpoints_number:" + vampire_hitpoints_number + " vampire_condition_number:" + vampire_condition_number);
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + vampire_hitpoints_number));
		if(_hitInfo.BodyPart == this.Const.BodyPart.Head)
		{
			local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			if(helmet != null) 
			{
				helmet.setArmor(this.Math.min(body.getArmorMax(), body.getArmor() + vampire_condition_number));
				helmet.updateAppearance();
			}
		}
		else 
		{
			local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			if(body != null) 
			{
				body.setArmor(this.Math.min(body.getArmorMax(), body.getArmor() + vampire_condition_number));
				body.updateAppearance();
			}
		}
		
	}
});


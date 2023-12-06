this.el_goblin_tuchun_crossbow <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		IsLoaded = true
	},
	function isLoaded()
	{
		return this.m.IsLoaded;
	}

	function setLoaded( _l )
	{
		this.m.IsLoaded = _l;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "el_weapon.goblin_tuchun_crossbow";
		this.m.Name = "哥布林督军弩";
		this.m.Description = "A large and heavy crossbow with menacing spikes in front. More like a minitature ballista, it shoots stakes with enough force to knock back a target hit. 对吸血鬼造成额外100点伤害。";
		this.m.IconLarge = "weapons/ranged/goblin_tuchun_crossbow.png";
		this.m.Icon = "weapons/ranged/goblin_tuchun_crossbow_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Crossbow;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive | this.Const.Items.ItemType.TwoHanded;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_crossbow_01";
		this.m.Value = 0;
		this.m.Condition = 72;
		this.m.ConditionMax = 72;
		this.m.RangeMin = 1;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.5;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
	}

	function getAmmoID()
	{
		return "ammo.bolts";
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
        
		if (!this.m.IsLoaded)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Must be reloaded before firing again[/color]"
			});
		}
        
		for(local i = 0; i < result.len(); ++i)
		{
			if(result[i].type == "text" && result[i].text == "——————————————")
			{
				result.insert(i, {
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "若你在攻击目标的视野之外，则此次攻击伤害翻倍"
				});
				return result;
			}
		}
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shoot_stake"));
		this.addSkill(this.new("scripts/skills/actives/legend_piercing_bolt"));
		if (!this.m.IsLoaded)
		{
			this.addSkill(this.new("scripts/skills/actives/reload_bolt"));
		}

        
		this.addSkill(this.new("scripts/skills/el_effects/el_goblin_tuchun_crossbow_effect"));
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.setLoaded(true);
	}
});


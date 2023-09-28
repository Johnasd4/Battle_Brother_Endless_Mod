this.el_eye_of_death_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "entry.el_eye_of_death";
		this.m.Name = "Eye of Death(Crossbow)";
		this.m.Description = "Death stares at your enemies."
		this.m.Icon = "el_entrys/el_eye_of_death_entry.png";
		//this.m.IconMini = "el_eye_of_death_entry_mini";
		this.m.Overlay = "el_eye_of_death_entry";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getTooltip()
	{
        local result = [
            {
				id = 1,
				type = "title",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.getName() + "[/color]"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]No need to load and no longer consume Ammo.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Chance to hit head 100%, double the damage inflicted from hits to the head, completely ignores armor.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Crossbow to take effect..[/color]"
            });
        }
		return result;
	}

	// function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	// {
    //     local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
	// 	if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
	// 	{
	// 		item.setLoaded(true);
	// 		//this.logInfo("setLoaded true1");
	// 		//this.getContainer().removeByID("actives.reload_bolt");
	// 		// foreach( skill in this.getContainer().getActor().getSkills())
	// 		// {
	// 		// 	if(skill.getID() == "actives.reload_bolt")
	// 		// 	{
	// 		// 		skill.onUse(this.getContainer().getActor(), null);;
	// 		// 	}
	// 		// }
	// 	}
	// }

	// function onTargetMissed( _skill, _targetEntity )
	// {
    //     local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
	// 	if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
	// 	{
	// 		item.setLoaded(true);
	// 		this.logInfo("setLoaded true2");
	// 		//this.getContainer().removeByID("actives.reload_bolt");
	// 	}
	// }

	// function onAnySkillUsed( _skill, _targetEntity, _properties )
	// {
    //     local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
	// 	if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow) && _skill.m.IsWeaponSkill)
	// 	{
	// 		_properties.IsIgnoringArmorOnAttack = true;
	// 		_properties.DamageDirectAdd = 1.0;
	// 	}
	// }

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
		{
			_hitInfo.BodyPart = this.Const.BodyPart.Head;
			_hitInfo.BodyDamageMult *= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_EyeOfDeath.HitHeadMult;
		}
	}

	function onUpdate( _properties )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
		{
			item.setLoaded(true);
			this.getContainer().removeByID("actives.reload_bolt");
		}
	}
});


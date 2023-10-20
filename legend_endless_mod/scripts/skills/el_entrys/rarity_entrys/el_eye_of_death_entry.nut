this.el_eye_of_death_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.eye_of_death";
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
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Crossbow to take effect.[/color]"
            });
        }
		return result;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity != null && _skill.m.IsWeaponSkill && EL_isUsable())
		{
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.DamageArmorMult *= 0.0;
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
        if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			_hitInfo.BodyPart = this.Const.BodyPart.Head;
			_hitInfo.BodyDamageMult *= this.Const.EL_Rarity_Entry.Factor.EL_EyeOfDeath.HitHeadMult;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).setLoaded(true);
			this.getContainer().removeByID("actives.reload_bolt");
		}
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Crossbow))
		{
			return true;
		}
		return false;
	}
});


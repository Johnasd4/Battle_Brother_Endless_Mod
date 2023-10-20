this.el_bloody_knock_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.bloody_knock";
		this.m.Name = "Bloody Knock(Two-Handed Flail)";
		this.m.Description = "Make their heads explode like watermelons.Waghghghghghghghghgh!!!";
		this.m.Icon = "el_entrys/el_bloody_knock_entry.png";
		//this.m.IconMini = "el_bloody_knock_entry_mini";
		this.m.Overlay = "el_bloody_knock_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Has a 100% chance to stun and make it dazed on a hit.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you attack the enemy, if the target does not has a helmet, it causes " + this.Const.EL_Rarity_Entry.Factor.EL_BloodyKnock.DamageMult + " times the damage. If the target has a helmet, it causes a concussion.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Two-Handed Flail to take effect.[/color]"
            });
        }
		return result;
	}
    
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
            _targetEntity.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
            _targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
            local helmet = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
            if(helmet != null && helmet.getCondition() > 0)
            {
                _targetEntity.getSkills().add(this.new("scripts/skills/injury/severe_concussion_injury"));
            }
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
			local helmet = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
            if(helmet == null || helmet.getCondition() == 0)
            {
                _hitInfo.DamageArmor *= this.Const.EL_Rarity_Entry.Factor.EL_BloodyKnock.DamageMult;
				_hitInfo.DamageRegular *= this.Const.EL_Rarity_Entry.Factor.EL_BloodyKnock.DamageMult;
            }
		}
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.TwoHanded) && item.isWeaponType(this.Const.Items.WeaponType.Flail))
		{
			return true;
		}
		return false;
	}
});


this.el_bloody_cutting_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "entry.el_bloody_cutting";
		this.m.Name = "Bloody Cutting(One-Handed Cleaver)";
		this.m.Description = "The scorching blood makes me so intoxicated.";//这炙热的鲜血，让我如此的陶醉
		this.m.Icon = "el_entrys/el_bloody_cutting_entry.png";
		//this.m.IconMini = "el_bloody_cutting_entry_mini";
		this.m.Overlay = "el_bloody_cutting_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Additional damage of 20% of the target's health has been lost.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Add an equal amount of health damage to the bleeding effect when hit.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Cleaver))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip  Cleaver to take effect..[/color]"
            });
        }
		return result;
	}
    
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || !_skill.isAttack() || _targetEntity.getCurrentProperties().IsImmuneToBleeding || !this.Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			return;
		}
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Cleaver))
		{
			local bleeding_damage = (this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_BloodyCutting.BleedingFactor * _damageInflictedHitpoints) / _targetEntity.getHitpointsMax() * 100;
			//this.logInfo("base bleeding_damage:" +bleeding_damage);
			local actor = this.getContainer().getActor();
			local effect = this.new("scripts/skills/effects/bleeding_effect");
			
			effect.setActor(actor);
			effect.setDamage(bleeding_damage);
			_targetEntity.getSkills().add(effect);

			if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " made a particularly Bloody Cut inflicting additional Bleeding on " + this.Const.UI.getColorizedEntityName(_targetEntity));
			}
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Cleaver))
		{
			_hitInfo.DamageRegular += (_targetEntity.getHitpointsMax() - _targetEntity.getHitpoints()) * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_BloodyCutting.TargetHealthLossExtraDamageFactor;
		}
	}
});


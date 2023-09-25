this.el_master_feat_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "entrys.el_master_feat";
		this.m.Name = "Master Feat(One-Handed Sword)";
		this.m.Description = "Accomplish a task with ease.";//游刃有余
		this.m.Icon = "el_entrys/el_master_feat_entry.png";
		//this.m.IconMini = "el_master_feat_entry_mini";
		this.m.Overlay = "el_master_feat_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Ignore damage from outside your attack range.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]100% Riposte.[/color]"
			},
			{
				id = 5,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you attack the enemy, based on the difference in Initiative between you and the target, gain additional Melee Skill and Attack damage.[/color]"
			},
			{
				id = 6,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you are attacked, based on the difference in Initiative between you and the target, gain additional Melee Denfense and Ranged Denfense.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Shield to take effect..[/color]"
            });
        }
		return result;
	}

	function onDamageReceived( _attacker, _skill, _properties )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
        {
		    EL_attackBack(_attacker);
        }
	}

	function onMissed( _attacker, _skill )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
        {
		    EL_attackBack(_attacker);
        }
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (_targetEntity != null && item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword) && _skill.m.IsWeaponSkill)
		{
            local user = this.getContainer().getActor();
            local bonus = this.Math.max(0, user.getInitiative() - _targetEntity.getInitiative());
            local bonus = this.Math.max(0, user.getInitiative() - _targetEntity.getInitiative());
            this.logInfo("before skill:"+_properties.MeleeSkill);
            this.logInfo("before damage_mult:"+_properties.DamageTotalMult);
			_properties.MeleeSkill += bonus * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MasterFeat.SkillFactor;
			_properties.DamageTotalMult *= (1.0 + bonus * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MasterFeat.DamageFactor);
            this.logInfo("after skill:"+_properties.MeleeSkill);
            this.logInfo("after damage_mult:"+_properties.DamageTotalMult);
		}
	}

    function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
    {
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
        {
            local user = this.getContainer().getActor();
			local distance = _attacker.getTile().getDistanceTo(user.getTile());
            if(distance > item.getRangeMax())
            {
                _properties.DamageReceivedTotalMult = 0;
            }
        }
    }

	function onBeingAttacked( _attacker, _skill, _properties )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
        {
            local user = this.getContainer().getActor();
            local bonus = this.Math.max(0, user.getInitiative() - _attacker.getInitiative());
            this.logInfo("before defense:"+_properties.MeleeDefense + "::"+_properties.RangedDefense);
			_properties.MeleeDefense += bonus * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MasterFeat.MeleeDefenseFactor;
			_properties.RangedDefense += bonus * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MasterFeat.RangedDefenseFactor;
            this.logInfo("after defense:"+_properties.MeleeDefense + "::"+_properties.RangedDefense);
        }
	}

	function EL_getAttackSkill(_EL_distance)
	{
		local ret;
		local ap = 999;
        local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach( skill in skills )
		{
			if (!skill.isActive() || !skill.isAttack() || !skill.isTargeted() || skill.isIgnoredAsAOO() || skill.isDisabled() || !skill.isUsable())
			{
				continue;
			}
			if (_EL_distance < skill.getMinRange() || _EL_distance > skill.getMaxRange())
			{
				continue;
			}
			if (skill.getActionPointCost() < ap)
			{
				ret = skill;
				ap = skill.getActionPointCost();
			}
		}
		return ret;
	}

	function EL_attackBack(_EL_attacker) {
		local actor = this.getContainer().getActor();
		if(_EL_attacker == null && _EL_attacker.isAlive() && !_EL_attacker.isAlliedWith(actor)) {
			return;
		}
        local skill = this.EL_getAttackSkill(actor.getTile().getDistanceTo(_EL_attacker.getTile()));
        if (skill != null && (actor.getFatigue() + skill.getFatigueCost() < actor.getFatigueMax()))
        {
            skill.useForFree(_EL_attacker.getTile());
            actor.setFatigue(actor.getFatigue() + skill.getFatigueCost());
        }
	}
});


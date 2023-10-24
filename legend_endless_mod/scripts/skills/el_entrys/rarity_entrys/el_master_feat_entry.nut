this.el_master_feat_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.master_feat";
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
		if (!EL_isUsable())
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Sword to take effect.[/color]"
            });
        }
		return result;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (EL_isUsable())
        {
		    EL_attackBack(_attacker);
        }
	}

	function onMissed( _attacker, _skill )
	{
		if (EL_isUsable())
        {
		    EL_attackBack(_attacker);
        }
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity != null && _skill.m.IsWeaponSkill && EL_isUsable())
		{
            local user = this.getContainer().getActor();
            local bonus = this.Math.max(0, user.getInitiative() - _targetEntity.getInitiative());
            //this.logInfo("before skill:"+_properties.MeleeSkill);
            //this.logInfo("before damage_mult:"+_properties.DamageTotalMult);
			_properties.MeleeSkill += bonus * this.Const.EL_Rarity_Entry.Factor.EL_MasterFeat.MeleeSkillFactor;
			_properties.DamageTotalMult *= (1.0 + bonus * this.Const.EL_Rarity_Entry.Factor.EL_MasterFeat.DamageMultFactor);
           // this.logInfo("after skill:"+_properties.MeleeSkill);
            //this.logInfo("after damage_mult:"+_properties.DamageTotalMult);
		}
	}

    function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
    {
        if (EL_isUsable())
        {
            local user = this.getContainer().getActor();
			local distance = _attacker.getTile().getDistanceTo(user.getTile());
			local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if(distance > item.getRangeMax())
            {
                _properties.DamageReceivedTotalMult = 0;
            }
        }
    }

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if(_attacker == null && _attacker.isAlive() && !_attacker.isAlliedWith(actor)) {
			return;
		}
		if (EL_isUsable())
        {
            local user = this.getContainer().getActor();
            local bonus = this.Math.max(0, user.getInitiative() - _attacker.getInitiative());
            //this.logInfo("before defense:"+_properties.MeleeDefense + "::"+_properties.RangedDefense);
			_properties.MeleeDefense += bonus * this.Const.EL_Rarity_Entry.Factor.EL_MasterFeat.MeleeDefenseFactor;
			_properties.RangedDefense += bonus * this.Const.EL_Rarity_Entry.Factor.EL_MasterFeat.RangedDefenseFactor;
            //this.logInfo("after defense:"+_properties.MeleeDefense + "::"+_properties.RangedDefense);
        }
	}

	function EL_attackBack( _attacker ) {
		local actor = this.getContainer().getActor();
		if(actor.getSkills().hasSkill("effects.stunned") || actor.getCurrentProperties().IsStunned)
		{
			return;
		}
        local skill = this.Const.EL_Rarity_Entry.EL_getAttackSkill(actor);
        skill.useForFree(_attacker.getTile());
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
		{
			return true;
		}
		return false;
	}
});


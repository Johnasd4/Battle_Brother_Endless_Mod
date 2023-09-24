this.el_massacre_desire_entry <- this.inherit("scripts/skills/skill", {
	m = {
        TempStacks = 0,
        Stacks = 0,
        TotalBonus = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = "entrys.el_massacre_desire";
		this.m.Name = "Massacre Desire(One-Handed Axe)";
		this.m.Description = "More, more blood!";
		this.m.Icon = "el_entrys/el_massacre_desire_entry.png";
		//this.m.IconMini = "el_massacre_desire_entry_mini";
		this.m.Overlay = "el_massacre_desire_entry";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getName()
	{
		if(Stacks)
		{
			return this.m.Name + " kills: " + Stacks;
		}
		else
		{
			return this.m.Name;
		}
	}

	function EL_isNegativeEffect( _skill )
	{
		foreach( id in this.Const.EL_Item_Other.NagativeEffectID)
		{
			if(_skill.m.ID == id)
			{
				return true;
			}
		}
		return false;
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you kill an enemy:[/color]"
			},
			{
				id = 4,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Attack damage + " + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MassacreDesire.DamageMult * 100 + "% in this combat.[/color]"
			},
			{
				id = 5,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Gain permanent gradually decreasing damage bonus (follow entry).[/color]"
			},
			{
				id = 6,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Clear all negative effects and Injury.[/color]"
			},
			{
				id = 7,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Current effect: Attack damage + " + (this.Math.round((this.m.TempStacks * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MassacreDesire.DamageMult + this.m.TotalBonus * 0.01) * 10000) * 0.01) + "%.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Axe))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip One-Handed Axe to take effect..[/color]"
            });
        }
		return result;
	}

    function onTargetKilled ( _targetEntity, _skill )
	{
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Axe))
		{
            local actor = this.getContainer().getActor();
            if (actor.isAlliedWith(_targetEntity))
            {
                return;
            }
            if (_skill == null || !_skill.isAttack())
            {
                return;
            }				
            ++this.m.TempStacks;
            ++this.m.Stacks;
            this.m.TotalBonus += 1.0 / this.m.Stacks;
			local actor = this.getContainer().getActor();
            local skills = actor.getSkills();
            foreach( skill in skills.m.Skills ) {
                local skill_type = skill.getType();
                if( skill_type == this.Const.SkillType.Injury ||
                    skill_type == this.Const.SkillType.PermanentInjury ||
                    skill_type == this.Const.SkillType.TemporaryInjury ||
                    skill_type == this.Const.SkillType.SemiInjury ||
					this.EL_isNegativeEffect(skill))
                {
                    skills.remove(skill);
                }
            }
            actor.setHitpoints(actor.getHitpointsMax());
            actor.setActionPoints(actor.getActionPointsMax());
            actor.setFatigue(0);
		}
	}	

	function EL_isNegativeEffect( _skill )
	{
		foreach( _id in this.Const.Item.NagativeEffectID)
		{
			if(_skill.m.ID == _id)
			{
				return true;
			}
		}
		return false;
	}

	function onUpdate( _properties )
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Axe))
		{
            _properties.DamageTotalMult *= (1.0 + this.m.TempStacks * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_MassacreDesire.DamageMult + this.m.TotalBonus * 0.01);
		}
	}

	function onCombatStarted()
	{
		this.m.TempStacks = 0;
	}
	
	function onCombatFinished()
	{
		this.m.TempStacks = 0;
	}	
        
    function onSerialize( _out )
	{
        _out.writeI32(this.m.Stacks);
		_out.writeF32(this.m.TotalBonus);
	}

	function onDeserialize( _in )
	{
        this.m.Stacks = _in.readI32();
		this.m.TotalBonus = _in.readF32();
	}
});


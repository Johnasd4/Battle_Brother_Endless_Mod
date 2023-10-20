this.el_massacre_desire_entry <- this.inherit("scripts/skills/skill", {
	m = {
		NeedXP = 1,
		CurrentXP = 0,
		TotalBonus = 0
    },
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.massacre_desire";
		this.m.Name = "Massacre Desire(One-Handed Axe)";
		this.m.Description = "More, more blood!";
		this.m.Icon = "el_entrys/el_massacre_desire_entry.png";
		//this.m.IconMini = "el_massacre_desire_entry_mini";
		this.m.Overlay = "el_massacre_desire_entry";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getName()
	{
		if(this.m.NeedXP > 1)
		{
			return this.m.Name + " + " + (this.m.NeedXP - 1) + "%";
		}
		else
		{
			return this.m.Name;
		}
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Attack damage + " + this.Const.EL_Rarity_Entry.Factor.EL_MassacreDesire.TempDamageMult * 100 + "% in this combat.[/color]"
			},
			{
				id = 5,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Gain permanent gradually decreasing damage bonus (follow entry).[/color]"
			},
			{
				id = 6,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Clear all negative effects and Injury, Recover 100% Hitpoints and Fatigue.[/color]"
			},
			{
				id = 7,
                type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Clear all negative effects and Injury.[/color]"
			},
			{
				id = 8,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Current effect: Attack damage + " + this.m.TotalBonus + "%.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip One-Handed Axe to take effect.[/color]"
            });
        }
		return result;
	}

    function onTargetKilled ( _targetEntity, _skill )
	{
		if (EL_isUsable())
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
            ++this.m.CurrentXP;
			if(this.m.CurrentXP == this.m.NeedXP)
			{
				this.m.CurrentXP = 0;
				++this.m.NeedXP;
				++this.m.TotalBonus;
			}
            this.m.TotalBonus += this.Const.EL_Rarity_Entry.Factor.EL_MassacreDesire.TempDamageMult * 100;
			local actor = this.getContainer().getActor();
            local skills = actor.getSkills();
            foreach( skill in skills.m.Skills ) {
                if( skill.isType(this.Const.SkillType.Injury) ||
                    skill.isType(this.Const.SkillType.PermanentInjury) ||
                    skill.isType(this.Const.SkillType.TemporaryInjury) ||
                    skill.isType(this.Const.SkillType.SemiInjury) ||
					this.Const.EL_Rarity_Entry.EL_isNegativeEffect(skill))
                {
                    skills.remove(skill);
                }
            }
            actor.setHitpoints(actor.getHitpointsMax());
            actor.setFatigue(0);
		}
	}	

	function onUpdate( _properties )
	{
		if (EL_isUsable())
		{
            _properties.DamageTotalMult *= (1.0 + this.m.TotalBonus * 0.01);
		}
	}

	function onCombatStarted()
	{
		this.m.TotalBonus = this.m.NeedXP - 1;
	}
	
	function onCombatFinished()
	{
		this.m.TotalBonus = this.m.NeedXP - 1;
	}	
        
    function onSerialize( _out )
	{
        _out.writeI32(this.m.NeedXP);
		_out.writeI32(this.m.CurrentXP);
	}

	function onDeserialize( _in )
	{
        this.m.NeedXP = _in.readI32();
		this.m.CurrentXP = _in.readI32();
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Axe))
		{
			return true;
		}
		return false;
	}
});


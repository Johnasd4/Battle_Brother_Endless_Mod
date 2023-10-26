this.el_pursuit_of_wind_entry <- this.inherit("scripts/skills/skill", {
	m = {
        EL_LastAttackActionPoint = 999
    },
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.pursuit_of_wind";
		this.m.Name = "Pursuit of Wind(Bow)";
		this.m.Description = "Death stares at your enemies."
		this.m.Icon = "el_entrys/el_pursuit_of_wind_entry.png";
		//this.m.IconMini = "el_pursuit_of_wind_entry_mini";
		this.m.Overlay = "el_pursuit_of_wind_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]No longer consume Ammo.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Attacks must hit, with infinite range and field of view.[/color]"
			},
			{
				id = 5,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]3 consecutive arrows per attack.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Bow to take effect.[/color]"
            });
        }
		return result;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
        if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable() && _skill.m.IsWeaponSkill)
		{
            if(this.m.EL_LastAttackActionPoint == this.getContainer().getActor().getActionPoints())
            {
                return;
            }
            this.m.EL_LastAttackActionPoint = this.getContainer().getActor().getActionPoints();
			_skill.useForFree(_targetEntity.getTile());
            _skill.useForFree(_targetEntity.getTile());
		}
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			local skills = this.getContainer().getActor().getSkills().m.Skills;
            foreach( skill in skills )
            {
                if (skill.m.IsWeaponSkill || skill.getID() == "actives.legend_cascade")
                {
                    skill.m.MaxRange += 9993;
                }
            }
		}
	}

	function onUpdate( _properties )
	{
		if (EL_isUsable())
		{
			_properties.Vision = 10000;
		}
	}

    function onCombatStarted()
    {
        this.m.EL_LastAttackActionPoint = 999;
    }

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Bow))
		{
			return true;
		}
		return false;
	}
});


this.el_cold_lie_cashing_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.cold_lie_cashing";
		this.m.Name = "Cold Lie Cashing(Two-Handed Spear)";
		this.m.Description = "The cold and cold awn condenses without emitting.";//冷冽的寒芒凝而不发
		this.m.Icon = "el_entrys/el_cold_lie_cashing_entry.png";
		//this.m.IconMini = "el_cold_lie_cashing_entry_mini";
		this.m.Overlay = "el_cold_lie_cashing_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Each friendly within the attack range increases your attack damage by " + this.Const.EL_Rarity_Entry.Factor.EL_ColdLieCashing.DamageMultFactor * 100 + "%.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When an enemy within the attack range is attacked, you can launch a pursuit towards them.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Two-Handed Spear to take effect.[/color]"
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
		if (EL_isUsable())
		{
			local ally_num = 0;
			local user = this.getContainer().getActor();
			local my_tile = user.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(user.getFaction());

			foreach( actor in actors )
			{
				if (actor.getID() == user.getID())
				{
					continue;
				}
				if (my_tile.getDistanceTo(actor.getTile()) > _skill.m.MaxRange)
				{
					continue;
				}
				if (actor.getFaction() == user.getFaction())
				{   
					++ally_num;
				}
			}
			_hitInfo.DamageRegular *= 1.0 + ally_num * this.Const.EL_Rarity_Entry.Factor.EL_ColdLieCashing.DamageMultFactor;
			_hitInfo.DamageArmor *= 1.0 + ally_num * this.Const.EL_Rarity_Entry.Factor.EL_ColdLieCashing.DamageMultFactor;
		}
	}

	function onNewRound()
	{
		local user = this.getContainer().getActor();
		local actors = this.Tactical.Entities.getInstancesOfFaction(user.getFaction());
		local pursuit_skill = this.Const.EL_Rarity_Entry.EL_getAttackSkill(user);

		foreach( actor in actors )
		{
			if (actor.getID() == user.getID())
			{
				continue;
			}
			if (actor.getFaction() == user.getFaction())
			{   
				local skills = actor.getSkills().getAllSkillsByID("el_rarity_effects.pursuit");
				local is_add = true;
				foreach(skill in skills)
				{
					if(skill.EL_getPursuitSkill() == pursuit_skill && skill.EL_getSourceActor() == user)
					{
						is_add = false;
						break;
					}
				}
				if(is_add)
				{
					local effect = this.new("scripts/skills/el_effects/el_pursuit_effect");
					effect.EL_setSourceActorAndAttackSkill(user, pursuit_skill);
					actor.getSkills().add(effect);
				}
			}
		}
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.TwoHanded) && item.isWeaponType(this.Const.Items.WeaponType.Spear))
		{
			return true;
		}
		return false;
	}
});
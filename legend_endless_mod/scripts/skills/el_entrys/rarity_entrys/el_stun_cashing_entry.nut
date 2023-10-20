this.el_stun_cashing_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_replacedSkills = []
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.stun_cashing";
		this.m.Name = "Stun Cashing(Polemace)";
		this.m.Description = "Sitting in the midfield, stabilizing the overall controller.";//坐镇中场，稳固全局的控制者
		this.m.Icon = "el_entrys/el_stun_cashing_entry.png";
		//this.m.IconMini = "el_stun_cashing_entry_mini";
		this.m.Overlay = "el_stun_cashing_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Merge and strengthen skills.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Cause additional fatigue damage equivalent to " + this.Const.EL_Rarity_Entry.Factor.EL_StunCashing.FatigueDamageMult * 100 +"% times health damage.[/color]"
			},
			{
				id = 6,
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
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Polemace to take effect.[/color]"
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
			local fatigue_damage = _damageInflictedHitpoints * this.Const.EL_Rarity_Entry.Factor.EL_StunCashing.FatigueDamageMult;
			this.applyFatigueDamage(_targetEntity, fatigue_damage);
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

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			this.Const.EL_Rarity_Entry.EL_ReplaceSkill(this.getContainer().getActor(), this.m.EL_replacedSkills, this.Const.EL_Rarity_Entry.Factor.EL_StunCashing.ReplaceSkillList);
			this.getContainer().add(this.new("scripts/skills/el_actives/el_stun_cashing_skill"));
		}
		else
		{
			this.m.EL_replacedSkills.clear();
			this.getContainer().removeByID("el_rarity_actives.stun_cashing_skill");
		}
	}

	function onRemoved()
	{
		this.Const.EL_Rarity_Entry.EL_ReturnSkill(this.getContainer().getActor(), this.m.EL_replacedSkills);
		this.getContainer().removeByID("el_rarity_actives.stun_cashing_skill");
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.TwoHanded) && item.isWeaponType(this.Const.Items.WeaponType.Mace) && item.getRangeMax() != 1)
		{
			return true;
		}
		return false;
	}
});
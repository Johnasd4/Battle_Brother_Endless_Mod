this.el_the_power_of_unity_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_IsExtraAttack = false,
		EL_replacedSkills = []
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.the_power_of_unity";
		this.m.Name = "The Power of Unity(Polearm)";
		this.m.Description = "Unity makes us invincible!";//团结使我们战无不胜
		this.m.Icon = "el_entrys/el_the_power_of_unity_entry.png";
		//this.m.IconMini = "el_the_power_of_unity_entry_mini";
		this.m.Overlay = "el_the_power_of_unity_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When attacking, carry out an additional attack on the target with all friendly forces within the attack range that can attack the target.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Polearm to take effect.[/color]"
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
			EL_ChainAttack(_targetEntity);
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			EL_ChainAttack(_targetEntity);
		}
	}

	function EL_ChainAttack( _targetEntity )
	{
		if(!this.m.EL_IsExtraAttack)
		{
			this.m.EL_IsExtraAttack = true;
			local user = this.getContainer().getActor();
			local my_tile = user.getTile();
			local target_tile = _targetEntity.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(user.getFaction());
			local attack_skill = this.Const.EL_Rarity_Entry.EL_getAttackSkill(user);

			foreach( actor in actors )
			{
				if (actor.getID() == user.getID())
				{
					continue;
				}
				if (my_tile.getDistanceTo(actor.getTile()) > attack_skill.m.MaxRange)
				{
					continue;
				}
				if(actor.getSkills().hasSkill("effects.stunned") || actor.getCurrentProperties().IsStunned)
				{
					return;
				}
				if (actor.getFaction() == user.getFaction())
				{   
					if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
					{
						continue;
					}
					local skill = this.Const.EL_Rarity_Entry.EL_getAttackSkill(actor);
					if(skill == null)
					{
						continue
					}
					if(target_tile.getDistanceTo(actor.getTile()) <= skill.m.MaxRange)
					{
						skill.useForFree(target_tile);
					}
				}
			}
		}
		this.m.EL_IsExtraAttack = false;
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Polearm))
		{
			return true;
		}
		return false;
	}
});


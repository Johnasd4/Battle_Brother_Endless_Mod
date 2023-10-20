this.el_take_away_by_force_or_trickery_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_IsExtraAttack = false,
		EL_replacedSkills = []
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.take_away_by_force_or_trickery";
		this.m.Name = "Take Away by Force or Trickery(Whip)";
		this.m.Description = "An ominous aura lingers on the Whip, and its enemies will suffer unimaginable pain and torment.";//不详的气息在匕首上萦绕，它的敌人将遭受难以想象的痛楚与折磨
		this.m.Icon = "el_entrys/el_take_away_by_force_or_trickery_entry.png";
		//this.m.IconMini = "el_take_away_by_force_or_trickery_entry_mini";
		this.m.Overlay = "el_take_away_by_force_or_trickery_entry";
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
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Simultaneously attack all enemies within range.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Whip to take effect.[/color]"
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
            this.EL_attackAllEnemies(_skill, _targetEntity);
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
            this.EL_attackAllEnemies(_skill, _targetEntity);
		}
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			this.Const.EL_Rarity_Entry.EL_ReplaceSkill(this.getContainer().getActor(), this.m.EL_replacedSkills, this.Const.EL_Rarity_Entry.Factor.EL_TakeAwayByForceOrTrickery.ReplaceSkillList);
			this.getContainer().add(this.new("scripts/skills/el_actives/el_take_away_by_force_or_trickery_skill"));
		}
		else
		{
			this.m.EL_replacedSkills.clear();
			this.getContainer().removeByID("el_rarity_actives.take_away_by_force_or_trickery_skill");
		}
	}

	function onRemoved()
	{
		this.Const.EL_Rarity_Entry.EL_ReturnSkill(this.getContainer().getActor(), this.m.EL_replacedSkills);
		this.getContainer().removeByID("el_rarity_actives.take_away_by_force_or_trickery_skill");
	}

	function EL_attackAllEnemies(_skill, _targetEntity)
	{
        local actor = this.getContainer().getActor();
        if(!this.m.EL_IsExtraAttack) {
            local targets = this.Tactical.Entities.getAllInstances();
            this.m.EL_IsExtraAttack = true;
            local affect_targets = [];
            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if(!t.isAlliedWith(actor) && actor.getTile().getDistanceTo(t.getTile()) <= _skill.m.MaxRange) {
                        affect_targets.push(t);
                    }
                }
            }
            for(local i = 0; i < affect_targets.len(); ++i) {
                if (actor.getFatigue() + _skill.getFatigueCost() * this.Const.EL_Rarity_Entry.Factor.EL_TakeAwayByForceOrTrickery.ExtraAttackFatigueCostFactor <= actor.getFatigueMax())
                {
                    if(affect_targets[i] != null && !affect_targets[i].isDying() && affect_targets[i].isAlive()) {
                        _skill.useForFree(affect_targets[i].getTile());
                    }
                    actor.setFatigue(actor.getFatigue() + _skill.getFatigueCost() * this.Const.EL_Rarity_Entry.Factor.EL_TakeAwayByForceOrTrickery.ExtraAttackFatigueCostFactor);
                }
            }
            this.m.EL_IsExtraAttack = false;
        }
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Whip))
		{
			return true;
		}
		return false;
	}
});


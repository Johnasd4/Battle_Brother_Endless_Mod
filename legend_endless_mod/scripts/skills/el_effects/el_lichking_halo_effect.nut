this.el_lichking_halo_effect <- this.inherit("scripts/skills/skill", {
	m = {
    },
	function create()
	{
		this.m.ID = "el_effects.lichking_halo";
		this.m.Name = "死亡灵气";
		this.m.Description = "被巫妖王身上散发的强烈死气所影响，亡灵生物受此效果影响翻倍。";
		this.m.Icon = "ui/perks/perk_bod.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
        local ret = [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            }
        ];
        if(EL_getMeleeSkillBonus() > 0) {
            ret.push({
                id = 13,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ EL_getMeleeSkillBonus() + "[/color] Melee Skill"
            });
        }
        if(EL_getRangedSkillBonus() > 0) {
            ret.push({
                id = 14,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ EL_getRangedSkillBonus() + "[/color] Ranged Skill"
            });
        }
        if(EL_getMeleeDefenseBonus() > 0) {
            ret.push({
            id = 15,
            type = "text",
            icon = "ui/icons/melee_defense.png",
            text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ EL_getMeleeDefenseBonus() + "[/color] Melee Defense"
        });
        }
        if(EL_getRangedDefenseBonus() > 0) {
            ret.push({
            id = 16,
            type = "text",
            icon = "ui/icons/ranged_defense.png",
            text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ EL_getRangedDefenseBonus() + "[/color] Ranged Defense"
        });
        }
        return ret;
	}

    function EL_isUsable()
    {
        local target = EL_getSourceActor();
        local actor = this.getContainer().getActor();
        if(target == null)
        {
            return false;
        }
		if(_actor.getSkills().hasSkill("el_trait.undead"))
		{
			return true;
		}
		foreach(valid_type in this.Const.EL_Weapon.EL_Entry.Factor.EL_SpecialAttackUndead.ValidEntity)
		{
			if(_actor.getType() == valid_type)
			{
				return true;
			}
		}
        return false;
    }

    function EL_isUndead( _actor )
    {
		if(_actor.getSkills().hasSkill("el_trait.undead"))
		{
			return true;
		}
		foreach(valid_type in this.Const.EL_Weapon.EL_Entry.Factor.EL_SpecialAttackUndead.ValidEntity)
		{
			if(_actor.getType() == valid_type)
			{
				return true;
			}
		}
        return false;
    }

    function EL_getMeleeSkillBonus()
    {
        local target = EL_getSourceActor();
        local actor = this.getContainer().getActor();
        if(target == null)
        {
            return 0;
        }
        local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local melee_skill_need = 10;
        local melee_skill = target.getCurrentProperties().getMeleeSkill();
        local bonus = 0;
        while(melee_skill > melee_skill_need)
        {
            ++bonus;
            melee_skill -= melee_skill_need;
            melee_skill_need += 10;
        }
        local result = this.Math.floor((bonus + melee_skill / melee_skill_need) * this.Const.EL_LichKing.Armor.Halo.MeleeSkillOffset);
        if(!actor.isAlliedWith(target))
        {
            result *= -1;
        }
        return EL_isUndead(actor) ? 2 * result : result;
    }

    function EL_getRangedSkillBonus()
    {
        local target = EL_getSourceActor();
        local actor = this.getContainer().getActor();
        if(target == null)
        {
            return 0;
        }
        local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local ranged_skill_need = 10;
        local ranged_skill = target.getCurrentProperties().getRangedSkill();
        local bonus = 0;
        while(ranged_skill > ranged_skill_need)
        {
            ++bonus;
            ranged_skill -= ranged_skill_need;
            ranged_skill_need += 10;
        }
        local result = this.Math.floor((bonus + ranged_skill / ranged_skill_need) * this.Const.EL_LichKing.Armor.Halo.RangedSkillOffset);
        if(!actor.isAlliedWith(target))
        {
            result *= -1;
        }
        return EL_isUndead(actor) ? 2 * result : result;
    }

    function EL_getMeleeDefenseBonus()
    {
        local target = EL_getSourceActor();
        local actor = this.getContainer().getActor();
        if(target == null)
        {
            return 0;
        }
        local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local melee_defense_need = 10;
        local melee_defense = target.getCurrentProperties().getMeleeDefense();
        local bonus = 0;
        while(melee_defense > melee_defense_need)
        {
            ++bonus;
            melee_defense -= melee_defense_need;
            melee_defense_need += 10;
        }
        local result = this.Math.floor((bonus + melee_defense / melee_defense_need) * this.Const.EL_LichKing.Armor.Halo.MeleeDefenseOffset);
        if(!actor.isAlliedWith(target))
        {
            result *= -1;
        }
        return EL_isUndead(actor) ? 2 * result : result;
    }

    function EL_getRangedDefenseBonus()
    {
        local target = EL_getSourceActor();
        local actor = this.getContainer().getActor();
        if(target == null)
        {
            return 0;
        }
        local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local ranged_defense_need = 10;
        local ranged_defense = target.getCurrentProperties().getRangedDefense();
        local bonus = 0;
        while(ranged_defense > ranged_defense_need)
        {
            ++bonus;
            ranged_defense -= ranged_defense_need;
            ranged_defense_need += 10;
        }
        local result = this.Math.floor((bonus + ranged_defense / ranged_defense_need) * this.Const.EL_LichKing.Armor.Halo.RangedDefenseOffset);
        if(!actor.isAlliedWith(target))
        {
            result *= -1;
        }
        return EL_isUndead(actor) ? 2 * result : result;
    }

    function EL_getSourceActor()
    {
        local actor = this.getContainer().getActor();
        if (!actor.isPlacedOnMap() || ("State" in this.Tactical) && this.Tactical.State.isBattleEnded())
        {
            return null;
        }
        local targets = this.Tactical.Entities.getAllInstances();

        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if (t == null || t.getID() == actor.getID() || t.isDying() || !t.isAlive())
                {
                    continue;
                }
                local skills = t.getSkills()

                local items = t.getItems();
                local armor = items == null ? null : items.getItemAtSlot(this.Const.ItemSlot.Body);
                if (armor != null && armor.getID() == "el_armor.body.ice_armor" && actor.getTile().getDistanceTo(t.getTile()) <= armor.EL_getSkillRange())
                {
                    return t;
                }
            }
        }
        return null;
    }

	function onUpdate( _properties )
	{
        _properties.MeleeSkill += EL_getMeleeSkillBonus();
        _properties.RangedSkill += EL_getRangedSkillBonus();
        _properties.MeleeDefense += EL_getMeleeDefenseBonus();
        _properties.RangedDefense += EL_getRangedDefenseBonus();
	}

	function onAfterUpdate( _properties )
	{
		if (EL_getMeleeSkillBonus() > 0)
		{
            this.m.Name = "死亡灵气(增幅)";
			this.m.IsHidden = false;
		}
		else if (EL_getMeleeSkillBonus() < 0)
		{
            this.m.Name = "死亡灵气(震慑)";
			this.m.IsHidden = false;
		}
        else
		{
			this.m.IsHidden = true;
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsHidden = true;
	}
});
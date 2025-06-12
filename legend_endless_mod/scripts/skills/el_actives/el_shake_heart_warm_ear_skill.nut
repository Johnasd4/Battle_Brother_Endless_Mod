this.el_shake_heart_warm_ear_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_actives.shake_heart_warm_ear_skill";
		this.m.Name = "感心动耳";
		this.m.Description = "轻柔的音乐可以减轻疼痛。";
		this.m.Icon = "el_skills/shake_heart_warm_ear_skill.png";
		this.m.IconDisabled = "el_skills/shake_heart_warm_ear_skill_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/wardrums_01.wav",
			"sounds/enemies/dlc4/wardrums_02.wav",
			"sounds/enemies/dlc4/wardrums_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillActionPointCost;
		this.m.FatigueCost = this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillFatigueCost;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getDefaultUtilityTooltip();
		tooltip.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/locked_small.png",
				text = "随机清除友军一项负面效果或临时伤残。"
			}
		]);
		return tooltip;
	}

	function onUse( _user, _targetTile )
	{
		local my_tile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( actor in actors )
		{
			if (actor.getID() == _user.getID())
			{
				continue;
			}

			if (my_tile.getDistanceTo(actor.getTile()) > this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillRange)
			{
				continue;
			}

			if (actor.getFaction() == _user.getFaction())
			{   
				local skills = actor.getSkills();
				local index_pool = [];
				for(local i = 0; i < skills.m.Skills.len(); ++i)
				{
					if(this.Const.EL_Rarity_Entry.EL_isNegativeEffect(skills.m.Skills[i]) || skills.m.Skills[i].isType(this.Const.SkillType.TemporaryInjury) )
					{
						index_pool.push(i);
					}
				}
				if(index_pool.len() != 0)
				{
					local r = this.Math.rand(0, index_pool.len() - 1);
					skills.remove(skills.m.Skills[index_pool[r]]);
				}
			}
		}
        this.m.IsUsable = false;
		return true;
	}

    function onTurnStart()
    {
        this.m.IsUsable = true;
    }
});


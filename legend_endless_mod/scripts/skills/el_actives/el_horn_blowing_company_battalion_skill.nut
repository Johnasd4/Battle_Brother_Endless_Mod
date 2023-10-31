this.el_horn_blowing_company_battalion_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_actives.horn_blowing_company_battalion_skill";
		this.m.Name = "吹角连营";
		this.m.Description = "激昂的乐曲能唤醒战意。";
		this.m.Icon = "el_skills/horn_blowing_company_battalion_skill.png";
		this.m.IconDisabled = "el_skills/horn_blowing_company_battalion_skill_sw.png";
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
				text = "提升 " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageMult * 100 + "% 攻击伤害, 减少 " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.DamageReceivedMult * 100 + "% 受到伤害。"
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
				actor.getSkills().add(this.new("scripts/skills/el_effects/el_horn_blowing_company_battalion_effect"));
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


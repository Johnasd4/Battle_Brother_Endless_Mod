this.el_octave_play_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_actives.octave_play_skill";
		this.m.Name = "八音叠奏";
		this.m.Description = "舒缓的音乐可以缓解疲劳。";
		this.m.Icon = "el_skills/octave_play_skill.png";
		this.m.IconDisabled = "el_skills/octave_play_skill_sw.png";
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
				text = "恢复友军 " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.FatigueRecover + "疲劳和 " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.HitpointsRecoverPercent * 100 + "%生命。"
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
				actor.setHitpointsPct(this.Math.minf(1.0, actor.getHitpointsPct() + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.HitpointsRecoverPercent));
				actor.setFatigue(this.Math.max(0, actor.getFatigue() - this.Math.round(actor.getFatigueMax() * this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.FatigueRecover)));
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


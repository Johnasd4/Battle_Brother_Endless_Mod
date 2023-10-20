this.el_generous_and_sad_songs_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_actives.generous_and_sad_songs_skill";
		this.m.Name = "Generous and Sad Songs";
		this.m.Description = "Generous music can elevate one's state.";
		this.m.Icon = "el_skills/generous_and_sad_songs_skill.png";
		this.m.IconDisabled = "el_skills/generous_and_sad_songs_skill_sw.png";
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
				text = "Improve ally " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.InitiativeOffset + " Initiative, " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeSkillOffset + " Melee Skill, " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedSkillOffset + " Ranged Skill, " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.MeleeDefenseOffset + " Melee Defense, " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.RangedDefenseOffset + " Ranged Defense."
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
				actor.getSkills().add(this.new("scripts/skills/el_effects/el_generous_and_sad_songs_effect"));
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


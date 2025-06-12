this.el_lichking_strengthen_effect <- this.inherit("scripts/skills/skill", {
	m = { },
	function create()
	{
		this.m.ID = "el_effect.lichking_strengthen";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsHidden = true;
	}
});


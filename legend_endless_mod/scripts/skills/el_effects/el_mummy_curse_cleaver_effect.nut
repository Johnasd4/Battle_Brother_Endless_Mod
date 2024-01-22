this.el_mummy_curse_cleaver_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_effect.mummy_curse_cleaver";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying() || !_skill.m.IsWeaponSkill)
		{
			return;
		}
		local bonus = 0;
		if(_targetEntity.getSkills().getSkillByID("effects.mummy_curse") != null)
		{
			bonus = _targetEntity.getSkills().getSkillByID("effects.mummy_curse").getBonus() * 0.01;
		}
		_hitInfo.DamageRegular *= 1.0 + bonus;
		_hitInfo.DamageArmor *= 1.0 + bonus;
	}
});


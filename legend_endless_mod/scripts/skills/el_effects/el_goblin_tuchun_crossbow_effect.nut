this.el_goblin_tuchun_crossbow_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_effect.goblin_tuchun_crossbow";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
        local user = this.getContainer().getActor();
        if (user == null || !user.isAlive() || user.isDying())
        {
            return;
        }
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.getTile().getDistanceTo(user.getTile()) <= _targetEntity.getCurrentProperties().getVision())
		{
			return;
		}
		_hitInfo.DamageArmor *= 2;
		_hitInfo.DamageRegular *= 2;
	}
});


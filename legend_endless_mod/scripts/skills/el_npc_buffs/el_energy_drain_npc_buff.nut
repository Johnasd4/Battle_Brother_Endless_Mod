this.el_energy_drain_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.energy_drain";
		this.m.Name = "Energy Drain";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.isAlive() && !_targetEntity.isDying() || _targetEntity.getHitpoints() <= 0 || !_targetEntity.isAlive());
		{
			return;
		}
        Target.
	}

});


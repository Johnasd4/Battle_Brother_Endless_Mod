this.el_combo_attack_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.combo_attack";
		this.m.Name = "Combo Attack";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.Chance[this.m.EL_RankLevel]) {
            _skill.useForFree(_targetEntity.getTile());
        }
	}

	function onTargetMissed( _skill, _targetEntity )
	{
        if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.Chance[this.m.EL_RankLevel]) {
            _skill.useForFree(_targetEntity.getTile());
        }
	}

});


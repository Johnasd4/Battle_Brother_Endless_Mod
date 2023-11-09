this.el_combo_attack_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
		EL_IsComboAttack = false,
		EL_ExtraAttackTimes = 0
	},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.combo_attack";
		this.m.Name = "连击";
		this.m.Description = "";
		this.m.EL_ExtraAttackTimes = this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.AttackTimes[this.m.EL_RankLevel];
	}

	function EL_comboAttack(_skill, _targetEntity)
	{
		local user = this.getContainer().getActor();
        if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			this.m.EL_IsComboAttack = false;
			this.m.EL_ExtraAttackTimes = this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.AttackTimes[this.m.EL_RankLevel];
			return;
		}
		if(!this.m.EL_IsComboAttack)
		{
			this.m.EL_IsComboAttack = true;
			if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.Chance[this.m.EL_RankLevel]) {
				for(local i = 0; i < this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.AttackTimes[this.m.EL_RankLevel]; ++i) {
					if (_targetEntity != null && !_targetEntity.isDying() && _targetEntity.isAlive()) {
						if (user != null && !user.isDying() && user.isAlive()) {
							_skill.useForFree(_targetEntity.getTile());
						}
					}
					else {
						this.m.EL_IsComboAttack = false;
						this.m.EL_ExtraAttackTimes = this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.AttackTimes[this.m.EL_RankLevel];
					}
				}
			}
		}
		else{
			--this.m.EL_ExtraAttackTimes;
			if(this.m.EL_ExtraAttackTimes == 0)
			{
				this.m.EL_IsComboAttack = false;
				this.m.EL_ExtraAttackTimes = this.Const.EL_NPC.EL_NPCBuff.Factor.ComboAttack.AttackTimes[this.m.EL_RankLevel];
			}
		}
	}

	function EL_onOtherSkillUesd( _skill, _targetEntity )
	{
        EL_comboAttack(_skill, _targetEntity);
	}

	// function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	// {
	// 	EL_comboAttack(_skill, _targetEntity);
	// }

	// function onTargetMissed( _skill, _targetEntity )
	// {
	// 	EL_comboAttack(_skill, _targetEntity);
	// }

});
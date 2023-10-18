this.el_concentrate_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
		EL_Stack = 0,
		EL_LastAttackTarget = null
	},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.concentrate";
		this.m.Name = "Concentrate";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if(this.m.EL_LastAttackTarget != _targetEntity) {
			this.m.EL_LastAttackTarget = this.WeakTableRef(_targetEntity);
			this.m.EL_Stack = 0;
		}
		++this.m.EL_Stack;
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if(this.m.EL_LastAttackTarget != _targetEntity) {
			this.m.EL_LastAttackTarget = this.WeakTableRef(_targetEntity);
			this.m.EL_Stack = 0;
		}
		++this.m.EL_Stack;
	}

	function EL_reset() {
		this.m.EL_Stack = 0;
		this.m.EL_LastAttackTarget = null;
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_Stack != 0) {
			this.m.Name = "Concentrate(x" + this.m.EL_Stack + ")";
		}
		else {
			this.m.Name = "Concentrate";
		}
        _properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Concentrate.MeleeSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Concentrate.RangedSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
	}

});


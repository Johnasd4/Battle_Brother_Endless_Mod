this.el_poisoned_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.poisoned";
		this.m.Name = "Poisoned";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        local user = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.Poisoned.Chance[this.m.EL_RankLevel]) {

            local poison_num_left = this.Const.EL_Config.EL_addPoisonsToActor(_targetEntity, this.Const.EL_NPC.EL_NPCBuff.Factor.Poisoned.PoisonNum[this.m.EL_RankLevel]);
            this.Const.EL_Config.EL_addPoisonsToActorNoRepeatCheck(_targetEntity, poison_num_left);
        }
	}

});


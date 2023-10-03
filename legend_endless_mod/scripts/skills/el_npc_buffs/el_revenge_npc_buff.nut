this.el_revenge_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_Stack = 0
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.revenge";
		this.m.Name = "Revenge";
		this.m.Description = "";
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
        ++this.m.EL_Stack;
        this.getContainer().getActor().getSkills().update();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        this.m.EL_Stack = 0;
        this.getContainer().getActor().getSkills().update();
	}

	function onUpdate( _properties )
	{
		if(this.m.EL_Stack != 0) {
			this.m.Name = "Revenge(x" + this.m.EL_Stack + ")";
		}
		else {
			this.m.Name = "Revenge";
		}
        _properties.DamageDirectMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Revenge.DamageMultPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;

    }

});


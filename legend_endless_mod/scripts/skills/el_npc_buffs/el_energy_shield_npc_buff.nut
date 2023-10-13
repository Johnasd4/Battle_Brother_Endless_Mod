this.el_energy_shield_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_Stack = 0
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.energy_shield";
		this.m.Name = "Energy Shield";
		this.m.Description = "";
	}

	function onTurnStart()
	{
        this.m.EL_Stack = this.Math.minf(this.m.EL_Stack + this.Const.EL_NPC.EL_NPCBuff.Factor.EnergyShield.MaxStack[this.m.EL_RankLevel] * this.Const.EL_NPC.EL_NPCBuff.Factor.EnergyShield.StackRecoverPersentPurTurn,
                                         this.Const.EL_NPC.EL_NPCBuff.Factor.EnergyShield.MaxStack[this.m.EL_RankLevel]);
	}

    function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
    {
        if(this.m.EL_Stack >= 1) {
            _properties.DamageReceivedTotalMult = 0;
            --this.m.EL_Stack;
        }
    }

    function onUpdate( _properties )
    {
		if(this.m.EL_Stack != 0) {
			this.m.Name = "Energy Shield(x" + this.Math.floor(this.m.EL_Stack) + ")";
		}
		else {
			this.m.Name = "Energy Shield";
		}
    }


});


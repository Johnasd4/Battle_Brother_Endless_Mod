this.el_evasion_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buffs", {
	m = {
        EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Evasion.RangeState
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.evasion";
		this.m.Name = "Evasion";
		this.m.Description = "";
	}

	function onCombatStarted()
	{
        this.m.EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Evasion.RangeState;
        this.getContainer().getActor().getSkills().update();
	}

	function onTurnStart()
	{
        if(this.m.EL_DefenseState == this.Const.EL_NPC.EL_NPCBuff.Evasion.MeleeState) {
            this.m.EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Evasion.RangeState;
        }
        else {
            this.m.EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Evasion.MeleeState;
        }
        this.getContainer().getActor().getSkills().update();
	}


	function onUpdate( _properties )
	{
        if(this.m.DefenseState == this.Const.EL_NPC.EL_NPCBuff.Evasion.MeleeState) {
            _properties.MeleeDefense += this.Const.EL_NPC.EL_NPCBuff.Evasion.DefenseOffset[this.m.EL_RankLevel];
        }
        else {
            _properties.RangedDefense += this.Const.EL_NPC.EL_NPCBuff.Evasion.DefenseOffset[this.m.EL_RankLevel];
        }
    }

});


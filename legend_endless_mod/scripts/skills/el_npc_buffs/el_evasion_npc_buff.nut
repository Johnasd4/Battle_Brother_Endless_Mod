this.el_evasion_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.RangeState
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.evasion";
		this.m.Name = "Evasion";
		this.m.Description = "";
	}

	function onTurnStart()
	{
        if(this.m.EL_DefenseState == this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.MeleeState) {
            this.m.EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.RangeState;
        }
        else {
            this.m.EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.MeleeState;
        }
        this.getContainer().getActor().getSkills().update();
	}


	function onUpdate( _properties )
	{
        if(this.m.EL_DefenseState == this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.MeleeState) {
            _properties.MeleeDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffset[this.m.EL_RankLevel] * this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffsetSelectedMult;
            _properties.RangedDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffset[this.m.EL_RankLevel];
            this.m.Name = "Evasion(Melee)";
        }
        else {
            _properties.MeleeDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffset[this.m.EL_RankLevel];
            _properties.RangedDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffset[this.m.EL_RankLevel] * this.Const.EL_NPC.EL_NPCBuff.Factor.Evasion.DefenseOffsetSelectedMult;
            this.m.Name = "Evasion(Ranged)";
        }
    }

});


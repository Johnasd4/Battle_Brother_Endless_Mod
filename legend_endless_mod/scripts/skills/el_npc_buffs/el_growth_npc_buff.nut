this.el_growth_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_Stack = 0
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.growth";
		this.m.Name = "成长";
		this.m.Description = "";
	}

	function onTurnStart()
	{
        ++this.m.EL_Stack;
        this.getContainer().getActor().getSkills().update();
	}


	function onUpdate( _properties )
	{
		if(this.m.EL_Stack != 0) {
			this.m.Name = "成长(x" + this.m.EL_Stack + ")";
		}
		else {
			this.m.Name = "成长";
		}
        _properties.DamageDirectMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.DamageMultPurStack[this.m.EL_RankLevel] * this.m.EL_Stack;
        _properties.DamageReceivedTotalMult *= 1 / (1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.DamageReceivedMultPurStack[this.m.EL_RankLevel] * this.m.EL_Stack);

        _properties.MeleeSkill += this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.MeleeSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack);
        _properties.RangedSkill += this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.RangedSkillOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack);
        _properties.MeleeDefense += this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.MeleeDefenseOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack);
        _properties.RangedDefense += this.Math.round(this.Const.EL_NPC.EL_NPCBuff.Factor.Growth.RangedDefenseOffsetPurStack[this.m.EL_RankLevel] * this.m.EL_Stack);
    }

	function EL_reset() {
		this.m.EL_Stack = 0;
	}

});


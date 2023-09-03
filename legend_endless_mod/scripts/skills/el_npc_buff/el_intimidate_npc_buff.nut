this.el_intimidate_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.intimidate";
		this.m.Name = "Intimidate";
		this.m.Description = "";
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Intimidate.MoraleCheckChance[this.m.EL_RankLevel]) {

            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if(!t.isAlliedWith(actor)) {
                        local difficulty = (t.getBravery() - actor.getBravery()) +
                                           this.Const.EL_NPC.EL_NPCBuff.Intimidate.BaseOffset +
                                           this.Const.EL_NPC.EL_NPCBuff.Intimidate.RankFactor * (t.EL_getRankLevel() - actor.EL_getRankLevel()) +
                                           this.Math.pow(this.Const.EL_NPC.EL_NPCBuff.Intimidate.CombatLevelFactor, this.Math.abs(t.EL_getCombatLevel() - actor.EL_getCombatLevel())) * (t.EL_getCombatLevel() - actor.EL_getCombatLevel()) +
                                           this.Math.pow(t.getTile().getDistanceTo(actor.getTile()), this.Const.EL_NPC.EL_NPCBuff.Intimidate.DistanceFactor);
                        this.checkMorale(-1, difficulty);
                    }
                }
            }
        }
	}

});


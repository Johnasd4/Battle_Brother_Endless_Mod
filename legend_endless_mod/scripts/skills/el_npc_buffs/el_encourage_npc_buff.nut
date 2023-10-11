this.el_encourage_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.encourage";
		this.m.Name = "Encourage";
		this.m.Description = "";
	}

	function EL_encourageAllies()
	{
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
        local affect_targets = [];
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if(t!= null && !t.isDying() && t.isAlive() && t.isAlliedWith(actor) && this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.Intimidate.MoraleCheckChance[this.m.EL_RankLevel]) {
                    affect_targets.push(t);
                }
            }
        }
        for(local i = 0; i < affect_targets.len(); ++i) {
            local difficulty = actor.getBravery() +
                               this.Const.EL_NPC.EL_NPCBuff.Factor.Intimidate.BaseOffset -
                               this.Const.EL_NPC.EL_NPCBuff.Factor.Intimidate.RankFactor * (affect_targets[i].EL_getRankLevel() - actor.EL_getRankLevel()) -
                               this.Math.pow(this.Const.EL_NPC.EL_NPCBuff.Factor.Intimidate.CombatLevelFactor, this.Math.abs(affect_targets[i].EL_getCombatLevel() - actor.EL_getCombatLevel())) * (affect_targets[i].EL_getCombatLevel() - actor.EL_getCombatLevel()) -
                               this.Math.pow(affect_targets[i].getTile().getDistanceTo(actor.getTile()), this.Const.EL_NPC.EL_NPCBuff.Factor.Intimidate.DistanceFactor);
            affect_targets[i].checkMorale(1, difficulty);
        }

	}

	function onTurnStart()
	{
        EL_encourageAllies();
    }

	function onUpdate( _properties )
	{
		_properties.Bravery += this.Const.EL_NPC.EL_NPCBuff.Factor.Encourage.BraveryOffset[this.m.EL_RankLevel];
	}

});


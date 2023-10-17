this.el_stunning_strike_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.stunning_strike";
		this.m.Name = "Stunning Strike";
		this.m.Description = "";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        local user = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isAlliedWith(user) || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			return;
		}
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.Factor.StunningStrike.StunChance[this.m.EL_RankLevel]) {
			local stunned_effect = this.new("scripts/skills/effects/stunned_effect");
			_targetEntity.getSkills().add(stunned_effect);
			stunned_effect.setTurns(this.Const.EL_NPC.EL_NPCBuff.Factor.StunningStrike.StunTurns[this.m.EL_RankLevel]);

			if (!user.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " has stunned " + this.Const.UI.getColorizedEntityName(_targetEntity) + " for " +  this.Const.EL_NPC.EL_NPCBuff.Factor.StunningStrike.StunTurns[this.m.EL_RankLevel] + " turn");
			}
        }
	}

});




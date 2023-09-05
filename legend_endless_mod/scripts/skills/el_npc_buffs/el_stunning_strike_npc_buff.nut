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
        if(this.Math.rand(1, 100) <= this.Const.EL_NPC.EL_NPCBuff.StunningStrike.StunChance[this.m.EL_RankLevel] && !_targetEntity.getCurrentProperties().IsImmuneToStun && !_targetEntity.getSkills().hasSkill("effects.stunned")) {
            _targetEntity.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
            local user = this.getContainer().getActor();
			if (!user.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " has stunned " + this.Const.UI.getColorizedEntityName(_targetEntity) + " for one turn");
			}
        }
	}

});




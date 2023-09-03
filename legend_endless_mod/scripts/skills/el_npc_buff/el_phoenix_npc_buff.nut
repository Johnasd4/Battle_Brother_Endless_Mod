this.el_phoenix_npc_buff <- this.inherit("scripts/skills/el_npc_buff/el_npc_buff", {
	m = {
        EL_RiseTimesLeft = 0
        EL_Stack = 0
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buff.phoenix";
		this.m.Name = "Phoenix";
		this.m.Description = "";
	}

	function onCombatStarted()
	{
        this.m.EL_RiseTimesLeft = this.Const.EL_NPC.EL_NPCBuff.Phoenix.RiseTimes[this.m.EL_RankLevel];
        this.m.EL_Stack = 0;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (EL_RiseTimesLeft > 0 && _damageHitpoints > this.getContainer().getActor().getHitpoints())
		{
            --this.m.EL_RiseTimesLeft;
            ++this.m.EL_Stack;
            local actor = this.getContainer().getActor();
            local properties = actor.getCurrentProperties();

            actor.setHitpoints(actor.getHitpointsMax());
            actor.setActionPoints(this.getActionPointsMax());
            actor.setFatigue(0);

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " rised!");
            }
            this.getContainer().getActor().getSkills().update();
		}
	}

	function onUpdate( _properties )
	{
        _properties.DamageDirectMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Growth.DamageMultPurStack * this.m.EL_Stack;
        _properties.DamageReceivedDirectMult *= 1 / (1 + this.Const.EL_NPC.EL_NPCBuff.Growth.DamageReceivedMultPurStack * this.m.EL_Stack);

        _properties.HitpointsMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Phoenix.HitPointsMultPurStack * this.m.EL_Stack;
        _properties.Bravery += this.Const.EL_NPC.EL_NPCBuff.Phoenix.BraveryOffsetPurStack * this.m.EL_Stack;
        _properties.Stamina += this.Const.EL_NPC.EL_NPCBuff.Phoenix.FatigueOffsetPurStack * this.m.EL_Stack;
        _properties.Initiative += this.Const.EL_NPC.EL_NPCBuff.Phoenix.InitiativeOffsetPurStack * this.m.EL_Stack;
        _properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.Phoenix.MeleeSkillOffsetPurStack * this.m.EL_Stack;
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.Phoenix.RangedSkillOffsetPurStack * this.m.EL_Stack;
        _properties.MeleeDefense += this.Const.EL_NPC.EL_NPCBuff.Phoenix.MeleeDefenseOffsetPurStack * this.m.EL_Stack;
        _properties.RangedDefense += this.Const.EL_NPC.EL_NPCBuff.Phoenix.RangedDefenseOffsetPurStack * this.m.EL_Stack;
	}

});


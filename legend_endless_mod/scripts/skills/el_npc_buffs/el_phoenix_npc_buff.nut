this.el_phoenix_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
    m = {
        EL_RiseTimesLeft = 0,
        EL_Stack = 0,
        EL_IsRising = false,
        EL_RisingReset = false,
        EL_MoraleState = 0
    },
    function create()
    {
        this.el_npc_buff.create();
        this.m.ID = "el_npc_buffs.phoenix";
        this.m.Name = "Phoenix";
        this.m.Description = "";
    }

    function EL_setRankLevel(_EL_rankLevel) {
        this.el_npc_buff.EL_setRankLevel(_EL_rankLevel);
        this.m.EL_RiseTimesLeft = this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.RiseTimes[this.m.EL_RankLevel];
    }

	function onAdded()
	{
        local actor = this.getContainer().getActor();
        actor.setIsAbleToDie(false);
	}

	function onTurnStart()
	{
        if(this.m.EL_IsRising) {
            this.m.EL_IsRising = false;
            this.m.EL_RisingReset = true;
            --this.m.EL_RiseTimesLeft;
            ++this.m.EL_Stack;
            local actor = this.getContainer().getActor();
            local properties = actor.getCurrentProperties();
            actor.m.IsAttackable = true;
            if(this.m.EL_RiseTimesLeft == 0) {
                actor.setIsAbleToDie(true);
            }
            local skills = actor.getSkills();
            foreach( skill in skills.m.Skills ) {
                local skill_type = skill.getType();
                if((skill_type == this.Const.SkillType.StatusEffect ||
                    skill_type == this.Const.SkillType.Injury ||
                    skill_type == this.Const.SkillType.PermanentInjury ||
                    skill_type == this.Const.SkillType.TemporaryInjury ||
                    skill_type == this.Const.SkillType.DrugEffect ||
                    skill_type == this.Const.SkillType.SemiInjury ||
                    skill_type == this.Const.SkillType.DamageOverTime) &&
                    !(skill.EL_isNPCBuff()))
                {
                    skills.remove(skill);
                }
            }




            actor.setHitpoints(actor.getHitpointsMax());
            actor.setActionPoints(actor.getActionPointsMax());
            actor.setFatigue(0);
            if(this.m.EL_MoraleState != this.Const.MoraleState.Ignore) {
                actor.m.setMoraleState(this.Const.MoraleState.Confident);
            }
            local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            if(body != null) {
                body.setArmor(body.getArmorMax());
                body.updateAppearance();
            }
            else {
                properties.Armor[this.Const.BodyPart.Body] = properties.ArmorMax[this.Const.BodyPart.Body];
            }

            local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
            if(head != null) {
                head.setArmor(head.getArmorMax());
                head.updateAppearance();
            }
            else {
                properties.Armor[this.Const.BodyPart.Head] = properties.ArmorMax[this.Const.BodyPart.Head];
            }

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " rised!");
            }
            this.getContainer().getActor().getSkills().update();
        }
	}


    function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
    {
        local actor = this.getContainer().getActor();
        if ((this.m.EL_RiseTimesLeft > 0 && _damageHitpoints > actor.getHitpoints()) || actor.getHitpoints() <= 0)
        {
            this.m.EL_IsRising = true;
            local actor = this.getContainer().getActor();
            local properties = actor.getCurrentProperties();
            actor.m.IsAttackable = false;
            actor.setActionPoints(0);
            actor.setFatigue(actor.getFatigueMax());
            this.m.EL_MoraleState = actor.getMoraleState();
            actor.m.MoraleState = this.Const.MoraleState.Ignore;
            local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            if(body != null) {
                body.setArmor(0);
            }
            else {
                properties.Armor[this.Const.BodyPart.Body] = 0;
            }

            local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
            if(head != null) {
                head.setArmor(0);
            }
            else {
                properties.Armor[this.Const.BodyPart.Head] = 0;
            }

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is rising!");
            }
            actor.getSkills().update();
        }
    }

    function onUpdate( _properties )
    {

        if(this.m.EL_IsRising) {
            _properties.IsStunned = true;
        }
        if(this.m.EL_RisingReset == true) {
            this.m.EL_RisingReset = false;
            _properties.IsStunned = false;
        }


        _properties.DamageDirectMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.DamageMultPurStack * this.m.EL_Stack;
        _properties.DamageReceivedTotalMult *= 1 / (1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.DamageReceivedMultPurStack * this.m.EL_Stack);

        _properties.HitpointsMult *= 1 + this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.HitPointsMultPurStack * this.m.EL_Stack;
        _properties.Bravery += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.BraveryOffsetPurStack * this.m.EL_Stack;
        _properties.Stamina += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.FatigueOffsetPurStack * this.m.EL_Stack;
        _properties.Initiative += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.InitiativeOffsetPurStack * this.m.EL_Stack;
        _properties.MeleeSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.MeleeSkillOffsetPurStack * this.m.EL_Stack;
        _properties.RangedSkill += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.RangedSkillOffsetPurStack * this.m.EL_Stack;
        _properties.MeleeDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.MeleeDefenseOffsetPurStack * this.m.EL_Stack;
        _properties.RangedDefense += this.Const.EL_NPC.EL_NPCBuff.Factor.Phoenix.RangedDefenseOffsetPurStack * this.m.EL_Stack;
    }

});


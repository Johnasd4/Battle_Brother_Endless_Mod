this.el_stamp_effect <- this.inherit("scripts/skills/skill", {
	m = {
		EL_Stack = 0
	},

	function create()
	{
		this.m.ID = "el_effects.stamp";
		this.m.Name = "印记";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Icon = "el_skills/stamp_1.png";
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 6,
				type = "text",
				text = "积满5层印记时爆炸，当前层数： " + this.m.EL_Stack
			}
		]);
		return tooltip;
	}

    function EL_addStack( _EL_stackNum, _EL_user )
	{
        this.m.EL_Stack += _EL_stackNum;
		this.m.Icon = "el_skills/stamp_" + this.m.EL_Stack + ".png";
        if(this.m.EL_Stack >= this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.ExplodeStackNum) {
            this.EL_explode(_EL_user);
        }
	}

    function EL_explode(_EL_user)
    {
        local actor = this.getContainer().getActor();
        if(_EL_user == null) {
            _EL_user = actor;
        }
        this.m.EL_Stack -= this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.ExplodeStackNum;
        local targets = this.Tactical.Entities.getAllInstances();
        local damage = this.Math.floor((this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.DamageBase * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.DamageMultPurWorldLevel)));
        local affect_targets = [];
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if(t != null && t.isAlliedWith(actor) && !t.isDying() && t.isAlive()) {
                    local distance = actor.getTile().getDistanceTo(t.getTile());
                    if(distance <= this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.MaxDistance) {
                        affect_targets.push(t);
                    }
                }
            }
        }
        for(local i = 0; i < affect_targets.len(); ++i) {
            if(affect_targets[i]== null || affect_targets[i].isDying() || !affect_targets[i].isAlive()) {
                continue;
            }
            local final_damage = damage;
            if(affect_targets[i]!= null && !affect_targets[i].isDying() && affect_targets[i].isAlive()) {
                local body_hit_info = clone this.Const.Tactical.HitInfo;
                body_hit_info.DamageRegular = final_damage;
                body_hit_info.DamageArmor = final_damage;
                body_hit_info.DamageDirect = 0;
                body_hit_info.BodyPart = this.Const.BodyPart.Body;
                body_hit_info.BodyDamageMult = 1.0;
                body_hit_info.FatalityChanceMult = 0.0;
                affect_targets[i].onDamageReceived(_EL_user, this, body_hit_info);
            }

            if(affect_targets[i]!= null && !affect_targets[i].isDying() && affect_targets[i].isAlive()) {
                local head_hit_info = clone this.Const.Tactical.HitInfo;
                head_hit_info.DamageRegular = final_damage;
                head_hit_info.DamageArmor = final_damage;
                head_hit_info.DamageDirect = 0;
                head_hit_info.BodyPart = this.Const.BodyPart.Head;
                head_hit_info.BodyDamageMult = 1.0;
                head_hit_info.FatalityChanceMult = 0.0;
                affect_targets[i].onDamageReceived(_EL_user, this, head_hit_info);
            }
            if(affect_targets[i]!= null && !affect_targets[i].isDying() && affect_targets[i].isAlive() && affect_targets[i].isAttackable()) {
                local skills = affect_targets[i].getSkills();
                local skill = skills.getSkillByID("el_effects.stamp");
                if(skill == null) {
                    skill = this.new("scripts/skills/el_effects/el_stamp_effect");
                    skills.add(skill);
                }
                skill.EL_addStack(this.Const.EL_NPC.EL_NPCBuff.Factor.Stamp.ExplodeStackGain, _EL_user);
            }
        }

    }

});


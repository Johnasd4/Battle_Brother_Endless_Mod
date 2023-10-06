this.el_total_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_EntryNum = 0,
		EL_HitpointsAddition = 0,
		EL_StaminaAddition = 0,
		EL_BraveryAddition = 0,
		EL_InitiativeAddition = 0,
        EL_MeleeSkillAddition = 0,
        EL_RangedSkillAddition = 0,
        EL_MeleeDefenseAddition = 0,
        EL_RangedDefenseAddition = 0,
		EL_VisionAddition = 0,

        EL_CombatLevelAddition = 0.0,
        EL_ActionPointAddition = 0,
		EL_FatigueRecoverAddition = 0,
		EL_DamageMultAddition = 0.0,
		EL_DamageReceivedMultAddition = 0.0,
		EL_HitpointsRecoveryRateAddition = 0,
        EL_XPGainMultAddition = 0.0,
		EL_VampireRateAddition = 0.0,
		EL_TargetAttractionMultAddition = 0,
		EL_AdditionalAccuracyAddition = 0,
		EL_RangeMaxAddition = 0,
		EL_RangeMaxAndVisionAddition = 0,

		EL_WeaponUseSkillfatigueAddition = 0,
        EL_WeaponConditionRecoverDaliyAddition = 0.0,
        EL_WeaponConditionRecoverRateAddition = 0.0,
		EL_ShieldUseSkillfatigueAddition = 0,
		EL_ShieldConditionRecoverDaliyAddition = 0,
        EL_ShieldConditionRecoverRateAddition = 0.0,
		EL_HelmetConditionRecoverDaliyAddition = 0.0,
        EL_HelmetConditionRecoverRateAddition = 0.0,
		EL_ArmorConditionRecoverDaliyAddition = 0.0,
        EL_ArmorConditionRecoverRateAddition = 0.0,
		
		EL_ImmueBleedingPoisonedFireMiasma = false,
		EL_ImmueGrabKnockTwirl = false,
		EL_ImmueOverwhelmDazed = false,
		EL_ImmueStunRootDisarm = false,
		EL_ImmueSurroundedRiposte = false
	},
	function create()
	{
		this.m.ID = "entry/total_entry",
		this.m.Name = "Entry Cumulative Effect";
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.Icon = "el_entrys/el_total_entry.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onCombatStarted()
	{
		this.m.IsHidden = true;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = false;
	}

    function Init()
	{
		this.m.EL_EntryNum = 0;
		this.m.EL_HitpointsAddition = 0;
		this.m.EL_StaminaAddition = 0;
		this.m.EL_BraveryAddition = 0;
		this.m.EL_InitiativeAddition = 0;
        this.m.EL_MeleeSkillAddition = 0;
        this.m.EL_RangedSkillAddition = 0;
        this.m.EL_MeleeDefenseAddition = 0;
        this.m.EL_RangedDefenseAddition = 0;
		this.m.EL_VisionAddition = 0;

        this.m.EL_CombatLevelAddition = 0.0;
        this.m.EL_ActionPointAddition = 0;
		this.m.EL_FatigueRecoverAddition = 0;
		this.m.EL_DamageMultAddition = 0.0;
		this.m.EL_DamageReceivedMultAddition = 0.0;
		this.m.EL_HitpointsRecoveryRateAddition = 0.0;
        this.m.EL_XPGainMultAddition = 0.0;
		this.m.EL_VampireRateAddition = 0.0;
		this.m.EL_TargetAttractionMultAddition = 0;
		this.m.EL_AdditionalAccuracyAddition = 0;
		this.m.EL_RangeMaxAddition = 0;
		this.m.EL_RangeMaxAndVisionAddition = 0;

		this.m.EL_WeaponUseSkillfatigueAddition = 0;
        this.m.EL_WeaponConditionRecoverDaliyAddition = 0.0;
        this.m.EL_WeaponConditionRecoverRateAddition = 0.0;
		this.m.EL_ShieldUseSkillfatigueAddition = 0;
		this.m.EL_ShieldConditionRecoverDaliyAddition = 0.0;
        this.m.EL_ShieldConditionRecoverRateAddition = 0.0;
		this.m.EL_HelmetConditionRecoverDaliyAddition = 0.0;
        this.m.EL_HelmetConditionRecoverRateAddition = 0.0;
		this.m.EL_ArmorConditionRecoverDaliyAddition = 0.0;
        this.m.EL_ArmorConditionRecoverRateAddition = 0.0;
		
		this.m.EL_ImmueBleedingPoisonedFireMiasma = false;
		this.m.EL_ImmueGrabKnockTwirl = false;
		this.m.EL_ImmueOverwhelmDazed = false;
		this.m.EL_ImmueStunRootDisarm = false;
		this.m.EL_ImmueSurroundedRiposte = false;
	}

	function onRefresh()
	{
        this.Init();
        local skills = this.getContainer().getActor().getSkills();
        foreach( skill in skills.m.Skills ) {
            if( skill.EL_isEntryEffect() )
            {
                skill.EL_refreshTotalEntry(this);
            }
        }
		if(this.m.EL_EntryNum == 0)
		{
			this.removeSelf();
		}
	}

	function onAfterUpdate( _properties )
	{
		this.onRefresh();
	}

    function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		if(this.m.EL_HitpointsAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Hitpoints + " + this.m.EL_HitpointsAddition
			});
		}
		if(this.m.EL_StaminaAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Fatigue + " + this.m.EL_StaminaAddition
			});
		}
		if(this.m.EL_BraveryAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Resolve + " + this.m.EL_BraveryAddition
			});
		}
		if(this.m.EL_InitiativeAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Initiative + " + this.m.EL_InitiativeAddition
			});
		}
		if(this.m.EL_MeleeSkillAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Melee Skill + " + this.m.EL_MeleeSkillAddition
			});
		}
		if(this.m.EL_RangedSkillAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Ranged Skill + " + this.m.EL_RangedSkillAddition
			});
		}
		if(this.m.EL_MeleeDefenseAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Melee Defense + " + this.m.EL_MeleeDefenseAddition
			});
		}
		if(this.m.EL_RangedDefenseAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Ranged Defense + " + this.m.EL_RangedDefenseAddition
			});
		}
		if(this.m.EL_VisionAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Vision + " + this.m.EL_VisionAddition
			});
		}
		if(this.m.EL_CombatLevelAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "CombatLevel + " + this.m.EL_CombatLevelAddition
			});
		}
		if(this.m.EL_ActionPointAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Action Points + " + this.m.EL_ActionPointAddition
			});
		}
		if(this.m.EL_FatigueRecoverAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Fatigue Recovery per turn + " + this.m.EL_FatigueRecoverAddition
			});
		}
		if(this.m.EL_DamageMultAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Attack damage + " + this.m.EL_DamageMultAddition + "%"
			});
		}
		if(this.m.EL_DamageReceivedMultAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Receive Damage - " + this.m.EL_DamageReceivedMultAddition + "%"
			});
		}
		if(this.m.EL_HitpointsRecoveryRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Health Recovery per turn + " + this.m.EL_HitpointsRecoveryRateAddition + "%"
			});
		}
		if(this.m.EL_XPGainMultAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Experience Gain + " + this.m.EL_XPGainMultAddition + "%"
			});
		}
		if(this.m.EL_VampireRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Vampire rate + " + this.m.EL_VampireRateAddition + "%"
			});
		}
		if(this.m.EL_TargetAttractionMultAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Character\' threat + " + this.m.EL_TargetAttractionMultAddition + "%"
			});
		}




		if(this.m.EL_WeaponUseSkillfatigueAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon skills build up " + this.m.EL_WeaponUseSkillfatigueAddition + " less fatigue."
			});
		}
		if(this.m.EL_WeaponConditionRecoverDaliyAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_WeaponConditionRecoverDaliyAddition + "% Weapon Durability"
			});
		}
		if(this.m.EL_WeaponConditionRecoverRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_WeaponConditionRecoverRateAddition + "% Weapon Durability"
			});
		}
		if(this.m.EL_ShieldUseSkillfatigueAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Shield skills build up " + this.m.EL_ShieldUseSkillfatigueAddition + " less fatigue."
			});
		}
		if(this.m.EL_ShieldConditionRecoverDaliyAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_ShieldConditionRecoverDaliyAddition + "% Shield Durability"
			});
		}
		if(this.m.EL_ShieldConditionRecoverRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_ShieldConditionRecoverRateAddition + "% Shield Durability"
			});
		}
		if(this.m.EL_HelmetConditionRecoverDaliyAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_HelmetConditionRecoverDaliyAddition + "% Helmet Durability"
			});
		}
		if(this.m.EL_HelmetConditionRecoverRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_HelmetConditionRecoverRateAddition + "% Helmet Durability"
			});
		}
		if(this.m.EL_ArmorConditionRecoverDaliyAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_ArmorConditionRecoverDaliyAddition + "% Armor Durability"
			});
		}
		if(this.m.EL_ArmorConditionRecoverRateAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_ArmorConditionRecoverRateAddition + "% Armor Durability"
			});
		}
		if(this.m.EL_AdditionalAccuracyAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "chance to hit + " + this.m.EL_AdditionalAccuracyAddition + "%"
			});
		}
		//this.logInfo("EL_RangeMaxAddition" + this.m.EL_RangeMaxAddition);
		if(this.m.EL_RangeMaxAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon Skill range + " + this.m.EL_RangeMaxAddition
			});
		}
		//this.logInfo("EL_RangeMaxAndVisionAddition" + this.m.EL_RangeMaxAndVisionAddition);
		if(this.m.EL_RangeMaxAndVisionAddition)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon Skill range and Vision + " + this.m.EL_RangeMaxAndVisionAddition
			});
		}



		if(this.m.EL_ImmueBleedingPoisonedFireMiasma)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Immune Bleeding, Immune Poisoned, Immune Fire, Immune Miasma"
			});
		}
		if(this.m.EL_ImmueGrabKnockTwirl)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Immune Grab, Immune Knock Back, Immune Twirl"
			});
		}
		if(this.m.EL_ImmueOverwhelmDazed)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Immune Overwhelm, Immune Dazed"
			});
		}
		if(this.m.EL_ImmueStunRootDisarm)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Immune Stun, Immune Root, Immune Disarm"
			});
		}
		if(this.m.EL_ImmueSurroundedRiposte)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Immune Surrounded, Immune Riposte"
			});
		}
		return result;
	}
});
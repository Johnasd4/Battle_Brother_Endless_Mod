this.el_total_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_EntryNum = 0,
		EL_Hitpoints = 0,
		EL_Stamina = 0,
		EL_Bravery = 0,
		EL_Initiative = 0,
        EL_MeleeSkill = 0,
        EL_RangedSkill = 0,
        EL_MeleeDefense = 0,
        EL_RangedDefense = 0,
		EL_Vision = 0,

        EL_CombatLevel = 0.0,
        EL_ActionPoint = 0,
		EL_FatigueRecover = 0,
		EL_EngrgyShieldCombat = 0,
		EL_EngrgyShield = 0,
		EL_DamageMult = 0.0,
		EL_DamageReceivedMult = 0.0,
		EL_HitpointsRecoveryRate = 0,
        EL_XPGainMult = 0.0,
		EL_Vampire = 0.0,
		EL_Curse = 0.0,
		EL_TargetAttractionMult = 1,
		EL_AdditionalAccuracy = 0,
		EL_MeleeRangeMax = 0,
		EL_RangedRangeMax = 0,
		EL_SaveAmmo = 0.0,

		EL_WeaponUseSkillfatigue = 0,
        EL_WeaponConditionRecoverDaliy = 0.0,
        EL_WeaponConditionRecoverRate = 0.0,
		EL_ShieldUseSkillfatigue = 0,
		EL_ShieldConditionRecoverDaliy = 0,
        EL_ShieldConditionRecoverRate = 0.0,
		EL_ShieldDamageReceivedMult = 0.0,
		EL_HelmetConditionRecoverDaliy = 0.0,
        EL_HelmetConditionRecoverRate = 0.0,
		EL_HelmetDamageReceivedMult = 0.0,
		EL_HelmetDamageDirectReceivedMult = 0.0,
		EL_HelmetReflectPercent = 0.0,
		EL_ArmorConditionRecoverDaliy = 0.0,
        EL_ArmorConditionRecoverRate = 0.0,
		EL_ArmorDamageReceivedMult = 0.0,
		EL_ArmorDamageDirectReceivedMult = 0.0,
		EL_ArmorReflectPercent = 0.0,

		EL_CheckMorale = false,
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
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.Icon = "el_entrys/el_total_entry.png";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

    function Init()
	{
		this.m.EL_EntryNum = 0;
		this.m.EL_Hitpoints = 0;
		this.m.EL_Stamina = 0;
		this.m.EL_Bravery = 0;
		this.m.EL_Initiative = 0;
        this.m.EL_MeleeSkill = 0;
        this.m.EL_RangedSkill = 0;
        this.m.EL_MeleeDefense = 0;
        this.m.EL_RangedDefense = 0;
		this.m.EL_Vision = 0;

        this.m.EL_CombatLevel = 0.0;
        this.m.EL_ActionPoint = 0;
		this.m.EL_FatigueRecover = 0;
		this.m.EL_EngrgyShieldCombat = 0;
		this.m.EL_EngrgyShield = 0;
		this.m.EL_DamageMult = 0.0;
		this.m.EL_DamageReceivedMult = 0.0;
		this.m.EL_HitpointsRecoveryRate = 0.0;
        this.m.EL_XPGainMult = 0.0;
		this.m.EL_Vampire = 0.0;
		this.m.EL_Curse = 0.0
		this.m.EL_TargetAttractionMult = 1;
		this.m.EL_AdditionalAccuracy = 0;
		this.m.EL_MeleeRangeMax = 0;
		this.m.EL_RangedRangeMax = 0;
		this.m.EL_SaveAmmo = 0.0;

		this.m.EL_WeaponUseSkillfatigue = 0;
        this.m.EL_WeaponConditionRecoverDaliy = 0.0;
        this.m.EL_WeaponConditionRecoverRate = 0.0;
		this.m.EL_ShieldUseSkillfatigue = 0;
		this.m.EL_ShieldConditionRecoverDaliy = 0.0;
        this.m.EL_ShieldConditionRecoverRate = 0.0;
		this.m.EL_ShieldDamageReceivedMult = 0.0
		this.m.EL_HelmetConditionRecoverDaliy = 0.0;
        this.m.EL_HelmetConditionRecoverRate = 0.0;
		this.m.EL_HelmetDamageReceivedMult = 0.0;
		this.m.EL_HelmetDamageDirectReceivedMult = 0.0;
		this.m.EL_HelmetReflectPercent = 0.0;
		this.m.EL_ArmorConditionRecoverDaliy = 0.0;
        this.m.EL_ArmorConditionRecoverRate = 0.0;
		this.m.EL_ArmorDamageReceivedMult = 0.0;
		this.m.EL_ArmorDamageDirectReceivedMult = 0.0;
		this.m.EL_ArmorReflectPercent = 0.0;

		this.m.EL_CheckMorale = false;
		this.m.EL_ImmueBleedingPoisonedFireMiasma = false;
		this.m.EL_ImmueGrabKnockTwirl = false;
		this.m.EL_ImmueOverwhelmDazed = false;
		this.m.EL_ImmueStunRootDisarm = false;
		this.m.EL_ImmueSurroundedRiposte = false;
	}

	function onAfterUpdate( _properties )
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

    function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		if(this.m.EL_Hitpoints)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Hitpoints + " + this.m.EL_Hitpoints + "%"
			});
		}
		if(this.m.EL_Stamina)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Fatigue + " + this.m.EL_Stamina
			});
		}
		if(this.m.EL_Bravery)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Resolve + " + this.m.EL_Bravery
			});
		}
		if(this.m.EL_Initiative)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Initiative + " + this.m.EL_Initiative
			});
		}
		if(this.m.EL_MeleeSkill)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Melee Skill + " + this.m.EL_MeleeSkill
			});
		}
		if(this.m.EL_RangedSkill)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Ranged Skill + " + this.m.EL_RangedSkill
			});
		}
		if(this.m.EL_MeleeDefense)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Melee Defense + " + this.m.EL_MeleeDefense
			});
		}
		if(this.m.EL_RangedDefense)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Ranged Defense + " + this.m.EL_RangedDefense
			});
		}
		if(this.m.EL_Vision)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Vision + " + this.m.EL_Vision
			});
		}
		if(this.m.EL_CombatLevel)
		{
			result.push({
				id = 10,
				type = "text",
				text = "CombatLevel + " + this.m.EL_CombatLevel
			});
		}
		if(this.m.EL_ActionPoint)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Action Points + " + this.m.EL_ActionPoint
			});
		}
		if(this.m.EL_FatigueRecover)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Fatigue Recovery per turn + " + this.m.EL_FatigueRecover
			});
		}
		if(this.m.EL_EngrgyShield)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Have a engrgy shield with a maximum limit of " + this.m.EL_EngrgyShield + " that will automatically recover"
			});
		}
		if(this.m.EL_DamageMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Attack damage + " + this.m.EL_DamageMult + "%"
			});
		}
		if(this.m.EL_DamageReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Receive Damage - " + this.m.EL_DamageReceivedMult + "%"
			});
		}
		if(this.m.EL_HitpointsRecoveryRate)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Health Recovery per turn + " + this.m.EL_HitpointsRecoveryRate + "%"
			});
		}
		if(this.m.EL_XPGainMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Experience Gain + " + this.m.EL_XPGainMult + "%"
			});
		}
		if(this.m.EL_Vampire)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Vampire + " + this.m.EL_Vampire + "%"
			});
		}
		if(this.m.EL_Curse)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Target hit increases damage taken by " + this.m.EL_Curse + "%"
			});
		}
		if(this.m.EL_TargetAttractionMult > 1)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Character\' threat + " + (this.m.EL_TargetAttractionMult - 1) * 100 + "%"
			});
		}
		else if(this.m.EL_TargetAttractionMult < 1)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Character\' threat - " + (1.0 - this.m.EL_TargetAttractionMult) * 100 + "%"
			});
		}
		if(this.m.EL_AdditionalAccuracy)
		{
			result.push({
				id = 10,
				type = "text",
				text = "chance to hit + " + this.m.EL_AdditionalAccuracy + "%"
			});
		}
		if(this.m.EL_MeleeRangeMax)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon Skill range + " + this.m.EL_MeleeRangeMax
			});
		}
		if(this.m.EL_RangedRangeMax)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon Skill range + " + this.m.EL_RangedRangeMax
			});
		}
		if(this.m.EL_SaveAmmo)
		{
			result.push({
				id = 10,
				type = "text",
				text = this.m.EL_SaveAmmo + "% does not consume ammo"
			});
		}




		if(this.m.EL_WeaponUseSkillfatigue)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Weapon skills build up " + this.m.EL_WeaponUseSkillfatigue + " less fatigue."
			});
		}
		if(this.m.EL_WeaponConditionRecoverDaliy)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_WeaponConditionRecoverDaliy + "% Weapon Durability"
			});
		}
		if(this.m.EL_WeaponConditionRecoverRate)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_WeaponConditionRecoverRate + "% Weapon Durability"
			});
		}
		if(this.m.EL_ShieldUseSkillfatigue)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Shield skills build up " + this.m.EL_ShieldUseSkillfatigue + " less fatigue."
			});
		}
		if(this.m.EL_ShieldConditionRecoverDaliy)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_ShieldConditionRecoverDaliy + "% Shield Durability"
			});
		}
		if(this.m.EL_ShieldConditionRecoverRate)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_ShieldConditionRecoverRate + "% Shield Durability"
			});
		}
		if(this.m.EL_ShieldDamageReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Shield Receive Damage - " + this.m.EL_ShieldDamageReceivedMult
			});
		}
		if(this.m.EL_HelmetConditionRecoverDaliy)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_HelmetConditionRecoverDaliy + "% Helmet Durability"
			});
		}
		if(this.m.EL_HelmetConditionRecoverRate)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_HelmetConditionRecoverRate + "% Helmet Durability"
			});
		}
		if(this.m.EL_HelmetDamageReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Helmet contition receive damage - " + this.m.EL_HelmetDamageReceivedMult + "%"
			});
		}
		if(this.m.EL_HelmetDamageDirectReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Reduces damage ignoring armor by " + this.m.EL_HelmetDamageDirectReceivedMult + "%"
			});
		}
		if(this.m.EL_HelmetReflectPercent)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Reflects " + this.m.EL_HelmetReflectPercent + "% of damage taken in melee back to the attacker in the head area"
			});
		}
		if(this.m.EL_ArmorConditionRecoverDaliy)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Every Day Recover + " + this.m.EL_ArmorConditionRecoverDaliy + "% Armor Durability"
			});
		}
		if(this.m.EL_ArmorConditionRecoverRate)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Each Turn Recover + " + this.m.EL_ArmorConditionRecoverRate + "% Armor Durability"
			});
		}
		if(this.m.EL_ArmorDamageReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Armor contition receive damage - " + this.m.EL_ArmorDamageReceivedMult + "%"
			});
		}
		if(this.m.EL_ArmorDamageDirectReceivedMult)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Reduces body damage ignoring armor by " + this.m.EL_ArmorDamageDirectReceivedMult + "%"
			});
		}
		if(this.m.EL_ArmorReflectPercent)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Reflects " + this.m.EL_ArmorReflectPercent + "% of damage taken in melee back to the attacker in the body area"
			});
		}



		if(this.m.EL_CheckMorale)
		{
			result.push({
				id = 10,
				type = "text",
				text = "Triggers a negative morale check to enemies on hit"
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
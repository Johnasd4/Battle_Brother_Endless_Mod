this.el_npc_ballance_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_racial.npc_ballance";
		this.m.Name = "";
		this.m.Icon = "";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
        local actor = this.getContainer().getActor();
        local level_ups = actor.m.EL_NPCLevel;
        if(level_ups > this.Const.EL_NPC.EL_LevelUp.MaxXPLevel) {
            level_ups = this.Const.EL_NPC.EL_LevelUp.MaxXPLevel + (level_ups - this.Const.EL_NPC.EL_LevelUp.MaxXPLevel) * this.Const.EL_NPC.EL_LevelUp.PropertiesLevelUpMultAfterMaxXPLevel;
        }
        level_ups -= this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset;
        if(level_ups < 0) {
            level_ups = 0;
        }
        local main_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
        local off_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
        local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

        if(main_hand == null && off_hand == null) {
            actor.m.EL_IsNonHumanoid = true;
            _properties.DamageTotalMult *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpDamageMult * level_ups;
        }
        if(body == null) {
            _properties.ArmorMult[this.Const.BodyPart.Body] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
        }
        if(head == null) {
            _properties.ArmorMult[this.Const.BodyPart.Head] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
        }
        if(main_hand != null) {
            _properties.Stamina -= main_hand.EL_getLevelAddtionStaminaModifier();
        }
        if(off_hand != null) {
            _properties.Stamina -= off_hand.EL_getLevelAddtionStaminaModifier();
        }
        if(body != null) {
            _properties.Stamina -= body.EL_getLevelAddtionStaminaModifier();
        }
        if(head != null) {
            _properties.Stamina -= head.EL_getLevelAddtionStaminaModifier();
        }

        if(actor.getFaction() != this.Const.Faction.Player && actor.getFaction() != this.Const.Faction.PlayerAnimals) {
            local level = actor.EL_getLevel();
            local difficulty_mult = this.World.Assets.EL_getHalfWorldDifficultFactor();
            _properties.Bravery += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.Bravery + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.Bravery) * (difficulty_mult - 1);
            _properties.Stamina += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.Fatigue + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.Fatigue) * (difficulty_mult - 1);
            _properties.Initiative += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.Initiative + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.Initiative) * (difficulty_mult - 1);
            _properties.MeleeSkill += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.MeleeSkill + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.MeleeSkill) * (difficulty_mult - 1);
            _properties.RangedSkill += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.RangedSkill + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.RangedSkill) * (difficulty_mult - 1);
            _properties.MeleeDefense += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.MeleeDefense + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.MeleeDefense) * (difficulty_mult - 1);
            _properties.RangedDefense += (this.Const.EL_NPC.EL_DifficultBallance.Attributes.RangedDefense + level * this.Const.EL_NPC.EL_DifficultBallance.AttributesGrowthPurLevel.RangedDefense) * (difficulty_mult - 1);
            _properties.DamageReceivedTotalMult /= (this.Const.EL_NPC.EL_DifficultBallance.DamageReceivedTotalDiv) * difficulty_mult;
            _properties.DamageDirectMult *= (this.Const.EL_NPC.EL_DifficultBallance.DirectDamageMult) * difficulty_mult;
        }
	}


});


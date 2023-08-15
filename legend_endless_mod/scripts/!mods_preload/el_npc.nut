local gt = getroottable();

::mods_registerMod("el_npc", 1, "el_npc");
::mods_queue(null, ">el_player_npc", function ()
{

	// ::mods_hookExactClass("skills/racial/champion_racial", function ( o )
	// {

	// 	o.onUpdate = function ( _properties )
	// 	{
    //         local actor = his.getContainer().getActor();
    //         local level = _properties.EL_CombatLevel;
    //         local rank = actor.EL_getRankLevel();
    //         _properties.Hitpoints += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.Hitpoints][rank] * level;
    //         _properties.Bravery += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.Bravery][rank] * level;
    //         _properties.Stamina += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.Fatigue][rank] * level;
    //         _properties.Initiative += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.Initiative][rank] * level;
    //         _properties.MeleeSkill += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.MeleeSkill][rank] * level;
    //         _properties.RangedSkill += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.RangedSkill][rank] * level;
    //         _properties.MeleeDefense += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.MeleeDefense][rank] * level;
    //         _properties.RangedDefense += this.Const.EL_NPC.EL_ChampionAttributes.LevelToOffsetMult[this.Const.EL_NPC.EL_Attributes.RangedDefense][rank] * level;

    //         _properties.HitpointsMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.Hitpoints][rank];
    //         _properties.BraveryMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.Bravery][rank];
    //         _properties.StaminaMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.Fatigue][rank];
    //         _properties.InitiativeMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.Initiative][rank];
    //         _properties.MeleeSkillMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.MeleeSkill][rank];
    //         _properties.RangedSkillMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.RangedSkill][rank];
    //         _properties.MeleeDefenseMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.MeleeDefense][rank];
    //         _properties.RangedDefenseMult *= this.Const.EL_NPC.EL_ChampionAttributes.MultFactor[this.Const.EL_NPC.EL_Attributes.RangedDefense][rank];

    //         _properties.ActionPoints += this.Const.EL_NPC.EL_ChampionActionPointsOffset[rank];
    //         _properties.EL_CombatLevel += this.Const.EL_NPC.EL_ChampionCombatLevelOffset[rank];

    //     };


	// });
});

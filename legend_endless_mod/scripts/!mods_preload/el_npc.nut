local gt = getroottable();

::mods_registerMod("el_npc", 1, "el_npc");
::mods_queue(null, ">el_player_npc", function ()
{

	::mods_hookExactClass("skills/racial/champion_racial", function ( o )
	{

		o.onUpdate = function ( _properties )
		{
            local actor = his.getContainer().getActor();
            local level = _properties.EL_CombatLevel;
            local rank = actor.EL_getRankLevel();
            _properties.Hitpoints += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.Hitpoints][rank] * level;
            _properties.Bravery += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.Bravery][rank] * level;
            _properties.Stamina += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.Fatigue][rank] * level;
            _properties.Initiative += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.Initiative][rank] * level;
            _properties.MeleeSkill += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.MeleeSkill][rank] * level;
            _properties.RangedSkill += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.RangedSkill][rank] * level;
            _properties.MeleeDefense += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.MeleeDefense][rank] * level;
            _properties.RangedDefense += this.Const.EL_NPC.EL_Champion.Attributes.LevelToOffsetMult[this.Const.EL_Config.EL_Attributes.RangedDefense][rank] * level;

            _properties.HitpointsMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.Hitpoints][rank];
            _properties.BraveryMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.Bravery][rank];
            _properties.StaminaMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.Fatigue][rank];
            _properties.InitiativeMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.Initiative][rank];
            _properties.MeleeSkillMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.MeleeSkill][rank];
            _properties.RangedSkillMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.RangedSkill][rank];
            _properties.MeleeDefenseMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.MeleeDefense][rank];
            _properties.RangedDefenseMult *= this.Const.EL_NPC.EL_Champion.Attributes.Mult[this.Const.EL_Config.EL_Attributes.RangedDefense][rank];
            _properties.DamageDirectMult *= this.Const.EL_NPC.EL_Champion.DirectDamageMult[rank];

            _properties.ActionPoints += this.Const.EL_NPC.EL_Champion.ActionPointsOffset[rank];
            _properties.EL_CombatLevel += this.Const.EL_NPC.EL_Champion.CombatLevelOffset[rank];

        };


	});

	::mods_hookNewObject("entity/world/world_entity", function( o )
	{
        o.m.EL_FinishGenerate <- false;
		o.m.EL_IsBossTroop <- false;
        o.m.EL_IsEliteTeam <- false;
        o.m.EL_HaveRandomLeader <- false;
        o.m.EL_HaveStrongestLeader <- false;

        local create = o.create;
        o.create = function( _EL_troop ) {
            //If elite team.

        }

        o.EL_addTroop <- function( _EL_troop ) {

        }
    });


    gt.Const.World.Common.addTroop = function ( _party, _troop, _updateStrength = true, _minibossify = 0 )
    {
        local troop = clone _troop.Type;
        troop.Party <- this.WeakTableRef(_party);
        troop.Faction <- _party.getFaction();
        troop.Name <- "";

        if (troop.Variant > 0)
        {
            _minibossify = _minibossify + this.World.Assets.m.ChampionChanceAdditional;
            local upperBound = "DieRoll" in troop ? troop.DieRoll : 100;

            if (!this.Const.DLC.Wildmen || this.Math.rand(1, upperBound) > troop.Variant + _minibossify + (this.World.getTime().Days > 90 ? 0 : -1))
            {
                troop.Variant = 0;
            }
            else
            {
                troop.Strength = this.Math.round(troop.Strength * 1.35);
                troop.Variant = this.Math.rand(1, 255);

                if ("NameList" in _troop.Type)
                {
                    troop.Name = this.generateName(_troop.Type.NameList) + (_troop.Type.TitleList != null ? " " + _troop.Type.TitleList[this.Math.rand(0, _troop.Type.TitleList.len() - 1)] : "");
                }
            }
        }

        troop.Variant += _minibossify + this.World.Assets.m.ChampionChanceAdditional;
        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }

        return troop;
    };

});

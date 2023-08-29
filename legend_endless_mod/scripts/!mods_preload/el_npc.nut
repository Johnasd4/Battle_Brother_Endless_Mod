local gt = getroottable();

::mods_registerMod("el_npc", 1, "el_npc");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/racial/champion_racial", function ( o )
	{

		o.onUpdate = function ( _properties )
		{
            local actor = this.getContainer().getActor();
            local level = actor.EL_getNPCLevel();
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

	::mods_hookExactClass("entity/tactical/player_party", function(o){

		local create = o.create;
		o.create = function ()
		{
			create();
            this.m.EL_IsPlayer = true;
		}


	});

	::mods_hookNewObjectOnce("entity/tactical/tactical_entity_manager", function(o){

		o.setupEntity = function (_e, _t)
		{
            _e.setWorldTroop(_t);
            _e.setFaction(_t.Faction);

            if (("Callback" in _t) && _t.Callback != null)
            {
                _t.Callback(_e, "Tag" in _t ? _t.Tag : null);
            }

            if (("Name" in _t) && _t.Name != "")
            {
                _e.setName(_t.Name);
                _e.m.IsGeneratingKillName = false;
            }

            if (!this.World.getTime().IsDaytime && _e.getBaseProperties().IsAffectedByNight)
            {
                _e.getSkills().add(this.new("scripts/skills/special/night_effect"));
            }

            if(_t.EL_UnitInfo == null) {
                _e.EL_setRankLevel(_t.EL_RankLevel);
                _e.EL_setCombatLevel(_t.EL_CombatLevel);
                _e.EL_generateNPCAttributesByLevel(_t.EL_Level);
                if (_t.EL_RankLevel != 0)
                {
                    _e.makeMiniboss();
                }
                _e.assignRandomEquipment();
            }
            else {

            }
		}

	});


	::mods_hookExactClass("entity/tactical/actor", function(o){
		o.m.EL_NPCLevel <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize( _out );
			_out.writeI32(this.m.EL_NPCLevel);
		}
		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize( _in );
			this.m.EL_NPCLevel = _in.readI32();
		}

        o.EL_getNPCLevel <- function() {
            return this.m.EL_NPCLevel;
        }

        o.makeMiniboss = function() {
            this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
            this.m.IsMiniboss = true;
            this.m.IsGeneratingKillName = false;
            return true;
        }

        o.EL_generateNPCAttributesByLevel <- function( _EL_npcLevel ) {
            this.m.EL_NPCLevel = _EL_npcLevel;
            local level_ups = _EL_npcLevel - this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset;
            if(level_ups < 0) {
                level_ups = 0;
            }
            this.m.BaseProperties.Hitpoints += this.Math.floor(this.m.BaseProperties.Hitpoints *
                                                               this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.HitpointsMult *
                                                               level_ups);
            this.m.BaseProperties.Bravery += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.Bravery * level_ups);
            this.m.BaseProperties.Stamina += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.Fatigue * level_ups);
            this.m.BaseProperties.Initiative += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.Initiative * level_ups);
            this.m.BaseProperties.MeleeSkill += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.MeleeSkill * level_ups);
            this.m.BaseProperties.RangedSkill += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.RangedSkill * level_ups);
            this.m.BaseProperties.MeleeDefense += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.MeleeDefense * level_ups);
            this.m.BaseProperties.RangedDefense += this.Math.floor(this.Const.EL_NPC.EL_LevelUp.LevelUpAttributes.RangedDefense * level_ups);
            this.m.XP += this.Const.EL_NPC.EL_Champion.XP.Offset[this.m.EL_RankLevel];
            this.m.XP *= this.Const.EL_NPC.EL_Champion.XP.Mult[this.m.EL_RankLevel];
            this.m.XP *= this.Math.pow(this.Const.EL_NPC.EL_LevelUp.XPFactor, level_ups);
        }

	});

    gt.Const.World.Common.addTroop = function ( _party, _troop, _updateStrength = true, _minibossify = 0 )
    {
        local troop = clone _troop.Type;
        troop.Party <- this.WeakTableRef(_party);
        troop.Faction <- _party.getFaction();
        troop.Name <- "";
        troop.EL_EliteChance <- _minibossify + this.World.Assets.m.ChampionChanceAdditional;
        troop.EL_Level <- 0;
        troop.EL_CombatLevel <- 0;
        troop.EL_RankLevel <- 0;
        troop.EL_UnitInfo <- null;

        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }
        return troop;
    };

});


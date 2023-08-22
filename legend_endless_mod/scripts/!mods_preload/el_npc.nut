local gt = getroottable();

::mods_registerMod("el_npc", 1, "el_npc");
::mods_queue(null, "el_player_npc", function ()
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
        o.m.EL_IsPlayer <- false;
        o.m.EL_HaveRandomLeader <- false;
        o.m.EL_HaveStrongestLeader <- false;
        o.m.EL_TroopsResourse <- 0;
        o.m.EL_Population <- 0;
		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize( _out );
			_out.writeBool(this.m.EL_FinishGenerate);
			_out.writeBool(this.m.EL_IsBossTroop);
			_out.writeBool(this.m.EL_IsEliteTeam);
			_out.writeBool(this.m.EL_IsPlayer);
			_out.writeBool(this.m.EL_HaveRandomLeader);
			_out.writeBool(this.m.EL_HaveStrongestLeader);
			_out.writeI32(this.m.EL_TroopResourse);
			_out.writeI32(this.m.EL_Population);
		}
		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize( _in );
			this.m.EL_FinishGenerate = _in.readBool();
			this.m.EL_IsBossTroop = _in.readBool();
			this.m.EL_IsEliteTeam = _in.readBool();
			this.m.EL_IsPlayer = _in.readBool();
			this.m.EL_HaveRandomLeader = _in.readBool();
			this.m.EL_HaveStrongestLeader = _in.readBool();
			this.m.EL_TroopResourse = _in.readI32();
			this.m.EL_Population = _in.readI32();
		}


        local create = o.create;
        o.create = function() {
            create();
            local world_level = this.World.Assets.m.EL_WorldLevel;
            local elite_team_chance = this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance.EL_getChance(world_level);
            local random_leader_chance = 0;
            local strongest_leader_chance = 0;
            if(elite_team_chance * 10 >= this.Math.rand(1, 1000)) {
                this.m.EL_IsEliteTeam = true;
            }
            if(this.m.EL_IsEliteTeam) {
                random_leader_chance = this.Const.EL_NPC.EL_EliteTeam.RandomLeaderChance.EL_getChance(world_level);
                strongest_leader_chance = this.Const.EL_NPC.EL_EliteTeam.StrongestLeaderChance.EL_getChance(world_level);
            }
            else {
                random_leader_chance = this.Const.EL_NPC.EL_NormalTeam.RandomLeaderChance.EL_getChance(world_level);
                strongest_leader_chance = this.Const.EL_NPC.EL_NormalTeam.StrongestLeaderChance.EL_getChance(world_level);
            }
            if(random_leader_chance * 10 >= this.Math.rand(1, 1000)) {
                this.m.EL_HaveRandomLeader = true;
            }
            if(strongest_leader_chance * 10 >= this.Math.rand(1, 1000)) {
                this.m.EL_HaveStrongestLeader = true;
            }
            this.m.EL_TroopResourse = this.Math.round(this.World.Assets.m.EL_WorldStrength * this.Math.rand(this.Const.EL_NPC.EL_Troop.Resourse.MinMult, this.Const.EL_NPC.EL_Troop.Resourse.MaxMult) / 100);
        }

        o.EL_addTroop <- function( _EL_troop ) {
            if(this.m.ZT_IsPlayer == true) {
                return;
            }
            for(local i = 0; i < this.m.Troops.len(); ++i) {
                if(_EL_troop.Strength > this.m.Troops[i].Strength) {
                    this.m.Troops[i].insert(i, _EL_troop);
                    return;
                }
            }
            this.m.Troops.push(_troop);
            return;
        }

        o.EL_updateTroop <- function() {
            if(this.m.EL_FinishGenerate == true) {
                return;
            }
            this.m.EL_FinishGenerate = true;
            //Calculate current troop info.
            local troops_info = [];
            for(local i = 0; i < this.m.Troops.len(); ++i) {
                troops_info.push(this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.EL_getTroopInfo(this.m.Troops[i]));
            }
            //Calculate ranks, level, combat level.
            if(this.m.EL_IsBossTroop) {
                local leader_id = 0;
                for(local i = 0; i < this.m.Troops.len(); ++i) {
                    //At least two leaders.
                    if(i < this.Const.EL_NPC.EL_Troop.BossTroopMinLeaders || this.m.Troops[i].ID == leader_id) {
                        this.m.Troops[i].EL_RankLevel = 2;
                        leader_id = this.m.Troops[i].ID;
                    }
                    else if(this.m.Troops[i].EL_IsBossUnit) {
                        this.m.Troops[i].EL_RankLevel = 2;
                    }
                    else if(this.m.Troops[i].EL_IsWeakUnit) {
                        this.m.Troops[i].EL_RankLevel = 0;
                    }
                    else {
                        this.m.Troops[i].EL_RankLevel = 1;
                    }
                    this.m.Troops[i].EL_Level = this.World.Assets.m.EL_WorldLevel;
                    this.m.Troops[i].EL_CombatLevel = this.World.Assets.m.EL_WorldLevel + troops_info[i].EL_ExtraCombatLevel;
                }
            }
            //Build names



            for(local i = 0; i < this.m.Troops.len(); ++i) {
                if(this.m.Troops[i].EL_RankLevel != 0 && "NameList" in _troop.Type) {
                    troop.Name = this.generateName(_troop.Type.NameList) + (_troop.Type.TitleList != null ? " " + _troop.Type.TitleList[this.Math.rand(0, _troop.Type.TitleList.len() - 1)] : "");
                }

            }
            // //Calculate ranks, level, combat level, resourse, population.
            // if(this.m.EL_IsBossTroop) {
            //     EL_IsEliteTeam
            // }
            // if(population == 0) {
            //     if(_EL_troop.Strength != 0) {
            //         population = this.Math.ceil((_EL_troop.Strength - 1) / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation);
            //     }
            //     else {
            //         population = 1;
            //     }
            // }

            // if(this.m.EL_IsBossTroop == true) {

            //     return;
            // }
            // if(this.m.EL_FinishGenerate == true) {


            //     if(_rankLevel != 0){
            //         _troop.Variant = _rankLevel + _bossLevel * 6;
            //     }
            //     else{
            //         _troop.Variant = 0;
            //     }
            //     _troop.Name = this.Const.ZT_Rank.TroopName[_troop.Variant];
            //     this.m.Troops.push(_troop);
            //     return;
            // }
            // if(this.m.EL_IsEliteTeam == false) {
            //     local population = 0;
            //     for(local i = 0; i < this.Const.EL_NPC.EL_Troop.SpecialUnit.len(); ++i){
            //         if(_EL_troop.ID == this.Const.EL_NPC.EL_Troop.SpecialUnit[i].ID) {
            //             population = tthis.Const.EL_NPC.EL_Troop.SpecialUnit[i].Population;
            //             break;
            //         }
            //     }
            //     if(population == 0) {
            //         population = _EL_troop.Strength
            //     }

            //                     StrengthPurPopulation
            //     if(i == this.Const.ZT_Enemy.EnemyStrongUnit.len()){
            //         if(_troop.Cost <= 20){
            //             size = 1;
            //             this.m.TempTroopSize += size;
            //         }
            //         else{
            //             size = _troop.Cost / 20;
            //             this.m.TempTroopSize += size;
            //         }
            //     }

            //     if( _rankLevel != 0 ){
            //         this.m.TempBossTroopSize += size;
            //     }
            //     //add troop to temp

            //     local insertIndex = 0;
            //     for( insertIndex = 0 ; insertIndex < this.m.TempTroops.len() ; insertIndex = insertIndex){

            //         if( _troop.Strength <= this.m.TempTroops[insertIndex].Strength ){
            //             break;
            //         }
            //         insertIndex += 1;
            //     }
            //     this.m.TempTroopSingleSize.insert(insertIndex, size);
            //     this.m.TempTroops.insert(insertIndex, _troop);
            //     this.m.TroopsRankAll[_rankLevel] += 1;
            //     this.m.EL_UsedTroopResourse += _troop.Strength;
            //     this.EL_updateTroop();
            // }
            // else if(this.m.IsBossTroop == false && this.m.ZT_IsPlayer == false ){


            // }
            // else if(this.m.IsBossTroop == true && this.m.ZT_IsPlayer == false ){

            //     this.m.TroopSize = 1;
            //     if(_rankLevel != 0){
            //         _troop.Variant = _rankLevel + _bossLevel * 6;
            //     }
            //     else{
            //         _troop.Variant = 0;
            //     }
            //     _troop.Name = this.Const.ZT_Rank.TroopName[_troop.Variant];
            //     this.m.Troops.push(_troop);
            // }
        }

    });


	::mods_hookExactClass("entity/tactical/player_party", function(o){

		local create = o.create;
		o.create = function ()
		{
			create();
            this.m.EL_IsPlayer = true;
		}


	});


    gt.Const.World.Spawn.Unit.EL_EliteChance <- 0;
    gt.Const.World.Spawn.Unit.EL_Level <- 0;
    gt.Const.World.Spawn.Unit.EL_CombatLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_RankLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_UnitInfo <- null;

    {
        ID = 0,
        Variant = 0,
        Strength = 0.0,
        Row = 0,
        Party = null,
        Faction = null,
        Tag = null,
        Script = "",
        Name = ""
    };


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

        troop.EL_EliteChance += _minibossify + this.World.Assets.m.ChampionChanceAdditional;
        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }

        return troop;
    };

});

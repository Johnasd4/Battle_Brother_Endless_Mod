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

	::mods_hookNewObject("entity/world/world_entity", function( o )
	{
        o.m.EL_FinishGenerate <- false;
		o.m.EL_IsBossTroop <- false;
        o.m.EL_IsEliteTeam <- false;
        o.m.EL_IsPlayer <- false;
        o.m.EL_HaveRandomLeader <- false;
        o.m.EL_HaveStrongestLeader <- false;
        o.m.EL_TroopsResourse <- 0;
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

        local clearTroops = o.clearTroops;
        o.clearTroops = function() {
            clearTroops();
            this.m.EL_FinishGenerate = false;
        }

        local getTooltip = o.getTooltip;
        o.getTooltip = function() {
            this.m.EL_updateTroop();
            getTooltip();
        }

        o.updateStrength = function() {
            if(this.m.EL_IsBossTroop) {
                this.m.Strength = 99999999;
            }
            else {
                local unit_strength = 0;
                local unit_population = 0;
                for(local i = 0; i < this.m.Troops.len(); ++i) {
                    unit_strength += this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel];
                    if(this.m.Troops[i].Strength <= 20) {
                        unit_population += this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                    else {
                        unit_population += this.Math.ceil((this.m.Troops[i].Strength - 1) / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation) * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                }
                this.m.Strength = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
            }
        }

        o.EL_addTroop <- function( _EL_troop ) {
            if(this.m.ZT_IsPlayer == true) {
                return;
            }
            for(local i = 0; i < this.m.Troops.len(); ++i) {
                if(_EL_troop.Strength > this.m.Troops[i].Strength) {
                    this.m.Troops.insert(i, _EL_troop);
                    return;
                }
            }
            this.m.Troops.push(_troop);
            return;
        }

        o.EL_updateTroop <- function() {
            if(this.m.EL_FinishGenerate == false && !this.m.EL_IsPlayer) {
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
                        else if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = 2;
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = 0;
                        }
                        else {
                            this.m.Troops[i].EL_RankLevel = 1;
                        }
                        this.m.Troops[i].EL_Level = this.World.Assets.m.EL_WorldLevel;
                        this.m.Troops[i].EL_CombatLevel = this.World.Assets.m.EL_WorldLevel + troops_info[i].EL_ExtraCombatLevel;
                    }
                }
                else if(this.m.EL_IsEliteTeam) {
                    local i = 0;
                    local unit_strength = 0;
                    local unit_population = 0;
                    local used_resourse = 0;
                    local random_leader_avilable_index = [];
                    if(this.m.EL_HaveStrongestLeader && !troops_info[i].EL_IsWeakUnit) {
                        this.m.Troops[i].EL_RankLevel = 2;
                        unit_strength += this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel];
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                        ++i;
                    }
                    for(; i < troops_info.len(); ++i) {
                        if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = 2;
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = 0;
                        }
                        else {
                            this.m.Troops[i].EL_RankLevel = 1;
                            random_leader_avilable_index.push(i);
                        }
                        if(this.m.Troops[i].EL_RankLevel == 0) {
                            this.m.Troops[i].EL_Level = this.Math.Rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
                        }
                        else {
                            this.m.Troops[i].EL_Level = this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset;
                        }
                        if(this.m.Troops[i].EL_Level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
                            this.m.Troops[i].EL_Level = this.Const.EL_NPC.EL_Troop.MaxLevel;
                        }
                        else if(this.m.Troops[i].EL_Level < this.Const.EL_NPC.EL_Troop.MinLevel) {
                            this.m.Troops[i].EL_Level = this.Const.EL_NPC.EL_Troop.MinLevel;
                        }
                        this.m.Troops[i].EL_CombatLevel = this.m.Troops[i].EL_Level + troops_info[i].EL_ExtraCombatLevel;
                        unit_strength += this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel];
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                    if(this.m.EL_HaveRandomLeader && random_leader_avilable_index.len() != 0) {
                        local random_leader_index = random_leader_avilable_index[this.Math.rand(0, random_leader_avilable_index.len() - 1)];
                        unit_strength -= this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        unit_population -= troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        this.m.Troops[random_leader_index].EL_RankLevel = 2;
                        unit_strength += this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        unit_population += troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                    }
                    used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                    if(used_resourse < this.m.EL_TroopsResourse) {
                        //Copy the troops until the resourse is used up.
                        for(local j = 0; ; j = (j + 1) % troops_info.len()) {
                            local troop = clone this.m.Troops[j];
                            if(troops_info[j].EL_IsBossUnit) {
                                troop.EL_RankLevel = 2;
                            }
                            else if(troops_info[j].EL_IsWeakUnit) {
                                troop.EL_RankLevel = 0;
                            }
                            else {
                                troop.EL_RankLevel = 1;
                            }
                            if(troop.EL_RankLevel == 0) {
                                troop.EL_Level = this.Math.Rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
                            }
                            else {
                                troop.EL_Level = this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset;
                            }
                            if(troop.EL_Level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
                                troop.EL_Level = this.Const.EL_NPC.EL_Troop.MaxLevel;
                            }
                            else if(troop.EL_Level < this.Const.EL_NPC.EL_Troop.MinLevel) {
                                troop.EL_Level = this.Const.EL_NPC.EL_Troop.MinLevel;
                            }
                            troop.EL_CombatLevel = troop.EL_Level + troops_info[j].EL_ExtraCombatLevel;
                            unit_strength += troop.Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[troop.EL_RankLevel];
                            unit_population += troops_info[j].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[troop.EL_RankLevel];
                            used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                            if(used_resourse > this.m.EL_TroopsResourse) {
                                break;
                            }
                            this.m.Troops.push(troop);
                        }
                    }
                }
                else {
                    local i = 0;
                    local unit_strength = 0;
                    local unit_population = 0;
                    local used_resourse = 0;
                    local random_leader_avilable_index = [];
                    if(this.m.EL_HaveStrongestLeader && !troops_info[i].EL_IsWeakUnit) {
                        this.m.Troops[i].EL_RankLevel = 2;
                        unit_strength += this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel];
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                        ++i;
                    }
                    for(; i < troops_info.len(); ++i) {
                        if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = 2;
                        }
                        else if(troops_info[i].EL_IsEliteUnit) {
                            this.m.Troops[i].EL_RankLevel = 1;
                            random_leader_avilable_index.push(i);
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = 0;
                        }
                        else {
                            this.m.Troops[i].EL_RankLevel = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
                            random_leader_avilable_index.push(i);
                        }
                        if(this.m.Troops[i].EL_RankLevel == 0) {
                            this.m.Troops[i].EL_Level = this.Math.Rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
                        }
                        else {
                            this.m.Troops[i].EL_Level = this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset;
                        }
                        if(this.m.Troops[i].EL_Level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
                            this.m.Troops[i].EL_Level = this.Const.EL_NPC.EL_Troop.MaxLevel;
                        }
                        else if(this.m.Troops[i].EL_Level < this.Const.EL_NPC.EL_Troop.MinLevel) {
                            this.m.Troops[i].EL_Level = this.Const.EL_NPC.EL_Troop.MinLevel;
                        }
                        this.m.Troops[i].EL_CombatLevel = this.m.Troops[i].EL_Level + troops_info[i].EL_ExtraCombatLevel;
                        unit_strength += this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel];
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                    if(this.m.EL_HaveRandomLeader && random_leader_avilable_index.len() != 0) {
                        local random_leader_index = random_leader_avilable_index[this.Math.rand(0, random_leader_avilable_index.len() - 1)];
                        unit_strength -= this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        unit_population -= troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        this.m.Troops[random_leader_index].EL_RankLevel = 2;
                        unit_strength += this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        unit_population += troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                    }
                    used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                    if(used_resourse < this.m.EL_TroopsResourse) {
                        //Copy the troops until the resourse is used up.
                        for(local j = 0; ; j = (j + 1) % troops_info.len()) {
                            local troop = clone this.m.Troops[j];
                            if(troops_info[j].EL_IsBossUnit) {
                                troop.EL_RankLevel = 2;
                            }
                            else if(troops_info[j].EL_IsEliteUnit) {
                                troop.EL_RankLevel = 1;
                            }
                            else if(troops_info[j].EL_IsWeakUnit) {
                                troop.EL_RankLevel = 0;
                            }
                            else {
                                troop.EL_RankLevel = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
                            }
                            if(troop.EL_RankLevel == 0) {
                                troop.EL_Level = this.Math.Rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
                            }
                            else {
                                troop.EL_Level = this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset;
                            }
                            if(troop.EL_Level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
                                troop.EL_Level = this.Const.EL_NPC.EL_Troop.MaxLevel;
                            }
                            else if(troop.EL_Level < this.Const.EL_NPC.EL_Troop.MinLevel) {
                                troop.EL_Level = this.Const.EL_NPC.EL_Troop.MinLevel;
                            }
                            troop.EL_CombatLevel = troop.EL_Level + troops_info[j].EL_ExtraCombatLevel;
                            unit_strength += troop.Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[troop.EL_RankLevel];
                            unit_population += troops_info[j].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[troop.EL_RankLevel];
                            used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                            if(used_resourse > this.m.EL_TroopsResourse) {
                                break;
                            }
                            this.m.Troops.push(troop);
                        }
                    }
                }
                //Build names
                for(local i = 0; i < this.m.Troops.len(); ++i) {
                    if(this.m.Troops[i].EL_RankLevel != 0) {
                        this.m.Troops[i].Name = this.Const.EL_NPC.EL_Troop.NamePrefix[this.m.Troops[i].EL_RankLevel];
                        this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
                        this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.NameSuffix[this.m.Troops[i].EL_RankLevel];
                    }
                }
                this.updateStrength();
            }
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

	::mods_hookNewObjectOnce("entity/tactical/tactical_entity_manager", function(o){

        local spawnEntitiesRandomly = o.spawnEntitiesRandomly;
        o.spawnEntitiesRandomly = function( _entities ) {
            _entities.EL_updateTroop();
            spawnEntitiesRandomly(_entities);
        }

        local spawnEntitiesInCircle = o.spawnEntitiesInCircle;
        o.spawnEntitiesInCircle = function(_entities) {
            _entities.EL_updateTroop();
            spawnEntitiesInCircle(_entities);
        }

        local spawnEntitiesAtCamp = o.spawnEntitiesAtCamp;
        o.spawnEntitiesAtCamp = function( _entities, _shiftX = 0, _shiftY = 0 ) {
            _entities.EL_updateTroop();
            spawnEntitiesAtCamp(_entities, _shiftX, _shiftY);
        }

        local spawnEntitiesInFormation = o.spawnEntitiesInFormation;
        o.spawnEntitiesInFormation = function( _entities, _factionNum, _offsetX = 0, _offsetY = 0 ) {
            _entities.EL_updateTroop();
            spawnEntitiesInFormation(_entities, _factionNum, _offsetX, _offsetY);
        }

        local spawnEntitiesAtCenter = o.spawnEntitiesAtCenter;
        o.spawnEntitiesAtCenter = function( _entities, _extraRadius = 0 ) {
            _entities.EL_updateTroop();
            spawnEntitiesAtCenter(_entities, _extraRadius);
        }

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
            this.m._EL_NPCLevel = _EL_npcLevel;
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


    gt.Const.World.Spawn.Unit.EL_EliteChance <- 0;
    gt.Const.World.Spawn.Unit.EL_Level <- 0;
    gt.Const.World.Spawn.Unit.EL_CombatLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_RankLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_UnitInfo <- null;

    gt.Const.World.Common.addTroop = function ( _party, _troop, _updateStrength = true, _minibossify = 0 )
    {
        local troop = clone _troop.Type;
        troop.Party <- this.WeakTableRef(_party);
        troop.Faction <- _party.getFaction();
        troop.Name <- "";
        troop.EL_EliteChance += _minibossify + this.World.Assets.m.ChampionChanceAdditional;
        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }
        return troop;
    };

});

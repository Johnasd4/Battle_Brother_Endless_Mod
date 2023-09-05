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

            this.m.Name = this.Const.EL_NPC.EL_Champion.Name[rank];
            this.m.Icon = this.Const.EL_NPC.EL_Champion.Icon[rank];
            this.m.IconMini = this.Const.EL_NPC.EL_Champion.IconMini[rank];

            _properties.HitpointsMult *= this.Const.EL_NPC.EL_Champion.Attributes.HitpointsMult[rank];
            _properties.Bravery += this.Const.EL_NPC.EL_Champion.Attributes.Bravery[rank];
            _properties.Stamina += this.Const.EL_NPC.EL_Champion.Attributes.Fatigue[rank];
            _properties.Initiative += this.Const.EL_NPC.EL_Champion.Attributes.Initiative[rank];
            _properties.MeleeSkill += this.Const.EL_NPC.EL_Champion.Attributes.MeleeSkill[rank];
            _properties.RangedSkill += this.Const.EL_NPC.EL_Champion.Attributes.RangedSkill[rank];
            _properties.MeleeDefense += this.Const.EL_NPC.EL_Champion.Attributes.MeleeDefense[rank];
            _properties.RangedDefense += this.Const.EL_NPC.EL_Champion.Attributes.RangedDefense[rank];

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

	::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(o){

		o.setupEntity = function (_e, _t)
		{
            _e.setWorldTroop(_t);
            _e.setFaction(_t.Faction);

            if (("Callback" in _t) && _t.Callback != null)
            {
                _t.Callback(_e, "Tag" in _t ? _t.Tag : null);
            }

            if (!this.World.getTime().IsDaytime && _e.getBaseProperties().IsAffectedByNight)
            {
                _e.getSkills().add(this.new("scripts/skills/special/night_effect"));
            }

            if ("Name" in _t)
            {
                local name = this.Const.EL_NPC.EL_Troop.NamePrefix[_t.EL_RankLevel];
                name += _e.getNameOnly();
                name += this.Const.EL_NPC.EL_Troop.NameSuffix[_t.EL_RankLevel];
                _e.setName(name);
                _e.m.IsGeneratingKillName = false;
            }

            local npc_level = 0;
            if(_t.EL_RankLevel != 0) {
                npc_level = this.World.Assets.m.EL_WorldLevel;
            }
            else {
                npc_level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset)
            }
            if(npc_level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
                npc_level = this.Const.EL_NPC.EL_Troop.MaxLevel;
            }
            else if(npc_level < this.Const.EL_NPC.EL_Troop.MinLevel) {
                npc_level = this.Const.EL_NPC.EL_Troop.MinLevel;
            }

            _e.EL_generateNPCAttributesByLevel(npc_level);
            _e.EL_setCombatLevel(npc_level + _t.EL_ExtraCombatLevel);
            _e.EL_setRankLevel(_t.EL_RankLevel);

            if (_t.EL_RankLevel != 0)
            {
                _e.makeMiniboss();
            }


            if(_t.EL_UnitInfo == null) {

                _e.assignRandomEquipment();
                if(_e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null &&
                   _e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null &&
                   _e.getItems().getItemAtSlot(this.Const.ItemSlot.Body) == null &&
                   _e.getItems().getItemAtSlot(this.Const.ItemSlot.Head) == null &&
                   _e.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) == null)
                {
                    this.Const.EL_NPC.EL_NPCBuff.Pool.EL_assignNPCBuffs(_e, this.Const.EL_NPC.EL_NPCBuff.BuffNum.NonHumanoidRank1[_t.EL_RankLevel], this.Const.EL_NPC.EL_NPCBuff.BuffNum.NonHumanoidRank2[_t.EL_RankLevel]);
                }
                else
                {
                    this.Const.EL_NPC.EL_NPCBuff.Pool.EL_assignNPCBuffs(_e, this.Const.EL_NPC.EL_NPCBuff.BuffNum.HumanoidRank1[_t.EL_RankLevel], this.Const.EL_NPC.EL_NPCBuff.BuffNum.HumanoidRank2[_t.EL_RankLevel]);
                }
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

	::mods_hookBaseClass("contracts/contract", function ( o )
	{
		while (!("EmployerID" in o.m))
		{
			o = o[o.SuperName];
		}
        local create = o.create;
		o.create = function ()
		{
            create();
			this.m.PaymentMult *= (1 + this.Const.EL_NPC.EL_Contract.PatmentMultPurWorldLevel * this.World.Assets.m.EL_WorldLevel);
		};
	});



    gt.Const.World.Spawn.Unit.EL_EliteChance <- 0;
    gt.Const.World.Spawn.Unit.EL_ExtraCombatLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_RankLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_UnitInfo <- null;

    gt.Const.World.Common.addTroop = function ( _party, _troop, _updateStrength = true, _minibossify = 0 )
    {
        local troop = clone _troop.Type;
        troop.Party <- this.WeakTableRef(_party);
        troop.Faction <- _party.getFaction();
        troop.Name <- "";
        troop.EL_EliteChance <- _minibossify + this.World.Assets.m.ChampionChanceAdditional + troop.Variant;
        troop.EL_ExtraCombatLevel <- 0;
        troop.EL_RankLevel <- 0;
        troop.EL_UnitInfo <- null;

        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }
        return troop;
    };


    gt.Const.World.Common.addUnitsToCombat = function ( _into, _partyList, _resources, _faction, _minibossify = 0 )
    {
        local p;

        if (typeof _partyList == "table")
        {
            p = this.Const.World.Common.buildDynamicTroopList(_partyList, _resources);
        }
        else
        {
            local total_weight = 0;
            local potential = [];

            foreach( party in _partyList )
            {
                if (party.Cost < _resources * 0.7)
                {
                    continue;
                }

                if (party.Cost > _resources)
                {
                    break;
                }

                potential.push(party);
                total_weight = total_weight + party.Cost;
            }

            if (potential.len() == 0)
            {
                local best;
                local bestCost = 9000;

                foreach( party in _partyList )
                {
                    if (this.Math.abs(_resources - party.Cost) <= bestCost)
                    {
                        best = party;
                        bestCost = this.Math.abs(_resources - party.Cost);
                    }
                }

                p = best;
            }
            else
            {
                local pick = this.Math.rand(1, total_weight);

                foreach( party in potential )
                {
                    if (pick <= party.Cost)
                    {
                        p = party;
                        break;
                    }

                    pick = pick - party.Cost;
                }
            }
        }

        local troopMbMap = {};

        foreach( t in p.Troops )
        {
            local key = "Enemy" + t.Type.ID;

            if (!(key in troopMbMap))
            {
                troopMbMap[key] <- this.Const.LegendMod.GetFavEnemyBossChance(t.Type.ID);
            }

            local mb = troopMbMap[key];

            for( local i = 0; i != t.Num; i = i )
            {
                local unit = clone t.Type;
                unit.Faction <- _faction;
                unit.Name <- "";
                unit.EL_EliteChance <- _minibossify + this.World.Assets.m.ChampionChanceAdditional + unit.Variant + mb;
                unit.EL_ExtraCombatLevel <- 0;
                unit.EL_RankLevel <- 0;
                unit.EL_UnitInfo <- null;

                local troop_info = this.Const.EL_NPC.EL_Troop.EL_getTroopInfo(unit);
                //Calculate ranks, level, combat level.
                if(troop_info.EL_IsBossUnit) {
                    unit.EL_RankLevel = 2;
                }
                else if(troop_info.EL_IsEliteUnit) {
                    unit.EL_RankLevel = 1;
                }
                else if(troop_info.EL_IsWeakUnit) {
                    unit.EL_RankLevel = 0;
                }
                else {
                    local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
                    unit.EL_RankLevel = (this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1;
                }
                unit.EL_ExtraCombatLevel = troop_info.EL_ExtraCombatLevel;
                //Build names
                if(unit.EL_RankLevel != 0) {
                    unit.Name = this.Const.EL_NPC.EL_Troop.NamePrefix[unit.EL_RankLevel];
                    unit.Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
                    unit.Name += this.Const.EL_NPC.EL_Troop.NameSuffix[unit.EL_RankLevel];
                }
                _into.push(unit);
                i = ++i;
            }
        }
    };



});


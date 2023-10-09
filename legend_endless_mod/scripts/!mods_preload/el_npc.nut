local gt = getroottable();

::mods_registerMod("el_npc", 1, "el_npc");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/racial/champion_racial", function ( o )
	{
        local create = o.create;
        o.create = function()
        {
            create();
            this.m.IsHidden = true;
        }

		o.onUpdate = function ( _properties )
		{
            local actor = this.getContainer().getActor();
            local level = actor.EL_getLevel();
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


	::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(o)
    {

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

            if (("Name" in _t) && _t.Name != "")
            {
                _e.setName(_t.Name);
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

            _e.EL_buildNPCPropertiesByLevel(npc_level);
            //this.logInfo("_t.EL_ExtraCombatLevel " + _t.EL_ExtraCombatLevel);
            _e.EL_setCombatLevel(this.Math.min(this.Const.EL_NPC.EL_Troop.MaxCalculateLevel, npc_level) + _t.EL_ExtraCombatLevel);
            _e.EL_setRankLevel(_t.EL_RankLevel);
            if (_t.EL_RankLevel != 0)
            {
                _e.makeMiniboss();
            }


            if(_t.EL_UnitInfo == null) {

                _e.EL_assignRandomEquipment();
                local extra_normal_buff_num = 0;
                local extra_elite_buff_num = 0;
                local extra_leader_buff_num = 0;
                if(_t.EL_IsBossUnit == true) {
                    extra_elite_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank1;
                    extra_leader_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank2;
                }
                if(_e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null &&
                   _e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
                {
                    extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank0[_t.EL_RankLevel];
                    extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank1[_t.EL_RankLevel];
                    extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank2[_t.EL_RankLevel];
                }
                else
                {
                    extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank0[_t.EL_RankLevel];
                    extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank1[_t.EL_RankLevel];
                    extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank2[_t.EL_RankLevel];
                }
                local chance = this.World.Assets.EL_getWorldDifficultFactor() * 100 - 100;
                while(true) {
                    local r = this.Math.rand(1, this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax);
                    if(r > chance) {
                        break;
                    }
                    chance -= this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax;
                    if(_t.EL_RankLevel == 2)
                    {
                        extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[2];
                        extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[2];
                        extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[2];
                    }
                    else if(_t.EL_RankLevel == 1)
                    {
                        extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[1];
                        extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[1];
                        extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[1];
                    }
                    else
                    {
                        extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[0];
                        extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[0];
                        extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[0];
                    }
                }
                extra_normal_buff_num += _t.EL_ExtraBuffNum[0];
                extra_elite_buff_num += _t.EL_ExtraBuffNum[1];
                extra_leader_buff_num += _t.EL_ExtraBuffNum[2];
                if(_e.getFaction() != this.Const.Faction.Player && _e.getFaction() != this.Const.Faction.PlayerAnimals) {
                    this.Const.EL_NPC.EL_NPCBuff.EL_assignNPCBuffs(_e, extra_normal_buff_num, extra_elite_buff_num, extra_leader_buff_num);
                }

                _e.EL_ballanceNPCPropertiesAfterAddingEquipment();
            }
            else {

            }
		}

	});

	::mods_hookExactClass("entity/tactical/actor", function(o){
		o.m.EL_NPCLevel <- 0;
        o.m.EL_EquipmentEssenceDrop <- [0, 0, 0, 0, 0];

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize( _out );
			_out.writeI32(this.m.EL_NPCLevel);
            for(local i = 0; i < this.m.EL_EquipmentEssenceDrop.len(); ++i) {
                _out.writeI32(this.m.EL_EquipmentEssenceDrop[i]);
            }
		}
		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize( _in );
			this.m.EL_NPCLevel = _in.readI32();
            for(local i = 0; i < this.m.EL_EquipmentEssenceDrop.len(); ++i) {
                this.m.EL_EquipmentEssenceDrop[i] = _in.readI32();
            }
		}

        o.EL_getLevel <- function() {
            return this.m.EL_NPCLevel;
        }

        o.getLevel <- function() {
            return this.m.EL_NPCLevel;
        }

        o.EL_resetOtherStates <- function() {}

		local onInit = o.onInit;
		o.onInit = function() {
			onInit();
			if (this.m.MoraleState != this.Const.MoraleState.Ignore)
			{
				this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
			}
			return;
		}

        o.makeMiniboss = function() {
            this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
            this.m.IsMiniboss = true;
            this.m.IsGeneratingKillName = false;
            return true;
        }

        o.EL_buildNPCPropertiesByLevel <- function( _EL_npcLevel ) {
            this.m.EL_NPCLevel = this.Math.min(_EL_npcLevel, this.Const.EL_NPC.EL_LevelUp.MaxPropertiesLevel);
            local level_ups = this.m.EL_NPCLevel - this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset;
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

            this.m.XP *= this.Math.pow(this.Const.EL_NPC.EL_LevelUp.XPFactor, this.Math.min(level_ups, this.Const.EL_NPC.EL_LevelUp.MaxXPLevel));
            this.m.XP = this.Math.floor(this.m.XP * this.World.Assets.EL_getHalfWorldDifficultFactor());
        }

        o.EL_ballanceNPCPropertiesAfterAddingEquipment <- function() {
            local level_ups = this.m.EL_NPCLevel - this.Const.EL_NPC.EL_LevelUp.LevelUpsOffset;
            if(level_ups < 0) {
                level_ups = 0;
            }
            local main_hand = this.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
            local off_hand = this.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
            local body = this.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local head = this.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

            if(main_hand == null && off_hand == null) {
                this.m.BaseProperties.DamageRegularMult *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpDamageMult * level_ups;
            }
            if(body == null) {
                this.m.BaseProperties.Armor[this.Const.BodyPart.Body] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
                this.m.BaseProperties.ArmorMax[this.Const.BodyPart.Body] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
            }
            if(head == null) {
                this.m.BaseProperties.Armor[this.Const.BodyPart.Head] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
                this.m.BaseProperties.ArmorMax[this.Const.BodyPart.Head] *= 1 + this.Const.EL_NPC.EL_LevelUp.LevelUpArmorMult * level_ups;
            }
            if(main_hand != null) {
                this.m.BaseProperties.Stamina -= main_hand.EL_getLevelAddtionStaminaModifier();
            }
            if(off_hand != null) {
                this.m.BaseProperties.Stamina -= off_hand.EL_getLevelAddtionStaminaModifier();
            }
            if(body != null) {
                this.m.BaseProperties.Stamina -= body.EL_getLevelAddtionStaminaModifier();
            }
            if(head != null) {
                this.m.BaseProperties.Stamina -= head.EL_getLevelAddtionStaminaModifier();
            }
        }

		o.getName = function()
		{
			return this.m.Name + " - Lv" + this.m.EL_NPCLevel + "(" + ((this.Math.round(this.EL_getCombatLevel() * 10) * 0.1)) + ")";
		}

        local kill = o.kill;
        o.kill = function( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
        {
            //this.logInfo(this.getName() + " is killed.");
            if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
            {
                local rank = 0;
                local level = this.m.EL_NPCLevel;
                if(this.m.WorldTroop != null && this.m.WorldTroop.EL_IsBossUnit == true) {
                    rank = 3;
                }
                else {
                    rank = this.EL_getRankLevel();
                }
                local num_1 = this.Const.EL_NPC.EL_Troop.EquipmentEssence.CurrentRankMult * this.Math.pow(1 + this.Const.EL_NPC.EL_Troop.EquipmentEssence.DropLevelMult * level, this.Const.EL_NPC.EL_Troop.EquipmentEssence.DropPowFactor);
                local num_2 = this.Const.EL_NPC.EL_Troop.EquipmentEssence.NextRankMult * this.Math.pow(1 + this.Const.EL_NPC.EL_Troop.EquipmentEssence.DropLevelMult * level, this.Const.EL_NPC.EL_Troop.EquipmentEssence.DropPowFactor);
                num_1 = this.Math.floor(num_1 * this.World.Assets.EL_getHalfWorldDifficultFactor());
                num_2 = this.Math.floor(num_2 * this.World.Assets.EL_getHalfWorldDifficultFactor());

                if (this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null && !this.m.WorldTroop.Party.isNull())
                {
                    this.m.WorldTroop.Party.EL_addEquipmentEssence(rank, num_1);
                    this.m.WorldTroop.Party.EL_addEquipmentEssence(rank + 1, num_2);

                    local accessory = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
                    if(accessory != null && accessory.getID() == "el_accessory.core") {
                        local core = this.new("scripts/items/el_misc/el_core_rank_" + accessory.EL_getRankLevel() + "_item");
                        core.EL_generateCoreXPByActorXP(this.Math.floor(this.getXP()));
                        this.m.WorldTroop.Party.EL_addLootItem(core);
                    }
                }
                else
                {
                    local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
                    local party = null;
                    for(local i = 0; i < p.Parties.len(); ++i) {
                        if(p.Parties[i].m.Name == "EquipmentEssenceOnly") {
                            party = p.Parties[i];
                            break;
                        }
                    }
                    if(party == null)
                    {
                        party = this.new("scripts/entity/world/party");
                        party.EL_setFaction(this.Const.Faction.Enemy);
                        party.EL_tempPartyInit();
                        party.EL_setTroopsResourse(0);
                        party.m.Name = "EquipmentEssenceOnly";
                        p.Parties.push(party);
                    }
                    party.EL_addEquipmentEssence(rank, num_1);
                    party.EL_addEquipmentEssence(rank + 1, num_2);

                }
            }
            kill(_killer, _skill, _fatalityType, _silent);
        }

	});

	::mods_hookClass("entity/world/world_entity", function(o) {
		while(!("getTroops" in o)) o = o[o.SuperName];
		o.m.EL_TempTroops <- [];
        o.m.EL_FinishGenerate <- false;
        o.m.EL_IsTempParty <- false;
		o.m.EL_IsBossParty <- false;
        o.m.EL_IsEliteParty <- false;
        o.m.EL_IsPlayer <- false;
        o.m.EL_HaveRandomLeader <- false;
        o.m.EL_HaveStrongestLeader <- false;
        o.m.EL_TroopsResourse <- 0;
        o.m.EL_LootEquipmentEssence <- [0, 0, 0, 0, 0];
        o.m.EL_Faction <- 0;
        o.m.EL_LootItems <- [];


        o.EL_tempPartyInit <- function() {
            this.getFaction <- function() { return this.EL_getFaction(); };
            this.m.EL_IsTempParty = true;
        }

        o.EL_setFaction <- function( _EL_Faction )
        {
            this.m.EL_Faction = _EL_Faction;
        }

        o.EL_getFaction <- function()
        {
            return this.m.EL_Faction;
        }

        local removeTroop = o.removeTroop;
		o.removeTroop = function( _t )
        {
            if(!this.m.EL_FinishGenerate) {
                this.m.EL_FinishGenerate = true;
            }
            return removeTroop(_t);
		}

        local clearTroops = o.clearTroops;
		o.clearTroops = function()
        {
            clearTroops();
            this.m.EL_TempTroops = [];
            this.m.EL_LootEquipmentEssence = [0, 0, 0, 0, 0];
            this.m.EL_LootItems = [];
            this.m.EL_FinishGenerate = false;
            local world_level = this.World.Assets.m.EL_WorldLevel;
            local resources_mult = 0.01 * this.Math.rand(this.Const.EL_NPC.EL_Troop.Resourse.MultBase, this.Const.EL_NPC.EL_Troop.Resourse.MultBase + world_level * this.Const.EL_NPC.EL_Troop.Resourse.MultPurWorldLevel);
            resources_mult = this.Math.rand(0, 1) == 1 ? resources_mult : (1 / resources_mult);
            this.m.EL_TroopsResourse = this.Math.round(this.World.Assets.m.EL_WorldStrength * resources_mult);
		}

		o.getTroopComposition = function()
        {
            if(!this.m.EL_FinishGenerate) {
                this.m.EL_FinishGenerate = true;
            }
            local entities = [];
            local champions = [];
            local entityTypes = [
                [],
                []
            ];
            entityTypes[0].resize(this.Const.EntityType.len(), 0);
            entityTypes[1].resize(this.Const.EntityType.len(), 0);

            foreach( t in this.m.Troops )
            {
                if (t.Script.len() != "")
                {
                    if (t.EL_RankLevel == 2)
                    {
                        champions.push(t);
                    }
                    else
                    {
                        ++entityTypes[t.EL_RankLevel][t.ID];
                    }
                }
            }

            foreach( c in champions )
            {
                entities.push({
                    id = 20,
                    type = "text",
                    icon = "ui/orientation/" + this.Const.EntityIcon[c.ID] + ".png",
                    text = c.Name
                });
            }
            for( local j = 1; j >= 0; --j ) {
                for( local i = 0; i < entityTypes[j].len(); ++i )
                {
                    if (entityTypes[j][i] > 0)
                    {
                        entities.push({
                            id = 20,
                            type = "text",
                            icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
                            text = this.Const.EL_NPC.EL_Troop.NamePrefix[j] + this.removeFromBeginningOfText("The ", this.Const.Strings.EntityName[i]) + " X " + entityTypes[j][i] + " " + this.Const.EL_NPC.EL_Troop.NameSuffix[j]
                        });
                    }
                }
            }
            return entities;
        }

		o.updateStrength = function()
        {
            if (!this.isAlive())
            {
                return;
            }
            if(this.m.EL_IsBossParty) {
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
                        unit_population += this.Math.ceil(this.m.Troops[i].Strength / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation) * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                }
                this.m.Strength = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
            }
            this.m.Strength = this.Math.max(this.m.Strength, this.m.EL_TroopsResourse);
            if (!this.m.EL_IsTempParty && this.hasLabel("name"))
            {
                if (!this.isPlayerControlled())
                {
                    if (this.m.Troops.len() != 0 && this.m.IsShowingStrength)
                    {
                        this.getLabel("name").Text = this.getName() + " (" + this.m.Troops.len() + ")";
                    }
                    else
                    {
                        this.getLabel("name").Text = this.getName();
                    }
                }
            }
        }

		o.dropMoney = function( _num, _lootTable )
        {
            _num = this.Math.max(0, this.Math.round(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.Money) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            local money = this.new("scripts/items/supplies/money_item");
            money.setAmount(_num);
            _lootTable.push(money);
		}

		o.dropFood = function( _num, _items, _lootTable )
        {
            _num = this.Math.max(0, this.Math.round(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.Food) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            for( local i = 0; i != _num; i = i )
            {
                local food = this.new("scripts/items/supplies/" + _items[this.Math.rand(0, _items.len() - 1)]);
                food.randomizeAmount();
                food.randomizeBestBefore();
                _lootTable.push(food);
                i = ++i;
            }
		}

		o.dropTreasure = function( _num, _items, _lootTable )
        {
            _num = this.Math.max(0, this.Math.floor(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.Treasure) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            for( local i = 0; i != _num; i = i )
            {
                local item = this.new("scripts/items/" + _items[this.Math.rand(0, _items.len() - 1)]);
                _lootTable.push(item);
                i = ++i;
            }
		}

		o.dropAmmo = function( _num, _lootTable )
        {
            _num = this.Math.max(0, this.Math.round(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.Ammo) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            local ammo = this.new("scripts/items/supplies/ammo_item");
            ammo.setAmount(_num);
            _lootTable.push(ammo);
		}

		o.dropArmorParts = function( _num, _lootTable )
        {
            _num = this.Math.max(0, this.Math.round(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.ArmorParts) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            local armorParts = this.new("scripts/items/supplies/armor_parts_item");
            armorParts.setAmount(_num);
            _lootTable.push(armorParts);
		}

		o.dropMedicine = function( _num, _lootTable )
        {
            _num = this.Math.max(0, this.Math.round(_num * this.m.LootScale * (1 + this.World.Assets.m.EL_WorldLevel * this.Const.EL_NPC.EL_Troop.DropIncreaseMultPurWorldLevel.Medicine) * this.World.Assets.EL_getHalfWorldDifficultFactor()));

            if (_num == 0)
            {
                return;
            }

            local medicine = this.new("scripts/items/supplies/medicine_item");
            medicine.setAmount(_num);
            _lootTable.push(medicine);
		}

        local create = o.create;
		o.create = function()
        {
            create();
            if(!this.World.Flags.has("EL_WorldDifficultyChangeEvent")) {
				this.World.Flags.set("EL_WorldDifficultyChangeEvent", this.Const.EL_World.EL_WorldChangeEvent.DefaultOption);
			}
            local world_level = this.World.Assets.m.EL_WorldLevel;
            local elite_team_chance = this.Const.EL_NPC.EL_EliteTeam.EliteTeamChance.EL_getChance(world_level);
            local random_leader_chance = 0;
            local strongest_leader_chance = 0;
            if(elite_team_chance * 10 >= this.Math.rand(1, 1000)) {
                this.m.EL_IsEliteParty = true;
            }
            if(this.m.EL_IsEliteParty) {
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
            local resources_mult = 0.01 * this.Math.rand(this.Const.EL_NPC.EL_Troop.Resourse.MultBase, this.Const.EL_NPC.EL_Troop.Resourse.MultBase + world_level * this.Const.EL_NPC.EL_Troop.Resourse.MultPurWorldLevel);
            resources_mult = this.Math.rand(0, 1) == 1 ? resources_mult : (1 / resources_mult);
            this.m.EL_TroopsResourse = this.Math.round(this.World.Assets.m.EL_WorldStrength * resources_mult);
		}

		o.onSerialize = function( _out )
        {
            _out.writeString(this.m.Name);
            _out.writeString(this.m.Description);
            _out.writeI32(this.m.EL_Faction);
            _out.writeU8(this.Math.min(255, this.m.Troops.len()));

            foreach( t in this.m.Troops )
            {
                _out.writeU16(t.ID);
                _out.writeU8(t.Variant);
                _out.writeF32(t.Strength);
                _out.writeI8(t.Row);
                _out.writeString(t.Name);

                _out.writeF32(t.EL_EliteChance);
                _out.writeI32(t.EL_ExtraCombatLevel);
                _out.writeI32(t.EL_RankLevel);
                _out.writeBool(t.EL_IsBossUnit);
                _out.writeI32(t.EL_ExtraBuffNum[0]);
                _out.writeI32(t.EL_ExtraBuffNum[1]);
                _out.writeI32(t.EL_ExtraBuffNum[2]);

                if ("Outfits" in t)
                {
                    _out.writeBool(true);
                    _out.writeU8(t.Outfits.len());

                    foreach( o in t.Outfits )
                    {
                        _out.writeU8(o.len());
                        _out.writeU8(o[0]);
                        _out.writeString(o[1]);

                        if (o.len() == 3)
                        {
                            _out.writeString(o[2]);
                        }
                    }
                }
                else
                {
                    _out.writeBool(false);
                }

                _out.writeI32(this.IO.scriptHashByFilename(t.Script));
            }

            _out.writeI32(this.m.CombatID);
            _out.writeI32(this.m.CombatSeed);
            _out.writeF32(this.m.VisionRadius);
            _out.writeF32(this.m.VisibilityMult);
            local numInventoryItems = this.m.Inventory.len();
            _out.writeI32(numInventoryItems);

            for( local i = 0; i < numInventoryItems; i = i )
            {
                _out.writeString(this.m.Inventory[i]);
                i = ++i;
            }

            _out.writeF32(this.m.LootScale);
            _out.writeBool(this.m.IsAttackable);
            _out.writeBool(this.m.IsAttackableByAI);
            _out.writeBool(this.m.IsUsingGlobalVision);
            _out.writeBool(this.m.IsShowingName);
            _out.writeBool(this.m.IsLooting);
            _out.writeBool(this.m.IsDroppingLoot);
            _out.writeU16(this.m.Resources);
            this.m.Flags.onSerialize(_out);

             _out.writeU8(this.Math.min(255, this.m.EL_TempTroops.len()));
            foreach( t in this.m.EL_TempTroops )
            {
                _out.writeU16(t.ID);
                _out.writeU8(t.Variant);
                _out.writeF32(t.Strength);
                _out.writeI8(t.Row);
                _out.writeString(t.Name);

                _out.writeF32(t.EL_EliteChance);
                _out.writeI32(t.EL_ExtraCombatLevel);
                _out.writeI32(t.EL_RankLevel);
                _out.writeBool(t.EL_IsBossUnit);
                _out.writeI32(t.EL_ExtraBuffNum[0]);
                _out.writeI32(t.EL_ExtraBuffNum[1]);
                _out.writeI32(t.EL_ExtraBuffNum[2]);

                if ("Outfits" in t)
                {
                    _out.writeBool(true);
                    _out.writeU8(t.Outfits.len());

                    foreach( o in t.Outfits )
                    {
                        _out.writeU8(o.len());
                        _out.writeU8(o[0]);
                        _out.writeString(o[1]);

                        if (o.len() == 3)
                        {
                            _out.writeString(o[2]);
                        }
                    }
                }
                else
                {
                    _out.writeBool(false);
                }

                _out.writeI32(this.IO.scriptHashByFilename(t.Script));
            }

            _out.writeBool(this.m.EL_IsTempParty);
            _out.writeBool(this.m.EL_FinishGenerate);
            _out.writeBool(this.m.EL_IsBossParty);
            _out.writeBool(this.m.EL_IsEliteParty);
            _out.writeBool(this.m.EL_IsPlayer);
            _out.writeBool(this.m.EL_HaveRandomLeader);
            _out.writeBool(this.m.EL_HaveStrongestLeader);
            _out.writeI32(this.m.EL_TroopsResourse);


            _out.writeBool(false);
        }

		o.onDeserialize = function( _in )
        {
            this.getSprite("selection").Visible = false;
            this.setSpriteOffset("selection", this.createVec(-30, 30));
            this.m.Troops = [];
            this.m.Strength = 0;
            this.m.Inventory = [];
            this.m.Name = _in.readString();
            this.m.Description = _in.readString();
            this.m.EL_Faction = _in.readI32();
            if (this.hasLabel("name"))
            {
                this.getLabel("name").Text = this.getName();
            }

            local numTroops = _in.readU8();

            for( local i = 0; i < numTroops; i = i )
            {
                local troop = clone this.Const.World.Spawn.Unit;
                troop.ID = _in.readU16();
                troop.Variant = _in.readU8();
                troop.Strength = _in.readF32();
                troop.Row = _in.readI8();
                troop.Party = this.WeakTableRef(this);
                troop.Faction = this.getFaction();



                if (_in.getMetaData().getVersion() >= 48)
                {
                    troop.Name = _in.readString();
                }
                else if (_in.getMetaData().getVersion() < 40)
                {
                    troop.ID = this.Const.EntityType.convertOldToNew(troop.ID);
                }


                troop.EL_EliteChance = _in.readF32();
                troop.EL_ExtraCombatLevel = _in.readI32();
                troop.EL_RankLevel = _in.readI32();
                troop.EL_IsBossUnit = _in.readBool()
                troop.EL_ExtraBuffNum[0] = _in.readI32();
                troop.EL_ExtraBuffNum[1] = _in.readI32();
                troop.EL_ExtraBuffNum[2] = _in.readI32();

                if (_in.getMetaData().getVersion() >= 71)
                {
                    local hasOutfits = _in.readBool();

                    if (hasOutfits)
                    {
                        local outfits = [];
                        local outfitLength = _in.readU8();

                        for( local i = 0; i < outfitLength; i++ )
                        {
                            if (_in.readU8() == 2)
                            {
                                outfits.push([
                                    _in.readU8(),
                                    _in.readString()
                                ]);
                            }
                            else
                            {
                                outfits.push([
                                    _in.readU8(),
                                    _in.readString(),
                                    _in.readU8()
                                ]);
                            }
                        }

                        troop.Outfits <- clone outfits;
                    }
                }

                local hash = _in.readI32();

                if (hash != 0)
                {
                    troop.Script = this.IO.scriptFilenameByHash(hash);
                }

                if (troop.Script == "scripts/entity/tactical/enemies/alp_illusion")
                {
                }
                else
                {
                    this.m.Troops.push(troop);
                }

                i = ++i;
            }

            this.updateStrength();
            this.m.CombatID = _in.readI32();

            if (_in.getMetaData().getVersion() >= 49)
            {
                this.m.CombatSeed = _in.readI32();
            }

            this.m.VisionRadius = _in.readF32();
            this.m.VisibilityMult = _in.readF32();
            local numInventoryItems = _in.readI32();

            for( local i = 0; i != numInventoryItems; i = i )
            {
                this.m.Inventory.push(_in.readString());
                i = ++i;
            }

            this.m.LootScale = _in.readF32();
            this.m.IsAttackable = _in.readBool();
            this.m.IsAttackableByAI = _in.readBool();
            this.m.IsUsingGlobalVision = _in.readBool();
            this.m.IsShowingName = _in.readBool();
            this.m.IsLooting = _in.readBool();
            this.m.IsDroppingLoot = _in.readBool();
            this.m.Resources = _in.readU16();

            if (this.hasLabel("name"))
            {
                this.getLabel("name").Visible = true;
            }

            this.m.Flags.onDeserialize(_in);

            this.m.EL_TempTroops = [];
            numTroops = _in.readU8();

            for( local i = 0; i < numTroops; i = i )
            {
                local troop = clone this.Const.World.Spawn.Unit;
                troop.ID = _in.readU16();
                troop.Variant = _in.readU8();
                troop.Strength = _in.readF32();
                troop.Row = _in.readI8();
                troop.Party = this.WeakTableRef(this);
                troop.Faction = (("getFaction" in this) ? this.getFaction() : this.EL_getFaction());

                if (_in.getMetaData().getVersion() >= 48)
                {
                    troop.Name = _in.readString();
                }
                else if (_in.getMetaData().getVersion() < 40)
                {
                    troop.ID = this.Const.EntityType.convertOldToNew(troop.ID);
                }


                troop.EL_EliteChance = _in.readF32();
                troop.EL_ExtraCombatLevel = _in.readI32();
                troop.EL_RankLevel = _in.readI32();
                troop.EL_IsBossUnit = _in.readBool();
                troop.EL_ExtraBuffNum[0] = _in.readI32();
                troop.EL_ExtraBuffNum[1] = _in.readI32();
                troop.EL_ExtraBuffNum[2] = _in.readI32();

                if (_in.getMetaData().getVersion() >= 71)
                {
                    local hasOutfits = _in.readBool();

                    if (hasOutfits)
                    {
                        local outfits = [];
                        local outfitLength = _in.readU8();

                        for( local i = 0; i < outfitLength; i++ )
                        {
                            if (_in.readU8() == 2)
                            {
                                outfits.push([
                                    _in.readU8(),
                                    _in.readString()
                                ]);
                            }
                            else
                            {
                                outfits.push([
                                    _in.readU8(),
                                    _in.readString(),
                                    _in.readU8()
                                ]);
                            }
                        }

                        troop.Outfits <- clone outfits;
                    }
                }

                local hash = _in.readI32();

                if (hash != 0)
                {
                    troop.Script = this.IO.scriptFilenameByHash(hash);
                }

                if (troop.Script == "scripts/entity/tactical/enemies/alp_illusion")
                {
                }
                else
                {
                    this.m.EL_TempTroops.push(troop);
                }

                i = ++i;
            }

            this.m.EL_IsTempParty = _in.readBool();
            this.m.EL_FinishGenerate = _in.readBool();
            this.m.EL_IsBossParty = _in.readBool();
            this.m.EL_IsEliteParty = _in.readBool();
            this.m.EL_IsPlayer = _in.readBool();
            this.m.EL_HaveRandomLeader = _in.readBool();
            this.m.EL_HaveStrongestLeader = _in.readBool();
            this.m.EL_TroopsResourse = _in.readI32();


            _in.readBool();
        }

        o.EL_getTroopsResourse <- function() {
            return this.m.EL_TroopsResourse;
        }

        o.EL_setTroopsResourse <- function( _EL_troopsResourse ) {
            this.m.EL_TroopsResourse = _EL_troopsResourse;
        }

        o.EL_setHaveRandomLeader <- function( _EL_haveRandomLeader ) {
            this.m.EL_HaveRandomLeader = _EL_haveRandomLeader;
        }

        o.EL_setHaveStrongestLeader <- function( _EL_haveStrongestLeader ) {
            this.m.EL_HaveStrongestLeader = _EL_haveStrongestLeader;
        }

        o.EL_setIsBossParty <- function( _EL_IsBossParty ) {
            this.m.EL_IsBossParty = _EL_IsBossParty;
        }

        o.EL_setIsEliteParty <- function( _EL_IsEliteParty ) {
            this.m.EL_IsEliteParty = _EL_IsEliteParty;
        }

        o.EL_emptyTroops <- function() {
            this.m.Troops = [];
        }



		o.EL_addTroop <- function( _EL_troop )
        {
            if(this.m.EL_IsPlayer) {
                return;
            }
            if(_EL_troop.Strength == 0) {
                _EL_troop.Strength = this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint;
            }
            if(this.m.EL_FinishGenerate) {
                local troop_info = this.Const.EL_NPC.EL_Troop.EL_getTroopInfo(_EL_troop);
                //Calculate ranks, level, combat level.
                if(_EL_troop.EL_RankLevel != 0) {
                }
                else if(troop_info.EL_IsBossUnit) {
                    _EL_troop.EL_RankLevel = this.Math.max(2, _EL_troop.EL_RankLevel);
                    _EL_troop.EL_IsBossUnit = true;
                }
                else if(troop_info.EL_IsWeakUnit) {
                    _EL_troop.EL_RankLevel = this.Math.max(0, _EL_troop.EL_RankLevel);
                }
                else {
                    if(this.m.EL_IsBossParty || this.m.EL_IsEliteParty) {
                        _EL_troop.EL_RankLevel = this.Math.max(1, _EL_troop.EL_RankLevel);
                    }
                    else {
                        local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel) + _EL_troop.EL_EliteChance;
                        elite_chance *= this.World.Assets.EL_getWorldDifficultFactor();
                        if(troop_info.EL_IsEliteUnit)
                        {
                            elite_chance *= this.Const.EL_NPC.EL_Troop.EliteUnitEliteChanceMult;
                        }
                        _EL_troop.EL_RankLevel = this.Math.max((this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1, _EL_troop.EL_RankLevel);
                    }
                }

                _EL_troop.EL_ExtraCombatLevel = troop_info.EL_ExtraCombatLevel;
                //Build names
                if(_EL_troop.EL_RankLevel == 2) {
                    _EL_troop.Name = this.Const.EL_NPC.EL_Troop.NamePrefix[_EL_troop.EL_RankLevel];
                    _EL_troop.Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
                    _EL_troop.Name += this.Const.EL_NPC.EL_Troop.NameSuffix[_EL_troop.EL_RankLevel];
                }
                local i = 0;
                for( ; i < this.m.Troops.len(); ++i) {
                    if(_EL_troop.Strength > this.m.Troops[i].Strength) {
                        this.m.Troops.insert(i, _EL_troop);
                        break;
                    }
                }
                if(i == this.m.Troops.len()) {
                    this.m.Troops.push(_EL_troop);
                }
                this.updateStrength();
            }
            else {
                //Puts the troop in the temp troops.
                local i = 0;
                for(; i < this.m.EL_TempTroops.len(); ++i) {
                    if(_EL_troop.Strength > this.m.EL_TempTroops[i].Strength) {
                        this.m.EL_TempTroops.insert(i, _EL_troop);
                        break;
                    }
                }
                if(i == this.m.EL_TempTroops.len()) {
                    this.m.EL_TempTroops.push(_EL_troop);
                }

                //Calculate current troop info.
                this.m.Troops = [];
                local troops_info = [];
                for(local i = 0; i < this.m.EL_TempTroops.len(); ++i) {
                    troops_info.push(this.Const.EL_NPC.EL_Troop.EL_getTroopInfo(this.m.EL_TempTroops[i]));
                    this.m.Troops.push(clone this.m.EL_TempTroops[i]);
                }

                //Calculate ranks, level, combat level.
                if(this.m.EL_IsBossParty) {
                    for(local i = 0; i < this.m.Troops.len(); ++i) {
                        //At least two leaders.
                        if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                            this.m.Troops[i].EL_IsBossUnit = true;
                        }
                        else if(i < this.Const.EL_NPC.EL_Troop.BossTroopMinLeaders) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                            if(this.Const.EL_NPC.EL_Troop.BossChance >= this.Math.rand(1, 100)) {
                                this.m.Troops[i].EL_IsBossUnit = true;
                            }
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(0, this.m.Troops[i].EL_RankLevel);
                        }
                        else {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(1, this.m.Troops[i].EL_RankLevel);
                        }
                        this.m.Troops[i].EL_ExtraCombatLevel = troops_info[i].EL_ExtraCombatLevel;
                    }
                }
                else if(this.m.EL_IsEliteParty) {

                    local i = 0;
                    local unit_strength = 0;
                    local unit_population = 0;
                    local used_resourse = 0;
                    local random_leader_avilable_index = [];
                    if(this.m.EL_HaveStrongestLeader && !troops_info[i].EL_IsWeakUnit && this.m.Troops[i].Strength >= this.Const.EL_NPC.EL_Troop.Rank2LeastStrength) {
                        this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                        unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel]);
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                        ++i;
                    }
                    for(; i < troops_info.len(); ++i) {
                        if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                            this.m.Troops[i].EL_IsBossUnit = true;
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(0, this.m.Troops[i].EL_RankLevel);
                        }
                        else {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(1, this.m.Troops[i].EL_RankLevel);
                            if(this.m.Troops[i].Strength >= this.Const.EL_NPC.EL_Troop.Rank2LeastStrength) {
                                random_leader_avilable_index.push(i);
                            }
                        }

                        this.m.Troops[i].EL_ExtraCombatLevel = troops_info[i].EL_ExtraCombatLevel;
                        unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel]);
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                    if(this.m.EL_HaveRandomLeader && random_leader_avilable_index.len() != 0) {
                        local random_leader_index = random_leader_avilable_index[this.Math.rand(0, random_leader_avilable_index.len() - 1)];
                        unit_strength -= this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel]);
                        unit_population -= troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        this.m.Troops[random_leader_index].EL_RankLevel = this.Math.max(2, this.m.Troops[random_leader_index].EL_RankLevel);
                        if(this.Const.EL_NPC.EL_Troop.BossChance >= this.Math.rand(1, 100)) {
                            this.m.Troops[random_leader_index].EL_IsBossUnit = true;
                        }
                        unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel]);
                        unit_population += troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                    }
                    used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                    if(used_resourse < this.m.EL_TroopsResourse) {
                        //TODO
                        //Add buffs.
                        // local loop_time = this.Const.EL_NPC.EL_NPCBuff.Pool.len();
                        // while(loop_time > 0)
                        // {
                        //     loop_time -= 1;
                        //     for(local j = 0; ; ++j) {
                        //         if(this.m.Troops[j].EL_RankLevel == 2)
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[2];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[2];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[2];
                        //         }
                        //         else if(this.m.Troops[j].EL_RankLevel == 1)
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[1];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[1];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[1];
                        //         }
                        //         else
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[0];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[0];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[0];
                        //         }
                        //         unit_strength -= this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[j].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[j].EL_RankLevel]);
                        //         this.m.Troops[j].Strength *= this.Const.EL_NPC.EL_Troop.ExtraBuffStrengthMultPurTime;
                        //         unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[j].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[j].EL_RankLevel]);
                        //         used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                        //         if(used_resourse > this.m.EL_TroopsResourse) {
                        //             loop_time = 0;
                        //             break;
                        //         }
                        //     }
                        // }
                    }
                }
                else {
                    local i = 0;
                    local unit_strength = 0;
                    local unit_population = 0;
                    local used_resourse = 0;
                    local random_leader_avilable_index = [];
                    if(this.m.EL_HaveStrongestLeader && !troops_info[i].EL_IsWeakUnit) {
                        this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                        unit_strength += this.Math.min(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel]);
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                        ++i;
                    }
                    for(; i < troops_info.len(); ++i) {
                        if(troops_info[i].EL_IsBossUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(2, this.m.Troops[i].EL_RankLevel);
                            this.m.Troops[i].EL_IsBossUnit = true;
                        }
                        else if(troops_info[i].EL_IsWeakUnit) {
                            this.m.Troops[i].EL_RankLevel = this.Math.max(0, this.m.Troops[i].EL_RankLevel);
                        }
                        else {
                            local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel) + this.m.Troops[i].EL_EliteChance;
                            elite_chance *= this.World.Assets.EL_getWorldDifficultFactor();
                            if(troops_info[i].EL_IsEliteUnit)
                            {
                                elite_chance *= this.Const.EL_NPC.EL_Troop.EliteUnitEliteChanceMult;
                            }
                            this.m.Troops[i].EL_RankLevel = this.Math.max((this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1, this.m.Troops[i].EL_RankLevel);
                            if(this.m.Troops[i].Strength >= this.Const.EL_NPC.EL_Troop.Rank2LeastStrength) {
                                random_leader_avilable_index.push(i);
                            }
                        }

                        this.m.Troops[i].EL_ExtraCombatLevel = troops_info[i].EL_ExtraCombatLevel;
                        unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[i].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[i].EL_RankLevel]);
                        unit_population += troops_info[i].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
                    }
                    if(this.m.EL_HaveRandomLeader && random_leader_avilable_index.len() != 0) {
                        local random_leader_index = random_leader_avilable_index[this.Math.rand(0, random_leader_avilable_index.len() - 1)];
                        unit_strength -= this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel]);
                        unit_population -= troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                        this.m.Troops[random_leader_index].EL_RankLevel = this.Math.max(2, this.m.Troops[random_leader_index].EL_RankLevel);
                        if(this.Const.EL_NPC.EL_Troop.BossChance >= this.Math.rand(1, 100)) {
                            this.m.Troops[random_leader_index].EL_IsBossUnit = true;
                        }
                        unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[random_leader_index].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[random_leader_index].EL_RankLevel]);
                        unit_population += troops_info[random_leader_index].EL_BasePopulation * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[random_leader_index].EL_RankLevel];
                    }
                    used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                    if(used_resourse < this.m.EL_TroopsResourse && this.m.Troops.len() > 0) {
                        //TODO
                        //Add buffs.
                        // local loop_time = this.Const.EL_NPC.EL_NPCBuff.Pool.len();
                        // while(loop_time-- > 0)
                        // {
                        //     for(local j = 0; j < this.m.Troops.len(); ++j) {
                        //         if(this.m.Troops[j].EL_RankLevel == 2)
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[2];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[2];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[2];
                        //         }
                        //         else if(this.m.Troops[j].EL_RankLevel == 1)
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[1];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[1];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[1];
                        //         }
                        //         else
                        //         {
                        //             this.m.Troops[j].EL_ExtraBuffNum[2] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[0];
                        //             this.m.Troops[j].EL_ExtraBuffNum[1] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[0];
                        //             this.m.Troops[j].EL_ExtraBuffNum[0] += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[0];
                        //         }
                        //         unit_strength -= this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[j].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[j].EL_RankLevel]);
                        //         this.m.Troops[j].Strength *= this.Const.EL_NPC.EL_Troop.ExtraBuffStrengthMultPurTime;
                        //         unit_strength += this.Math.max(this.Const.EL_NPC.EL_Troop.UnitGenerateMinCalculateResourse, this.m.Troops[j].Strength * this.Const.EL_NPC.EL_Troop.RankResouseMult[this.m.Troops[j].EL_RankLevel]);
                        //         used_resourse = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
                        //         if(used_resourse > this.m.EL_TroopsResourse) {
                        //             loop_time = 0;
                        //             break;
                        //         }
                        //     }
                        // }

                    }
                }
                while(this.m.Troops.len() > this.Const.EL_NPC.EL_Troop.MaxTroopNum) {
                    this.m.Troops.remove(this.Const.EL_NPC.EL_Troop.MaxTroopNum);
                }
                // //Build names
                for(local i = 0; i < this.m.Troops.len(); ++i) {
                    if(this.m.Troops[i].EL_RankLevel == 2) {
                        this.m.Troops[i].Name = this.Const.EL_NPC.EL_Troop.NamePrefix[this.m.Troops[i].EL_RankLevel];
                        this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
                        this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.NameSuffix[this.m.Troops[i].EL_RankLevel];
                    }
                }
            }
            return;
        }


		o.EL_dropEquipmentEssence <- function( _lootTable )
        {
			for(local i = 0; i < this.m.EL_LootEquipmentEssence.len(); ++i) {
                local num = this.m.EL_LootEquipmentEssence[i];
                if(num == 0) {
                    continue;
                }
                local essence = this.new("scripts/items/el_supplies/el_equipment_essence_rank_" + i + "_item");
                essence.EL_setAmount(num);
                _lootTable.push(essence);
            }
		}

		o.EL_addEquipmentEssence <- function(_EL_rank, _EL_num)
        {
            this.m.EL_LootEquipmentEssence[_EL_rank] += _EL_num;
		}

		o.EL_dropLootItems <- function( _lootTable )
        {
			for(local i = 0; i < this.m.EL_LootItems.len(); ++i) {
                _lootTable.push(this.m.EL_LootItems[i]);
            }
		}


        o.EL_addLootItem <- function(_EL_LootItem)
        {
            this.m.EL_LootItems.push(_EL_LootItem);
		}


		local onDropLootForPlayer = o.onDropLootForPlayer;
		o.onDropLootForPlayer = function (_lootTable)
		{
            onDropLootForPlayer(_lootTable);
            this.EL_dropEquipmentEssence(_lootTable);
            this.EL_dropLootItems(_lootTable);
		}


	});

	::mods_hookExactClass("entity/world/player_party", function(o){

		local create = o.create;
		o.create = function ()
		{
			create();
            this.m.EL_IsPlayer = true;
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
			this.m.PaymentMult *= (1 + this.Const.EL_NPC.EL_Contract.PaymentMultPurWorldLevel * this.Math.min(this.Const.EL_NPC.EL_Contract.PaymentMultMaxWorldLevel, this.World.Assets.m.EL_WorldLevel)) * this.World.Assets.EL_getHalfWorldDifficultFactor();
		};
	});

	::mods_hookExactClass("states/world_state", function ( o )
	{
        // o.onCombatFinished = function()
        // {
        //     this.logDebug("World::onCombatFinished");
        //     this.World.FactionManager.onCombatFinished();
        //     this.World.Statistics.getFlags().increment("LastCombatID", 1);
        //     this.Time.setVirtualTime(this.m.CombatStartTime);
        //     this.Math.seedRandom(this.Time.getRealTime());
        //     this.m.CombatStartTime = 0;
        //     this.m.CombatSeed = 0;
        //     this.World.Statistics.getFlags().set("LastCombatSavedCaravan", false);

        //     if (!this.World.Statistics.getFlags().get("LastCombatWasArena"))
        //     {
        //         local nonLocationBattle = true;

        //         foreach( party in this.m.PartiesInCombat )
        //         {
        //             if (party.isLocation() && !party.isAlliedWithPlayer())
        //             {
        //                 nonLocationBattle = false;
        //             }

        //             if(party.isLocation() && !party.isAlliedWithPlayer()) {
        //                 this.logInfo("world_state onCombatFinished() party.isAlive() " + party.isAlive());
        //                 this.logInfo("world_state onCombatFinished() party.getTroops().len() " + party.getTroops().len());
        //             }
        //             if (party.isAlive() && party.getTroops().len() == 0)
        //             {
        //                 party.onCombatLost();
        //             }
        //             else if (party.isAlive() && party.isAlliedWithPlayer() && party.getFlags().get("IsCaravan") && this.m.EscortedEntity == null)
        //             {
        //                 this.World.Statistics.getFlags().set("LastCombatSavedCaravan", true);
        //                 this.World.Statistics.getFlags().set("LastCombatSavedCaravanProduce", party.getInventory()[this.Math.rand(0, party.getInventory().len() - 1)]);
        //             }
        //         }

        //         this.m.PartiesInCombat = [];

        //         if (nonLocationBattle)
        //         {
        //             local playerTile = this.getPlayer().getTile();
        //             local battlefield;

        //             if (!playerTile.IsOccupied)
        //             {
        //                 battlefield = this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", playerTile.Coords);
        //             }
        //             else
        //             {
        //                 for( local i = 0; i != 6; i = i )
        //                 {
        //                     if (!playerTile.hasNextTile(i))
        //                     {
        //                     }
        //                     else
        //                     {
        //                         local nextTile = playerTile.getNextTile(i);

        //                         if (!nextTile.IsOccupied)
        //                         {
        //                             battlefield = this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", nextTile.Coords);
        //                             break;
        //                         }
        //                     }

        //                     i = ++i;
        //                 }
        //             }

        //             if (battlefield != null)
        //             {
        //                 battlefield.setSize(2);
        //             }
        //         }
        //     }

        //     if (this.World.getPlayerRoster().getSize() == 0 || !this.World.Assets.getOrigin().onCombatFinished() || this.commanderDied())
        //     {
        //         if (this.World.Assets.isIronman())
        //         {
        //             this.autosave();
        //         }

        //         this.show();
        //         this.showGameFinishScreen(false);
        //         return;
        //     }

        //     local playerRoster = this.World.getPlayerRoster().getAll();

        //     foreach( bro in playerRoster )
        //     {
        //         bro.onCombatFinished();
        //     }

        //     this.Stash.setLocked(false);
        //     this.Sound.stopAmbience();
        //     this.Sound.setAmbience(0, this.getSurroundingAmbienceSounds(), this.Const.Sound.Volume.Ambience * this.Const.Sound.Volume.AmbienceTerrain, this.World.getTime().IsDaytime ? this.Const.Sound.AmbienceMinDelay : this.Const.Sound.AmbienceMinDelayAtNight);
        //     this.Sound.setAmbience(1, this.getSurroundingLocationSounds(), this.Const.Sound.Volume.Ambience * this.Const.Sound.Volume.AmbienceOutsideSettlement, this.Const.Sound.AmbienceOutsideDelay);

        //     if (this.Settings.getGameplaySettings().RestoreEquipment)
        //     {
        //         this.World.Assets.restoreEquipment();
        //     }

        //     this.World.Assets.consumeItems();
        //     this.World.Assets.refillAmmo();
        //     this.World.Assets.updateAchievements();
        //     this.World.Assets.checkAmbitionItems();
        //     this.updateTopbarAssets();
        //     this.World.State.getPlayer().updateStrength();
        //     this.World.Events.updateBattleTime();
        //     this.World.Ambitions.resetTime();
        //     this.stunPartiesNearPlayer();
        //     this.setWorldmapMusic(true);

        //     if (this.World.Assets.isIronman())
        //     {
        //         this.autosave();
        //     }

        //     this.show();
        //     this.setAutoPause(false);
        //     this.setPause(true);
        //     this.m.IsTriggeringContractUpdatesOnce = true;
        // }


		o.showCombatDialog = function ( _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null )
        {
            local entities = [];
            local allyBanners = [];
            local enemyBanners = [];
            local hasOpponents = false;
            local listEntities = _isCombatantsVisible && (_isPlayerInitiated || this.World.Assets.getOrigin().getID() == "scenario.rangers" || this.Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type] && this.World.getTime().IsDaytime);

            if (_pos == null)
            {
                _pos = this.m.Player.getPos();
            }

            if (_properties != null)
            {
                allyBanners = _properties.AllyBanners;
                enemyBanners = _properties.EnemyBanners;
            }

            if (allyBanners.len() == 0)
            {
                allyBanners.push(this.World.Assets.getBanner());
            }

            if (!_isPlayerInitiated && this.World.Camp.isCamping())
            {
                _allowFormationPicking = false;
            }

            if (!_isPlayerInitiated && !this.Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type])
            {
                _allowFormationPicking = false;
            }

            local champions = [];
            local entityTypes = [
                [],
                []
            ];
            entityTypes[0].resize(this.Const.EntityType.len(), 0);
            entityTypes[1].resize(this.Const.EntityType.len(), 0);

            if (_properties != null)
            {
                _properties.IsPlayerInitiated = _isPlayerInitiated;
            }

            if (_properties == null)
            {
                local parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance);
                local isAtUniqueLocation = false;

                if (parties.len() <= 1)
                {
                    this.m.EngageCombatPos = null;
                    return;
                }

                foreach( party in parties )
                {
                    if (!party.isAlive() || party.isPlayerControlled())
                    {
                        continue;
                    }

                    if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
                    {
                        continue;
                    }

                    if (party.isLocation() && party.isShowingDefenders() && party.getCombatLocation().Template[0] != null && party.getCombatLocation().Fortification != 0 && !party.getCombatLocation().ForceLineBattle)
                    {
                        entities.push({
                            Name = "Fortifications",
                            Icon = "palisade_01_orientation",
                            Overlay = null
                        });
                    }

                    if (party.isLocation() && party.isLocationType(this.Const.World.LocationType.Unique))
                    {
                        isAtUniqueLocation = true;
                        break;
                    }

                    if (party.isInCombat())
                    {
                        parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance * 2.0);
                        break;
                    }
                }

                foreach( party in parties )
                {
                    if (!party.isAlive() || party.isPlayerControlled())
                    {
                        continue;
                    }

                    if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
                    {
                        continue;
                    }

                    if (isAtUniqueLocation && (!party.isLocation() || !party.isLocationType(this.Const.World.LocationType.Unique)))
                    {
                        continue;
                    }

                    if (party.isAlliedWithPlayer())
                    {
                        if (party.getTroops().len() != 0 && allyBanners.find(party.getBanner()) == null)
                        {
                            allyBanners.push(party.getBanner());
                        }

                        continue;
                    }
                    else
                    {
                        hasOpponents = true;

                        if (!party.isLocation() || party.isShowingDefenders())
                        {
                            if (party.getTroops().len() != 0 && enemyBanners.find(party.getBanner()) == null)
                            {
                                enemyBanners.push(party.getBanner());
                            }
                        }
                    }

                    if (party.isLocation() && !party.isShowingDefenders())
                    {
                        entityTypes[0].resize(this.Const.EntityType.len(), 0);
                        entityTypes[1].resize(this.Const.EntityType.len(), 0);
                        break;
                    }

                    party.onBeforeCombatStarted();
                    local troops = party.getTroops();

                    foreach( t in troops )
                    {
                        if (t.Script.len() != "")
                        {
                            if (t.EL_RankLevel == 2)
                            {
                                champions.push(t);
                            }
                            else
                            {
                                ++entityTypes[t.EL_RankLevel][t.ID];
                            }
                        }
                    }
                }
            }
            else
            {
                foreach( t in _properties.Entities )
                {
                    if (!hasOpponents && (!this.World.FactionManager.isAlliedWithPlayer(t.Faction) || _properties.TemporaryEnemies.find(t.Faction) != null))
                    {
                        hasOpponents = true;
                    }
                    if (t.EL_RankLevel == 2)
                    {
                        champions.push(t);
                    }
                    else
                    {
                        ++entityTypes[t.EL_RankLevel][t.ID];
                    }
                }
            }

            foreach( c in champions )
            {
                entities.push({
                    Name = c.Name,
                    Icon = this.Const.EntityIcon[c.ID],
                    Overlay = "el_icons/miniboss_rank2.png"
                });
            }
            for( local i = 0; i < entityTypes[1].len(); i = i )
            {
                if (entityTypes[1][i] > 0)
                {
                    entities.push({
                        Name = this.removeFromBeginningOfText("The ", this.Const.Strings.EntityName[i]) + " X " + entityTypes[1][i],
                        Icon = this.Const.EntityIcon[i],
                        Overlay = "el_icons/miniboss_rank1.png"
                    });
                }

                i = ++i;
            }
            for( local i = 0; i < entityTypes[0].len(); i = i )
            {
                if (entityTypes[0][i] > 0)
                {
                    entities.push({
                        Name = this.removeFromBeginningOfText("The ", this.Const.Strings.EntityName[i]) + " X " + entityTypes[0][i],
                        Icon = this.Const.EntityIcon[i],
                        Overlay = null
                    });
                }

                i = ++i;
            }
            for( local j = 1; j >= 0; --j ) {


            }


            if (!hasOpponents)
            {
                this.m.EngageCombatPos = null;
                return;
            }

            local text = "";

            if (!listEntities || entities.len() == 0)
            {
                entities = [];
                allyBanners = [];
                enemyBanners = [];

                if (!_isPlayerInitiated)
                {
                    text = "You can\'t make out who is attacking you in time.<br/>You have to defend yourself!";
                }
                else
                {
                    text = "You can\'t make out who you\'ll be facing. Attack at your own peril and be prepared to retreat if need be!";
                }
            }

            local tile = this.World.getTile(this.World.worldToTile(_pos));
            local image = this.Const.World.TerrainTacticalImage[tile.TacticalType];

            if (!this.World.getTime().IsDaytime)
            {
                image = image + "_night";
            }

            image = image + ".png";
            this.setAutoPause(true);
            this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
            this.m.EngageCombatPos = _pos;
            this.m.EngageByPlayer = _isPlayerInitiated;
            this.Tooltip.hide();
            this.m.WorldScreen.hide();
            this.m.CombatDialog.show(entities, allyBanners, enemyBanners, _isPlayerInitiated || this.m.EscortedEntity != null, _allowFormationPicking, text, image, this.m.EscortedEntity != null ? "Flee!" : "Fall back!");
            this.m.MenuStack.push(function ()
            {
                this.m.EngageCombatPos = null;
                this.m.CombatDialog.hide();
                this.m.WorldScreen.show();
                this.stunPartiesNearPlayer(_isPlayerInitiated);
                this.setAutoPause(false);
            }, function ()
            {
                return !this.m.CombatDialog.isAnimating();
            }, _isPlayerInitiated);
        }

	});


    gt.Const.World.Spawn.Unit.EL_EliteChance <- 0;
    gt.Const.World.Spawn.Unit.EL_ExtraCombatLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_RankLevel <- 0;
    gt.Const.World.Spawn.Unit.EL_ExtraBuffNum <- [0, 0, 0];
    gt.Const.World.Spawn.Unit.EL_IsBossUnit <- false;
    gt.Const.World.Spawn.Unit.EL_UnitInfo <- null;

    gt.Const.World.Common.addTroop = function ( _party, _troop, _updateStrength = true, _minibossify = 0, _EL_RankLevel = 0 )
    {
        local troop = clone _troop.Type;
        troop.Party <- this.WeakTableRef(_party);
        troop.Faction <- _party.getFaction();
        troop.Name <- "";
        troop.EL_EliteChance <- _minibossify + this.World.Assets.m.ChampionChanceAdditional + troop.Variant;
        troop.EL_ExtraCombatLevel <- 0;
        troop.EL_RankLevel <- _EL_RankLevel;
        troop.EL_ExtraBuffNum <- [0, 0, 0];
        troop.EL_IsBossUnit <- false;
        troop.EL_UnitInfo <- null;
        _party.EL_addTroop(troop);
        if (_updateStrength)
        {
            _party.updateStrength();
        }
        return troop;
    };


    gt.Const.World.Common.addUnitsToCombat = function ( _party, _partyList, _resources, _faction, _minibossify = 0 )
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

            for( local i = 0; i != t.Num; ++i )
            {
                this.Const.World.Common.addTroop(_party, t, false);
            }
        }
    };

    gt.Const.World.Common.EL_addEntity <- function (_EL_troop, _EL_tile, _EL_faction, _EL_rank, _EL_level = -1, _EL_assignEquipments = true)
    {
        local e = this.Tactical.spawnEntity(_EL_troop.Script, _EL_tile.Coords);
        if(e == null) {
            return e;
        }
        if (!this.World.getTime().IsDaytime && e.getBaseProperties().IsAffectedByNight)
        {
            e.getSkills().add(this.new("scripts/skills/special/night_effect"));
        }

        local troop_info = this.Const.EL_NPC.EL_Troop.EL_getTroopInfo(_EL_troop);
        e.EL_setRankLevel(_EL_rank);
        if(_EL_level != -1) {

        }
        else if(_EL_rank != 0) {
            _EL_level = this.World.Assets.m.EL_WorldLevel;
        }
        else {
            _EL_level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset)
        }
        if(_EL_level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
            _EL_level = this.Const.EL_NPC.EL_Troop.MaxLevel;
        }
        else if(_EL_level < this.Const.EL_NPC.EL_Troop.MinLevel) {
            _EL_level = this.Const.EL_NPC.EL_Troop.MinLevel;
        }
        if (_EL_rank != 0)
        {
            e.makeMiniboss();
        }

        e.EL_buildNPCPropertiesByLevel(_EL_level);
        e.EL_setCombatLevel(this.Math.min(this.Const.EL_NPC.EL_Troop.MaxCalculateLevel, _EL_level) + troop_info.EL_ExtraCombatLevel);
        e.setFaction(_EL_faction);

        if(_EL_assignEquipments) {
            e.EL_assignRandomEquipment();
        }

        local skills = e.getSkills().m.Skills;
        foreach(skill in skills)
        {
            if(skill.EL_isNPCBuff())
            {
                skill.EL_setRankLevel(_EL_rank);
            }
        }

        local extra_normal_buff_num = 0;
        local extra_elite_buff_num = 0;
        local extra_leader_buff_num = 0;
        if(troop_info.EL_IsBossUnit == true) {
            extra_elite_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank1;
            extra_leader_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank2;
        }
        if(e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null &&
           e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
        {
            extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank0[_EL_rank];
            extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank1[_EL_rank];
            extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank2[_EL_rank];
        }
        else
        {
            extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank0[_EL_rank];
            extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank1[_EL_rank];
            extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank2[_EL_rank];
        }
        local chance = this.World.Assets.EL_getWorldDifficultFactor() * 100 - 100;
        while(true) {
            local r = this.Math.rand(1, this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax);
            if(r > chance) {
                break;
            }
            chance -= this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax;
            if(_EL_rank == 2)
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[2];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[2];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[2];
            }
            else if(_EL_rank == 1)
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[1];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[1];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[1];
            }
            else
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[0];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[0];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[0];
            }
        }
        if(e.getFaction() != this.Const.Faction.Player && e.getFaction() != this.Const.Faction.PlayerAnimals) {
            this.Const.EL_NPC.EL_NPCBuff.EL_assignNPCBuffs(e, extra_normal_buff_num, extra_elite_buff_num, extra_leader_buff_num);
        }


        e.EL_ballanceNPCPropertiesAfterAddingEquipment();
        return e;
    }

    gt.Const.World.Common.EL_addEntityByScript <- function (_EL_script, _EL_tile, _EL_faction, _EL_rank, _EL_level = -1, _EL_assignEquipments = true, _EL_isBossUnit = false, _EL_extraCombatLevel = 0)
    {
        local e = this.Tactical.spawnEntity(_EL_script, _EL_tile.Coords);
        if(e == null) {
            return e;
        }
        if (!this.World.getTime().IsDaytime && e.getBaseProperties().IsAffectedByNight)
        {
            e.getSkills().add(this.new("scripts/skills/special/night_effect"));
        }

        e.EL_setRankLevel(_EL_rank);
        if(_EL_level != -1) {

        }
        else if(_EL_rank != 0) {
            _EL_level = this.World.Assets.m.EL_WorldLevel;
        }
        else {
            _EL_level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset)
        }
        if(_EL_level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
            _EL_level = this.Const.EL_NPC.EL_Troop.MaxLevel;
        }
        else if(_EL_level < this.Const.EL_NPC.EL_Troop.MinLevel) {
            _EL_level = this.Const.EL_NPC.EL_Troop.MinLevel;
        }
        if (_EL_rank != 0)
        {
            e.makeMiniboss();
        }

        e.EL_buildNPCPropertiesByLevel(_EL_level);
        e.EL_setCombatLevel(this.Math.min(this.Const.EL_NPC.EL_Troop.MaxCalculateLevel, _EL_level) + _EL_extraCombatLevel);
        e.setFaction(_EL_faction);

        if(_EL_assignEquipments) {
            e.EL_assignRandomEquipment();
        }

        local skills = e.getSkills().m.Skills;
        foreach(skill in skills)
        {
            if(skill.EL_isNPCBuff())
            {
                skill.EL_setRankLevel(_EL_rank);
            }
        }

        local extra_normal_buff_num = 0;
        local extra_elite_buff_num = 0;
        local extra_leader_buff_num = 0;
        if(_EL_isBossUnit == true) {
            extra_elite_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank1;
            extra_leader_buff_num = this.Const.EL_NPC.EL_NPCBuff.Num.BossUnitExtraRank2;
        }
        if(e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null &&
           e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
        {
            extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank0[_EL_rank];
            extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank1[_EL_rank];
            extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.NonHumanoidRank2[_EL_rank];
        }
        else
        {
            extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank0[_EL_rank];
            extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank1[_EL_rank];
            extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.HumanoidRank2[_EL_rank];
        }
        local chance = this.World.Assets.EL_getWorldDifficultFactor() * 100 - 100;
        while(true) {
            local r = this.Math.rand(1, this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax);
            if(r > chance) {
                break;
            }
            chance -= this.Const.EL_NPC.EL_Troop.ExtraBuffRollMax;
            if(_EL_rank == 2)
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[2];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[2];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[2];
            }
            else if(_EL_rank == 1)
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[1];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[1];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[1];
            }
            else
            {
                extra_leader_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank2[0];
                extra_elite_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank1[0];
                extra_normal_buff_num += this.Const.EL_NPC.EL_NPCBuff.Num.ExtraBuffRank0[0];
            }
        }
        if(e.getFaction() != this.Const.Faction.Player && e.getFaction() != this.Const.Faction.PlayerAnimals) {
            this.Const.EL_NPC.EL_NPCBuff.EL_assignNPCBuffs(e, extra_normal_buff_num, extra_elite_buff_num, extra_leader_buff_num);
        }

        e.EL_ballanceNPCPropertiesAfterAddingEquipment();
        return e;
    }

});


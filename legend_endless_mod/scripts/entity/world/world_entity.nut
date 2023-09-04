this.world_entity <- {
	m = {
		Name = "",
		Description = "",
		VisionRadius = this.Const.World.Settings.Vision,
		VisibilityMult = 1.0,
		CombatID = 0,
		CombatSeed = 0,
		OnCombatWithPlayerCallback = null,
		Troops = [],
		Strength = 0.0,
		Flags = null,
		Inventory = [],
		LootScale = 1.0,
		IsAlive = true,
		IsDirty = false,
		IsAttackable = false,
		IsAttackableByAI = true,
		IsDestructible = true,
		IsLooting = false,
		IsDroppingLoot = true,
		IsUsingGlobalVision = true,
		IsShowingStrength = true,
		IsShowingName = true,
		Resources = 0,

		EL_TempTroops = [],
        EL_FinishGenerate = false,
		EL_IsBossTroop = false,
        EL_IsEliteTeam = false,
        EL_IsPlayer = false,
        EL_HaveRandomLeader = false,
        EL_HaveStrongestLeader = false,
        EL_TroopsResourse = 0,
	},
	function getName()
	{
		return this.m.Name;
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getFlags()
	{
		return this.m.Flags;
	}

	function getVisibilityMult()
	{
		return this.m.VisibilityMult;
	}

	function getCombatID()
	{
		return this.m.CombatID;
	}

	function getCombatSeed()
	{
		return this.m.CombatSeed;
	}

	//OVERRIDE
	function getTroops()
	{
		this.m.EL_FinishGenerate = true;
		return this.m.Troops;
	}

	//OVERRIDE
	function getStrength()
	{
		this.m.EL_FinishGenerate = true;
		return this.m.Strength;
	}

	//OVERRIDE
	function clearTroops()
	{
		this.m.Troops = [];
		this.updateStrength();

		this.m.EL_TempTroops = [];
		this.m.EL_FinishGenerate = false;
	}

	function setDirty( _v )
	{
		this.m.IsDirty = _v;
	}

	function setName( _n )
	{
		this.m.Name = _n;
		this.updateStrength();
	}

	function setDescription( _v )
	{
		this.m.Description = _v;
	}

	function setCombatID( _v )
	{
		this.m.CombatID = _v;
	}

	function isAlive()
	{
		return this.m.IsAlive;
	}

	function isDirty()
	{
		return this.m.IsDirty;
	}

	function isAttackable()
	{
		return this.m.IsAttackable && this.m.VisibilityMult > 0;
	}

	function isAttackableByAI()
	{
		return this.m.IsAttackableByAI;
	}

	function isDestructible()
	{
		return this.m.IsDestructible;
	}

	function isUsingGlobalVision()
	{
		return this.m.IsUsingGlobalVision;
	}

	function isInCombat()
	{
		return this.m.CombatID != 0;
	}

	function isParty()
	{
		return false;
	}

	function isLocation()
	{
		return false;
	}

	function isLooting()
	{
		return this.m.IsLooting;
	}

	function isDroppingLoot()
	{
		return this.m.IsDroppingLoot;
	}

	function isPlayerControlled()
	{
		return this.getFaction() == this.Const.FactionType.Player;
	}

	function isAlliedWithPlayer()
	{
		return this.getFaction() == 0 || this.getFaction() == this.Const.FactionType.Player || this.World.FactionManager.isAlliedWithPlayer(this.getFaction());
	}

	function setAttackable( _f )
	{
		this.m.IsAttackable = _f;
	}

	function setAttackableByAI( _f )
	{
		this.m.IsAttackableByAI = _f;
	}

	function setVisibilityMult( _v )
	{
		this.m.VisibilityMult = _v;
	}

	function setVisionRadius( _v )
	{
		this.m.VisionRadius = _v;
	}

	function setUsingGlobalVision( _v )
	{
		this.m.IsUsingGlobalVision = _v;
	}

	function setLooting( _f )
	{
		this.m.IsLooting = _f;
	}

	function setShowName( _b )
	{
		this.m.IsShowingName = _b;

		if (this.hasLabel("name"))
		{
			this.getLabel("name").Visible = _b;
		}
	}

	function setDropLoot( _l )
	{
		this.m.IsDroppingLoot = _l;
	}

	function setLootScale( _f )
	{
		this.m.LootScale = _f;
	}

	function getInventory()
	{
		return this.m.Inventory;
	}

	function addToInventory( _i )
	{
		this.m.Inventory.push(_i);
	}

	function clearInventory()
	{
		this.m.Inventory = [];
	}

	function getLoot()
	{
		return this.m.Loot;
	}

	function isAlliedWith( _p )
	{
		if (this.getFaction() == 0)
		{
			return true;
		}

		local f = _p;

		if (typeof _p == "instance" || typeof _p == "table")
		{
			f = _p.getFaction();
		}

		return f == this.getFaction() || this.World.FactionManager.isAllied(this.getFaction(), f);
	}

	function setFaction( _f )
	{
		this.setFactionEx(_f);
		this.updatePlayerRelation();
	}

	function setOnCombatWithPlayerCallback( _c )
	{
		this.m.OnCombatWithPlayerCallback = _c;
	}

	function getVisionRadius()
	{
		if (!this.m.IsUsingGlobalVision)
		{
			return this.m.VisionRadius * this.Const.World.TerrainTypeVisionRadiusMult[this.getTile().Type];
		}
		else
		{
			return this.m.VisionRadius * this.World.getGlobalVisibilityMult() * this.Const.World.TerrainTypeVisionRadiusMult[this.getTile().Type];
		}
	}

	function isAbleToSee( _entity )
	{
		local e = typeof _entity == "instance" ? _entity.get() : this._entity2;
		return e.isVisibleToEntity(this, this.getVisionRadius());
	}

	function getImagePath()
	{
		return "worldentity(" + this.Math.rand() + "," + this.getID() + ")";
	}

	//OVERRIDE
	function getTooltip()
	{
		this.m.EL_FinishGenerate = true;
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function getDefenderCount()
	{
		return this.m.Troops.len();
	}

	//OVERRIDE
	function getTroopComposition()
	{
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

	function setOrders( _o )
	{
	}

	function fadeOutAndDie()
	{
		this.m.IsAlive = false;
		this.fadeAndDie();
	}

	function updatePlayerRelation()
	{
		if (this.isPlayerControlled())
		{
			return;
		}

		if (!this.hasLabel("name"))
		{
			return;
		}

		if (!this.isAlliedWithPlayer())
		{
			if (this.World.FactionManager.getFaction(this.getFaction()).isPlayerRelationPermanent())
			{
				this.getLabel("name").Color = this.Const.Factions.PermanentHostileColor;
			}
			else
			{
				this.getLabel("name").Color = this.Const.Factions.HostileColor;
			}
		}
		else
		{
			this.getLabel("name").Color = this.Const.Factions.NeutralColor;
		}
	}

	//OVERRIDE
	function updateStrength()
	{
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
					unit_population += this.Math.ceil(this.m.Troops[i].Strength / this.Const.EL_NPC.EL_Troop.StrengthPurPopulation) * this.Const.EL_NPC.EL_Troop.RankPopulationMult[this.m.Troops[i].EL_RankLevel];
				}
			}
			this.m.Strength = unit_strength * (1 + this.Math.pow(unit_population / this.Const.EL_NPC.EL_Troop.TotalResourse.Factor1, this.Const.EL_NPC.EL_Troop.TotalResourse.Factor2));
		}
	}

	function getStrengthAsText()
	{
		local v = 0;

		if (this.m.Strength != 0)
		{
			v = this.m.Strength;
		}
		else
		{
			return "";
		}

		local p = this.World.State.getPlayer() != null ? this.World.State.getPlayer().getStrength() : 33;
		local s = p / (v * 1.0);

		if (s >= 0.85 && s <= 1.15)
		{
			return "Even";
		}
		else if (s >= 0.7 && s < 0.85)
		{
			return "Challenging";
		}
		else if (s >= 0.5 && s < 0.7)
		{
			return "Deadly";
		}
		else if (s < 0.5)
		{
			return "Impossible";
		}
		else if (s >= 1.15 && s <= 1.3)
		{
			return "Slightly Weaker";
		}
		else if (s >= 1.3 && s <= 1.5)
		{
			return "Weaker";
		}
		else if (s > 1.5)
		{
			return "Puny";
		}

		return "Unknown";
	}

	function removeTroop( _t )
	{
		if (!this.isAlive())
		{
			return;
		}

		foreach( i, troop in this.m.Troops )
		{
			if (troop == _t)
			{
				this.m.Troops.remove(i);
				break;
			}
		}

		this.updateStrength();
	}

	function stun( _seconds )
	{
	}

	function dropMoney( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local money = this.new("scripts/items/supplies/money_item");
		money.setAmount(_num);
		_lootTable.push(money);
	}

	function dropFood( _num, _items, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

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

	function dropTreasure( _num, _items, _lootTable )
	{
		_num = this.Math.max(0, this.Math.floor(_num * this.m.LootScale));

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

	function dropAmmo( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local ammo = this.new("scripts/items/supplies/ammo_item");
		ammo.setAmount(_num);
		_lootTable.push(ammo);
	}

	function dropArmorParts( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local armorParts = this.new("scripts/items/supplies/armor_parts_item");
		armorParts.setAmount(_num);
		_lootTable.push(armorParts);
	}

	function dropMedicine( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local medicine = this.new("scripts/items/supplies/medicine_item");
		medicine.setAmount(_num);
		_lootTable.push(medicine);
	}

	//OVERRIDE
	function create()
	{
		this.m.Flags = this.new("scripts/tools/tag_collection");

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
		this.m.EL_TroopsResourse = this.Math.round(this.World.Assets.m.EL_WorldStrength * this.Math.rand(this.Const.EL_NPC.EL_Troop.Resourse.MinMult, this.Const.EL_NPC.EL_Troop.Resourse.MaxMult) / 100);
	}


	function onUpdate()
	{
		if (!this.m.IsAlive)
		{
			return;
		}

		this.setVisibility(this.m.VisibilityMult * this.Const.World.TerrainTypeVisibilityMult[this.getTile().Type]);

		if (this.Const.World.AI.VisionDebugMode)
		{
			local debug_vision = this.getSprite("debug_vision");
			debug_vision.Scale = this.getVisionRadius() / 100.0;
		}
	}

	function onBeforeCombatStarted()
	{
	}

	function onCombatStarted()
	{
	}

	function onCombatWon()
	{
	}

	function onCombatLost()
	{
		if (this.m.IsDestructible)
		{
			if (this.hasLabel("name"))
			{
				this.getLabel("name").Visible = false;
			}

			this.fadeOutAndDie();
		}
	}

	function onDropLootForPlayer( _lootTable )
	{
		foreach( item in this.m.Inventory )
		{
			local item = this.new("scripts/items/" + item);

			if (item.isItemType(this.Const.Items.ItemType.Food))
			{
				item.randomizeAmount();
				item.randomizeBestBefore();
			}

			_lootTable.push(item);
		}
	}

	function onEnteringCombatWithPlayer( _isPlayerAttacking = true )
	{
		if (this.m.OnCombatWithPlayerCallback != null)
		{
			this.m.OnCombatWithPlayerCallback(this, _isPlayerAttacking);
			return false;
		}
		else
		{
			return true;
		}
	}

	function onInit()
	{
		this.m.IsDirty = true;

		if (this.Const.World.AI.VisionDebugMode)
		{
			local debug_vision = this.addSprite("debug_vision");
			debug_vision.setBrush("debug_circle_100");
			debug_vision.Scale = this.m.VisionRadius / 100.0;
			debug_vision.Visible = false;
		}

		if (this.m.CombatSeed == 0)
		{
			this.m.CombatSeed = this.Math.rand();
		}
	}

	function onAfterInit()
	{
		local selection = this.addSprite("selection");
		this.setSpriteScaling("selection", false);
		this.setSpriteOffset("selection", this.createVec(-30, 30));
		selection.setBrush("world_party_selection");
		selection.Visible = false;
		this.updateStrength();
	}

	function onFinish()
	{
		this.m.IsAlive = false;
	}

	function onDiscovered()
	{
		if (!this.World.State.isPaused() && this.isAttackable() && this.getFaction() != 0 && !this.isAlliedWithPlayer())
		{
			this.World.State.playEnemyDiscoveredSound();
		}
	}

	function getResources()
	{
		return this.m.Resources;
	}

	function setResources( _v )
	{
		this.m.Resources = this.Math.max(0, this.Math.round(_v));
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Description);
		_out.writeU8(this.Math.min(255, this.m.Troops.len()));

		foreach( t in this.m.Troops )
		{
			_out.writeU16(t.ID);
			_out.writeU8(t.Variant);
			_out.writeF32(t.Strength);
			_out.writeI8(t.Row);
			_out.writeString(t.Name);

			_out.writeF32(t.EL_EliteChance);
			_out.writeI32(t.EL_Level);
			_out.writeI32(t.EL_CombatLevel);
			_out.writeI32(t.EL_RankLevel);


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
		local numInventoryItems = this.Math.min(255, this.m.Inventory.len());
		_out.writeU8(numInventoryItems);

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
			_out.writeI32(t.EL_Level);
			_out.writeI32(t.EL_CombatLevel);
			_out.writeI32(t.EL_RankLevel);


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

		_out.writeBool(this.m.EL_FinishGenerate);
		_out.writeBool(this.m.EL_IsBossTroop);
		_out.writeBool(this.m.EL_IsEliteTeam);
		_out.writeBool(this.m.EL_IsPlayer);
		_out.writeBool(this.m.EL_HaveRandomLeader);
		_out.writeBool(this.m.EL_HaveStrongestLeader);
		_out.writeI32(this.m.EL_TroopsResourse);


		_out.writeBool(false);
	}

	function onDeserialize( _in )
	{
		this.getSprite("selection").Visible = false;
		this.setSpriteOffset("selection", this.createVec(-30, 30));
		this.m.Troops = [];
		this.m.Strength = 0;
		this.m.Inventory = [];
		this.m.Name = _in.readString();
		this.m.Description = _in.readString();

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
			troop.EL_Level = _in.readI32();
			troop.EL_CombatLevel = _in.readI32();
			troop.EL_RankLevel = _in.readI32();


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
		local numInventoryItems = _in.readU8();

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
			troop.EL_Level = _in.readI32();
			troop.EL_CombatLevel = _in.readI32();
			troop.EL_RankLevel = _in.readI32();


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

		this.m.EL_FinishGenerate = _in.readBool();
		this.m.EL_IsBossTroop = _in.readBool();
		this.m.EL_IsEliteTeam = _in.readBool();
		this.m.EL_IsPlayer = _in.readBool();
		this.m.EL_HaveRandomLeader = _in.readBool();
		this.m.EL_HaveStrongestLeader = _in.readBool();
		this.m.EL_TroopsResourse = _in.readI32();


		_in.readBool();
	}



	function EL_addTroop( _EL_troop ) {
		if(this.m.EL_IsPlayer) {
			return;
		}
		if(_EL_troop.Strength == 0) {
			_EL_troop.Strength = this.Const.EL_NPC.EL_Troop.ExtraCombatLevel.CrticalPoint;
		}
		if(this.m.EL_FinishGenerate) {
			local troop_info = this.Const.EL_NPC.EL_Troop.EL_getTroopInfo(_EL_troop);
			//Calculate ranks, level, combat level.
			if(troop_info.EL_IsBossUnit) {
				_EL_troop.EL_RankLevel = 2;
			}
			else if(troop_info.EL_IsEliteUnit) {
				_EL_troop.EL_RankLevel = 1;
			}
			else if(troop_info.EL_IsWeakUnit) {
				_EL_troop.EL_RankLevel = 0;
			}
			else {
				if(this.m.EL_IsBossTroop || this.m.EL_IsEliteTeam) {
					_EL_troop.EL_RankLevel = 1;
				}
				else {
					local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
					_EL_troop.EL_RankLevel = (this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1;
				}
			}
			if(_EL_troop.EL_RankLevel == 0) {
				_EL_troop.EL_Level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
			}
			else {
				_EL_troop.EL_Level = this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset;
			}
			if(_EL_troop.EL_Level > this.Const.EL_NPC.EL_Troop.MaxLevel) {
				_EL_troop.EL_Level = this.Const.EL_NPC.EL_Troop.MaxLevel;
			}
			else if(_EL_troop.EL_Level < this.Const.EL_NPC.EL_Troop.MinLevel) {
				_EL_troop.EL_Level = this.Const.EL_NPC.EL_Troop.MinLevel;
			}
			_EL_troop.EL_CombatLevel = (_EL_troop.EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? _EL_troop.EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troop_info.EL_ExtraCombatLevel;
			//Build names
			if(_EL_troop.EL_RankLevel != 0) {
				_EL_troop.Name = this.Const.EL_NPC.EL_Troop.NamePrefix[_EL_troop.EL_RankLevel];
				_EL_troop.Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
				_EL_troop.Name += this.Const.EL_NPC.EL_Troop.NameSuffix[_EL_troop.EL_RankLevel];
			}
			this.m.Troops.push(_EL_troop);
		}
		else {
			//Puts the troop in the temp troops.
			local i = 0;
			for(; i < this.m.Troops.len(); ++i) {
				if(_EL_troop.Strength > this.m.Troops[i].Strength) {
					this.m.EL_TempTroops.insert(i, _EL_troop);
					break;
				}
			}
			if(i == this.m.Troops.len()) {
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
					this.m.Troops[i].EL_CombatLevel = (this.m.Troops[i].EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? this.m.Troops[i].EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troops_info[i].EL_ExtraCombatLevel;
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
						this.m.Troops[i].EL_Level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
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
					this.m.Troops[i].EL_CombatLevel = (this.m.Troops[i].EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? this.m.Troops[i].EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troops_info[i].EL_ExtraCombatLevel;
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
							troop.EL_Level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
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
						troop.EL_CombatLevel = (troop.EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? troop.EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troops_info[j].EL_ExtraCombatLevel;
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
						local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
						this.m.Troops[i].EL_RankLevel = (this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1;
						random_leader_avilable_index.push(i);
					}
					if(this.m.Troops[i].EL_RankLevel == 0) {
						this.m.Troops[i].EL_Level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
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
					this.m.Troops[i].EL_CombatLevel = (this.m.Troops[i].EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? this.m.Troops[i].EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troops_info[i].EL_ExtraCombatLevel;
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
				if(used_resourse < this.m.EL_TroopsResourse && this.m.Troops.len() > 0) {
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
							local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
							troop.EL_RankLevel = (this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1;
						}
						if(troop.EL_RankLevel == 0) {
							troop.EL_Level = this.Math.rand(this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MinLevelOffset, this.World.Assets.m.EL_WorldLevel + this.Const.EL_NPC.EL_Troop.MaxLevelOffset);
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
						troop.EL_CombatLevel = (troop.EL_Level < this.Const.EL_NPC.EL_Troop.MaxCombatlevel ? troop.EL_Level : this.Const.EL_NPC.EL_Troop.MaxCombatlevel) + troops_info[j].EL_ExtraCombatLevel;
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
			// //Build names
			for(local i = 0; i < this.m.Troops.len(); ++i) {
				if(this.m.Troops[i].EL_RankLevel == 2) {
					this.m.Troops[i].Name = this.Const.EL_NPC.EL_Troop.NamePrefix[this.m.Troops[i].EL_RankLevel];
					this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.Name[this.Math.rand(0, this.Const.EL_NPC.EL_Troop.Name.len() - 1)];
					this.m.Troops[i].Name += this.Const.EL_NPC.EL_Troop.NameSuffix[this.m.Troops[i].EL_RankLevel];
				}
			}
		}
		this.updateStrength();
		return;
	}

};


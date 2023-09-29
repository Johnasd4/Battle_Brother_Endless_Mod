local gt = getroottable();

::mods_registerMod("el_adaption_entity_tactical_enimies", 1, "el_adaption_entity_tactical_enimies");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("entity/tactical/enemies/goblin_wolfrider", function(o){

        o.spawnWolf = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.Wolf, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());
            if (entity != null)
            {
                entity.setVariant(this.m.Variant, _info.WolfColor, _info.WolfSaturation, 0.45);
                entity.setMoraleState(_info.Morale);
            }
        }

        o.spawnGoblin = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.GoblinSkirmisher, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());

            if (entity != null)
            {
                local newBody = entity.getSprite("body");
                newBody.setBrush(_info.Body);
                newBody.Color = _info.Color;
                newBody.Saturation = _info.Saturation;
                local newHead = entity.getSprite("head");
                newHead.setBrush(_info.Head);
                newHead.Color = _info.Color;
                newHead.Saturation = _info.Saturation;
                entity.getItems().clear();
                this.m.Items.transferTo(entity.getItems());
                entity.setMoraleState(_info.Morale);
                entity.setHitpoints(entity.getHitpointsMax() * 0.45);
                entity.onUpdateInjuryLayer();
            }
        }


    });

	::mods_hookExactClass("entity/tactical/enemies/kobold_wolfrider", function(o){

        o.spawnWolf = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.Wolf, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());
            if (entity != null)
            {
                entity.setVariant(this.m.Variant, _info.WolfColor, _info.WolfSaturation, 0.45);
                entity.setMoraleState(_info.Morale);
            }
        }

        o.spawnGoblin = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.GoblinSkirmisher, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());

            if (entity != null)
            {
                local newBody = entity.getSprite("body");
                newBody.setBrush(_info.Body);
                newBody.Color = _info.Color;
                newBody.Saturation = _info.Saturation;
                local newHead = entity.getSprite("head");
                newHead.setBrush(_info.Head);
                newHead.Color = _info.Color;
                newHead.Saturation = _info.Saturation;
                entity.getItems().clear();
                this.m.Items.transferTo(entity.getItems());
                entity.setMoraleState(_info.Morale);
                entity.setHitpoints(entity.getHitpointsMax() * 0.45);
                entity.onUpdateInjuryLayer();
            }
        }


    });

	::mods_hookExactClass("entity/tactical/enemies/kraken", function(o){

        o.onTentacleDestroyed = function()
        {
            if (!this.isAlive() || this.isDying())
            {
                return;
            }

            ++this.m.TentaclesDestroyed;

            foreach( i, t in this.m.Tentacles )
            {
                if (t.isNull() || t.isDying() || !t.isAlive())
                {
                    this.m.Tentacles.remove(i);
                    break;
                }
            }

            local hitInfo = clone this.Const.Tactical.HitInfo;
            hitInfo.DamageRegular = this.Math.max(35, 190 - (this.m.TentaclesDestroyed - 1) * 5);
            hitInfo.DamageDirect = 1.0;
            hitInfo.BodyPart = this.Const.BodyPart.Head;
            hitInfo.BodyDamageMult = 1.0;
            hitInfo.FatalityChanceMult = 0.0;
            this.onDamageReceived(this, null, hitInfo);

            if (!this.isAlive() || this.isDying())
            {
                return;
            }

            for( local numTentacles = this.Math.max(4, this.Math.min(8, this.Math.ceil(this.getHitpointsPct() * 2.0 * 8))); this.m.Tentacles.len() < numTentacles;  )
            {
                local mapSize = this.Tactical.getMapSize();
                local myTile = this.getTile();

                for( local attempts = 0; attempts < 500; attempts = attempts )
                {
                    local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 8), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
                    local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
                    local tile = this.Tactical.getTileSquare(x, y);

                    if (!tile.IsEmpty)
                    {
                    }
                    else
                    {
                        local tentacle = this.Const.World.Common.EL_addEntity({
                            ID = this.Const.EntityType.KrakenTentacle,
                            Variant = 0,
                            Strength = 0,
                            Cost = 0,
                            Row = 0,
                            Script = "scripts/entity/tactical/enemies/kraken_tentacle"
                        }, tile, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel());
                        tentacle.setParent(this);
                        tentacle.setMode(this.m.IsEnraged ? 1 : 0);
                        tentacle.riseFromGround();
                        this.m.Tentacles.push(this.WeakTableRef(tentacle));
                        break;
                    }

                    attempts = ++attempts;
                }
            }
        }

        o.onPlacedOnMap = function()
        {
            this.actor.onPlacedOnMap();
            this.getTile().clear();
            this.getTile().IsHidingEntity = false;
            local myTile = this.getTile();

            if (myTile.hasNextTile(this.Const.Direction.N))
            {
                local tile = myTile.getNextTile(this.Const.Direction.N);

                if (tile.IsEmpty)
                {
                    local tentacle = this.Const.World.Common.EL_addEntity({
                        ID = this.Const.EntityType.KrakenTentacle,
                        Variant = 0,
                        Strength = 0,
                        Cost = 0,
                        Row = 0,
                        Script = "scripts/entity/tactical/enemies/kraken_tentacle"
                    }, tile, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel());
                }

                if (tile.hasNextTile(this.Const.Direction.N))
                {
                    local tile = tile.getNextTile(this.Const.Direction.N);

                    if (tile.IsEmpty)
                    {
                        local tentacle = this.Const.World.Common.EL_addEntity({
                            ID = this.Const.EntityType.KrakenTentacle,
                            Variant = 0,
                            Strength = 0,
                            Cost = 0,
                            Row = 0,
                            Script = "scripts/entity/tactical/enemies/kraken_tentacle"
                        }, tile, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel());
                    }
                }
            }
        }

    });

	::mods_hookExactClass("entity/tactical/enemies/legend_bandit_outrider", function(o){

        o.spawnWolf = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity({
                ID = 0,
                Variant = 0,
                Strength = 10,
                Cost = 0,
                Row = 0,
                Script = "scripts/entity/tactical/enemies/legend_horse"
            }, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());

            if (entity != null)
            {
                entity.setVariant(this.m.Variant);
                entity.setMoraleState(_info.Morale);
            }
        }

        o.spawnGoblin = function( _info )
        {
            this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
            local entity = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.BanditThug, _info.Tile, _info.Faction, this.EL_getRankLevel(), this.EL_getLevel());

            if (entity != null)
            {
                local newHead = entity.getSprite("head");
                newHead.setBrush(_info.Head);
                newHead.Color = _info.Color;
                newHead.Saturation = _info.Saturation;
                entity.getItems().clear();
                this.m.Items.transferTo(entity.getItems());
                entity.setMoraleState(_info.Morale);
                entity.setHitpoints(entity.getHitpointsMax() * 0.45);
                entity.onUpdateInjuryLayer();
            }
        }

    });

	::mods_hookExactClass("entity/tactical/enemies/legend_stollwurm_tail", function(o){

		o.EL_getRankLevel <- function ()
		{
			return this.m.Body.m.EL_RankLevel;
		}
		o.EL_getCombatLevel <- function ()
		{
			return this.m.Body.m.CurrentProperties.EL_CombatLevel;
		}
        o.getName <- function()
		{
			return this.m.Name + " - Lv" + this.m.Body.m.EL_NPCLevel + "(" + ((this.Math.round(this.EL_getCombatLevel() * 10) * 0.1)) + ")";
		}
        o.getXP <- function()
		{
			return this.m.Body.m.XP;
		}
    });

	::mods_hookExactClass("entity/tactical/enemies/lindwurm_tail", function(o){

		o.EL_getRankLevel <- function ()
		{
			return this.m.Body.m.EL_RankLevel;
		}
		o.EL_getCombatLevel <- function ()
		{
			return this.m.Body.m.CurrentProperties.EL_CombatLevel;
		}
        o.getName <- function()
		{
			return this.m.Name + " - Lv" + this.m.Body.m.EL_NPCLevel + "(" + ((this.Math.round(this.EL_getCombatLevel() * 10) * 0.1)) + ")";
		}
        o.getXP <- function()
		{
			return this.m.Body.m.XP;
		}
    });

	::mods_hookExactClass("entity/tactical/enemies/sand_golem", function(o){

        o.onDeath = function( _killer, _skill, _tile, _fatalityType )
        {
            if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
            {
                this.updateAchievement("StoneMason", 1, 1);
            }

            this.m.BackupFaction = this.getFaction();
            this.m.BackupWorldParty = this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null && !this.m.WorldTroop.Party.isNull() ? this.m.WorldTroop.Party : null;

            if (_tile != null && this.getSize() > 1)
            {
                local freeTiles = [];

                for( local i = 0; i < 6; i = i )
                {
                    if (!_tile.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local nextTile = _tile.getNextTile(i);

                        if (nextTile.Level > _tile.Level + 1)
                        {
                        }
                        else if (nextTile.IsEmpty)
                        {
                            freeTiles.push(nextTile);
                        }
                    }

                    i = ++i;
                }

                if (freeTiles.len() != 0)
                {
                    local n = 2;

                    while (n != 0 && freeTiles.len() >= 1)
                    {
                        local r = this.Math.rand(0, freeTiles.len() - 1);
                        local tile = freeTiles[r];
                        freeTiles.remove(r);
                        local rock = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.SandGolem, tile, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel());
                        n = n - 1;

                        if (this.getWorldTroop() != null && ("Party" in this.getWorldTroop()) && this.getWorldTroop().Party != null && !this.m.WorldTroop.Party.isNull())
                        {
                            local e;

                            if (this.getSize() == 3)
                            {
                                e = this.Const.World.Common.addTroop(this.getWorldTroop().Party.get(), {
                                    Type = this.Const.World.Spawn.Troops.SandGolemMEDIUM
                                }, false);
                            }
                            else
                            {
                                e = this.Const.World.Common.addTroop(this.getWorldTroop().Party.get(), {
                                    Type = this.Const.World.Spawn.Troops.SandGolem
                                }, false);
                            }

                            rock.setWorldTroop(e);
                        }

                        rock.getSprite("body").Color = this.getSprite("body").Color;
                        rock.getSprite("body").Saturation = this.getSprite("body").Saturation;

                        if (tile.IsVisibleForPlayer)
                        {
                            for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = i )
                            {
                                this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, tile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
                                i = ++i;
                            }
                        }

                        if (this.getSize() == 3)
                        {
                            rock.grow(true);
                        }
                    }

                    if (n > 0)
                    {
                        this.m.IsSpawningOnTile = true;
                    }
                }
                else
                {
                    this.m.IsSpawningOnTile = true;
                }
            }
            else
            {
                this.m.IsSpawningOnTile = true;
            }

            local flip = this.Math.rand(0, 100) < 50;
            local sprite_body = this.getSprite("body");

            if (_tile != null)
            {
                local decal;
                local skin = this.getSprite("body");
                this.m.IsCorpseFlipped = flip;
                decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
                decal.Color = skin.Color;
                decal.Saturation = skin.Saturation;
                decal.Scale = 0.9;
                decal.setBrightness(0.9);
                this.spawnTerrainDropdownEffect(_tile);
                local corpse = clone this.Const.Corpse;
                corpse.CorpseName = "An " + this.getName();
                corpse.Tile = _tile;
                corpse.Value = 2.0;
                corpse.IsResurrectable = false;
                corpse.IsConsumable = false;
                corpse.Armor = this.m.BaseProperties.Armor;
                corpse.IsHeadAttached = true;
                _tile.Properties.set("Corpse", corpse);
                this.Tactical.Entities.addCorpse(_tile);

                if ((_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals) && this.Math.rand(1, 100) <= 40)
                {
                    local n = 0 + this.Math.rand(0, 1) + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

                    for( local i = 0; i < n; i = i )
                    {
                        local loot = this.new("scripts/items/misc/sulfurous_rocks_item");
                        loot.drop(_tile);
                        i = ++i;
                    }

                    if (this.Math.rand(1, 100) <= 10)
                    {
                        local loot = this.new("scripts/items/loot/glittering_rock_item");
                        loot.drop(_tile);
                    }
                    else if (this.Math.rand(1, 100) <= 5)
                    {
                        local loot = this.new("scripts/items/trade/uncut_gems_item");
                        loot.drop(_tile);
                    }
                }

                this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
            }
        }

        o.onAfterDeath = function( _tile )
        {
            if (!this.m.IsSpawningOnTile)
            {
                return;
            }

            if (this.getSize() == 1)
            {
                return;
            }
            local rock = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.SandGolem, _tile, this.m.BackupFaction, this.EL_getRankLevel(), this.EL_getLevel());
            if (this.m.BackupWorldParty != null)
            {
                local e;

                if (this.getSize() == 3)
                {
                    e = this.Const.World.Common.addTroop(this.m.BackupWorldParty.get(), {
                        Type = this.Const.World.Spawn.Troops.SandGolemMEDIUM
                    }, false);
                }
                else
                {
                    e = this.Const.World.Common.addTroop(this.m.BackupWorldParty.get(), {
                        Type = this.Const.World.Spawn.Troops.SandGolem
                    }, false);
                }

                rock.setWorldTroop(e);
            }

            if (this.getSize() == 3)
            {
                rock.grow(true);
            }
        }

    });

	::mods_hookExactClass("entity/tactical/enemies/skeleton_lich", function(o){

        o.onDeath = function( _killer, _skill, _tile, _fatalityType )
        {
            local entities = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
            local phylacteries = [];

            foreach( e in entities )
            {
                if (e.getType() == this.Const.EntityType.SkeletonPhylactery)
                {
                    phylacteries.push(e);
                }
            }

            if (phylacteries.len() != 0)
            {
                this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Body));
                this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
            }

            this.skeleton.onDeath(_killer, _skill, _tile, _fatalityType);

            if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
            {
                local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

                for( local i = 0; i < n; i = i )
                {
                    local loot = this.new("scripts/items/misc/legend_ancient_scroll_item");
                    loot.drop(_tile);
                    local loot = this.new("scripts/items/misc/legend_ancient_scroll_item");
                    loot.drop(_tile);
                    local loot = this.new("scripts/items/misc/legend_ancient_scroll_item");
                    loot.drop(_tile);
                    local loot = this.new("scripts/items/misc/legend_ancient_scroll_item");
                    loot.drop(_tile);
                    local loot = this.new("scripts/items/misc/legend_ancient_scroll_item");
                    loot.drop(_tile);
                    i = ++i;
                }
            }

            if (phylacteries.len() != 0)
            {
                local players = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
                local candidates = [];

                foreach( phy in phylacteries )
                {
                    local nearest = 9000;

                    foreach( player in players )
                    {
                        local d = player.getTile().getDistanceTo(phy.getTile());

                        if (d < nearest)
                        {
                            nearest = d;
                        }
                    }

                    candidates.push({
                        Phylactery = phy,
                        Distance = nearest
                    });
                }

                candidates.sort(function ( _a, _b )
                {
                    if (_a.Distance < _b.Distance)
                    {
                        return -1;
                    }
                    else if (_a.Distance > _b.Distance)
                    {
                        return 1;
                    }

                    return 0;
                });
                local p = candidates[0].Phylactery;
                local t = p.getTile();
                p.kill(null, null);
                local spawn = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.SkeletonLich, t, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel(), true);
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " transcends death!");
            }
            else
            {
                this.Sound.play("sounds/enemies/dlc6/lich_death_01.wav", this.Const.Sound.Volume.Actor, this.getPos());
            }
        }
    });

	::mods_hookExactClass("entity/tactical/enemies/spider_eggs", function(o){

        o.onSpawn = function( _tile )
        {
            if (_tile.IsEmpty)
            {
                return;
            }

            if (!_tile.IsOccupiedByActor || _tile.getEntity().getType() != this.Const.EntityType.SpiderEggs)
            {
                return;
            }

            if (this.Tactical.Entities.isEnemyRetreating())
            {
                return;
            }

            local tile;

            for( local i = 0; i < 6; i = i )
            {
                if (!_tile.hasNextTile(i))
                {
                }
                else
                {
                    local nextTile = _tile.getNextTile(i);

                    if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - _tile.Level) > 1)
                    {
                    }
                    else
                    {
                        tile = nextTile;
                        break;
                    }
                }

                i = ++i;
            }

            if (tile != null)
            {
                local spawn = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.Spider, tile, this.getFaction(), this.EL_getRankLevel(), this.EL_getLevel());
                spawn.setSize(this.Math.rand(60, 75) * 0.01);
                spawn.m.XP = spawn.m.XP / 2;
                local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

                foreach( a in allies )
                {
                    if (a.getType() == this.Const.EntityType.Hexe)
                    {
                        spawn.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));
                        break;
                    }
                }

                ++this.m.Count;
            }

            if (this.m.Count < 4)
            {
                this.registerSpawnEvent();
            }
            else
            {
                this.killSilently();
            }
        }
    });

	::mods_hookExactClass("entity/tactical/enemies/zombie_boss", function(o){

        o.onDeath = function( _killer, _skill, _tile, _fatalityType )
        {
            local flip = this.Math.rand(1, 100) < 50;

            if (_tile != null)
            {
                this.m.IsCorpseFlipped = flip;
                local decal;
                decal = _tile.spawnDetail("bust_ghost_knight_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
                decal.Scale = 0.9;
                decal.setBrightness(0.9);
                decal = _tile.spawnDetail("bust_ghost_knight_01_head_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
                decal.Scale = 0.9;
                decal.setBrightness(0.9);
                this.spawnTerrainDropdownEffect(_tile);
                local corpse = clone this.Const.Corpse;
                corpse.CorpseName = this.getName();
                corpse.Tile = _tile;
                corpse.IsResurrectable = false;
                corpse.IsConsumable = false;
                corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
                _tile.Properties.set("Corpse", corpse);
                this.Tactical.Entities.addCorpse(_tile);
            }

            this.m.Info = {
                Tile = this.getTile(),
                Faction = this.getFaction()
            };
            this.Sound.play("sounds/enemies/horrific_scream_01.wav", this.Const.Sound.Volume.Skill * 2.25, this.m.Info.Tile.Pos);
            local mapSize = this.Tactical.getMapSize();
            local attempts = 0;
            local n = 0;

            while (attempts++ < 250)
            {
                local x = this.Math.rand(this.Math.max(0, this.m.Info.Tile.SquareCoords.X - 5), this.Math.min(mapSize.X - 1, this.m.Info.Tile.SquareCoords.X + 5));
                local y = this.Math.rand(this.Math.max(0, this.m.Info.Tile.SquareCoords.Y - 5), this.Math.min(mapSize.Y - 1, this.m.Info.Tile.SquareCoords.Y + 5));

                if (!this.Tactical.isValidTileSquare(x, y))
                {
                    continue;
                }

                local tile = this.Tactical.getTileSquare(x, y);

                if (!tile.IsEmpty || tile.ID == this.m.Info.Tile.ID)
                {
                    continue;
                }

                this.spawnSpawnEffect(tile);
                local e = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.Ghost, tile, this.m.Info.Faction, this.EL_getRankLevel(), this.EL_getLevel(), true);
                n = ++n;
                n = n;

                if (n >= 11)
                {
                    break;
                }
            }

            this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
        }

        o.onAfterDeath = function( _tile )
        {
            if (!this.m.Info.Tile.IsEmpty)
            {
                local changed = false;

                for( local i = 0; i != 6; i = i )
                {
                    if (!this.m.Info.Tile.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local tile = this.m.Info.Tile.getNextTile(i);

                        if (tile.IsEmpty && this.Math.abs(tile.Level - this.m.Info.Tile.Level) <= 1)
                        {
                            this.m.Info.Tile = tile;
                            changed = true;
                            break;
                        }
                    }

                    i = ++i;
                }

                if (!changed)
                {
                    return;
                }
            }

            this.spawnSpawnEffect(this.m.Info.Tile);
            local e = this.Const.World.Common.EL_addEntity({
                ID = 0,
                Variant = 0,
                Strength = 80,
                Cost = 80,
                Row = 0,
                Script = "scripts/entity/tactical/enemies/ghost_knight"
            }, this.m.Info.Tile, this.m.Info.Faction, this.EL_getRankLevel(), this.EL_getLevel(), true);
        }
    });


});

local gt = getroottable();

::mods_registerMod("el_adaption_entity_tactical", 1, "el_adaption_entity_tactical");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(o){

        o.updateTileEffects <- function()
        {
            local garbage = [];

            foreach( i, tile in this.m.TileEffects )
            {
                if (tile.Effect.Timeout <= this.Time.getRound())
                {
                    garbage.push(i);
                }
            }

            garbage.reverse();

            foreach( trash in garbage )
            {
                this.m.TileEffects[trash].Tile.Properties.Effect = null;
                this.m.TileEffects[trash].Tile.clear(this.Const.Tactical.DetailFlag.Effect);

                foreach( p in this.m.TileEffects[trash].Particles )
                {
                    p.die();
                }

                this.m.TileEffects.remove(trash);
            }

            if (this.Time.getRound() == 1 && !this.Tactical.State.isScenarioMode() && !this.Tactical.State.getStrategicProperties().IsArenaMode || this.Tactical.State.isScenarioMode() && this.Time.getRound() == 2)
            {
                local spiders = 0;
                local entities = this.Tactical.TurnSequenceBar.getAllEntities();
                local rank_num = [0, 0, 0];
                foreach( e in entities )
                {
                    if (e.getType() == this.Const.EntityType.Spider && !this.isKindOf(e, "spider_bodyguard"))
                    {
                        rank_num[e.EL_getRankLevel()] += 1;
                        spiders = ++spiders;
                    }
                }

                local mapSize = this.Tactical.getMapSize();

                if (spiders > 5)
                {
                    for( local x = 0; x < mapSize.X; x = ++x )
                    {
                        for( local y = 0; y < mapSize.Y; y = ++y )
                        {
                            local tile = this.Tactical.getTileSquare(x, y);

                            if (tile.IsEmpty || this.Math.rand(1, 100) > 30)
                            {
                            }
                            else if (tile.getEntity().hasSprite("web"))
                            {
                                tile.getEntity().getSprite("web").Visible = true;
                            }
                        }
                    }

                    local eggs = spiders / 5;

                    for( local attempts = 0; attempts < 750; attempts = ++attempts )
                    {
                        local x = this.Math.rand(5, mapSize.X - 8);
                        local y = this.Math.rand(7, mapSize.Y - 7);
                        local tile = this.Tactical.getTileSquare(x, y);

                        if (!tile.IsEmpty)
                        {
                        }
                        else if (tile.IsVisibleForPlayer)
                        {
                        }
                        else if (tile.IsHidingEntity)
                        {
                        }
                        else if (this.isTileIsolated(tile))
                        {
                        }
                        else
                        {
                            local total_weight = 0;
                            for(local i = 0; i < rank_num.len(); ++i) {
                                total_weight += rank_num[i];
                            }
                            local r = this.Math.rand(1, total_weight);
                            local rank = 0;
                            for(local i = 0; i < rank_num.len(); ++i) {
                                if(r > rank_num[i]) {
                                    r -= rank_num[i];
                                }
                                else {
                                    rank = i;
                                }
                            }
                            local nest = this.Const.World.Common.EL_addEntity({
                                ID = this.Const.EntityType.SpiderEggs,
                                Variant = 0,
                                Strength = 10,
                                Cost = 0,
                                Row = 0,
                                Script = "scripts/entity/tactical/enemies/spider_eggs"
                            }, tile, this.Tactical.State.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(), rank);
                            eggs = --eggs;

                            if (eggs <= 0)
                            {
                                break;
                            }
                        }
                    }
                }
            }
        }

        o.onResurrect = function( _info, _force = false, _user = null)
        {
            if (this.Tactical.State.m.TacticalDialogScreen.isVisible() || this.Tactical.State.m.TacticalDialogScreen.isAnimating())
            {
                this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
                return null;
            }

            if (this.Tactical.Entities.isCombatFinished() || !_force && this.Tactical.Entities.isEnemyRetreating())
            {
                return null;
            }

            local targetTile = _info.Tile;

            if (!targetTile.IsEmpty)
            {
                local knockToTile;

                for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
                {
                    if (!targetTile.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local newTile = targetTile.getNextTile(i);

                        if (!newTile.IsEmpty || newTile.IsCorpseSpawned)
                        {
                        }
                        else if (newTile.Level > targetTile.Level + 1)
                        {
                        }
                        else
                        {
                            knockToTile = newTile;
                            break;
                        }
                    }
                }

                if (knockToTile == null)
                {
                    this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
                    return null;
                }

                this.Tactical.getNavigator().teleport(targetTile.getEntity(), knockToTile, null, null, true);

                if (_info.Tile.IsVisibleForPlayer)
                {
                    this.Tactical.CameraDirector.pushMoveToTileEvent(0, _info.Tile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
                    this.Tactical.CameraDirector.addDelay(0.2);
                }
                else if (knockToTile.IsVisibleForPlayer)
                {
                    this.Tactical.CameraDirector.pushMoveToTileEvent(0, knockToTile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
                    this.Tactical.CameraDirector.addDelay(0.2);
                }
                else
                {
                    this.Tactical.CameraDirector.pushIdleEvent(0, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
                    this.Tactical.CameraDirector.addDelay(0.2);
                }

                return null;
            }

            this.Tactical.Entities.removeCorpse(targetTile);
            targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
            targetTile.Properties.remove("Corpse");
            targetTile.Properties.remove("IsSpawningFlies");
            this.Const.Movement.AnnounceDiscoveredEntities = false;
            local entity = null;

            if(_user == null) {
                local rank_level = 0;
                local elite_chance = this.Const.EL_NPC.EL_NormalTeam.EliteChance.EL_getChance(this.World.Assets.m.EL_WorldLevel);
                elite_chance *= this.World.Assets.EL_getWorldDifficultFactor();
                rank_level = (this.Math.rand(1, 1000) >= elite_chance * 10) ? 0 : 1;
                local npc_level = 0;
                if(rank_level) {
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
                entity = this.Const.World.Common.EL_addEntity(_info.Type, targetTile, this.Const.Faction.Enemy, rank_level, npc_level);
            }
            else {
                local faction = _user.getFaction();
                if (faction == this.Const.Faction.Player || faction == this.Const.Faction.PlayerAnimals) {
                    entity = this.Const.World.Common.EL_addEntity(_info.Type, targetTile, this.Const.Faction.PlayerAnimals, 0, _user.EL_getCombatLevel());
                }
                else {
                    entity = this.Const.World.Common.EL_addEntity(_info.Type, targetTile, faction, _user.EL_getRankLevel(), _user.EL_getCombatLevel());
                }
            }

            this.Const.Movement.AnnounceDiscoveredEntities = true;
            entity.onResurrected(_info);
            entity.riseFromGround();

            if (!entity.isHiddenToPlayer())
            {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " has risen from the dead");
            }

            return entity;
        }

    });

});

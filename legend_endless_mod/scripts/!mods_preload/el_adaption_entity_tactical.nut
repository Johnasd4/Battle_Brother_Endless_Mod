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
                                Strength = 0,
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

    });

});

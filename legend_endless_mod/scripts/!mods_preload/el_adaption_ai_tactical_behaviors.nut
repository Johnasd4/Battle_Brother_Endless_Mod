local gt = getroottable();

::mods_registerMod("el_adaption_ai_tactical_behaviors", 1, "el_adaption_ai_tactical_behaviors");
::mods_queue(null, "el_player_npc", function ()
{

    ::mods_hookExactClass("ai/tactical/behaviors/ai_flying_skulls", function(o){

        o.onExecute = function( _entity )
        {
            if (this.m.IsFirstExecuted)
            {
                this.getAgent().adjustCameraToDestination(this.m.Tiles[0].Tile);
                this.m.IsFirstExecuted = false;
                this.m.Skill.use(_entity.getTile());
                this.m.WaitUntil = this.Time.getRealTimeF() + 1.5;
                return false;
            }
            else if (this.Time.getRealTimeF() >= this.m.WaitUntil)
            {
                local max_skulls = this.m.Skulls;

                for( local i = 0; i < this.m.Tiles.len(); i = ++i )
                {
                    local tile = this.m.Tiles[0].Tile;
                    this.m.Tiles.remove(0);
                    local skull = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.FlyingSkull, tile, _entity.getFaction(), 2, -1);
                    skull.spawnEffect();
                    max_skulls = --max_skulls;

                    if (max_skulls <= 0)
                    {
                        break;
                    }
                }

                this.m.Tiles = [];
                this.m.IsSpent = true;
                this.getAgent().declareEvaluationDelay(1000);
                return true;
            }
        }

    });


    ::mods_hookExactClass("ai/tactical/behaviors/ai_mirror_image", function(o){

        o.onExecute = function( _entity )
        {
            if (this.m.IsFirstExecuted)
            {
                this.getAgent().adjustCameraToDestination(this.m.Tiles[0].Tile);
                this.m.IsFirstExecuted = false;
                this.m.Skill.use(_entity.getTile());
                this.m.WaitUntil = this.Time.getRealTimeF() + 1.45;
                return false;
            }
            else if (this.Time.getRealTimeF() >= this.m.WaitUntil)
            {
                local max_mirror_images = this.m.Images;

                for( local i = 0; i < this.m.Tiles.len(); i = ++i )
                {
                    local tile = this.m.Tiles[0].Tile;
                    this.m.Tiles.remove(0);

                    local image = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.SkeletonLichMirrorImage, tile, _entity.getFaction(), 2, -1);
                    image.spawnEffect();
                    max_mirror_images = --max_mirror_images;

                    if (max_mirror_images <= 0)
                    {
                        break;
                    }
                }

                this.m.Tiles = [];
                this.m.IsSpent = true;
                this.getAgent().declareEvaluationDelay(1000);
                return true;
            }

            return false;
        }

    });

    ::mods_hookExactClass("ai/tactical/behaviors/ai_retreat", function(o){

        o.onEvaluate = function( _entity )
        {
            // Function is a generator.
            this.m.TargetTile = null;

            if ((this.Const.AI.NoRetreatMode || this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode) && _entity.getFaction() != this.Const.Faction.Player)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (_entity.getCurrentProperties().IsRooted)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (this.m.IsDone)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()) && _entity.getFaction() != this.Const.Faction.Player)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }


            local score = this.getProperties().BehaviorMult[this.m.ID];

            if (_entity.getFaction() != this.Const.Faction.Player)
            {
                local allyInstances = 0.0;
                local allyInstancesMax = 0.0;
                local hostileInstances = 0.0;

                foreach( i, faction in this.Tactical.Entities.getAllInstances() )
                {
                    if (faction.len() == 0)
                    {
                        continue;
                    }

                    if (i == _entity.getFaction() || _entity.isAlliedWith(i))
                    {
                        foreach( e in faction )
                        {
                            if (e.getXPValue() > 0)
                            {
                                allyInstances = allyInstances + 1.0;
                            }
                        }
                    }
                    else
                    {
                        hostileInstances = hostileInstances + faction.len() * 1.0;
                    }
                }

                foreach( i, numPerFaction in this.Tactical.Entities.getAllInstancesMax() )
                {
                    if (i == _entity.getFaction() || _entity.isAlliedWith(i))
                    {
                        allyInstancesMax = allyInstancesMax + numPerFaction;
                    }
                }

                if (_entity.getBaseProperties().Bravery != 0 && allyInstances / allyInstancesMax >= this.Const.AI.Behavior.RetreatMinAllyRatio)
                {
                    return this.Const.AI.Behavior.Score.Zero;
                }

                if (_entity.getBaseProperties().Bravery != 0 && allyInstances >= hostileInstances)
                {
                    return this.Const.AI.Behavior.Score.Zero;
                }

                score = score * (1.0 + this.Const.AI.Behavior.RetreatMinAllyRatio - allyInstances / allyInstancesMax);
            }

            if (this.isAtMapBorder(_entity))
            {
                score = score * this.Const.AI.Behavior.RetreatAtMapBorderMult;
            }
            else
            {
                local func = this.findRetreatToPosition(_entity);

                while (resume func == null)
                {
                    yield null;
                }

                if (this.m.TargetTile == null)
                {
                    return this.Const.AI.Behavior.Score.Zero;
                }
            }

            if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
            {
                score = score * this.Const.AI.Behavior.RetreatFleeingMult;
            }

            if (_entity.getBaseProperties().Bravery == 0)
            {
                score = score * 10.0;
            }

            return this.Const.AI.Behavior.Score.Retreat * score;
        }


    });


    ::mods_hookExactClass("ai/tactical/behaviors/ai_spawn_demon_shadow", function(o){

        o.onExecute = function( _entity )
        {
            local max_shadows = 4;

            for( local i = 0; i < this.m.Tiles.len(); i = i )
            {
                if (this.m.Tiles[0].Score == 0)
                {
                    break;
                }

                local tile = this.m.Tiles[0].Tile;
                this.m.Tiles.remove(0);
                local shadow = this.Const.World.Common.EL_addEntity({
                    ID = this.Const.EntityType.AlpShadow,
                    Variant = 0,
                    Strength = 30,
                    Cost = 30,
                    Row = 0,
                    Script = "scripts/entity/tactical/enemies/alp_shadow"
                }, tile, _entity.getFaction(), _entity.EL_getRankLevel(), _entity.EL_getLevel());
                max_shadows = --max_shadows;
                max_shadows = max_shadows;

                if (max_shadows <= 0)
                {
                    break;
                }

                i = ++i;
            }

            this.m.Tiles = [];
            this.m.IsSpent = true;
            this.getAgent().declareEvaluationDelay(1000);
            return true;
        }


    });

});


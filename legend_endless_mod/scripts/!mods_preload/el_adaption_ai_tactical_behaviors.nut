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

    ::mods_hookExactClass("ai/tactical/behaviors/ai_gruesome_feast", function(o){

        o.onExecute = function( _entity )
        {
            this.m.Skill = null;
            this.m.TargetTile = null;
            this.m.IsTravelling = false;
            this.m.IsWaiting = false;
            local time = this.Time.getExactTime();
            local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

            if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (_entity.getCurrentProperties().IsRooted)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            local skills = [];

            foreach( skillID in this.m.PossibleSkills )
            {
                local skill = _entity.getSkills().getSkillByID(skillID);

                if (skill != null && skill.isUsable() && skill.isAffordable())
                {
                    skills.push(skill);
                }
            }

            if (skills.len() == 0)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            this.m.Skill = skills[this.Math.rand(0, skills.len() - 1)];
            local myTile = _entity.getTile();
            local isInMelee = this.queryTargetsInMeleeRange().len() != 0;
            local inZOC = myTile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions());
            local potentialDanger = this.getPotentialDanger(true);

            if (this.isAllottedTimeReached(time))
            {
                yield null;
                time = this.Time.getExactTime();
            }

            local corpses = this.Tactical.Entities.getCorpses();

            if (corpses.len() == 0)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            local allies = this.getAgent().getKnownAllies();
            local potentialCorpses = [];

            if (myTile.IsCorpseSpawned && myTile.Properties.get("Corpse").IsConsumable)
            {
                potentialCorpses.push({
                    Tile = myTile,
                    Distance = 0,
                    Score = 10.0
                });
            }
            else
            {
                foreach( c in corpses )
                {
                    if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsConsumable)
                    {
                        continue;
                    }

                    if (!c.IsEmpty && !(_entity.isAbleToWait() && c.IsOccupiedByActor && c.getEntity().getType() == this.Const.EntityType.Ghoul && c.getEntity().getMoraleState() == this.Const.MoraleState.Fleeing && !c.getEntity().isTurnDone() && c.getDistanceTo(myTile) == 1))
                    {
                        continue;
                    }

                    local score = 4.0;
                    local dist = c.getDistanceTo(myTile);

                    if (dist > this.Const.AI.Behavior.GruesomeFeastMaxDistance)
                    {
                        continue;
                    }

                    score = score - dist * this.Const.AI.Behavior.GruesomeFeastDistanceMult;

                    if (this.getAgent().getIntentions().IsDefendingPosition && dist > this.m.Skill.getMaxRange())
                    {
                        continue;
                    }

                    score = score - this.Const.AI.Behavior.GruesomeFeastWaitPenalty;
                    score = score - this.Const.AI.Behavior.GruesomeFeastSpearwallPenalty * this.querySpearwallValueForTile(_entity, c);
                    local mag = this.queryOpponentMagnitude(c, this.Const.AI.Behavior.GruesomeFeastMagnitudeMaxRange);
                    score = score - mag.Opponents * (1.0 - mag.AverageDistanceScore) * this.Math.maxf(0.5, 1.0 - mag.AverageEngaged) * this.Const.AI.Behavior.GruesomeFeastOpponentValue;

                    if (isInMelee && !c.isSameTileAs(myTile))
                    {
                        score = score - this.Const.AI.Behavior.GruesomeFeastLeaveZOC;
                    }

                    if (dist > 1)
                    {
                        local letComradeGo = false;

                        foreach( ally in allies )
                        {
                            if (!ally.isTurnDone() && ally.getTile().getDistanceTo(c) == 1 && ally.getType() == this.Const.EntityType.Ghoul && _entity.getSize() < 3)
                            {
                                letComradeGo = true;
                                break;
                            }
                        }

                        if (letComradeGo)
                        {
                            continue;
                        }
                    }

                    potentialCorpses.push({
                        Tile = c,
                        Distance = dist,
                        Score = score
                    });
                }

                if (potentialCorpses.len() == 0)
                {
                    return this.Const.AI.Behavior.Score.Zero;
                }

                potentialCorpses.sort(this.onSortByScore);
            }

            local navigator = this.Tactical.getNavigator();
            local bestTarget;
            local bestIntermediateTile;
            local bestCost = -9999;
            local bestTiles = 0;
            local bestDanger = 0;
            local n = 0;
            local maxRange = this.m.Skill.getMaxRange();

            foreach( t in potentialCorpses )
            {
                n = ++n;

                if (n > this.Const.AI.Behavior.GruesomeFeastMaxAttempts && bestTarget != null)
                {
                    break;
                }

                if (this.isAllottedTimeReached(time))
                {
                    yield null;
                    time = this.Time.getExactTime();
                }

                local score = 0 + t.Score;
                local tiles = 0;
                local intermediateTile;
                local danger = 0.0;
                local danger_intermediate = 0.0;

                if (t.Distance > maxRange && t.Tile.IsEmpty)
                {
                    local settings = navigator.createSettings();
                    settings.ActionPointCosts = _entity.getActionPointCosts();
                    settings.FatigueCosts = _entity.getFatigueCosts();
                    settings.FatigueCostFactor = 0.0;
                    settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
                    settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
                    settings.AllowZoneOfControlPassing = false;
                    settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
                    settings.AlliedFactions = _entity.getAlliedFactions();
                    settings.Faction = _entity.getFaction();

                    if (navigator.findPath(_entity.getTile(), t.Tile, settings, maxRange))
                    {
                        local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

                        if (movementCosts.Tiles == 0)
                        {
                            continue;
                        }

                        score = score - movementCosts.ActionPointsRequired;

                        if (!movementCosts.IsComplete)
                        {
                            intermediateTile = movementCosts.End;
                        }

                        if (movementCosts.End.IsBadTerrain)
                        {
                            score = score - this.Const.AI.Behavior.RaiseUndeadMoveToBadTerrainPenalty * this.getProperties().EngageOnBadTerrainPenaltyMult;
                        }

                        if (this.getProperties().EngageOnBadTerrainPenaltyMult != 0.0)
                        {
                            score = score - movementCosts.End.TVLevelDisadvantage;
                        }

                        score = score + movementCosts.End.Level;

                        foreach( opponent in potentialDanger )
                        {
                            if (this.isAllottedTimeReached(time))
                            {
                                yield null;
                                time = this.Time.getExactTime();
                            }

                            local d = this.queryActorTurnsNearTarget(opponent, t.Tile, _entity);
                            danger = danger + this.Math.maxf(0.0, 1.0 - d.Turns);

                            if (!movementCosts.IsComplete)
                            {
                                local id = this.queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);
                                danger_intermediate = danger_intermediate + this.Math.maxf(0.0, 1.0 - id.Turns);
                                d = d.Turns > id.Turns ? id : d;
                            }

                            if (d.Turns <= 1.0)
                            {
                                if (d.InZonesOfControl != 0 || opponent.getCurrentProperties().IsStunned)
                                {
                                    score = score - this.Const.AI.Behavior.GruesomeFeastLowDangerPenalty;
                                }
                                else
                                {
                                    score = score - this.Const.AI.Behavior.GruesomeFeastHighDangerPenalty;
                                }
                            }

                            if (danger >= this.Const.AI.Behavior.GruesomeFeastMaxDanger || danger_intermediate >= this.Const.AI.Behavior.GruesomeFeastMaxDanger)
                            {
                                break;
                            }
                        }

                        if (danger >= this.Const.AI.Behavior.GruesomeFeastMaxDanger || danger_intermediate >= this.Const.AI.Behavior.GruesomeFeastMaxDanger)
                        {
                            continue;
                        }

                        tiles = movementCosts.Tiles;
                    }
                    else
                    {
                        continue;
                    }
                }
                else
                {
                    score = score + myTile.Level;
                }

                if (score > bestCost)
                {
                    bestTarget = t.Tile;
                    bestCost = score;
                    bestTiles = tiles;
                    bestIntermediateTile = intermediateTile;
                    bestDanger = this.Math.maxf(danger, danger_intermediate);
                }
            }

            if (bestTarget == null)
            {
                return this.Const.AI.Behavior.Score.Zero;
            }

            this.m.TargetTile = bestTarget;
            this.m.IsTravelling = bestTarget.getDistanceTo(myTile) > this.m.Skill.getMaxRange();

            if (!bestTarget.IsEmpty && !bestTarget.isSameTileAs(myTile))
            {
                this.m.IsWaiting = true;
            }

            if (_entity.getHitpoints() < _entity.getHitpointsMax())
            {
                scoreMult = scoreMult + (1.0 - _entity.getHitpoints() / _entity.getHitpointsMax());
            }

            if (inZOC != 0 && !bestTarget.isSameTileAs(myTile))
            {
                scoreMult = scoreMult * (this.Const.AI.Behavior.GruesomeFeastLeaveZOCMult / inZOC);
            }

            scoreMult = scoreMult - this.Const.AI.Behavior.GruesomeFeastDangerPenaltyMult * bestDanger;
            return this.Math.max(0, this.Const.AI.Behavior.Score.GruesomeFeast * scoreMult);
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


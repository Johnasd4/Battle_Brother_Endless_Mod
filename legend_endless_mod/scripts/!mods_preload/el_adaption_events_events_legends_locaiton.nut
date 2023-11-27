local gt = getroottable();

::mods_registerMod("el_adaption_events_events_legends_locaiton", 1, "el_adaption_events_events_legends_locaiton");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("events/events/legends/location/legend_mummy_enter_event", function(o){

        o.create = function()
        {
            //this.logInfo("legend_mummy_enter_event create");

            this.m.ID = "event.location.legend_mummy_enter";
            this.m.Title = "As you approach...";
            this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
            this.m.IsSpecial = true;
            this.m.Screens.push({
                ID = "A",
                Text = "[img]gfx/ui/events/event_173.png[/img]{As the sand swallows your feet you scramble to the zenith of the next sand dune, the crest gives way to more of the same — the sands part between the hypnotising peaks between the valleys, occasionally sprinkled with columns, collapsed entrances and skeletons human and animal alike. Further afield you see the apex of a more rigid structure, the faded motifs strike you first, a small smatter of colour in an otherwise desolate landscape.\n\n As you wade closer the colours become more vivid; teals, maroons and jaundiced yellows all wax and wane in stripes, seemingly telling a tale nobody living can still recant. The air is warm, but stale — time seems to have affected this place differently than anywhere else you have seen so far. \n\n Small pots and urns make mickles around the entryways and columns, this place is a shining beacon for graverobbers but remains untouched and orderly.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "More treasure for us then!",
                        function getResult( _event )
                        {
                            return "B";
                        }

                    },
                    {
                        Text = "Let\'s not disturb what rests here.",
                        function getResult( _event )
                        {
                            if (this.World.State.getLastLocation() != null)
                            {
                                this.World.State.getLastLocation().setVisited(false);
                            }

                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "B",
                Text = "[img]gfx/ui/events/event_89.png[/img]{As you slowly pace inside the main monolith the temperature dramatically drops to a more comfortable level. The shade makes your skin writhe with comfort from the heat outside. \n\n The room is mostly blank, the only distinguishing feature aside from the inscribed walls are stone caskets of varying quality — some depict great battles, a figure whipping servants and others who are partaking in a form of ritual that has been purposely defaced with a weapon or chisel. Others remain blank — either not important enough to be worth more time of the craftsmen or simply unfinished. }",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "What was that noise?",
                        function getResult( _event )
                        {
                            return "C";
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "C",
                Text = "[img]gfx/ui/events/event_89.png[/img]{As you inch closer you begin to realise that fingers have smudged and flailed against the inside enclosure of the sarcophagus, some caskets have been opened from inside, while others had outside assistance. \n\n However, all of them are empty. \n\n The air begins to feel warm again suddenly, there is more in this chamber than you suspected. A figure of a man catches your eye, it opens its mouth as it plods from the darkness. \n\n Words do not come, only a trickle of sand and skin.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "The dead are upon us",
                        function getResult( _event )
                        {
                            if (this.World.State.getLastLocation() != null)
                            {
                                this.World.State.getLastLocation().setVisited(false);
                            }

                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
                            p.CombatID = "Mastaba";
                            p.TerrainTemplate = "tactical.sinkhole";
                            p.LocationTemplate.Template[0] = "tactical.sunken_library";
                            p.Music = this.Const.Music.UndeadTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            p.IsWithoutAmbience = true;
                            p.Entities = [];
                            local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
                            local party = this.new("scripts/entity/world/party");
                            party.EL_setFaction(f);
                            party.EL_tempPartyInit();
                            party.EL_setIsEliteParty(true);
                            party.EL_setHaveRandomLeader(false);
                            party.EL_setHaveStrongestLeader(false);
                            p.Parties.push(party);
                            for( local i = 0; i < 4; i = ++i )
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.LegendMummyHeavy
                                }, false);
                            }
                            for( local i = 0; i < 4; i = ++i )
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.LegendMummyPriest
                                }, false);
                            }
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }

                            p.BeforeDeploymentCallback = function ()
                            {
                                local light = 4;
                                local light_tiles = [];

                                do
                                {
                                    local x = this.Math.rand(10, 28);
                                    local y = this.Math.rand(4, 28);
                                    local tile = this.Tactical.getTileSquare(x, y);

                                    if (!tile.IsEmpty)
                                    {
                                    }
                                    else
                                    {
                                        local skip = false;

                                        foreach( t in light_tiles )
                                        {
                                            if (t.getDistanceTo(tile) <= 5)
                                            {
                                                skip = true;
                                                break;
                                            }
                                        }

                                        if (skip)
                                        {
                                        }
                                        else
                                        {
                                            this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.LegendVampireLord, tile, f, 2, -1 ,true);
                                            light = --light;
                                            light = light;
                                            light_tiles.push(tile);
                                        }
                                    }
                                }
                                while (light > 0);

                                local toRise = 3;

                                do
                                {
                                    local r = this.Math.rand(0, light_tiles.len() - 1);
                                    local p = light_tiles[r];

                                    if (p.SquareCoords.X > 14)
                                    {
                                        p.Level = 1;
                                        toRise = --toRise;
                                        toRise = toRise;
                                    }

                                    light_tiles.remove(r);
                                }
                                while (toRise > 0 && light_tiles.len() > 0);

                                local queen = 1;

                                do
                                {
                                    local x = this.Math.rand(9, 10);
                                    local y = this.Math.rand(15, 17);
                                    local tile = this.Tactical.getTileSquare(x, y);

                                    if (!tile.IsEmpty)
                                    {
                                    }
                                    else
                                    {
                                        this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.LegendMummyQueen, tile, f, 2, -1 ,true);
                                        queen = --queen;
                                        queen = queen;
                                    }
                                }
                                while (queen > 0);

                                local treasureHunters = 4;

                                do
                                {
                                    local x = this.Math.rand(9, 11);
                                    local y = this.Math.rand(11, 21);
                                    local tile = this.Tactical.getTileSquare(x, y);

                                    if (!tile.IsEmpty)
                                    {
                                    }
                                    else
                                    {
                                        local e = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.ZombieTreasureHunter, tile, f, 1, -1, true);
                                        treasureHunters = --treasureHunters;
                                        treasureHunters = treasureHunters;
                                    }
                                }
                                while (treasureHunters > 0);

                                local medium = 12;

                                do
                                {
                                    local x = this.Math.rand(9, 14);
                                    local y = this.Math.rand(8, 20);
                                    local tile = this.Tactical.getTileSquare(x, y);

                                    if (!tile.IsEmpty)
                                    {
                                    }
                                    else
                                    {
                                        local e = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.LegendMummyLight, tile, f, 1, -1, true);
                                        medium = --medium;
                                        medium = medium;
                                    }
                                }
                                while (medium > 0);

                                local heavy = 4;

                                do
                                {
                                    local x = this.Math.rand(12, 14);
                                    local y = this.Math.rand(12, 26);
                                    local tile = this.Tactical.getTileSquare(x, y);

                                    if (!tile.IsEmpty)
                                    {
                                    }
                                    else
                                    {
                                        local e = this.Const.World.Common.EL_addEntity(this.Const.World.Spawn.Troops.LegendMummyHeavy, tile, f, 1, -1, true);
                                        heavy = --heavy;
                                        heavy = heavy;
                                    }
                                }
                                while (heavy > 0);
                            };
                            p.AfterDeploymentCallback = function ()
                            {
                                this.Tactical.getWeather().setAmbientLightingPreset(5);
                                this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
                            };
                            _event.registerToShowAfterCombat("Victory", "Defeat");
                            this.World.State.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "Victory",
                Text = "[img]gfx/ui/events/event_89.png[/img]{The ancient queen crumbles to ash before you, leaving nothing left in the chamber but sand.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "What was that?",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    _event.m.Title = "After the battle...";

                    if (this.World.State.getLastLocation() != null)
                    {
                        this.World.State.getLastLocation().die();
                    }

                    this.World.Assets.getStash().makeEmptySlots(1);
                    local item = this.new("scripts/items/weapons/legendary/legend_mage_swordstaff");
                    this.World.Assets.getStash().add(item);
                    this.List.push({
                        id = 10,
                        icon = "ui/items/" + item.getIcon(),
                        text = "You gain " + item.getName()
                    });
                    this.World.Flags.set("IsMastabaDefeated", true);
                }

            });
            this.m.Screens.push({
                ID = "Defeat",
                Text = "[img]gfx/ui/events/event_173.png[/img]The mercenaries run out into the blazing sun again.%SPEECH_ON%Perhaps another time?%SPEECH_OFF%One sellsword says. %randombrother% nods.%SPEECH_ON%Another time, aye. Maybe a time far away from now, when I\'m out retired and farkin\' whoors, then y\'all can dip down into the darkness and go gallivanting with dead wizards. Does that time work for y\'all?%SPEECH_OFF%",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Perhaps one day...",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    _event.m.Title = "After the battle...";

                    if (this.World.State.getLastLocation() != null)
                    {
                        this.World.State.getLastLocation().setVisited(false);
                    }
                }

            });
        }

    });

	::mods_hookExactClass("events/events/legends/location/legend_tournament_enter_event", function(o){

        o.create = function()	{
            this.logInfo("Creating tournament event");
            this.m.ID = "event.location.legend_tournament_enter";
            this.m.Title = "世界竞技场";
            this.m.Cooldown = 100;
            this.m.IsSpecial = true;

            local start_screen = {
                ID = "A",
                Text = "[img]gfx/ui/events/legend_tournament.png[/img]欢迎来到世界竞技场，在这里你会挑战来自世界各地甚至世界之外的的各种强者。 \n\n 1. 一旦开始你需要连续打满三场才可以离开。  \n\n 2. 完成挑战你将会获得传说装备奖励！ \n\n 3. 胜利或者死亡！！！",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "The Grand Melee is for us, let\'s begin at once",
                        function getResult( _event )
                        {
                            local p = _event.selectFight(_event.getReputationToDifficultyLightMult(), this.Const.World.Spawn.GrandMelee, false);
                            _event.registerToShowAfterCombat("F", "null");
                            this.World.State.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    },
                    {
                        Text = "Actually, I\'m not...",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }
            }

            this.m.Screens.push(start_screen);
            this.m.Screens.push({
                ID = "G3",
                Text = "[img]gfx/ui/events/event_04.png[/img]{The attendant guides you to a tournament official who checks a large ledger of fight results.  %SPEECH_ON% Ah yes, here you are. The %companyname%, took part in a small Show Match. Here is your reward.%SPEECH_OFF% The official hands a pouch to you, and the attendant leads you back out through the main door of the tournament.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Fare well",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    local round = this.World.Flags.get("LegendTournamentRound");
                    local payment = 250;

                    for( local i = 0; i < round && i < 5; i = i )
                    {
                        payment = payment * 2;
                        i = ++i;
                        i = i;
                    }

                    this.World.Assets.addMoney(payment);
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = payment + " crowns as reward"
                    });
                    this.World.Flags.set("LegendTournamentRound", 1);
                }

            });
        }

    });


});

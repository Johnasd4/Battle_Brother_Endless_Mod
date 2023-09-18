local gt = getroottable();

::mods_registerMod("el_adaption_events_events_legends_scenario_escaped_slaves", 1, "el_adaption_events_events_legends_scenario_escaped_slaves");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("events/events/legends/scenario/escaped_slaves/sato_pursuer_ambush_event", function(o){

        o.create = function()
        {
            this.logInfo("sato_pursuer_ambush_event create");

            local ManhuntersText1 = "An unnatural quiet takes hold, and the hairs on the back of your neck prick up. It seems %nemesisviziername% has not forgotten about you or your escape. You\'re surrounded by manhunters!";
            local ManhuntersText2 = "Two men come out from behind a thicket, standing directly in your path. More materialize behind you. One of them brandishes a pair of manacles and jeers at you. Your heart sinks as you realize their true purpose: Manhunters from the %nemesiscityname%, here to capture or kill you! You have no choice but to defend yourselves!";
            local ManhuntersText3 = "A group of mean looking men filter out into the path in front of you. You glance over your shoulder and see more of them there, too.%SPEECH_ON%%nemesisviziername% sends his regards, slave.%SPEECH_OFF%One of the men in front of you spits out. Manhunters, then. You order the company to defend themselves as the hunters close in...";
            this.m.ID = "event.sato_pursuer_ambush";
            this.m.Title = "Along the way...";
            this.m.Cooldown = 6.0 * this.World.getTime().SecondsPerDay;
            this.m.Screens.push({
                ID = "Manhunters",
                Text = "[img]gfx/ui/events/event_172.png[/img]{" + ManhuntersText1 + " | " + ManhuntersText2 + " | " + ManhuntersText3 + "}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult( _event )
                        {
                            this.World.Statistics.getFlags().set("SatoLastAmbushType", "Manhunters");
                            _event.m.NemesisCityState.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded capture");
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.OrientalBanditTracks;
                            properties.IsAutoAssigningBases = false;
                            properties.Entities = [];
                            properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local party = this.new("scripts/entity/world/party");
                            party.EL_setFaction(this.Const.Faction.Enemy);
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.SatoManhunters, (100 + _event.m.ResourceBoost) * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy);
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.State.startScriptedCombat(properties, false, false, true);
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            local ManhuntersBribeText1 = "A band of men suddenly materialize all around you, stepping out of brush, climbing down from perches, even popping out of holes in the ground.%SPEECH_ON%I see you\'ve main a bit of a name for yourself, Indebted. %nemesisviziername% will pay well for your heads, but you lot clearly know how to handle yourselves in a fight. You make it worth my while, and we can forget we ever saw each other, yeah?%SPEECH_OFF%The manhunter who spoke jeers at you, but the group keeps their distance awaiting your response.";
            local ManhuntersBribeText2 = "You\'re stopped by a man cheerfully swinging a pair of manacles around.%SPEECH_ON%Hold there, good sir! It seems that you\'ve gotten the attention of the %nemesiscityname%, and they\'re quite displeased with you. Seems they think you\'re some sort of Indebted who escaped before the Gilder had his due, and me and my men have been hired to bring you back in, or kill the lot of you if that\'s what it takes.%SPEECH_OFF%More men appear behind the speaker, some with weapons already drawn, but he puts his manacle down and gives you a friendly smile.%SPEECH_ON%Of course, it seems they\'ve clearly made a mistake. After all, you lot are all a professional mercenary company, aren\'t you? Escaped slaves, indeed. Ha! I daresay we have nothing to fight over at all. Of course, seeing as how my group here has come all this way, we\'ll need some money for the return trip, and the vizier will hardly pay us for coming back empty handed. If you catch my drift, sir.%SPEECH_OFF%";
            this.m.Screens.push({
                ID = "ManhuntersBribe",
                Text = "[img]gfx/ui/events/event_172.png[/img]{" + ManhuntersBribeText1 + " | " + ManhuntersBribeText2 + "}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "You\'ll regret crossing our path, manhunter.",
                        function getResult( _event )
                        {
                            this.World.Statistics.getFlags().set("SatoLastAmbushType", "ManhuntersBribe");
                            return "ManhuntersBribeBattle";
                        }

                    },
                    {
                        Text = "Perhaps we can work this out. Will %bribe% crowns do?",
                        function getResult( _event )
                        {
                            this.World.Statistics.getFlags().set("SatoLastAmbushType", "ManhuntersBribe");
                            return "ManhuntersBribeSuccess";
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "ManhuntersBribeBattle",
                Text = "[img]gfx/ui/events/event_172.png[/img]The man in front snarls.%SPEECH_ON%So be it, slave.%SPEECH_OFF%",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult( _event )
                        {
                            _event.m.NemesisCityState.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded capture");
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.OrientalBanditTracks;
                            properties.IsAutoAssigningBases = false;
                            properties.Entities = [];
                            properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local party = this.new("scripts/entity/world/party");
                            party.EL_setFaction(this.Const.Faction.Enemy);
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.SatoManhunters, (115 + _event.m.ResourceBoost) * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy);
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.State.startScriptedCombat(properties, false, false, true);
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "ManhuntersBribeSuccess",
                Text = "[img]gfx/ui/events/event_172.png[/img]The man flashes you a vicious smile as he counts out the coin.%SPEECH_ON%A pleasure doing business with you, \'Crownling\'. Ha! Maybe we\'ll cross paths again some day, eh?%SPEECH_OFF%His smile disappears and his voice drops to a growl.%SPEECH_ON%Now get out of my sight.%SPEECH_OFF%",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "At least we avoided a fight...",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    this.World.Assets.addMoney(-_event.m.BribeAmount);
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.BribeAmount + "[/color] Crowns"
                    });
                }

            });
            local AssassinsText1 = "It seems that the %nemesiscityname% is no longer content to send mere manhunters after you - assassins descend upon you from the shadows! Defend yourselves!";
            local AssassinsText2 = "%nemesisviziername% has a long memory for grudges. You knew this, having dealt with his manhunters before, but somehow you never expected him to go so far as to hire assassins to hunt you down! You order the company to defend themselves as cloaked figures menacingly advance upon you from all directions...";
            this.m.Screens.push({
                ID = "Assassins",
                Text = "[img]gfx/ui/events/event_165.png[/img]{" + AssassinsText1 + " | " + AssassinsText2 + "}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult( _event )
                        {
                            this.World.Statistics.getFlags().set("SatoLastAmbushType", "Assassins");
                            _event.m.NemesisCityState.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded capture");
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.OrientalCityStateTracks;
                            properties.IsAutoAssigningBases = false;
                            properties.Entities = [];
                            properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local party = this.new("scripts/entity/world/party");
                            party.EL_setFaction(this.Const.Faction.Enemy);
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Assassins, 90 * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy);
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.State.startScriptedCombat(properties, false, false, true);
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            local BountyHunterText1 = "A group of armed men step out onto the road.%SPEECH_ON%Sorry to do this to ya, friend. Us bounty hunters usually leave slave hunting to the southerners, but the vizier said he didn\'t care if you was dead or alive, and we need that money.%SPEECH_OFF%The man who spoke looks almost apologetic as he draws his weapon.";
            local BountyHunterText2 = "A voice from the brush hails you.%SPEECH_ON%What could a bunch of sorry wenches like you do to piss off the %nemesiscityname% so bad they put a bounty on your head, anyway?%SPEECH_OFF%The voice is followed by a group of nasty looking men who spill out onto the path before you. The leader levels his weapon at you and spits.%SPEECH_ON%They don\'t care if we bring you in dead or alive, though, so I guess I\'ll just hafta keep on wondering.%SPEECH_OFF%";
            this.m.Screens.push({
                ID = "BountyHunters",
                Text = "[img]gfx/ui/events/event_07.png[/img]{" + BountyHunterText1 + " | " + BountyHunterText2 + "}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult( _event )
                        {
                            this.World.Statistics.getFlags().set("SatoLastAmbushType", "BountyHunters");
                            _event.m.NemesisCityState.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded capture");
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.OrientalCityStateTracks;
                            properties.IsAutoAssigningBases = false;
                            properties.Entities = [];
                            properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.EL_setFaction(this.Const.Faction.Enemy);
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.BountyHunters, 125 * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy);
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.State.startScriptedCombat(properties, false, false, true);
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
        }

    });

});

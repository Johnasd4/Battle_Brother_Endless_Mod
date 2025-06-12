local gt = getroottable();

::mods_registerMod("el_adaption_events_events_dlc2", 1, "el_adaption_events_events_dlc2");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("events/events/dlc2/spooky_forest_event", function(o){

        o.create = function()
        {
            //this.logInfo("spooky_forest_event create");

            this.m.ID = "event.spooky_forest";
            this.m.Title = "During camp...";
            this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
            this.m.Screens.push({
                ID = "A",
                Text = "[img]gfx/ui/events/event_25.png[/img]While camping in the woods, %randombrother% calls you out of the command tent. You ask what it is and you see a finger to lips in a silent shush. %randombrother% points up a tree which grows tall into the evening darkness. You hear cracks as though something were making a nest out of branches whole. The noisemaker only pauses to snort and chortle in a quick tittering of guttural chirps, like a bird crying for help from the belly of a snake. When you look back down, the company are staring at you, looking for an idea as to what to do about this event.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "It\'s just some animal. Get back to doing your jobs.",
                        function getResult( _event )
                        {
                            return "WalkOff";
                        }

                    },
                    {
                        Text = "Better safe than sorry. We\'ll cut down the tree.",
                        function getResult( _event )
                        {
                            if (this.Math.rand(1, 100) <= 50)
                            {
                                return "CutdownGood";
                            }
                            else
                            {
                                return "CutdownBad";
                            }
                        }

                    }
                ],
                function start( _event )
                {
                    if (_event.m.Lumberjack != null)
                    {
                        this.Options.push({
                            Text = "%lumberjack%, you know well how to bring down trees. Do it.",
                            function getResult( _event )
                            {
                                return "Lumberjack";
                            }

                        });
                    }

                    if (_event.m.Brave != null)
                    {
                        this.Options.push({
                            Text = "%bravebro%, you\'re the bravest of the lot. Go see what this is about.",
                            function getResult( _event )
                            {
                                return "Brave";
                            }

                        });
                    }
                }

            });
            this.m.Screens.push({
                ID = "Lumberjack",
                Text = "[img]gfx/ui/events/event_25.png[/img]You order %lumberjack% the lumberjack to bring the tree down. The mercenary nods and gets to work, using a host of tools available, not all of which are axes. The lumberjack plies the wood open in a divot on one side and jams the gaps with the helves of weapons and then goes to the other side and chops away at its trunk. The mercenary works with the sort of speed you\'d love to see on the battlefield. It\'s the sort of authenticity one rarely sees in life, someone who is home at work, eyes settled on modeling an undeniable future, hands hardly assigned to the task so much as born for it.%SPEECH_ON%Ay-yo!%SPEECH_OFF%The lumberjack yells out and the tree is felled. It cracks and slumbers down the heft and tilts into the forest where its long stock falls through the wickets and slams the ground so hard it seems to ache the very earth. Drawing your sword, you go to investigate the felled treetop. You find a pair of Nachzehrers there, smashed flat, teeth skittered to the forest floor like capless shrooms. The company\'s fear is settled by the grisly sight.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "So that mystery is solved.",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    this.Characters.push(_event.m.Lumberjack.getImagePath());
                    local item = this.new("scripts/items/misc/ghoul_teeth_item");
                    this.World.Assets.getStash().add(item);
                    this.List.push({
                        id = 10,
                        icon = "ui/items/" + item.getIcon(),
                        text = "You gain " + item.getName()
                    });
                }

            });
            this.m.Screens.push({
                ID = "Brave",
                Text = "[img]gfx/ui/events/event_25.png[/img]%bravebro%, the ever brave sellsword, clambers up the tree with speed not to be erred by fear or reluctance. You\'d think they spotted a fair flirt up in those parts the speed of ascent. It isn\'t long until the mercenary is gone, though the scratch \'n\' scratch of his noisy ascent is unmistakable. Finally you hear returning sounds, the clutter of descent coming in stops and starts as finding safe footing. You see the mercenary break back into view. with boots first to appear like butter trays dangling in the dark. The rest of the shadowy silhouette follows, sliding ever downward until making a last leap to the earth. The mercenary intentionally buckles at the knees and rolls back against the tree trunk with tired hands limp across knees.%SPEECH_ON%T\'was a black bear head deep in a honeycomb, but the beast been dead at least two days. I saw a group of bats skitter on out when I approached, I think they was eating its insides. This tumbled on out when they fled.%SPEECH_OFF% The tired mercenary turns and throws a sword upon the ground. It\'s covered in sticky honey and pinestraw, but otherwise looks like a remarkable blade.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Let\'s see that blade.",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    this.Characters.push(_event.m.Brave.getImagePath());
                    local item = this.new("scripts/items/weapons/arming_sword");
                    this.World.Assets.getStash().add(item);
                    this.List.push({
                        id = 10,
                        icon = "ui/items/" + item.getIcon(),
                        text = "You gain an " + item.getName()
                    });
                }

            });
            this.m.Screens.push({
                ID = "CutdownGood",
                Text = "[img]gfx/ui/events/event_25.png[/img]You order the company to chop the tree down. They get to the task, though there\'s little experience in doing it and the end result is a frantic run for safety as the trunk comes barreling down in an unexpected direction. A very frightened black bear bolts off the treetop. It has a honeycomb for a snout and huffs its way into the dark of the forest.\n\n No one is crushed, but the chaos and debris leaves a few of the mercenaries worse for the wear.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Well, that was a worthwhile endeavour...",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    local brothers = this.World.getPlayerRoster().getAll();

                    foreach( bro in brothers )
                    {
                        if (bro.getSkills().hasSkill("trait.swift") || bro.getSkills().hasSkill("trait.sure_footed") || bro.getSkills().hasSkill("trait.lucky") || bro.getSkills().hasSkill("trait.quick"))
                        {
                            continue;
                        }

                        if (this.Math.rand(1, 100) <= 20)
                        {
                            bro.addLightInjury();
                            this.List.push({
                                id = 10,
                                icon = "ui/icons/days_wounded.png",
                                text = bro.getName() + " suffers light wounds"
                            });
                        }
                    }
                }

            });
            this.m.Screens.push({
                ID = "CutdownBad",
                Text = "[img]gfx/ui/events/event_25.png[/img]You order the company to cut the tree down. %randombrother% starts in with a heavy thwack, planting a foot on the trunk to wrench the tool free and that\'s about the last you see as the mercenary goes flying away. A tree branch swings back into view with a long groan emanating from the trunk as though some ancient wood were being felled inside its very body. You watch as the wood cracks loose of the soil and uproots itself. Emerald eyes flare and widen, their stare blinkered by the twists of falling leaves.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "What the hell!",
                        function getResult( _event )
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.BeastsTracks;
                            properties.Entities = [];
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local party = this.new("scripts/entity/world/party");
                            local dif = this.Math.rand(90, 110);
                            party.EL_setTroopsResourse(party.EL_getTroopsResourse() * dif * 0.01);
                            party.EL_setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
                            party.EL_tempPartyInit();
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Schrats, dif, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
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
                ID = "WalkOff",
                Text = "[img]gfx/ui/events/event_25.png[/img]You can\'t be bothered by such trivial nonsense. It\'s likely to be a lynx or an eagle of some sort. If it\'s worse, it\'ll come on down and the company will deal with it then. This line of thinking doesn\'t sit well with some of the company.",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "It\'s just some animal...",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                    local brothers = this.World.getPlayerRoster().getAll();

                    foreach( bro in brothers )
                    {
                        if (this.Math.rand(1, 100) <= 25)
                        {
                            bro.worsenMood(0.5, "Concerned that you didn\'t act on a possible threat");

                            if (bro.getMoodState() <= this.Const.MoodState.Neutral)
                            {
                                this.List.push({
                                    id = 10,
                                    icon = this.Const.MoodStateIcon[bro.getMoodState()],
                                    text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
                                });
                            }
                        }
                    }
                }

            });
        }





    });

	::mods_hookExactClass("events/events/dlc2/treant_vs_giants_event", function(o){

        o.create = function()
        {
            //this.logInfo("treant_vs_giants_event create");

            this.m.ID = "event.treant_vs_giants";
            this.m.Title = "Along the way...";
            this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
            this.m.Screens.push({
                ID = "A",
                Text = "[img]gfx/ui/events/event_107.png[/img]{%randombrother% wrinkles his calf into a hole in the forest floor and curses with frustration.%SPEECH_ON%For farks sake as if my dogs weren\'t barking enough!%SPEECH_OFF%You turn to tell him to keep it quiet when suddenly you see an unhold scrambling up the forested hillside the company just climbed. Whereas you all struggled to ascend, the giant is hurdling upward and scrambling the incline, leaving small landslides in its wake. Before you can call it out, an enormous tree swerves down from a crowd of its still brethren and clotheslines the giant. A ball of spit zips through the forest breaking branches and brush and the giant slams its back to the forest floor and even at this distance it rumbles the ground beneath your feet. You see more unhold giants coming and more schrats unweaving themselves from the camouflage of the forest to do battle with them. It\'s a schrat against unhold no holds barked brawl!}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Prepare to attack.",
                        function getResult( _event )
                        {
                            return "C";
                        }

                    },
                    {
                        Text = "Let\'s get the hell out of here.",
                        function getResult( _event )
                        {
                            return "B";
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "B",
                Text = "[img]gfx/ui/events/event_107.png[/img]{You crouch low and order the men to come forward and to do so quickly. They march past like ants as leaves and mats of hair sputter down from above and the violence of the giants claps against your ears like lightning. But you do manage to get out of there and leave the war of the monsters behind.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "A close call.",
                        function getResult( _event )
                        {
                            return 0;
                        }

                    }
                ],
                function start( _event )
                {
                }

            });
            this.m.Screens.push({
                ID = "C",
                Text = "[img]gfx/ui/events/event_107.png[/img]{You draw your sword, but %randombrother% puts his hand on your shoulder.%SPEECH_ON%Really, captain?%SPEECH_OFF%}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Yes, really.",
                        function getResult( _event )
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Event";
                            properties.Music = this.Const.Music.BeastsTracks;
                            properties.IsAutoAssigningBases = false;
                            properties.Entities = [];
                            properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
                            properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
                            local party_1 = this.new("scripts/entity/world/party");
                            party_1.EL_setTroopsResourse(party_1.EL_getTroopsResourse() * 1);
                            party_1.EL_setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
                            party_1.EL_tempPartyInit();
                            properties.Parties.push(party_1);
                            this.Const.World.Common.addUnitsToCombat(party_1, this.Const.World.Spawn.UnholdBog, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
                            foreach(troop in party_1.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            local party_2 = this.new("scripts/entity/world/party");
                            party_2.EL_setTroopsResourse(party_2.EL_getTroopsResourse() * 1);
                            party_2.EL_setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            party_2.EL_tempPartyInit();
                            properties.Parties.push(party_2);
                            this.Const.World.Common.addUnitsToCombat(party_2, this.Const.World.Spawn.Schrats, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party_2.getTroops()) {
                                properties.Entities.push(troop);
                            }

                            this.World.State.startScriptedCombat(properties, false, false, true);
                            return 0;
                        }

                    },
                    {
                        Text = "On second thought, no.",
                        function getResult( _event )
                        {
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

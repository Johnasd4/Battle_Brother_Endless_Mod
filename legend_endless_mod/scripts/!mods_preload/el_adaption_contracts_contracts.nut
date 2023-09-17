local gt = getroottable();

::mods_registerMod("el_adaption_contracts_contracts", 1, "el_adaption_contracts_contracts");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("contracts/contracts/arena_contract", function(o){

        o.createScreens = function()
        {
            this.logInfo("arena_contract createScreens 12312312123");
            this.m.Screens.push({
                ID = "Task",
                Title = "At the Arena",
                Text = "",
                Image = "",
                List = [],
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{We shall turn the sand red with blood! | I want to hear the crowd chant our names! | We\'ll slaughter them like lambs!}",
                        function getResult()
                        {
                            return "Overview";
                        }

                    },
                    {
                        Text = "{This isn\'t what I had in mind. | I\'ll sit this one out. | I\'ll wait for the next fight.}",
                        function getResult()
                        {
                            this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                            this.World.State.getTownScreen().getMainDialogModule().reload();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Text = "[img]gfx/ui/events/event_155.png[/img]Dozens of men mingle about the arena\'s entrance. Some stand stoically, not wishing to give any hint of their capabilities. Others, however, boast and brag with aplomb, either sincerely confident in their martial skills or hoping their bravado masks any holes in their game.\n\n";
                    this.Text += "A grizzled man, the master of the arena, holds up a scroll and taps it with a hook for a hand.";
                    local baseDifficulty = 30;

                    if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
                    {
                        baseDifficulty = baseDifficulty + 10;
                    }

                    baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

                    if (this.Flags.get("IsSwordmaster"))
                    {
                        if (baseDifficulty < this.Const.World.Spawn.Troops.Swordmaster.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
                        {
                            this.Flags.set("Number", 0);
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Swordmaster";
                        }
                        else
                        {
                            this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost, 2));
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Swordmaster and %amount% raiders";
                        }

                        this.Text += "%SPEECH_ON%They put a star beside his name, the mark of the Gilder. That means his path is a gilded one. What you need to know is that he is a swordmaster. You may find some comfort in that he is an elder man, but you\'d not be the first I have said that to, understand? May your path be as Gilded, because this swordmaster\'s certainly was.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsHedgeKnight"))
                    {
                        if (baseDifficulty < this.Const.World.Spawn.Troops.HedgeKnight.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
                        {
                            this.Flags.set("Number", 0);
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Hedge Knight";
                        }
                        else
                        {
                            this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost, 2));
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Hedge Knight and %amount% raiders";
                        }

                        this.Text += "%SPEECH_ON%I believe northerners refer to him as a \'hate knight.\' Might have that wrong. Don\'t tell the other arena masters I said this about northern trash, but this knight is one of the most dangerous men I\'ve seen come through here and if you wish your path to continue being gilded then I suggest you make sharp preparations and get a good rest before the fight.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsDesertDevil"))
                    {
                        if (baseDifficulty < this.Const.World.Spawn.Troops.DesertDevil.Cost + this.Const.World.Spawn.Troops.NomadOutlaw.Cost)
                        {
                            this.Flags.set("Number", 0);
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Blade Dancer";
                        }
                        else
                        {
                            this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost, 2));
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one Blade Dancer and %amount% nomads";
                        }

                        this.Text += "The arena master holds up a scroll and taps it with a hook for a hand.%SPEECH_ON%A blade dancer of the nomad tribes is on the docket. Now, he might look a bit foppish, but to get the title of \'blade dancer\' you must be as articulate with the blade as a bird is with the wind. Dancing expertise is optional, but they\'re all pretty good at that, too.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsSandGolems"))
                    {
                        this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolem, baseDifficulty, 3)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% ifrits";
                        this.Text += "%SPEECH_ON%There\'s nothing on the page because I fear the desert\'s wrath if I dare to illuminate its most ferocious presence. You\'re fighting %number% ifrits. I do not know how they managed to get them here, I just know it was the doing of alchemists. If you ask me, I\'d rather you fight them than the ifrits.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsGhouls"))
                    {
                        local num = 0;

                        if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
                        {
                            num = num + 1;
                            num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty - this.Const.World.Spawn.Troops.GhoulHIGH.Cost);
                        }
                        else
                        {
                            num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5);
                            num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5);
                        }

                        this.Flags.set("Number", num);
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% nachzehrers";
                        this.Text += "%SPEECH_ON%The alchemists call them, well, I can\'t even pronounce it. My tongue simply cannot shape itself to the word for it requires specialized northern lexicography and I\'ve no time to narrow northern verbiage in a fruitless matter of mundane minutiae. Do I look like a phonetician to you? Let\'s just call them \'gnashslashers.\' They\'re ghoulish cretins, it\'s %number% of them, and I\'ve seen them eat men alive, so you\'d best hope the Gilder is watching - I don\'t think He\'ll have any light for you in the belly of one of those beasts!%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsUnholds"))
                    {
                        this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, baseDifficulty));

                        if (this.Flags.get("Number") == 1)
                        {
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one unhold";
                        }
                        else
                        {
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% unholds";
                        }

                        this.Text += "%SPEECH_ON%You\'re against %number% of what the northern scum refer to as an \'unhold.\' The Vizier pays a proper pile of coin to get them here, and the masses love the giant bastards. They do a good job smashing fighters and, on occasion, heaving a warrior clear into the crowds. It\'s quite wonderful. I think some of the unholds even learn to enjoy it the longer they stay here, like they learn what spurs the mob to cheers and jeer. The brutality is something else. Anyway, may the Gilder watch over you.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsDesertRaiders"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% nomads";
                        this.Text += "%SPEECH_ON%Your opponents will be %number% recently retired desert bandits. And by retired, I mean taken by the Vizier\'s lawmen, of course. No bandit willingly steps foot in here, haghaghagh!%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsGladiators"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% gladiators";
                        this.Text += "%SPEECH_ON%Well, heh, the Gilder must have a sense of humor. You\'ll be facing %number% gladiators. May your path be ever Gilded, but to be honest, I said that to the gladiators. And I\'ve been saying it to them every day. Understand? You should prepare to the best of your abilities.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsSpiders"))
                    {
                        this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% webknechts";
                        this.Text += "%SPEECH_ON%That is not a fig tree, it\'s a spider. The alchemists, bless their learned hearts, call them webknechts which is a silly northern name, in truth they\'re spiders. Unfortunately for you a boot will not be sufficient this time around for %number% of them.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsSerpents"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% serpents";
                        this.Text += "%SPEECH_ON%What do you mean you don\'t understand? Huh, it\'s just a squiggly line? No. Look, this is its tail, and that\'s the head. It\'s a snake. You\'re fighting %number% snakes. \'Serpents\' the alchemists like to call them, but if I wanted to draw a serpent I\'d just draw an alchemist haghaghagh!%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsHyenas"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% hyenas";
                        this.Text += "%SPEECH_ON%Hyenas. Heeheehee. Hyenas. %numberC% of the giggling mutts, to be exact. Good luck, and may the Gilder watch over you.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsFrenziedHyenas"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% frenzied hyenas";
                        this.Text += "%SPEECH_ON%Hyenas. Heeheehee. Hyenas. %numberC% of the giggling mutts, to be exact. Good luck, and may the Gilder watch over you.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsLindwurm"))
                    {
                        this.Flags.set("Number", this.Math.min(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, baseDifficulty - 30)));

                        if (this.Flags.get("Number") == 1)
                        {
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against one lindwurm";
                        }
                        else
                        {
                            this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against two lindwurms";
                        }

                        this.Text += "%SPEECH_ON%Your opponent is a... a... what is this? A worm? It\'s green. Never seen a worm that col- oh! A wyrm! No wait, \'wurm.\' Wurm? A lindwurm! I gots\'ta be honest with ya, I don\'t know what the hell this is, but I imagine our dear matchmakers won\'t be having you fightin\' a worm of the regular sort. Or maybe they is. Maybe they\'ll just have ye eat it for our entertainment. Maybe they ain\'t matchmakers, but tastemakers! Herghgheeagghheeehoogh. Ha.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsMercenaries"))
                    {
                        this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %amount% mercenaries";
                        this.Text += "%SPEECH_ON%Crownlings like you have ventured down from the north. Up there, they call them \'sellswords.\' Hagh! What sort of attempt at poetry is that? Don\'t they know not every man even uses a sword? They ain\'t the brightest up there. That\'s why I like it in the south. The sun is bright, and thus so are we.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsGladiatorChampion"))
                    {
                        this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
                        this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %champion1% and %amount% gladiators";
                        this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsSwordmasterChampion"))
                    {
                        this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
                        this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %champion1% and %amount% mercenaries";
                        this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsExecutionerChampion"))
                    {
                        this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
                        this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %champion1% and %amount% gladiators";
                        this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
                    }
                    else if (this.Flags.get("IsDesertDevilChampion"))
                    {
                        this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
                        this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
                        this.Contract.m.BulletpointsObjectives[1] = "Enter the arena again to start the fight against %champion1% and %amount% nomads";
                        this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
                    }

                    if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
                    {
                        this.Text += "He pauses.%SPEECH_ON%We expect important guests for this bout, so everything is set up for you to die proper bloody this time, got it? And if you can\'t do that, then have your lot dispatch their opponents in the most spectacular way to please the crowd. Do that, and I\'ll hand you a proper piece of gladiator gear ontop of the coin.%SPEECH_OFF%";
                    }

                    this.Text += "He points to some strange looking collars and continues.%SPEECH_ON%When you\'re ready, put these on the three men who\'ll be doing the fighting. This lets us know who to take into the pits. Anyone not wearing these will not be allowed in, not you, not the Vizier, dare I say even the Gilder may be turned down.%SPEECH_OFF%";
                }

            });
            this.m.Screens.push({
                ID = "Overview",
                Title = "Overview",
                Text = "This arena fight works as follows. Do you agree to the terms?",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I accept.",
                        function getResult()
                        {
                            this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
                            this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
                            this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
                            this.Contract.setState("Running");
                            return 0;
                        }

                    },
                    {
                        Text = "I\'ll have to think it over.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                ShowObjectives = true,
                ShowPayment = true,
                function start()
                {
                    this.Contract.m.IsNegotiated = true;
                }

            });
            this.m.Screens.push({
                ID = "Start",
                Title = "At the Arena",
                Text = "[img]gfx/ui/events/event_155.png[/img]{As you wait your turn, the crowd\'s bloodlust crawls through the dark, sheets of dust falling from above, the stomps of feet thunderous. They murmur in anticipation, and roar at killings. The quiet between battles is mere moments, and this silence is snatched away as the rusted gate lurches upward, chains rankling, the crowd abuzz once more. You step out into the light and so thunderous is the noise against your heart it could surely yet spur a dead man forth... | The arena\'s crowd is shoulder to shoulder, most blathering drunk. They scream and shout, their languages a mix of local and foreign, though the appeal to their bloodlust needs little articulation beyond their maddened faces and pumping fists. Now, the %companyname%\'s men will satiate these mad fools... | Cleaners hurry about the arena. They drag away the bodies, collect what\'s worth collecting, and occasionally throw a trophy into the crowds, eliciting a moblike rendition of the arena\'s battles in the stands themselves. The %companyname% is now a part of this affair. | The arena awaits, the crowd alight, and the %companyname%\'s turn to gain glory is at hand! | The crowd booms as the %companyname%\'s men stride into its bloody pit. Despite the mindless bloodlust of the peoples, you can\'t help but feel a beat of pride in your chest, knowing that it is your company ready to put on a show. | The gate rises. Nothing is heard save the rattle of chains, the creak of pulleys, the grunts of slaves at work. When the men of the %companyname% step out of the arena\'s bowels they can hear the crunch of sand underfoot until they come to stand in the center of the pit. A strange voice screams from the tops of the stadium, some lost language beyond your knowing, but the words echo just once before the crowd erupts with cheers and roaring. Now is the time your men shall prove themselves before the watchful eye of the commoner. | The %companyname%\'s business is rarely done before the eyes of those who would prefer themselves distantly separated from such violence. But in the arena, the commoner greedily awaits death and suffering, and it growls with bloodlust as your men enter the pits, and roars as the sellswords draw their weapons and ready for battle. | The arena is shaped like the pit of some sore, its ceiling torn away by the gods, revealing the vanity, bloodlust, and savagery of man. And it is man there, yelling and screaming, and if the blood sprays hit them, they wash their faces in the gore and grin at one another as though it were a joke. They fight one another for trophies and relish in the pain of others. And it is before these peoples that the %companyname% will fight, and for them they shall entertain and entertain well. | The arena\'s crowd is a mash of classes, rich and poor, for only the Viziers separate themselves out into stations above all. Briefly unified, the peoples of %townname% have graciously come together to watch men and monsters murder one another. With pleasure, the %companyname% seeks to do its part. | Boys sitting on the shoulders of fathers, young girls throwing flowers to the gladiators, women fanning themselves, men wondering if they could do it. These are the peoples of the arena - and the rest are all drunk out of their gourd and screaming nonsense. You hope the %companyname% can contribute to at least an hour or two to entertaining this mad lot. | The crowd roars as the %companyname%\'s men step into the pit. One would be dumb to confuse excitement for desire, for as soon as the applause ends there is a smattering of empty beer mugs and rotten tomatoes and the general giggling delight of those watching the matter. You wonder if the %companyname%\'s men are really best spent here, but then think hard on the gold and glory to be won, and that at the end of the day these mongrels in the stands will go home to their shit lives, and you\'ll go home to your shit life as well, but at least your pockets will be a bit deeper.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Let\'s give the crowd something to cheer for!",
                        function getResult()
                        {
                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
                            p.CombatID = "Arena";
                            p.TerrainTemplate = "tactical.arena";
                            p.LocationTemplate.Template[0] = "tactical.arena_floor";
                            p.Music = this.Const.Music.ArenaTracks;
                            p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
                            p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
                            p.AmbienceMinDelay[0] = 0;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
                            p.IsUsingSetPlayers = true;
                            p.IsFleeingProhibited = true;
                            p.IsLootingProhibited = true;
                            p.IsWithoutAmbience = true;
                            p.IsFogOfWarVisible = false;
                            p.IsArenaMode = true;
                            p.IsAutoAssigningBases = false;
                            local bros = this.Contract.getBros();
                            this.logInfo("push bros");
                            for( local i = 0; i < bros.len() && i < 3; i = i )
                            {
                                p.Players.push(bros[i]);
                                i = ++i;
                            }
                            this.logInfo("push party");
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Arena).getID());
                            //Stop copying troops.
                            party.EL_setTroopsResourse(0);
                            p.Parties.push(party);

                            local baseDifficulty = 30;

                            if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
                            {
                                baseDifficulty = baseDifficulty + 10;
                            }

                            baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

                            if (this.Flags.get("IsSwordmaster"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.Swordmaster
                                }, false);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster);

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.BanditRaider
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsHedgeKnight"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.HedgeKnight
                                }, false);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HedgeKnight);

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.BanditRaider
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsDesertDevil"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.DesertDevil
                                }, false);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil);

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.NomadOutlaw
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsSandGolems"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.SandGolem
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.SandGolem);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsGhouls"))
                            {
                                if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.GhoulHIGH
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulHIGH);

                                    for( local i = 0; i < this.Flags.get("Number") - 1; i = i )
                                    {
                                        this.Const.World.Common.addTroop(party, {
                                            Type = this.Const.World.Spawn.Troops.Ghoul
                                        }, false);
                                        //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
                                        i = ++i;
                                    }
                                }
                                else
                                {
                                    for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5); i = i )
                                    {
                                        this.Const.World.Common.addTroop(party, {
                                            Type = this.Const.World.Spawn.Troops.GhoulLOW
                                        }, false);
                                        //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulLOW);
                                        i = ++i;
                                    }

                                    for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5); i = i )
                                    {
                                        this.Const.World.Common.addTroop(party, {
                                            Type = this.Const.World.Spawn.Troops.Ghoul
                                        }, false);
                                        //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
                                        i = ++i;
                                    }
                                }
                            }
                            else if (this.Flags.get("IsUnholds"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Unhold
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Unhold);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsDesertRaiders"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.NomadOutlaw
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsGladiators"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Gladiator
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsSpiders"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Spider
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Spider);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsSerpents"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Serpent
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Serpent);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsHyenas"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Hyena
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Hyena);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsFrenziedHyenas"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.HyenaHIGH
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HyenaHIGH);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsLindwurm"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Lindwurm
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Lindwurm);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsMercenaries"))
                            {
                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Mercenary
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsGladiatorChampion"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.Gladiator
                                }, false, 0, 1);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator, true, this.Flags.get("Champion1"));

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Gladiator
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsSwordmasterChampion"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.Swordmaster
                                }, false, 0, 1);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster, true, this.Flags.get("Champion1"));

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Mercenary
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsExecutionerChampion"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.Executioner
                                }, false, 0, 1);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Executioner, true, this.Flags.get("Champion1"));

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.Gladiator
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
                                    i = ++i;
                                }
                            }
                            else if (this.Flags.get("IsDesertDevilChampion"))
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.DesertDevil
                                }, false, 0, 1);
                                //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil, true, this.Flags.get("Champion1"));

                                for( local i = 0; i < this.Flags.get("Number"); i = i )
                                {
                                    this.Const.World.Common.addTroop(party, {
                                        Type = this.Const.World.Spawn.Troops.NomadOutlaw
                                    }, false);
                                    //this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
                                    i = ++i;
                                }
                            }

                            // for( local i = 0; i < p.Entities.len(); i = i )
                            // {
                            //     p.Entities[i].Faction <- this.Contract.getFaction();
                            //     i = ++i;
                            // }
                            p.Entities = [];
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }

                            this.World.Contracts.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    },
                    {
                        Text = "We\'re not doing this. I don\'t want to die!",
                        function getResult()
                        {
                            this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                            this.World.State.getTownScreen().getMainDialogModule().reload();
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Text += "\n\n\n\n\n\n\n\nThe following characters will enter the arena:\n\n%bro1name%\n%bro2name%\n%bro3name%";
                }

            });
            this.m.Screens.push({
                ID = "Success",
                Title = "At the Arena",
                Text = "[img]gfx/ui/events/event_147.png[/img]{The arena master talks as if he doesn\'t even remember your face, then again he probably doesn\'t.%SPEECH_ON%Here\'s your pay, please come again.%SPEECH_OFF%The arena will be closed for the day, but you could return as early as tomorrow. | Without even raising his head from a rag of papyrus, the arena master throws you a purse of coin.%SPEECH_ON%I heard the crowds, and so here are your crowns. May you come visit the pits again.%SPEECH_OFF%The arena will be closed for the day, but you could return as early as tomorrow. | The arena master is waiting for you.%SPEECH_ON%That was a mighty fine show, Crownling. Would not mind it in the slightest if you come back again.%SPEECH_OFF%The arena will be closed for the day, but you could return as early as tomorrow.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "{Victory! | Are you not entertained?! | Killed it. | A bloody spectacle.}",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

                            if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
                            {
                                return "Gladiators";
                            }
                            else
                            {
                                this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                                this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
                                this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
                                this.World.Contracts.finishActiveContract();

                                if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
                                {
                                    this.updateAchievement("Gladiator", 1, 1);
                                }

                                return 0;
                            }
                        }

                    }
                ],
                function start()
                {
                    local roster = this.World.getPlayerRoster().getAll();
                    local n = 0;

                    foreach( bro in roster )
                    {
                        local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

                        if (item != null && item.getID() == "accessory.arena_collar")
                        {
                            local skill;
                            bro.getFlags().increment("ArenaFightsWon", 1);
                            bro.getFlags().increment("ArenaFights", 1);

                            if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
                            {
                                skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }
                            else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
                            {
                                bro.getSkills().removeByID("trait.pit_fighter");
                                skill = this.new("scripts/skills/traits/arena_fighter_trait");
                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }
                            else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
                            {
                                bro.getSkills().removeByID("trait.arena_fighter");
                                skill = this.new("scripts/skills/traits/arena_veteran_trait");
                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }
                            else if (bro.getFlags().getAsInt("ArenaFightsWon") > 25 && bro.getSkills().hasSkill("trait.arena_veteran"))
                            {
                                bro.getSkills().removeByID("trait.arena_veteran");

                                if (bro.getFlags().getAsInt("ArenaFightsWon") < 50)
                                {
                                    skill = this.new("scripts/skills/traits/arena_champion_trait");
                                }
                                else
                                {
                                    skill = this.new("scripts/skills/traits/arena_invictus_trait");
                                }

                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }
                            else if (bro.getFlags().getAsInt("ArenaFightsWon") == 25)
                            {
                                bro.getSkills().removeByID("trait.arena_veteran");
                                skill = this.new("scripts/skills/traits/arena_champion_trait");
                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }
                            else if (bro.getFlags().getAsInt("ArenaFightsWon") == 50)
                            {
                                bro.getSkills().removeByID("trait.arena_champion");
                                skill = this.new("scripts/skills/traits/arena_invictus_trait");
                                bro.getSkills().add(skill);
                                this.List.push({
                                    id = 10,
                                    icon = skill.getIcon(),
                                    text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
                                });
                            }

                            n = ++n;
                            n = n;
                        }

                        if (n >= 3)
                        {
                            break;
                        }
                    }

                    if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
                    {
                        local r;
                        local a;
                        local u;

                        if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 5)
                        {
                            r = 1;
                        }
                        else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 10)
                        {
                            r = 3;
                        }
                        else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 15)
                        {
                            r = 2;
                        }
                        else
                        {
                            r = this.Math.rand(1, 3);
                        }

                        switch(r)
                        {
                        case 1:
                            a = this.Const.World.Common.pickArmor([
                                [
                                    1,
                                    "oriental/gladiator_harness"
                                ]
                            ]);
                            a.setUpgrade(this.new("scripts/items/" + (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() ? "legend_armor/armor_upgrades/legend_light_gladiator_upgrade" : "armor_upgrades/light_gladiator_upgrade")));
                            this.List.push({
                                id = 12,
                                icon = "ui/items/armor_upgrades/upgrade_24.png",
                                text = "You gain a " + a.getName()
                            });
                            break;

                        case 2:
                            a = this.Const.World.Common.pickArmor([
                                [
                                    1,
                                    "oriental/gladiator_harness"
                                ]
                            ]);
                            a.setUpgrade(this.new("scripts/items/" + (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() ? "legend_armor/armor_upgrades/legend_heavy_gladiator_upgrade" : "armor_upgrades/heavy_gladiator_upgrade")));
                            this.List.push({
                                id = 12,
                                icon = "ui/items/armor_upgrades/upgrade_25.png",
                                text = "You gain a " + a.getName()
                            });
                            break;

                        case 3:
                            a = ::new(::MSU.Array.rand([
                                "scripts/items/legend_helmets/helm/legend_helmet_southern_gladiator_helm_crested",
                                "scripts/items/legend_helmets/helm/legend_helmet_southern_gladiator_helm_split",
                                "scripts/items/legend_helmets/helm/legend_helmet_southern_gladiator_helm_masked"
                            ]));
                            this.List.push({
                                id = 12,
                                icon = "ui/items/" + a.getIcon(),
                                text = "You gain a " + a.getName()
                            });
                            break;
                        }

                        this.World.Assets.getStash().makeEmptySlots(1);
                        this.World.Assets.getStash().add(a);
                    }
                }

            });
            this.m.Screens.push({
                ID = "Failure1",
                Title = "At the Arena",
                Text = "[img]gfx/ui/events/event_147.png[/img]{The %companyname%\'s men have been defeated, either dead or, perhaps worse, badly mangled. At least the crowds are happy. In the pits, any showing, even that which ends in demise, is a good showing.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Disaster!",
                        function getResult()
                        {
                            local roster = this.World.getPlayerRoster().getAll();
                            local n = 0;

                            foreach( bro in roster )
                            {
                                local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

                                if (item != null && item.getID() == "accessory.arena_collar")
                                {
                                    bro.getFlags().increment("ArenaFights", 1);
                                    n = ++n;
                                    n = n;
                                }

                                if (n >= 3)
                                {
                                    break;
                                }
                            }

                            this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Failure2",
                Title = "At the Arena",
                Text = "{[img]gfx/ui/events/event_155.png[/img]The time for your arena match has come and passed, but you didn\'t show up there. Perhaps something more important came up, or perhaps you\'ve just been hiding like cowards. Either way, your reputation will suffer because of this.",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "But...",
                        function getResult()
                        {
                            this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Collars",
                Title = "At the Arena",
                Text = "{[img]gfx/ui/events/event_155.png[/img]The time for your arena match has come, but none of your men bear the arena collars, and so they aren\'t let in.\n\nYou should decide on who is to fight by equipping them with the arena collars that you\'ve been given, and the match will start once you enter the arena again.",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Oh, right!",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Gladiators",
                Title = "At the Arena",
                Text = "{[img]gfx/ui/events/event_85.png[/img]The fight over, you find a few women sauntering upon you and the gladiators. They are practically swooning, faces blushed, and the men take special care of them. A little tired yourself, you have one of the fans help you count inventory. | [img]gfx/ui/events/event_147.png[/img]The battle\'s over, but a shadow suddenly crosses the ground. In a flash, you unsheathe and slash the sky. Flower petals shower your glistening body and you catch the rest of the bouquet in your teeth. A woman stands there fanning herself.%SPEECH_ON%I wondered why you didn\'t fight.%SPEECH_OFF%She says. You sheathe your blade and tie the bouquet to your belt. You tell her that if you fought, it wouldn\'t be a \'fight\' at all. The fan goes weak at the knees and finds comfort on the ground. Before leaving, you tell her to drink plenty of water and make sure she stretches in the mornings. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Can I learn to fight like you men?%SPEECH_OFF%The voices catches you off guard and before you know it you have your blade an inch from a little boy\'s face. His eyes are shut, and he slowly opens one. You sheathe the sword and laugh.%SPEECH_ON%No. What I am cannot be learned.%SPEECH_OFF%You use a bit of ash and blood from the field to sign the kid\'s shirt and then make your leave. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Are you... are you gladiators?%SPEECH_OFF%You look to see a boy standing there with awe on his face. He almost cries he\'s so giddy.%SPEECH_ON%You\'re amazing!%SPEECH_OFF%Tussling the boy\'s hair, you tell him thanks, and make your leave. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%H-how did you get so good?%SPEECH_OFF%You turn to see a boy nervously staring at you. Smiling, you give him the truth.%SPEECH_ON%When I was your age, I was killing men my age.%SPEECH_OFF%Grinning back, he asks if he works on it, can he be like you. Nodding, you answer.%SPEECH_ON%You can\'t know until you try, kid. Now go on home.%SPEECH_OFF%The boy brandishes a butter knife and fiendishly turns and sprints away. He\'s a good lad.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "{Damn, we\'re good. | We\'re the best.}",
                        function getResult()
                        {
                            this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
                            this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
                            this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
                            this.World.Contracts.finishActiveContract();

                            if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
                            {
                                this.updateAchievement("Gladiator", 1, 1);
                            }

                            return 0;
                        }

                    }
                ]
            });
        }

    });

	::mods_hookExactClass("contracts/contracts/arena_tournament_contract", function(o){

        o.getOpponents = function( _round, _index = -1 )
        {
            local twists = [];

            if (_round >= 2)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _difficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Mercenary
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _difficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Mercenary
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round >= 2)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.HedgeKnight
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _difficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Mercenary
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.HedgeKnight
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _difficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Mercenary
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.HedgeKnight
                        }, false);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, _difficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.BanditRaider
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.BanditRaider);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.HedgeKnight
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.MasterArcher
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.MasterArcher, true);
                    }

                });
            }

            if (_round == 3)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.NomadOutlaw
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Swordmaster
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.NomadOutlaw
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round >= 2)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.NomadOutlaw
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.Executioner.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Gladiator
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Gladiator
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Executioner
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Gladiator
                            }, false);
                            _contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertStalker
                        }, false);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _difficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost - this.Const.World.Spawn.Troops.DesertStalker.Cost); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.NomadOutlaw
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertDevil
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.DesertStalker
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Executioner
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Gladiator
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Gladiator
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Gladiator
                        }, false, 0, 1);
                        this.Const.World.Common.addTroop(_party, {
                            Type = this.Const.World.Spawn.Troops.Gladiator
                        }, false, 0, 1);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);
                        //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _difficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 4); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Gladiator
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 2)
            {
                twists.push({
                    R = 10,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Mercenary
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.Const.DLC.Unhold)
            {
                twists.push({
                    R = 10,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Unhold
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Unhold);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 3 && this.Const.DLC.Lindwurm)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < this.Math.min(3, _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, _d)); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.Lindwurm
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Lindwurm);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 2)
            {
                twists.push({
                    R = 10,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolemMEDIUM, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(_party, {
                                Type = this.Const.World.Spawn.Troops.SandGolemMEDIUM
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.SandGolemMEDIUM);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 2)
            {
                twists.push({
                    R = 10,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(Gladiator, {
                                Type = this.Const.World.Spawn.Troops.SandGolemMEDIUM
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 1 && this.Const.DLC.Unhold)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(Gladiator, {
                                Type = this.Const.World.Spawn.Troops.Spider
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Spider);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round <= 2)
            {
                twists.push({
                    R = 10,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(Gladiator, {
                                Type = this.Const.World.Spawn.Troops.NomadOutlaw
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 1)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(Gladiator, {
                                Type = this.Const.World.Spawn.Troops.Serpent
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.Serpent);
                            i = ++i;
                        }
                    }

                });
            }

            if (_round == 1)
            {
                twists.push({
                    R = 5,
                    function F( _contract, _difficulty, _party )
                    {
                        for( local i = 0; i < _contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, _d); i = i )
                        {
                            this.Const.World.Common.addTroop(Gladiator, {
                                Type = this.Const.World.Spawn.Troops.HyenaHIGH
                            }, false);
                            //_contract.addToCombat(_e, this.Const.World.Spawn.Troops.HyenaHIGH);
                            i = ++i;
                        }
                    }

                });
            }

            if ("bool" == typeof _index || _index >= 0)
            {
                return {
                    I = _index,
                    F = twists[_index].F
                };
            }
            else
            {
                local maxR = 0;

                foreach( t in twists )
                {
                    maxR = maxR + t.R;
                }

                local r = this.Math.rand(1, maxR);

                foreach( i, t in twists )
                {
                    if (r <= t.R)
                    {
                        return {
                            I = i,
                            F = t.F
                        };
                    }
                    else
                    {
                        r = r - t.R;
                    }
                }
            }
        }

        o.startTournamentRound = function()
        {
            local p = this.Const.Tactical.CombatInfo.getClone();
            p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
            p.CombatID = "Arena";
            p.TerrainTemplate = "tactical.arena";
            p.LocationTemplate.Template[0] = "tactical.arena_floor";
            p.Music = this.Const.Music.ArenaTracks;
            p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
            p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
            p.AmbienceMinDelay[0] = 0;
            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
            p.IsUsingSetPlayers = true;
            p.IsFleeingProhibited = true;
            p.IsLootingProhibited = true;
            p.IsWithoutAmbience = true;
            p.IsFogOfWarVisible = false;
            p.IsArenaMode = true;
            p.IsAutoAssigningBases = false;
            local bros = this.getBros();

            for( local i = 0; i < bros.len() && i < 5; i = i )
            {
                p.Players.push(bros[i]);
                i = ++i;
            }
            local party = this.new("scripts/entity/world/party");
            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Arena).getID());
            //Stop copying troops.
            party.EL_setTroopsResourse(0);
            p.Parties.push(party);

            local baseDifficulty = 45 + 10 * this.m.Flags.get("Round");
            baseDifficulty = baseDifficulty * this.getScaledDifficultyMult();
            local opponents = this.getOpponents(this.m.Flags.get("Round"), this.m.Flags.get("Opponents" + this.m.Flags.get("Round")));
            opponents.F(this, baseDifficulty, party);

            p.Entities = [];
            foreach(troop in party.getTroops()) {
                p.Entities.push(troop);
            }

            this.World.Contracts.startScriptedCombat(p, false, false, false);
        }

    });

	::mods_hookExactClass("contracts/contracts/decisive_battle_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Move to the war camp and report to %commander%",
                        "Assist the army in their battle against %feudfamily%"
                    ];

                    if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
                    {
                        this.Contract.setScreen("Intro");
                    }
                    else
                    {
                        this.Contract.setScreen("Task");
                    }
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).addPlayerRelation(-99.0, "Took sides in the war");

                    if (this.Contract.m.WarcampTile == null)
                    {
                        local settlements = this.World.EntityManager.getSettlements();
                        local lowest_distance = 99999;
                        local best_settlement;
                        local myTile = this.Contract.m.Home.getTile();

                        foreach( s in settlements )
                        {
                            if (this.World.FactionManager.isAllied(this.Contract.getFaction(), s.getFaction()))
                            {
                                continue;
                            }

                            local d = s.getTile().getDistanceTo(myTile);

                            if (d < lowest_distance)
                            {
                                lowest_distance = d;
                                best_settlement = s;
                            }
                        }

                        this.Contract.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
                    }

                    local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.WarcampTile, 1, 12, [
                        this.Const.World.TerrainType.Shore,
                        this.Const.World.TerrainType.Ocean,
                        this.Const.World.TerrainType.Mountains,
                        this.Const.World.TerrainType.Forest,
                        this.Const.World.TerrainType.LeaveForest,
                        this.Const.World.TerrainType.SnowyForest,
                        this.Const.World.TerrainType.AutumnForest,
                        this.Const.World.TerrainType.Swamp
                    ], false, false, true);
                    tile.clear();
                    this.Contract.m.WarcampTile = tile;
                    this.Contract.m.Warcamp = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/noble_camp_location", tile.Coords));
                    this.Contract.m.Warcamp.onSpawned();
                    this.Contract.m.Warcamp.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
                    this.Contract.m.Warcamp.setFaction(this.Contract.getFaction());
                    this.Contract.m.Warcamp.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Warcamp.getTile().Pos, 500.0);
                    local r = this.Math.rand(1, 100);

                    if (r <= 40)
                    {
                        this.Flags.set("IsScoutsSighted", true);
                    }
                    else
                    {
                        this.Flags.set("IsRequisitionSupplies", true);
                        r = this.Math.rand(1, 100);

                        if (r <= 33)
                        {
                            this.Flags.set("IsAmbush", true);
                        }
                        else if (r <= 66)
                        {
                            this.Flags.set("IsUnrulyFarmers", true);
                        }
                        else
                        {
                            this.Flags.set("IsCooperativeFarmers", true);
                        }
                    }

                    r = this.Math.rand(1, 100);

                    if (r <= 40)
                    {
                        if (this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements().len() >= 2)
                        {
                            this.Flags.set("IsInterceptSupplies", true);
                            local myTile = this.Contract.m.Warcamp.getTile();
                            local settlements = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements();
                            local lowest_distance = 99999;
                            local highest_distance = 0;
                            local best_start;
                            local best_dest;

                            foreach( s in settlements )
                            {
                                if (s.isIsolated())
                                {
                                    continue;
                                }

                                local d = s.getTile().getDistanceTo(myTile);

                                if (d < lowest_distance)
                                {
                                    lowest_distance = d;
                                    best_dest = s;
                                }

                                if (d > highest_distance)
                                {
                                    highest_distance = d;
                                    best_start = s;
                                }
                            }

                            this.Flags.set("InterceptSuppliesStart", best_start.getID());
                            this.Flags.set("InterceptSuppliesDest", best_dest.getID());
                        }
                    }
                    else if (r <= 80)
                    {
                        this.Flags.set("IsDeserters", true);
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Move to the war camp and report to %commander%"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsWarcampDay1Shown"))
                    {
                        this.Flags.set("IsWarcampDay1Shown", true);
                        this.Contract.setScreen("WarcampDay1");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
            this.m.States.push({
                ID = "Running_WaitForNextDay",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Wait in the war camp until your services are called upon"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
                    {
                        if (this.World.getTime().Days > this.Flags.get("LastDay"))
                        {
                            if (this.Flags.get("NextDay") == 2)
                            {
                                this.Contract.setScreen("WarcampDay2");
                            }
                            else
                            {
                                this.Contract.setScreen("WarcampDay3");
                            }

                            this.World.Contracts.showActiveContract();
                        }
                    }
                }

            });
            this.m.States.push({
                ID = "Running_Scouts",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Intercept scouts of %feudfamily% last seen %direction% of the warcamp",
                        "Let no one escape alive"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = false;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithScouts.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
                    {
                        if (this.Flags.get("IsScoutsFailed"))
                        {
                            this.Contract.setScreen("ScoutsEscaped");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            this.Contract.setScreen("ScoutsCaught");
                            this.World.Contracts.showActiveContract();
                        }
                    }
                    else if (this.Flags.get("IsScoutsRetreat"))
                    {
                        this.Flags.set("IsScoutsRetreat", false);
                        this.Contract.m.Destination.die();
                        this.Contract.m.Destination = null;
                        this.Contract.setScreen("ScoutsEscaped");
                        this.World.Contracts.showActiveContract();
                    }
                }

                function onCombatWithScouts( _dest, _isPlayerAttacking = true )
                {
                    local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                    properties.CombatID = "Scouts";
                    properties.Music = this.Const.Music.NobleTracks;
                    properties.EnemyBanners = [
                        this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
                    ];
                    this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
                }

                function onActorRetreated( _actor, _combatID )
                {
                    if (_combatID == "Scouts")
                    {
                        this.Flags.set("IsScoutsFailed", true);
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "Scouts")
                    {
                        this.Flags.set("IsScoutsRetreat", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Running_ReturnAfterScouts",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to the war camp"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsReportAfterScoutsShown"))
                    {
                        this.Flags.set("IsReportAfterScoutsShown", true);
                        this.Contract.setScreen("WarcampDay1End");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
            this.m.States.push({
                ID = "Running_Requisition",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Requisition supplies at %objective% to the %direction% of the warcamp"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = false;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.TempFlags.get("IsReportAfterRequisitionShown"))
                    {
                        this.TempFlags.set("IsReportAfterRequisitionShown", true);
                        this.Contract.setScreen("RequisitionSupplies2");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsRequisitionRetreat") && !this.Flags.get("IsRequisitionCombatDone"))
                    {
                        this.Flags.set("IsRequisitionCombatDone", true);
                        this.Contract.setScreen("BeatenByFarmers");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsRequisitionVictory") && !this.Flags.get("IsRequisitionCombatDone"))
                    {
                        this.Flags.set("IsRequisitionCombatDone", true);
                        this.Contract.setScreen("PoorFarmers");
                        this.World.Contracts.showActiveContract();
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "Ambush" || _combatID == "TakeItByForce")
                    {
                        this.Flags.set("IsRequisitionRetreat", true);
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "Ambush" || _combatID == "TakeItByForce")
                    {
                        this.Flags.set("IsRequisitionVictory", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Running_ReturnAfterRequisition",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to the war camp"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = true;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = false;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
                    {
                        if (this.Flags.get("IsInterceptSupplies") || this.Flags.get("IsDeserters"))
                        {
                            this.Contract.setScreen("WarcampDay1End");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            this.Contract.setScreen("WarcampDay2End");
                            this.World.Contracts.showActiveContract();
                        }
                    }
                }

            });
            this.m.States.push({
                ID = "Running_InterceptSupplies",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Intercept supplies enroute from %supply_start% to %supply_dest%"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = false;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setVisibleInFogOfWar(true);
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsInterceptSuppliesSuccess"))
                    {
                        this.Contract.setScreen("SuppliesIntercepted");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
                    {
                        this.Flags.set("IsInterceptSuppliesFailure", true);
                        this.Contract.setScreen("SuppliesReachedEnemy");
                        this.World.Contracts.showActiveContract();
                    }
                }

                function onPartyDestroyed( _party )
                {
                    if (_party.getFlags().has("ContractSupplies"))
                    {
                        this.Flags.set("IsInterceptSuppliesSuccess", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Running_ReturnAfterIntercept",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to the war camp"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = true;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = false;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
                    {
                        this.Contract.setScreen("WarcampDay2End");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
            this.m.States.push({
                ID = "Running_Deserters",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Follow the footprints and approach the deserters",
                        "Either convince them to come back or kill them"
                    ];

                    if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
                    {
                        this.Contract.m.Warcamp.getSprite("selection").Visible = false;
                    }

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsDesertersFailed"))
                    {
                        if (this.Contract.m.Destination != null)
                        {
                            this.Contract.m.Destination.die();
                            this.Contract.m.Destination = null;
                        }

                        this.Contract.setState("Running_ReturnAfterIntercept");
                    }
                    else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
                    {
                        this.Contract.setScreen("DesertersAftermath");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Contract.isPlayerNear(this.Contract.m.Destination, this.Const.World.CombatSettings.CombatPlayerDistance / 2) && !this.TempFlags.get("IsDeserterApproachShown"))
                    {
                        this.TempFlags.set("IsDeserterApproachShown", true);
                        this.Contract.setScreen("Deserters2");
                        this.World.Contracts.showActiveContract();
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "Deserters")
                    {
                        this.Flags.set("IsDesertersFailed", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Running_FinalBattle",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Win the battle for %noblehouse%"
                    ];
                }

                function update()
                {
                    if (this.Flags.get("IsFinalBattleLost") && !this.Flags.get("IsFinalBattleLostShown"))
                    {
                        this.Flags.set("IsFinalBattleLostShown", true);
                        this.Contract.m.Warcamp.die();
                        this.Contract.m.Warcamp = null;
                        this.Contract.setScreen("BattleLost");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsFinalBattleWon") && !this.Flags.get("IsFinalBattleWonShown"))
                    {
                        this.Flags.set("IsFinalBattleWonShown", true);
                        this.Contract.m.Warcamp.die();
                        this.Contract.m.Warcamp = null;
                        this.Contract.setScreen("BattleWon");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (!this.TempFlags.get("IsFinalBattleStarted"))
                    {
                        this.TempFlags.set("IsFinalBattleStarted", true);
                        local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Warcamp.getTile(), 3, 12, [
                            this.Const.World.TerrainType.Shore,
                            this.Const.World.TerrainType.Ocean,
                            this.Const.World.TerrainType.Mountains,
                            this.Const.World.TerrainType.Forest,
                            this.Const.World.TerrainType.LeaveForest,
                            this.Const.World.TerrainType.SnowyForest,
                            this.Const.World.TerrainType.AutumnForest,
                            this.Const.World.TerrainType.Swamp,
                            this.Const.World.TerrainType.Hills
                        ], false);
                        this.World.State.getPlayer().setPos(tile.Pos);
                        this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "FinalBattle";
                        p.Music = this.Const.Music.NobleTracks;
                        p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;

                        p.AllyBanners = [
                            this.World.Assets.getBanner(),
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
                        ];
                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
                        ];
                        local allyStrength = 90;

                        if (this.Flags.get("IsRequisitionFailure"))
                        {
                            allyStrength = allyStrength - 20;
                        }

                        if (this.Flags.get("IsDesertersFailed"))
                        {
                            allyStrength = allyStrength - 20;
                        }

                        local ally_party = this.new("scripts/entity/world/party");
                        ally_party.setFaction(this.Contract.getFaction());
                        p.Parties.push(ally_party);

                        this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.Noble, allyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());

                        this.Const.World.Common.addTroop(ally_party, {
                            Type = this.Const.World.Spawn.Troops.Knight
                        }, false);

                        local enemyStrength = 150;

                        if (this.Flags.get("IsScoutsFailed"))
                        {
                            enemyStrength = enemyStrength + 25;
                        }

                        if (this.Flags.get("IsInterceptSuppliesFailure"))
                        {
                            enemyStrength = enemyStrength + 25;
                        }

                        local enemy_party = this.new("scripts/entity/world/party");
                        enemy_party.setFaction(this.Flags.get("EnemyNobleHouse"));
                        p.Parties.push(enemy_party);

                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Noble, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Mercenaries, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));

                        this.Const.World.Common.addTroop(enemy_party, {
                            Type = this.Const.World.Spawn.Troops.knight
                        }, false, 0, this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0);

                        p.Entities = [];
                        foreach(troop in ally_party.getTroops()) {
                            p.Entities.push(troop);
                        }
                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
                        }

                        this.Contract.setState("Running_FinalBattle");
                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "FinalBattle")
                    {
                        this.Flags.set("IsFinalBattleLost", true);
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "FinalBattle")
                    {
                        this.Flags.set("IsFinalBattleWon", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName() + " to claim your payment"
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success1");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% welcomes you inside. He\'s wearing armor, though his commanders seem to be trying to talk him out of doing any actual fighting. The man welcomes you warmly nonetheless and quickly explains what he needs from you.%SPEECH_ON%We are about to conclude this silly war. My largest forces are organizing %direction% from here. I need you to go there and meet with %commander%. He will explain his uses for you. If you manage to help us swing the tides, then you will be paid handsomely, sellsword.%SPEECH_OFF% | You walk into %employer%\'s room to see him feeding a %feudfamily% banner to some dogs. The mongrels tear at it with practiced viciousness. %employer% looks up at you.%SPEECH_ON%Ah, sellsword. Glad that you are finally here. I need you to go visit %commander% %direction% of here. We are beginning the final stages of this damned war and I believe men such as yourself can help quicken its end. I can\'t tell you what to expect other than that these wars usually end most spectacularly. Your pay, too, will be spectacular.%SPEECH_OFF% | You walk into %employer%\'s room to find him surrounded by his generals. They\'re looking down at a map where a great number of opposing tokens are facing off. The nobleman looks at you.%SPEECH_ON%Ah, sellsword. I need you to go here.%SPEECH_OFF%He drops a stick on the map.%SPEECH_ON%And meet with %commander%. We are preparing to end this war once and for all and your help will be most crucial.%SPEECH_OFF%You nod, but linger. The man raises his eyebrows then a finger.%SPEECH_ON%Oh yes, your help will be paid for! Make no mistake about that.%SPEECH_OFF% | You cannot enter %employer%\'s room. Instead, one of his commanders meets you outside with a map and a contract. He explains that a great battle is coming and that your help is needed. If you choose to accept, you\'ll go to %commander% %direction% of here and there await further instruction. | A guard outside %employer%\'s room stops you from going in. He stares at the sigil you have of the %companyname% then speaks to you directly.%SPEECH_ON%I\'m supposed to give you this.%SPEECH_OFF%He slaps a scroll into your chest. The instructions state that a war-ending battle is coming and, if you so choose to help, you are to report to %commander% at his camp for further instruction. You ask if you are to barter with the guard or with %employer%. The guard swallows hard and a bead of sweat runs down his cheek.%SPEECH_ON%If you must haggle, you are to try and haggle with me.%SPEECH_OFF% | %employer% greets you and takes you outside to his personal houndmaster. The dogs sit obediently as he walks down their line. He takes a hand across the tops of their heads, an easy, commandeering pet.%SPEECH_ON%%commander% is leading my men %direction% of here and he has reported to me that a large battle may be on the horizon.%SPEECH_OFF%The nobleman stops and turns to you.%SPEECH_ON%He thinks this could end the war with %feudfamily%. So I want you to go there and help out, anything to put an end to his horrid conflict.%SPEECH_OFF% | You meet with %employer% in a room full of generals. His commanders stare at you suspiciously, but the man invites you to a corner to talk personally.%SPEECH_ON%Don\'t mind them. Quickly now, I have an army being led by %commander% just %direction% of here. I need you to go and meet him for further instructions. My commanders believe a final battle may be soon upon us and we need all the help we can get. If this fight does indeed end this war, you\'ll be rewarded accordingly.%SPEECH_OFF% | A guard lets you into %employer%\'s room and there you find the man surrounded by squabbling generals. They yell over one another, knocking over war tokens on a map, and making a mess of the arrangement that is battle planning. %employer% stands up and meets with you personally.%SPEECH_ON%Don\'t mind the noise. The men are on edge because it\'s quite possible that we are at the cusp of ending this damned war with %feudfamily%. %commander% and most of my army is resting %direction% of here. He has called for as many reinforcements as he can get, including mercenaries. If you go there and help put an end to this shite we call war, then you will be most rewarded, sellsword.%SPEECH_OFF% | %employer% takes you outside to some pig pens. There you find the swine chomping on a corpse. Nearby, a few goats munch a banner of %feudfamily%. %employer% turns to you with a grin.%SPEECH_ON%A spy, you understand how these things are. Anyway, %commander% has reported to me that he believes a final battle with %feudfamily% may be at hand. He has asked for all the help he can get and I plan on sending it. If you go there, meet with him, and do as he asks, you will be rewarded most handsomely.%SPEECH_OFF% | You meet with one of %employer%\'s guards who takes you to the man personally. He\'s roosted in a small room that must be a sort of cubby away from the annoyances of the world. A candle flickers as he flips through a book. He speaks without looking at you.%SPEECH_ON%Hello, sellsword. My field commander, %commander%, has sent me a little bird that the armies of %feudfamily% may be coming together. He believes we have a chance at ending this war once and for all.%SPEECH_OFF%The nobleman licks his thumb and slowly turns a page. He continues.%SPEECH_ON%I want you to go and join him. Naturally, your pay will accommodate what you have to offer, which I suspect is quite a lot.%SPEECH_OFF% | One of %employer%\'s guards takes you to the top of a tower where you find the nobleman himself. He looks to you.%SPEECH_ON%Nice view, no?%SPEECH_OFF%You glance around. The land stretches and people become small mites bounding across it. A little donkey-pulled cart rattles its way beneath the tower, entering %townname% for business. You shrug. %employer% nods.%SPEECH_ON%I figured you for one to enjoy sights such as these, but I suppose a man of business wouldn\'t have such thoughts on this mind when business is at hand. And, dear sellsword, business is at hand. One of my commander has reported that the armies of %feudfamily% are coming together. He thinks that it\'s possible we can end this war with them in a big, final battle. Understand?%SPEECH_OFF%You nod. He continues.%SPEECH_ON%If this goes according to plan, you\'ll be paid according to your services. I don\'t know if you have ever helped end a war before, sellsword, but many men would pay a king\'s ransom for such services.%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "A great battle, you say?",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{I won\'t submit the %companyname% to another man\'s command. | I have to decline. | We\'re needed elsewhere.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "WarcampDay1",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{You arrive at the camp, which is more akin to a tent city, and find %commander%. He welcomes you into his tent which is more akin to a map city as he surveys where his army is, and where he thinks %feudfamily%\'s army might be.%SPEECH_ON%Welcome, sellsword. You arrived just in time.%SPEECH_OFF% | %commander%\'s war camp is filled with bored men. They\'re stirring stews or playing card games. The most exciting thing available is a battle between a beetle and a worm, a fight neither side seems particularly interested in. %commander% himself welcomes you and takes you inside his tent which is adorned with maps and other tools of planning. | You come into %commander%\'s tent to find a less than enthused group of men. One calls out.%SPEECH_ON%You are not the wenches we asked for.%SPEECH_OFF%The soldiers laugh. %randombrother% barks back.%SPEECH_ON%Your mothers took care of us first.%SPEECH_OFF%Predictably, all sides begin drawing their weapons. %commander% himself intervened to stop an outright bloodletting battle from breaking out. He takes you to his tent.%SPEECH_ON%Glad you\'re here, although your men could be less of a nuisance if we are to win farkin\' war.%SPEECH_OFF% | You come into %commander%\'s camp to find the men partaking in a beetle race. They cheer on the beetles which, halfway down a track made of haystraw, turn on one another and start fighting. The soldiers\' cheers get ever louder. %commander% finds you through the crowds and takes you to his tent.%SPEECH_ON%I am glad you are here, sellsword. I have something for you to do right now.%SPEECH_OFF% | Arriving at %commander%\'s war camp, you find the men cheering on a barely dressed woman riding around on a donkey. The lady and the ass ride off into a tent which quickly swells with men. %randombrother% asks if he can go. You state that you\'re going too, so yes, of course. Just then, %commander% grabs you. He leads you to his command tent.%SPEECH_ON%Trust me, you don\'t want to see that.%SPEECH_OFF%You do not trust him. | %commander%\'s war camp has turned the land into mud. They\'ve cut down all the nearby trees, constructing in their place little poorly made hovels that slant wherever the mud gives. Tents go out as far as your eye can see. Fires brim along the way, like stars glowing along a white sky.\n\n You meet with %commander% in his tent which is full of maps and lieutenants awaiting orders. | The war camp is full of clinking and clanking. Blacksmiths work to repair equipment, cooks stew what horrid messes they suggest is food, and soldiers hammer in posts for their tents. You meet with %commander% in his tent. Stolen away from all that metal noise, it is instead replaced by the arguments of his lieutenants. He shakes his head.%SPEECH_ON%When a large battle draws nigh, the men get nervous. Do not mind their bickering.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "What do you need the %companyname% to do?",
                        function getResult()
                        {
                            if (this.Flags.get("IsScoutsSighted"))
                            {
                                return "ScoutsSighted";
                            }
                            else
                            {
                                return "RequisitionSupplies1";
                            }
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "WarcampDay1End",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{You return to the war camp and order your men to get some rest. Who knows what awaits you tomorrow. | Well, %commander%\'s orders have been fulfilled, but there\'s surely to be more tomorrow. Get some rest while you can! | The war camp is just as you left it. You\'re not sure if that\'s good or bad. Tomorrow will bring more shite to take care of so you order the %companyname% to get some rest.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Rest well, we\'ll soon be called upon again.",
                        function getResult()
                        {
                            this.Flags.set("LastDay", this.World.getTime().Days);
                            this.Flags.set("NextDay", 2);
                            this.Contract.setState("Running_WaitForNextDay");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "ScoutsSighted",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_54.png[/img]%commander% explains the situation.%SPEECH_ON%{Our scouts have located their scouts. Unfortunately, I did not arm my scouts for battle so they have requested help. The enemy is located %direction% of here. Kill them all and %feudfamily% will be left in the dark about our army\'s movements. | A few of my pathfinders have located some of %feudfamily%\'s scouts just %direction% of here. They\'re rummaging around looking for the main army, but they won\'t find it because you\'ll be going out there to kill them all. Got it? | %feudfamily%\'s scouts have been spotted %direction% from here. I need you to go and kill them all before they find us or report whatever they\'ve learned in the past days. | In war, information is god. And I have recently acquired information that %feudfamily%\'s scouts are on the prowl just %direction% of here. If I can learn things about them, and then destroy what they\'ve learned about us, then we have acquired quite the advantage for the upcoming fights.}%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "The company will head out immediately.",
                        function getResult()
                        {
                            this.Contract.setState("Running_Scouts");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local playerTile = this.Contract.m.Warcamp.getTile();
                    local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 8);
                    local party = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).spawnEntity(tile, "Scouts", false, this.Const.World.Spawn.Noble, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
                    party.setDescription("Professional soldiers in service to local lords.");
                    party.setFootprintType(this.Const.World.FootprintsType.Nobles);
                    this.Contract.m.UnitsSpawned.push(party);
                    party.getLoot().Money = this.Math.rand(50, 100);
                    party.getLoot().ArmorParts = this.Math.rand(0, 10);
                    party.getLoot().Medicine = this.Math.rand(0, 2);
                    party.getLoot().Ammo = this.Math.rand(0, 20);
                    local r = this.Math.rand(1, 6);

                    if (r == 1)
                    {
                        party.addToInventory("supplies/bread_item");
                    }
                    else if (r == 2)
                    {
                        party.addToInventory("supplies/roots_and_berries_item");
                    }
                    else if (r == 3)
                    {
                        party.addToInventory("supplies/dried_fruits_item");
                    }
                    else if (r == 4)
                    {
                        party.addToInventory("supplies/ground_grains_item");
                    }
                    else if (r == 5)
                    {
                        party.addToInventory("supplies/pickled_mushrooms_item");
                    }

                    this.Contract.m.Destination = this.WeakTableRef(party);
                    party.setAttackableByAI(false);
                    party.setFootprintSizeOverride(0.75);
                    local c = party.getController();
                    c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
                    local roam = this.new("scripts/ai/world/orders/roam_order");
                    roam.setPivot(this.Contract.m.Warcamp);
                    roam.setMinRange(4);
                    roam.setMaxRange(9);
                    roam.setAllTerrainAvailable();
                    roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
                    roam.setTerrain(this.Const.World.TerrainType.Shore, false);
                    roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
                    c.addOrder(roam);
                }

            });
            this.m.Screens.push({
                ID = "ScoutsEscaped",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{Unfortunately, one or more of the scouts managed to slip out of the battle. Whatever information they had collected is now in the hands of %feudfamily%. | Damn it all! Some of the scouts managed to escape and no doubt make their way back to %feudfamily%.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Damnit!",
                        function getResult()
                        {
                            this.Contract.setState("Running_ReturnAfterScouts");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "ScoutsCaught",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{All of the scouts have been slain. Whatever information they had died with them. This will be a great boon for the upcoming battle. | The scouts are dead and whatever they had learned is dead with them.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Victory!",
                        function getResult()
                        {
                            this.Contract.setState("Running_ReturnAfterScouts");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "RequisitionSupplies1",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% sighs and begins to talk.%SPEECH_ON%I don\'t mean to waste your talents, sellsword, but I need someone to go out and requisition food supplies for the army. We are running low on supplies and need all the help we can get.%SPEECH_OFF%Hey, if you\'re getting paid then it is no insult to you. | %commander% stuffs a dried leaf behind his lip and crosses his arms.%SPEECH_ON%Hell, I know you\'re here to fight. I know you\'re here to kill men and get paid well for doing it. But right now, my army needs to be fed and to get fed I need someone to go out there and get the food.%SPEECH_OFF%He goes to one of his maps and points down at it.%SPEECH_ON%I need you to visit these farmers and load up their food. They will be expecting you so there shouldn\'t be any problems. Consider this an easy day before the battle, yeah?%SPEECH_OFF% | %commander% points at a scroll laid across one of his maps. There are numbers down it, and the numbers are shrinking the lower they get down the page.%SPEECH_ON%We are running low on food supplies. We usually requisition stores by visiting the farmers %direction% of here. I need you to go down there and pick more up. They\'ll be expecting you there shouldn\'t be any problems.%SPEECH_OFF% | You look down at a plate with a dried loaf of bread on it. There\'s meat on the plate next to it, half-eaten, the rest taken to by the flies. A well-fed, healthy dog wags its tail in one of the corners. %commander% walks around to one of his maps.%SPEECH_ON%We\'re running very low on food stores. If my men go hungry, they won\'t fight, and if they won\'t fight then we lose!%SPEECH_OFF%You nod. The math checks out. He continues.%SPEECH_ON%We\'ve been taking food from farmers %direction% of here for some time now. I need you to go there and do the same. One of my guards will get you a list of things to get. The farmers themselves will not oppose you. They know what happens if they do.%SPEECH_OFF% | You see a studious man in the corner of the tent. He\'s running a dried quill pen down a scroll, shaking his head all the while. Suddenly, he rises to his feet and hands the page to %commander%. The commander nods a few times then looks at you.%SPEECH_ON%This might seem beneath some mercenaries, but I need the %companyname% to visit the farms %direction% of here and \'requisition\' the foods that they have. It will not be the first time our army has made requests of these farmers. The last time we went, they tried to resist but, well, lessons were learned. My scribe will write down everything we need. Think of it as a day shopping at the markets.%SPEECH_OFF%The commander grins wryly.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "The company will move out within the hour.",
                        function getResult()
                        {
                            this.Contract.setState("Running_Requisition");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local settlements = this.World.EntityManager.getSettlements();
                    local lowest_distance = 99999;
                    local best_location;
                    local myTile = this.Contract.m.Warcamp.getTile();

                    foreach( s in settlements )
                    {
                        foreach( l in s.getAttachedLocations() )
                        {
                            if (l.getTypeID() == "attached_location.wheat_fields" || l.getTypeID() == "attached_location.pig_farm")
                            {
                                local d = myTile.getDistanceTo(l.getTile());

                                if (d < lowest_distance)
                                {
                                    lowest_distance = d;
                                    best_location = l;
                                }
                            }
                        }
                    }

                    best_location.setActive(true);
                    this.Contract.m.Destination = this.WeakTableRef(best_location);
                }

            });
            this.m.Screens.push({
                ID = "RequisitionSupplies2",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_72.png[/img]{The farmhouses draw near. A sea of crops stretches before you, the fields gliding wavelike as the winds soar through. %randombrother% runs his hand through a field of wheat. %randombrother2% slugs him in the shoulder.%SPEECH_ON%You wanna bring sawflies home with us? Get yer hand out of there.%SPEECH_OFF%The mercenary rubs his shoulder before slugging back.%SPEECH_ON%Fark you. My hand goes where it please, just ask yer mother.%SPEECH_OFF%The punches rapidly increase in volume and the idyllic scene breaks. | The farmhouses are in the distance. Fields of crops seesaw to a crisp wind, rustling like calm ocean waves. Farmhands chop through the fields with scythes, a crew of followers heaving the remains with pitchforks. Donkeys bring up the rear, drawing carts through the roughshod terrain. | The farms roll amongst the hills, the soil too good to let a bit of geography get in the way. Every field is flush with crops, and piping through them are the farmhands, scythes and pitchforks glinting as they rise and fall. In the distance, you see the owners of the farms standing together. They look mighty pissed, but rarely does anyone stay angry in front of the %companyname%.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Let\'s get what we\'re here for.",
                        function getResult()
                        {
                            if (this.Flags.get("IsAmbush"))
                            {
                                return "Ambush";
                            }
                            else if (this.Flags.get("IsUnrulyFarmers"))
                            {
                                return "UnrulyFarmers";
                            }
                            else
                            {
                                return "CooperativeFarmers";
                            }
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Ambush",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_10.png[/img]{As you near the farmers, a shout comes from your sides and out jumps a group of well-armed men. This is an ambush! | Closing in on the farmhouses, the food-filled carts begin to trundle backwards. As they shuffle away, they slowly reveal a troop of well-armed men. The farmers quickly clear out. %randombrother% draws his weapon.%SPEECH_ON%This is an ambush!%SPEECH_OFF% | You draw in on the food carts. The farmers step aside as %randombrother% goes forward and throws the tarp off one of the wagons. There\'s nothing inside. Suddenly, an arrow slams against the wagon side with a wooden thwang. The farmers duck down and run off as well-armed men stream in from the sides. This is an ambush!}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "Ambush";
                            p.Music = this.Const.Music.CivilianTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local n = 0;

                            do
                            {
                                n = this.Math.rand(1, this.Const.PlayerBanners.len());
                            }
                            while (n == this.World.Assets.getBannerID());

                            p.EnemyBanners = [
                                this.Const.PlayerBanners[n - 1],
                                "banner_noble_11"
                            ];

                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Const.Faction.Enemy);
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Mercenaries, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.PeasantsArmed, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);

                            p.Entities = [];
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "UnrulyFarmers",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_43.png[/img]You get up to the farmers only for them to resist. Their leader crosses his arms and shakes his head.%SPEECH_ON%{Look. My men have already loaded the carts. I\'m willing to meet halfway here, you know? Because we got families to feed and debts to pay just like anybody else. How about you pay us %cost% crowns and we\'ll let all this go up to %commander%. | You\'re mercenaries, right? Then you\'d understand the need for gold more than most. We\'re simple farmers, not money changers. All we ask for is a little compensation for our work. You give us %cost% crowns, and we\'ll give you the food. We\'re still taking a loss with that agreement, but I still think it\'s fair. | You come up here you\'re your gaudy outfit thinking you\'re just going to bully us into submission. %commander%\'s already taken too much, I say, and it\'s about time he pays for his food just like everybody else! So here\'s the deal. I\'ll sell you the food for %cost% crowns. I think that is perfectly fair for what we have to offer.}%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "You forget your place, farmer. You want us to take it by force?",
                        function getResult()
                        {
                            return "TakeItByForce";
                        }

                    },
                    {
                        Text = "I understand. You shall have your %cost% crowns and we the supplies.",
                        function getResult()
                        {
                            return "PayCompensation";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BeatenByFarmers",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_22.png[/img]The ambush is too strong! You take what men are still standing and beat a retreat. %commander%\'s men will have to ration even more now and news of the %companyname%\'s defeat here will no doubt spread.",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Damn this!",
                        function getResult()
                        {
                            this.Flags.set("IsRequisitionFailure", true);
                            this.Contract.setState("Running_ReturnAfterRequisition");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "PoorFarmers",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_60.png[/img]{The farmers and their hired swords are put down. One of the farmhands, kicking backward with his guts hanging out, begs for mercy as you close in for the kill. You shake your head.%SPEECH_ON%You\'re all turned out, kid. This right here is mercy.%SPEECH_OFF%The blade slides easily through his throat. He gargles, but it\'s over very quickly. You order the men to collect the foodstuffs and prepare to return to %commander%. | The farmers and their hired ambush have been slain to a man. You order the men to gather the foodstuffs. %commander% and his men should be happy to see your return. | There\'s blood on some of the food, but a little water will rub that right out. %commander%\'s men will appreciate your work here. | %randombrother% picks up a farmer that was playing dead and slashes him across the throat. The man gargles and wriggles free of the mercenary\'s grip. He jaunts over to one of the wagons, spewing blood all over the food. You call out.%SPEECH_ON%Goddammit, get him off there!%SPEECH_OFF%The farmer is quickly disposed of, but that shipment is no doubt ruined. You shake your head.%SPEECH_ON%Put a blanket on those ones. Maybe no one will notice.%SPEECH_OFF% | Getting the food required a little more work than you bargained for, but it\'s all in your hands now. You bestow ownership of the farmlands to a poor farmhand with woolsacks for shoes.%SPEECH_ON%Don\'t you forget what happened to your master here, because it sure as shit can happen to you to, got it?%SPEECH_OFF%The kid quickly nods. You order the %companyname% to prepare its return to %commander%.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Fools.",
                        function getResult()
                        {
                            this.Flags.set("RequisitionSuccess", true);
                            this.Contract.setState("Running_ReturnAfterRequisition");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "CooperativeFarmers",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{The farmers greet you warmly.%SPEECH_ON%Lemme guess, %commander% sent y\'all?%SPEECH_OFF%You nod. The farmer spits and nods back.%SPEECH_ON%Well alright. You\'ll have no trouble here. Men, help them get on the road.%SPEECH_OFF%Farmhands come out to help your men take the foodstuffs and prepare the journey home to %commander%. | You meet the leader of the farmers. He shakes your hand.%SPEECH_ON%%commander%\'s little bird told me he\'d sent mercenaries, but your outfit looks a step above any company I\'ve ever seen. My boys\'ll help you load the carts so you can be on your way.%SPEECH_OFF% | The farmers begin loading the carts as you near. Their leader steps forward.%SPEECH_ON%I ain\'t happy about doing this, but I\'m happier here in these fields than sitting in some war camp waitin\' to die in a war I don\'t care about. My men will help you load the carts so you can be on yer way. When you see %commander%, put in a good for me, would ya? I\'d like to keep farming.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I\'m sure %noblehouse% will appreciate it.",
                        function getResult()
                        {
                            this.Flags.set("RequisitionSuccess", true);
                            this.Contract.setState("Running_ReturnAfterRequisition");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "TakeItByForce",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_43.png[/img]{You draw out your sword. The farmers step back and a clatter of pitchforks being grabbed rattles through their lines. Their leader spits and runs a sleeve across his mouth.%SPEECH_ON%Hell, you wanna take it there? Then we\'ll go there.%SPEECH_OFF% | You shake your head.%SPEECH_ON%No deal. Give up the foodstuffs or face our wrath.%SPEECH_OFF%The farmer swings a pitchfork from side to side. His men slowly begin picking up arms. He nods.%SPEECH_ON%We\'re farmers, asshole. Wrath chose us a long, long time ago.%SPEECH_OFF% | You did not come here to broker deals.%SPEECH_ON%There will be no compensation. %commander% sent us here to...%SPEECH_OFF%The farmer laughs and interrupts.%SPEECH_ON%The commander sent some lapdogs. Well I\'ll tell you what little doggie, let\'s see if your men are more bark than bite.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Let\'s make this quick.",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "TakeItByForce";
                            p.Music = this.Const.Music.CivilianTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyBanners = [
                                "banner_noble_11"
                            ];
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Const.Faction.Enemy);
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Peasants, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);

                            p.Entities = [];
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }

                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "PayCompensation",
                Title = "At the farm...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You see no reason to shed the blood of some poor farmers just trying to live their lives. Handing over the crowns, you warn the farmer to be careful trying to cut deals like this.%SPEECH_ON%Not everyone is so kind as to try and broker with you.%SPEECH_OFF%The farmer turns his head, revealing a long scar the runs from scalp to shoulder.%SPEECH_ON%I know well enough. Thank you for your consideration, sellsword.%SPEECH_OFF% | You\'re only in the farmer-kill business if someone pays you to do just that. %commander% did not. You agree to the farmers\' terms. Their leader shakes your hand.%SPEECH_ON%Thank you mercenary. It\'s rare to see a man willing to cede some ground. I took you for a brute, but clearly you are a man of much acumen.%SPEECH_OFF% | You did not come out all this way to slaughter some poor farmers. You agree to the man\'s terms. He thanks you for not coming out all this way to slaughter some poor farmers. %randombrother%, however, quietly states that he did not come all this way to... You loudly tell him to shut his mouth and start loading the carts.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Let\'s hurry up and get back to the war camp.",
                        function getResult()
                        {
                            this.Flags.set("RequisitionSuccess", true);
                            this.Contract.setState("Running_ReturnAfterRequisition");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.World.Assets.addMoney(-this.Flags.get("RequisitionCost"));
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("RequisitionCost") + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "WarcampDay2",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{The morning sun leaks into your tent, running a beam right across your eyes to really rub it in that you\'ve a new day to put up with. | You get up and put your boots on, slapping out some spiders that thought it the place to rest overnight. | Outside your tent, a rooster loudly lets everyone know what a real asshole of an animal it is. You begrudgingly get up. | You wake to yet another day. Great. | You slept like a dead man and wake like one, too. The sunlight slipping into the tent is too blinding to go back to bed and the flaps are too far to shut. To hell with it, you\'ll get up. | Morning. That inevitable hour where a thousand regrets arrive on the glowy limelight of a new day.}\n\n A young boy stands outside your tent with a scroll. He unfurls and struggles to read it.%SPEECH_ON%{Your... co-co-commander has re... rekeestered... uh, you\'d just better go and see him yourself. | %commander% wi-wishes to see you, he... he says, wait, no horses do? What? Look I can\'t read. Just go see the commander. | Sir, this here paper tells me to tell you that, you... uh, you should... er, uh, go see the commander. There\'s a lot more, but we\'d be here all day if I tried finish it. | So yeah, I can\'t actually read, but I think the commander wishes to see you. | Let\'s see, this letter... I know this letter... it\'s the letter \'I\', and I think the rest of the sentence is a whole lot of I can\'t read a damn lick of this shite. Look, just go see the commander. I think that\'s what he wants.}%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to pay a visit to the commander...",
                        function getResult()
                        {
                            if (this.Flags.get("IsInterceptSupplies"))
                            {
                                return "InterceptSupplies";
                            }
                            else
                            {
                                return "Deserters1";
                            }
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "InterceptSupplies",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]You meet with %commander% in his tent. He looks rather excited. A shrewd and shrouded little man stands by his side. The commander talks hurriedly.%SPEECH_ON%{My little bird here has reported that a shipment of equipment is heading toward %feudfamily%\'s army. If we can intercept and destroy it, they won\'t be nearly as ready to fight in the future! | Hello, sellsword. My spies tell me that %feudfamily% has a much needed shipment of equipment heading toward their camp. I need you to go and destroy it. | Aren\'t spies the best? Look at this little man. He tells me, sir, %feudfamily% has a large shipment of goods coming in. Weapons, armor, food, so and so forth. Well I say, I\'ve got just the man to take advantage of this news: you! Go and find this shipment and lay it to waste. | Battles are oft won before they ever take place, you know that, right? My little spy here tells me that %feudfamily% has a shipment of arms and armor coming in. If you can manage to take it out, then their army will be far less prepared for a fight on open ground. | Did you know I once won a battle without so much as raising a sword? I managed to intercept a shipment of goods which left my enemy wholly unready to fight, so they surrendered instead. My little spy here tells me that %feudfamily% has a similar shipment of equipment coming in. I\'m sure it won\'t end the war, but if you could go and take it out that would be a huge boon. | Did you know that an army without equipment is hardly an army to begin with? %feudfamily%\'s army is running low on supplies. In fact, the reason they haven\'t attacked yet is because they\'re waiting for more arms and armor to arrive! Well, my little spy here has spotted that shipment. And I want you to go and destroy it. | I\'ve acquired a bit of most excellent news, sellsword. %feudfamily% is awaiting the arrival of arms and armor - and we know exactly where it\'s coming from. I just need you to go and do the obvious: destroy that shipment and cripple my enemy before he even knows what\'s hit him.}%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "The company will head out immediately.",
                        function getResult()
                        {
                            this.Contract.setState("Running_InterceptSupplies");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local startTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesStart")).getTile();
                    local destTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesDest")).getTile();
                    local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
                    local party = enemyFaction.spawnEntity(startTile, "Supply Caravan", false, this.Const.World.Spawn.NobleCaravan, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    party.getSprite("base").Visible = false;
                    party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
                    party.setMirrored(true);
                    party.setVisibleInFogOfWar(true);
                    party.setImportant(true);
                    party.setDiscovered(true);
                    party.setDescription("A caravan with armed escorts transporting provisions, supplies and equipment between settlements.");
                    party.setFootprintType(this.Const.World.FootprintsType.Caravan);
                    party.getFlags().set("IsCaravan", true);
                    party.setAttackableByAI(false);
                    party.getFlags().add("ContractSupplies");
                    this.Contract.m.Destination = this.WeakTableRef(party);
                    this.Contract.m.UnitsSpawned.push(party);
                    party.getLoot().Money = this.Math.rand(50, 100);
                    party.getLoot().ArmorParts = this.Math.rand(0, 10);
                    party.getLoot().Medicine = this.Math.rand(0, 2);
                    party.getLoot().Ammo = this.Math.rand(0, 20);
                    local r = this.Math.rand(1, 6);

                    if (r == 1)
                    {
                        party.addToInventory("supplies/bread_item");
                    }
                    else if (r == 2)
                    {
                        party.addToInventory("supplies/roots_and_berries_item");
                    }
                    else if (r == 3)
                    {
                        party.addToInventory("supplies/dried_fruits_item");
                    }
                    else if (r == 4)
                    {
                        party.addToInventory("supplies/ground_grains_item");
                    }
                    else if (r == 5)
                    {
                        party.addToInventory("supplies/pickled_mushrooms_item");
                    }

                    local c = party.getController();
                    c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
                    c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
                    local move = this.new("scripts/ai/world/orders/move_order");
                    move.setDestination(destTile);
                    move.setRoadsOnly(true);
                    local despawn = this.new("scripts/ai/world/orders/despawn_order");
                    c.addOrder(move);
                    c.addOrder(despawn);
                }

            });
            this.m.Screens.push({
                ID = "SuppliesReachedEnemy",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You failed to destroy the caravan. Obviously, all its goods have reached %feudfamily%\'s army which will make the fighting much harder in the coming days. | The caravan was not destroyed. You can be most assured that %feudfamily%\'s army will be near full-strength for the big battle ahead. | Well, shite. The caravan was not destroyed. Now, %feudfamily%\'s army is going to be very well prepared for the battle ahead.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We should head back to the camp...",
                        function getResult()
                        {
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SuppliesIntercepted",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_60.png[/img]{You had hoped to perhaps raid all that you could from the caravan, but the guards set fire to everything before it could be stolen away. Unfortunate, but all that matters is that %feudfamily%\'s army did not get their hands on all this equipment. | You destroyed much of the caravan and that which you didn\'t the guards did themselves in an effort to keep the equipment out of enemy hands. %commander% will be most pleased by these results. | It was hard fought, but you managed to kill off the caravan guards. Unfortunately, the troop seems to have employed a scorched earth policy as they managed to raze every wagon before they could be captured. They knew better than to let all this equipment fall into enemy hands. %commander% will be more than happy nonetheless. | The caravan guards put up a good fight, all considered, but the %companyname% manages to slay them to a man. Or so you think: during the battle, one of the guards managed to slip away and employ a bit of scorched earth. Every wagon has been set alight. Obviously, if %feudfamily% could not get the equipment, then nobody could. Annoying, but smart. Nonetheless, %commander% and his men will appreciate the news. | The caravan has been put to waste. You had hoped to perhaps capture the wagons and take the equipment for yourself, but one of the guards managed to burn them all, no doubt to keep such gear out of enemy hands. Regardless, %feudfamily%\'s army has most definitely been weakened.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "One less problem to deal with in the coming battle.",
                        function getResult()
                        {
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Deserters1",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{You enter %commander%\'s tent just in time to watch a candle go flying by your face. Its wick sizzles into the mud as you watch a table follow after it, flipping over and over with all its maps going flying. A red-faced %commander% stands at the foot of the carnage, his hands on his hips, breathing heavy as he recollects himself. He explains himself.%SPEECH_ON%Deserters! They\'ve deserted! On the eve of the most important battle of my life, I can\'t even keep my goddam men around. Look, I cannot have this army coming apart at the seams. I need you to go and find those deserters and bring them back to me. If they refuse to return, well, kill them all. One of the sentries said he saw them going %direction% of here. Now hurry up!%SPEECH_OFF% | Just as you are about to enter %commander%\'s tent, a man comes flying out. %commander% rushes forth from the tent and slams him into the mud. He grabs him by the collars and picks him up like a ragdoll.%SPEECH_ON%Where did they go? I swear by the old gods I will have you begging for death if you do not answer me honestly!%SPEECH_OFF%The man cries out and points.%SPEECH_ON%%direction%! They went that way, I swear!%SPEECH_OFF%%commander% drops the man who is quickly dragged away by a pair of guards. The commander stands up straight and runs a hand through his hair.%SPEECH_ON%Sellsword, a few of my men thought it best to desert the camp. Find them. Bring them back. Got it?%SPEECH_OFF%You nod, but ask what if the men refuse. The commander shrugs.%SPEECH_ON%Slaughter them, of course.%SPEECH_OFF% | You enter %commander%\'s tent to find him stepping away from a seated man. The commander has pliers in his hands and there\'s a white tooth clamped in between the prongs. You notice that the seated man is passed out, head lolling, blood dripping from his mouth. %commander% throws the pliers on his table and runs a reddened hand through his hair.%SPEECH_ON%A few of my men have deserted. I cannot risk this army coming undone, not at this hour, not when the battle is so close. My little friend here, when he was still speaking anyway, told me that his compatriots saw fit to run off %direction% of here. Go, sellsword, and bring those deserters back to me.%SPEECH_OFF%Before you go, you ask what to do if the deserters refuse to return. The commander glares at you.%SPEECH_ON%What do you think? Kill them all!%SPEECH_OFF% | You find %commander% brooding over his maps. His knuckles turn into his table, the legs groaning and wobbling. He looks up. His eyes flash, a quick glance of unbelievable anger.%SPEECH_ON%A few of my men saw fit to desert my army. The sentries tell me they saw them running %direction% of here. Go and bring them back.%SPEECH_OFF%You ask if he wants them alive. He nods.%SPEECH_ON%I want them back healthy as can be so I can better remind them what it means to abandon my army. Of course, if they absolutely refuse then I want them dead. That is also a good reminder to not abandon the army, wouldn\'t you agree?%SPEECH_OFF% | %commander%\'s got one of his lieutenants tied to one of the tent poles. The commander\'s got a long stick in hand and uses it bash the lieutenant across the chest and legs. The man cries out, spinning himself around only for his back to be beaten. When the lieutenant spins back around, his purpled face is snorting into unconsciousness.\n\n %commander% throws the stick down and starts pulling splinters out of his fingers.%SPEECH_ON%Glad you came, sellsword. A few of my men have deserted and I need you to go and find them. Bring them back alive, kill them all if they refuse. This here friend of mine said that they ran %direction%. For his sake, I hope he\'s telling the truth.%SPEECH_OFF%You hope he\'s telling the truth, too.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "The company will head out within the hour.",
                        function getResult()
                        {
                            this.Contract.setState("Running_Deserters");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local playerTile = this.World.State.getPlayer().getTile();
                    local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
                        this.Const.World.TerrainType.Shore,
                        this.Const.World.TerrainType.Mountains
                    ]);
                    local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(tile, "Deserters", false, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    party.getSprite("banner").setBrush("banner_deserters");
                    party.setFootprintType(this.Const.World.FootprintsType.Nobles);
                    party.setAttackableByAI(false);
                    party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
                    party.setFootprintSizeOverride(0.75);
                    this.Const.World.Common.addFootprintsFromTo(playerTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nobles, 0.75);
                    this.Contract.m.Destination = this.WeakTableRef(party);
                    party.getLoot().Money = this.Math.rand(50, 100);
                    party.getLoot().ArmorParts = this.Math.rand(0, 10);
                    party.getLoot().Medicine = this.Math.rand(0, 2);
                    party.getLoot().Ammo = this.Math.rand(0, 20);
                    local r = this.Math.rand(1, 6);

                    if (r == 1)
                    {
                        party.addToInventory("supplies/bread_item");
                    }
                    else if (r == 2)
                    {
                        party.addToInventory("supplies/roots_and_berries_item");
                    }
                    else if (r == 3)
                    {
                        party.addToInventory("supplies/dried_fruits_item");
                    }
                    else if (r == 4)
                    {
                        party.addToInventory("supplies/ground_grains_item");
                    }
                    else if (r == 5)
                    {
                        party.addToInventory("supplies/pickled_mushrooms_item");
                    }

                    local c = party.getController();
                    local wait = this.new("scripts/ai/world/orders/wait_order");
                    wait.setTime(9000.0);
                    c.addOrder(wait);
                }

            });
            this.m.Screens.push({
                ID = "Deserters2",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{You come upon the deserters sitting around a smoldering campfire, one of them desperately kicking dust over the coals. He stops when he sees you. The rest of the deserters follow his gaze before springing to their feet.%SPEECH_ON%We ain\'t going back. You can tell %commander% to go to hell.%SPEECH_OFF% | The deserters are arguing amongst themselves when you crash their little runaway party. One of the men jumps back.%SPEECH_ON%%commander% sent you, didn\'t he? Well, you can tell him to go to hell.%SPEECH_OFF%Another man pumps his fist.%SPEECH_ON%Yeah, we ain\'t going back!%SPEECH_OFF%They\'re an unruly bunch, no doubt. | %randombrother% points out a group of men standing at a road sign. They\'re arguing too loudly amongst themselves to hear you approach. You give out a sharp whistle which simultaneously silences and spins the men around. One rears back.%SPEECH_ON%That rat commander sent mercenaries after us?%SPEECH_OFF%You nod and explain that they should come on back with you. Another deserter shakes his head.%SPEECH_ON%Go on back? How about you go on and get the hell out of here? We ain\'t going back so you go on and tell the commander just that.%SPEECH_OFF% | The deserters are found sharing food out of a wool sack. They pause at the sight of you and one elects to try and swallow his food whole. He chokes. The rest of the men don\'t move. The choker scrambles around for help, his face going purple. His legs scissor over the wool sack, kicking food everywhere. You nod.%SPEECH_ON%Help your man.%SPEECH_OFF%The deserters quickly run to the choking man and knock the food out of his throat. He gasps for air. You begin to explain what %commander% has asked of you, but one of the deserters interrupts.%SPEECH_ON%No. We are not going back. This war is a waste and we want no part of it.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Is this who you want to be? Cowards that won\'t defend their own lands?",
                        function getResult()
                        {
                            return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptMotivation" : "DesertersRefuseMotivation";
                        }

                    },
                    {
                        Text = "Your choice is simple. Fight for your lord, or die here.",
                        function getResult()
                        {
                            return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptThreats" : "DesertersRefuseThreats";
                        }

                    },
                    {
                        Text = "Let\'s be honest what this is about. Here\'s %bribe% crowns if you return.",
                        function getResult()
                        {
                            return "DesertersAcceptBribe";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "DesertersAcceptBribe",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{You take out a bag and put %bribe% crowns into it.%SPEECH_ON%I will personally pay you men to come back with me to the war camp. %commander% is furious with you, make no farkin\' mistake about it, but he needs every man he can get. If you fight for him in this coming battle, I\'ve no doubt he\'ll pardon this little error you have made.%SPEECH_OFF% | You offer the deserters %bribe% crowns. The men look at one another, then speak to you.%SPEECH_ON%And what good is money when the commander hangs us all?%SPEECH_OFF%You nod and answer.%SPEECH_ON%Good question, but %commander% is no fool. He needs all the men he can muster for the coming battle. Prove yourself in that battle and this little pity party you\'ve thrown for yourselves will be forgotten.%SPEECH_OFF%}{The deserters mull their options and eventually agree to come back with you. | The deserters huddle and come to some sort of agreement. Breaking the huddle, their leader steps forward.%SPEECH_ON%Despite some objections, we agree to come back with you to the war camp. I hope I do not come to regret this.%SPEECH_OFF% | After a short time debating on what to do, the deserters put it to a vote. It isn\'t unanimous, but they come to an agreement: they\'ll go back with you to %commander%. | The deserters argue about what to do next. Inevitably, it comes to a vote. Predictably, that vote is a tie. The men then agree to toss a crown: heads they go back to camp, tails they leave. Their leader flips the coin and all the men watch as it turns and glints. The coin lands heads. Every single one of them sighs upon seeing it, as if chance and fortune relieved them of an enormous responsibility beyond their own choosing.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "This should help us in the coming battle.",
                        function getResult()
                        {
                            this.Contract.m.Destination.die();
                            this.Contract.m.Destination = null;
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.World.Assets.addMoney(-this.Flags.get("Bribe"));
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("Bribe") + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "DesertersAcceptThreats",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% steps forward, wheeling a weapon around over his shoulder with ease. He nods.%SPEECH_ON%You\'re afraid of %commander%. I get that. You know him, you know his temperament, and what he\'s capable of. Question is...%SPEECH_OFF%The sellsword grins, the wily smile reflected in the sheen of his blade.%SPEECH_ON%Do you know me?%SPEECH_OFF% | The deserters look about ready to leave when %bigdog% whistles loudly.%SPEECH_ON%Hey you shits, my commander gave you an order.%SPEECH_OFF%One of the deserter scoffs.%SPEECH_ON%Yeah? He ain\'t our farkin\' commander so you can take that order and cram it.%SPEECH_OFF%%bigdog% draws out a huge blade and plants it in the ground. He tents his hands atop the pommel.%SPEECH_ON%You\'re afraid of %commander% and that\'s alright. But you keep on being a little shit, my friend, and we\'ll see just which commander you should have really been afraid of.%SPEECH_OFF% | The deserters turn to leave. %bigdog% takes out a huge blade and clangs it against his armor. Slowly, the deserters turn around. %bigdog% smiles.%SPEECH_ON%Any one of you ever pissed your pants?%SPEECH_OFF%One of the deserters shakes his head.%SPEECH_ON%H-hey man, get the fark out of here with that talk.%SPEECH_OFF%%bigdog% snatches up his blade and points the tip of it at the deserter.%SPEECH_ON%Oh, you want me shut up? Keep speaking to me like that and there won\'t be anybody talking here real soon.%SPEECH_OFF%}{The deserters mull their options and eventually agree to come back with you. | The deserters huddle and come to some sort of agreement. Breaking the huddle, their leader steps forward.%SPEECH_ON%Despite some objections, we agree to come back with you to the war camp. I hope I do not come to regret this.%SPEECH_OFF% | After a short time debating on what to do, the deserters put it to a vote. It isn\'t unanimous, but they come to an agreement: they\'ll go back with you to %commander%. | The deserters argue about what to do next. Inevitably, it comes to a vote. Predictably, that vote is a tie. The men then agree to toss a crown: heads they go back to camp, tails they leave. Their leader flips the coin and all the men watch as it turns and glints. The coin lands heads. Every single one of them sighs upon seeing it, as if chance and fortune relieved them of an enormous responsibility beyond their own choosing.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "You made the right decision.",
                        function getResult()
                        {
                            this.Contract.m.Destination.die();
                            this.Contract.m.Destination = null;
                            this.Contract.m.Dude = null;
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local brothers = this.World.getPlayerRoster().getAll();
                    local candidates = [];

                    foreach( bro in brothers )
                    {
                        if (bro.getSkills().hasSkill("trait.player"))
                        {
                            continue;
                        }

                        if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
                        {
                            candidates.push(bro);
                        }
                    }

                    if (candidates.len() == 0)
                    {
                        candidates = brothers;
                    }

                    this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "DesertersAcceptMotivation",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{As the deserters turn to leave, %motivator% steps forward and clears his throat.%SPEECH_ON%So, that\'s how it\'s going to be, huh? You\'re going to wiggle out of your responsibilities like a bunch of limp dicks? I know how you\'re feeling. I know you see no point in this war or risking your life for some stuck up nobleman who has no idea what you go through. That\'s fair. But you\'re gonna wake up years from now, bouncing your grandson on your knee, and he\'s going to ask you questions about when you fought in the war. And you are going to have to lie to that little boy.%SPEECH_OFF% | %motivator% puts his fingers to his lips and draws a sharp whistle. The deserters turn to him as he begins to speak.%SPEECH_ON%So that\'s it, huh? You\'re going to intentionally burden yourself with this? And what will you tell your little ones when the time comes, hm? That you were a no good deserter who left your comrades to die in your stead? And make no mistake, your absence will have men die who should not have. Your not being there will have effects beyond your measure!%SPEECH_OFF% | %motivator% calls out to the deserters.%SPEECH_ON%Alright, so you leave now. Throw down your banner and call it a campaign. And what happens when %feudfamily% wins, huh?%SPEECH_OFF%One of the deserters shrugs.%SPEECH_ON%They don\'t know me. I\'m gonna go back to my family and farm.%SPEECH_OFF%Laughing, %motivator% shakes his head.%SPEECH_ON%Is that right? And what will you do when these foreign men come around your stead? When they see your wife? When they see your children? What, exactly, do you think this war is about? There won\'t be any home for you to go back to, you fool!%SPEECH_OFF%}{The deserters mull their options and eventually agree to come back with you. | The deserters huddle and come to some sort of agreement. Breaking the huddle, their leader steps forward.%SPEECH_ON%Despite some objections, we agree to come back with you to the war camp. I hope I do not come to regret this.%SPEECH_OFF% | After a short time debating on what to do, the deserters put it to a vote. It isn\'t unanimous, but they come to an agreement: they\'ll go back with you to %commander%. | The deserters argue about what to do next. Inevitably, it comes to a vote. Predictably, that vote is a tie. The men then agree to toss a crown: heads they go back to camp, tails they leave. Their leader flips the coin and all the men watch as it turns and glints. The coin lands heads. Every single one of them sighs upon seeing it, as if chance and fortune relieved them of an enormous responsibility beyond their own choosing.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "You made the right decision.",
                        function getResult()
                        {
                            this.Contract.m.Destination.die();
                            this.Contract.m.Destination = null;
                            this.Contract.m.Dude = null;
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local brothers = this.World.getPlayerRoster().getAll();
                    local highest_bravery = 0;
                    local best;

                    foreach( bro in brothers )
                    {
                        if (bro.getCurrentProperties().getBravery() > highest_bravery)
                        {
                            best = bro;
                        }
                    }

                    this.Contract.m.Dude = best;
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "DesertersRefuseThreats",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% steps forward, wheeling a weapon around over his shoulder with ease. He nods.%SPEECH_ON%You\'re afraid of %commander%. I get that. You know him, you know his temperament, and what he\'s capable of. Question is...%SPEECH_OFF%The sellsword grins, the wily smile reflected in the sheen of his blade.%SPEECH_ON%Do you know me?%SPEECH_OFF% | The deserters look about ready to leave when %bigdog% whistles loudly.%SPEECH_ON%Hey you shits, my commander gave you an order.%SPEECH_OFF%One of the deserter scoffs.%SPEECH_ON%Yeah? He ain\'t our farkin\' commander so you can take that order and cram it.%SPEECH_OFF%%bigdog% draws out a huge blade and plants it in the ground. He tents his hands atop the pommel.%SPEECH_ON%You\'re afraid of %commander% and that\'s alright. But you keep on being a little shit, my friend, and we\'ll see just which commander you should have really been afraid of.%SPEECH_OFF% | The deserters turn to leave. %bigdog% takes out a huge blade and clangs it against his armor. Slowly, the deserters turn around. %bigdog% smiles.%SPEECH_ON%Any one of you ever pissed your pants?%SPEECH_OFF%One of the deserters shakes his head.%SPEECH_ON%H-hey man, get the fark out of here with that talk.%SPEECH_OFF%%bigdog% snatches up his blade and points the tip of it at the deserter.%SPEECH_ON%Oh, you want me shut up? Keep speaking to me like that and there won\'t be anybody talking here real soon.%SPEECH_OFF%}{The deserters cannot decide amongst themselves and put it to a vote. The choice to keep running carries the majority. Their leader informs you of this democratic result and bids you farewell. %commander% won\'t be happy, but you draw out your sword and tell the men there\'s only one other path for them to go. The leader turns around, unsheathing his blade and nodding.%SPEECH_ON%Alright, I figured you didn\'t come all this way just to hear us say goodbye. At arms, men.%SPEECH_OFF% | %commander% will hate it, but the deserters refuse to come back. They see no reason to jump back into the fray. You tell their leader good luck. He thanks you, but quickly falls silent as you draw out your weapon, the rest of the %companyname% following suit. The leader sighs.%SPEECH_ON%Yeah, I thought this is how it\'d go.%SPEECH_OFF%You nod.%SPEECH_ON%Nothing personal. I don\'t care what you do, but this here is a matter of business and we have to see it to its conclusion.%SPEECH_OFF% | The deserters are unable to come to a decision so they turn to chance: their leader takes out a coin and flips it through the air. Heads they go back to camp, tails they keep on leaving. It lands tails. The deserters collectively breathe a sigh of relief. Their leader claps you on the shoulder.%SPEECH_ON%Fortune has decided our fates.%SPEECH_OFF%You nod and draw out your sword, the rest of the company following suit.%SPEECH_ON%You keep that in mind when we\'re killing the lot of you.%SPEECH_OFF%The leader smiles weakly as he draws his blade.%SPEECH_ON%It\'s quite alright. We\'d rather die on freedom\'s doorstep than go back to that grind.%SPEECH_OFF% | The leader politely refuses to come back.%SPEECH_ON%We didn\'t choose this path lightly, sellsword. We\'re not coming back.%SPEECH_OFF%You order the %companyname% to draw out their weapons. The deserter\'s leader sighs, but nods understandingly.%SPEECH_ON%I suppose it is what it is. We talked of this, and we are prepared to die here, walking where we wish, than die out there on some dog\'s orders. This is all the world to us now.%SPEECH_OFF%Shrugging, you respond.%SPEECH_ON%Tis only business for us.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Let\'s get this over with...",
                        function getResult()
                        {
                            this.Contract.m.Dude = null;
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
                            p.CombatID = "Deserters";
                            p.Music = this.Const.Music.CivilianTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.TemporaryEnemies = [
                                this.Contract.getFaction()
                            ];
                            p.AllyBanners = [
                                this.World.Assets.getBanner()
                            ];
                            p.EnemyBanners = [
                                "banner_deserters"
                            ];
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local brothers = this.World.getPlayerRoster().getAll();
                    local candidates = [];

                    foreach( bro in brothers )
                    {
                        if (bro.getSkills().hasSkill("trait.player"))
                        {
                            continue;
                        }

                        if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
                        {
                            candidates.push(bro);
                        }
                    }

                    if (candidates.len() == 0)
                    {
                        candidates = brothers;
                    }

                    this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "DesertersRefuseMotivation",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_88.png[/img]{As the deserters turn to leave, %motivator% steps forward and clears his throat.%SPEECH_ON%So, that\'s how it\'s going to be, huh? You\'re going to wiggle out of your responsibilities like a bunch of limp dicks? I know how you\'re feeling. I know you see no point in this war or risking your life for some stuck up nobleman who has no idea what you go through. That\'s fair. But you\'re gonna wake up years from now, bouncing your grandson on your knee, and he\'s going to ask you questions about when you fought in the war. And you are going to have to lie to that little boy.%SPEECH_OFF% | %motivator% puts his fingers to his lips and draws a sharp whistle. The deserters turn to him as he begins to speak.%SPEECH_ON%So that\'s it, huh? You\'re going to intentionally burden yourself with this? And what will you tell your little ones when the time comes, hm? That you were a no good deserter who left your comrades to die in your stead? And make no mistake, your absence will have men die who should not have. Your not being there will have effects beyond your measure!%SPEECH_OFF% | %motivator% calls out to the deserters.%SPEECH_ON%Alright, so you leave now. Throw down your banner and call it a campaign. And what happens when %feudfamily% wins, huh?%SPEECH_OFF%One of the deserters shrugs.%SPEECH_ON%They don\'t know me. I\'m gonna go back to my family and farm.%SPEECH_OFF%Laughing, %motivator% shakes his head.%SPEECH_ON%Is that right? And what will you do when these foreign men come around your stead? When they see your wife? When they see your children? What, exactly, do you think this war is about? There won\'t be any home for you to go back to, you fool!%SPEECH_OFF%}{The deserters cannot decide amongst themselves and put it to a vote. The choice to keep running carries the majority. Their leader informs you of this democratic result and bids you farewell. %commander% won\'t be happy, but you draw out your sword and tell the men there\'s only one other path for them to go. The leader turns around, unsheathing his blade and nodding.%SPEECH_ON%Alright, I figured you didn\'t come all this way just to hear us say goodbye. At arms, men.%SPEECH_OFF% | %commander% will hate it, but the deserters refuse to come back. They see no reason to jump back into the fray. You tell their leader good luck. He thanks you, but quickly falls silent as you draw out your weapon, the rest of the %companyname% following suit. The leader sighs.%SPEECH_ON%Yeah, I thought this is how it\'d go.%SPEECH_OFF%You nod.%SPEECH_ON%Nothing personal. I don\'t care what you do, but this here is a matter of business and we have to see it to its conclusion.%SPEECH_OFF% | The deserters are unable to come to a decision so they turn to chance: their leader takes out a coin and flips it through the air. Heads they go back to camp, tails they keep on leaving. It lands tails. The deserters collectively breathe a sigh of relief. Their leader claps you on the shoulder.%SPEECH_ON%Fortune has decided our fates.%SPEECH_OFF%You nod and draw out your sword, the rest of the company following suit.%SPEECH_ON%You keep that in mind when we\'re killing the lot of you.%SPEECH_OFF%The leader smiles weakly as he draws his blade.%SPEECH_ON%It\'s quite alright. We\'d rather die on freedom\'s doorstep than go back to that grind.%SPEECH_OFF% | The leader politely refuses to come back.%SPEECH_ON%We didn\'t choose this path lightly, sellsword. We\'re not coming back.%SPEECH_OFF%You order the %companyname% to draw out their weapons. The deserter\'s leader sighs, but nods understandingly.%SPEECH_ON%I suppose it is what it is. We talked of this, and we are prepared to die here, walking where we wish, than die out there on some dog\'s orders. This is all the world to us now.%SPEECH_OFF%Shrugging, you respond.%SPEECH_ON%Tis only business for us.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Let\'s get this over with...",
                        function getResult()
                        {
                            this.Contract.m.Dude = null;
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
                            p.CombatID = "Deserters";
                            p.Music = this.Const.Music.CivilianTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.TemporaryEnemies = [
                                this.Contract.getFaction()
                            ];
                            p.AllyBanners = [
                                this.World.Assets.getBanner()
                            ];
                            p.EnemyBanners = [
                                "banner_deserters"
                            ];
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local brothers = this.World.getPlayerRoster().getAll();
                    local highest_bravery = 0;
                    local best;

                    foreach( bro in brothers )
                    {
                        if (bro.getCurrentProperties().getBravery() > highest_bravery)
                        {
                            best = bro;
                        }
                    }

                    this.Contract.m.Dude = best;
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "DesertersAftermath",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% cleans his blade on the tabard of one of the corpses.%SPEECH_ON%Shame they went out that way. They could have lived. They had a choice.%SPEECH_OFF%You shrug and respond.%SPEECH_ON%They had death on all sides of them. They merely chose us as the executioner.%SPEECH_OFF% | The deserters are dead all around you. One is crawling along the ground, ever putting distance between himself and %commander%\'s army. You crouch beside him, dagger in hand to finish the job. He laughs at you.%SPEECH_ON%No need to dirty the dirk, sellsword. Just give me time. That\'s all I g-got, augh.%SPEECH_OFF%A spurt of blood runs down his chin. His eyes narrow, staring straight, and he slowly sinks to the ground. You stand and tell the company to get ready to leave. | The last deserter is found leaning against a rock, his hands limp at his sides, both turned up like a beggar with plenty of business. There\'s blood running down his chest and legs and pooling about the ground. He stares at it.%SPEECH_ON%I\'m alright, thanks for asking, sellsword.%SPEECH_OFF%You tell him you didn\'t say anything. He looks at you, genuinely confused.%SPEECH_ON%You didn\'t? Well then.%SPEECH_OFF%A moment later and he falls to a side, face frozen in that deadened way. | Some men fancy the hilarity of a doomed life. With all choices and freedom stripped from them, what else is there to do but laugh in the face of such cruel fate? Every deserter died with a look of absolute aplomb across their faces. | The last deserter alive is found staring at the sky. He pedals a hand in the air.%SPEECH_ON%Goddammit, I just wanna see one.%SPEECH_OFF%You ask what it is he wishes to see. He laughs, a hearty chuckle quickly interrupted by a surge of pain.%SPEECH_ON%A bird. Oh, there\'s one. It\'s so big, so beautiful.%SPEECH_OFF%He points and you look up. A vulture cycles overhead. When you look back down, the man is dead.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Unfortunate, but it had to be done.",
                        function getResult()
                        {
                            this.Contract.setState("Running_ReturnAfterIntercept");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "WarcampDay2End",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% informs you that tomorrow is the big day. You return to your tent for a good and earned rest. | You return to %commander% and inform him of the news. He is very subdued, his thoughts consumed with what is coming tomorrow: a large and decisive battle. The day over, you decide to turn in and wait for morning. | You report to %commander%, but he hardly even responds. He\'s practically living in his battle maps.%SPEECH_ON%I\'ll see you tomorrow, mercenary. Get a good night\'s rest because you\'ll be needing it.%SPEECH_OFF% | %commander% welcomes you into his tent, but seemingly ignores your reports. Instead, he is focused in on his maps and is continuing debates with his lieutenants on tomorrow\'s battle plans. You decide to turn in and get a good night\'s rest. | %commander% nods to your reports, but is otherwise not really paying any attention to you. A bunch of battle maps are laid out on a table and his eyes are focused in on those instead. You understand it: tomorrow\'s the big battle and he has better things to think about. You decide to turn in for the night.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Rest well this night, for tomorrow battle awaits!",
                        function getResult()
                        {
                            this.Flags.set("LastDay", this.World.getTime().Days);
                            this.Flags.set("NextDay", 3);
                            this.Contract.setState("Running_WaitForNextDay");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "WarcampDay3",
                Title = "At the war camp...",
                Text = "[img]gfx/ui/events/event_78.png[/img]{%commander% walks before an assembly of his soldiers. Some idle with weary faces, having not slept through the night. Others still shake with the jitters. Their commander calls to them.%SPEECH_ON%Are you afraid? Are you scared? That\'s fine. I\'d be worried if you weren\'t.%SPEECH_OFF%Scattered laughter lifts the mood. He continues.%SPEECH_ON%But right now I\'m asking you not to be scared for your own hide, but instead to be scared for the lives of your countrymen, your families! They are who we fight for this day! Let us worry about ourselves tomorrow, for today we will be men!%SPEECH_OFF%The laughter turns into roaring cheers. | %commander% has his men assembled before him. Footmen, archers, reserves, all standing in a stiff wind. The commander looks them up and down.%SPEECH_ON%I know what you\'re thinking, \'What am I doing fighting for this sorry git. If he\'s so noble, where\'s his high horse to stand on?\'%SPEECH_OFF%The soldiers laugh, easing some tension. %commander% continues.%SPEECH_ON%Well, ugly sod or not, I like nothing better than a good fight. And that\'s where I\'ll be, men. I\'ll be in there with you, fighting until I can\'t, fighting until the very end, because that is what a fighter is supposed to do!%SPEECH_OFF%The soldiers raise their arms and cheer. Their commander turns around, sword raised.%SPEECH_ON%Now follow me, and we\'ll show %feudfamily% what it is to be men!%SPEECH_OFF% | %commander%\'s motley army has come together for the big battle. Walking up and down the battle lines, the commander starts in on a speech.%SPEECH_ON%Some of y\'all looked sapped of sleep. What are you, nervous? Me too! Didn\'t sleep a wink.%SPEECH_OFF%This loosens some of the men up. It is good to know you are not alone, whether in flesh or spirit. He continues.%SPEECH_ON%But I am awake for today, for this fight. I wouldn\'t miss it for the world. So rub that sleep from your eyes men, for today we show those %feudfamily% bastards they should have stayed in their beds!%SPEECH_OFF% | %commander% addresses his readying men. You don\'t listen to a word of it. Instead, you prepare your men for the coming fight. | You watch as %commander% goes to his men and peppers them with lines of inspiration. Many you\'ve heard before. In fact, did these lines come from some scroll of old? A motivational speaker whose energy has been passed down through the generations? %randombrother% comes up to you chuckling.%SPEECH_ON%I know that commander speaks empty rhetoric, yet I feel compelled to do a pushup or two anyway.%SPEECH_OFF%Laughing, you tell the man to get in line with the rest of the company. He barbs back.%SPEECH_ON%Will there be a speech?%SPEECH_OFF%You push the man as he turns laughing. | %commander% walks up and down his battle lines. He comes to a boy who is shaking so hard his armor is rattling.%SPEECH_ON%You remind me of myself, kid, you know that? You think I haven\'t been where you are? Heh, take it easy, because someday you might be where I am.%SPEECH_OFF%The kid looks up with a new glint in his eye. He steadies himself and nods determinedly. The commander raises his voice, barking at his men to prepare for the battle of their lives. | %commander% goes about his men, yelling out that this battle is the most important event that they will ever experience in their lives. You\'re not so sure, but what is sure is that it will be the last thing many of them will ever experience. The cruelties of war don\'t make for the best of motivation, though, so you keep your mouth shut. | You tighten your boots as %commander% readies his men with a big, pompous speech about the grand importance of a war between the noble houses. It\'s very convincing. It has to be, if men with nothing to gain from fighting are going to be doing the dying. | %commander% comes to stand in front of his men. He\'s attired in spectacular battle garments, standing astride his men like a pearl among beach sands. He explains that they must win the battle, for losing it might just as well lose the entire war. He\'s saying anything to get the men invested, you think. You sure as shit wouldn\'t die for dainty nobility just because some honor-seeking commander divined it from political spirits. Then again, that attitude is why you\'re a mercenary to begin with. | War is a hell of a thing. How does one sell a man on it? %commander% does his best, pontificating on numerous subjects as he addresses his men. First, he states that it is the honorable thing to do. Then he states that they are many soldiers here, no doubt increasing the odds that some other schmuck will die instead of you. Health in numbers! Then he argues that losing this battle might mean losing their wives, their children, their country. This last number seems to work the best as the men roar with anger and energy. Through the now cheering crowd of soldiers, you can easily spot the cynics and sodomites. | %commander% addresses his men with a deep, strong tone.%SPEECH_ON%Ah, some of you are looking very giddy. Can\'t wait to slaughter %feudfamily%\'s men, huh? I know that feeling.%SPEECH_OFF%A scattering of nervous laughter. The commander continues.%SPEECH_ON%Keep your families in mind, men, for they are surely depending upon us this day!%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Onwards, brothers, there\'s a battle to be won!",
                        function getResult()
                        {
                            this.Contract.setState("Running_FinalBattle");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BattleLost",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_86.png[/img]{Dead bodies everywhere. The silhouette of %commander% atop the corpses, his armor glinting, a shiny encasement of a fleshen ruin. %employer% will no doubt be saddened by the loss of the battle here, but there is nothing more that can be done. | The battle is lost! %commander%\'s men have been slain to a scattering of survivors and the commander himself has been struck down. Vultures are already cycling overhead and %feudfamily%\'s men steadily work through the mounds of bodies to kill off any man pretending to be dead. You quickly gather the remnants of the %companyname% to retreat. %employer% will no doubt be horrified by the results here, but there\'s nothing that can be done now.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Not every battle can be won...",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Lost an important battle");
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BattleWon",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_87.png[/img]{You\'ve triumphed! Well, you and %commander%\'s men both. The battle has been won, that\'s what is most important. You step over the mounds of bodies to prepare a return to your employer. | Corpses in piles five deep. Vultures plucking morsels from the mounds. Wounded begging for help. Surely, to a stranger\'s eye, there does not appear to be any winner here. %commander%, however, comes over with a wide grin.%SPEECH_ON%{Good work, sellsword! You should get on back to your employer and tell him what\'s happened here. | Well if it isn\'t the sellsword. Wasn\'t sure if you\'d make it. You should get on back to your employer and tell him what happened here.}%SPEECH_OFF% | A wounded man begs at your feet. You can\'t tell if he\'s one of %commander%\'s or an enemy. Suddenly, a spearhead jets in and pierces the man through the head, leaving him permanently side-eyed. You look over to see the killer tenting his hands atop the spear with an accomplished look on his face. He points a finger.%SPEECH_ON%You\'re that sellsword, right? %commander% told me to tell you that you should head on back to your employer. That sound right to you?%SPEECH_OFF%You nod. A groan rises from the piles of corpses. The man picks his spear back up, catching it in his other hand.%SPEECH_ON%Whelp, back to it!%SPEECH_OFF% | The battle over, you find %commander% roaring and ripping off his armor and undershirt. He shows off his wounds, flexing so they open agape like seeping rinds of freshly cut fruit. He demands his men to do the same, turning each around so that he can see their back.%SPEECH_ON%You see, good warriors like us carry our wounds here, here, and here...%SPEECH_OFF%He points to every spot on the front of his body, and then he points to his back.%SPEECH_ON%But here, no man carries an injury here. Because we die going forward, not one step back! Isn\'t that right?%SPEECH_OFF%The men cheer, though some are woozy on their feet, blood trickling from their injuries. You ignore the theatrics and gather the men of the %companyname%. Your employer will surely be happy to hear of the results here and that\'s all you really care about. | %commander% greets you after the battle. He\'s drenched in blood as if he cut someone\'s head off and bathed beneath the spewing trunk. A white stroke of teeth glimmers when he smiles.%SPEECH_ON%Now that is what I call a fight.%SPEECH_OFF%You ask if he\'d say the same had he lost. He laughs.%SPEECH_ON%Oh, the cynic are we? No, I had no intention of losing here and, if I did, I had no intention of being alive to witness my own defeat.%SPEECH_OFF%You nod and respond.%SPEECH_ON%Rare is the man who gets to still be around to see his greatest defeat. It was good fighting with you, commander, but I must return to your employer now.%SPEECH_OFF%The commander nods and then turns around, yelling for someone to fetch him a towel. | You find %commander% squatting over a wounded enemy soldier. He\'s running a dagger along the poor man\'s chest, back and forth, scraping it along the armor. The commander looks at you.%SPEECH_ON%What do you think, sellsword? Should I let him live?%SPEECH_OFF%The prisoner stares at you, he juts his head forward, blinking hard. You suppose this is a \'yes.\' You shrug.%SPEECH_ON%That is not up to me. Look, it was good fighting with you, but I must return to your employer now.%SPEECH_OFF%%commander% nods.%SPEECH_ON%Be seeing you, then.%SPEECH_OFF%As you leave, the commander is still back there hunched beside his prisoner, the blade clinking as it goes back and forth, back and forth, back and forth. | You find %commander% punching a dagger into the side of a wounded man\'s chest. The felled enemy seizes to the pain, but he quickly fades thereafter, going limp in mere moments. A gush of blood follows the blade\'s retrieval as the commander wipes it on his pantleg.%SPEECH_ON%Right to the heart, quick and easy. What man could hope for better?%SPEECH_OFF%You nod and tell the commander that you are returning to your employer for your pay. | You watch as %commander% and a troop of soldiers bandy about the battlefield, killing any wounded enemies they discover. %randombrother% asks if we should report to the commander. You shake your head.%SPEECH_ON%No. We report to your employer. To hell with this place, let\'s go get paid.%SPEECH_OFF% | The battlefield is littered with the dead and those who wish they were. %commander%\'s men go about collecting their wounded and killing any enemies they find. The commander himself claps you on the shoulder, a fleck of blood splattering your cheek.%SPEECH_ON%Good work, sellsword. I wasn\'t sure if your men would hold their end of the bargain, but you damn well did. Your employer should be very happy to see you, I believe.%SPEECH_OFF% | You go around gathering the men of the %companyname%. %commander% comes to you, wiping a cloth over a sword, blood washing off in thick gobs.%SPEECH_ON%Leaving so soon?%SPEECH_OFF%You nod.%SPEECH_ON%Your employer is the one who is paying us, so to him we go.%SPEECH_OFF%The commander sheathes his weapon and nods back.%SPEECH_ON%Makes sense. Good fightin\' with you, sellsword. A shame I couldn\'t have you in my outfit. Guess you blokes gotta keep chasing that coin, huh?%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Victory!",
                        function getResult()
                        {
                            local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
                            local settlements = faction.getSettlements();
                            local origin = settlements[this.Math.rand(0, settlements.len() - 1)];
                            local party = faction.spawnEntity(this.World.State.getPlayer().getTile(), origin.getName() + " Company", true, this.Const.World.Spawn.Noble, 150);
                            party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + faction.getBannerString());
                            party.setDescription("Professional soldiers in service to local lords.");
                            this.Contract.setState("Return");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% drunk as a skunk. He stares at you over the lip of a cup and speaks in the bowl of it before drinking.%SPEECH_ON%Ah hell, you\'re back.%SPEECH_OFF%The cup falls away as he swallows. You quickly report of your success. The man smiles although he\'s so drunk he almost looks confused.%SPEECH_ON%Then it is done. Victory is mine. That is what I wanted. I hope too many didn\'t die doing what I wanted.%SPEECH_OFF%He breaks into laughter. One of his guards hands you a satchel and ushers you out of the room. | %employer% welcomes you with a satchel of crowns.%SPEECH_ON%{Victory is ours. Thank you, sellsword. | Hell of a job out there, sellsword. Victory belongs to us and we have, in part, you to thank for that. Your %reward_completion% crowns is right here. | What was it, %reward_completion% crowns? A small price to pay for defeating that army and bringing us one step closer to ending this war. | My little birds told me you did well out there, sellsword. Of course, they also tell me that the army of %feudfamily% is in retreat. What more could I ask for? Your %reward_completion% crowns, as promised.}%SPEECH_OFF% | You find %employer% barking orders at his commanders. Seeing you, he quickly points your way.%SPEECH_ON%See this man right here? He\'s a man that gets things done. Guards! Hand him %reward_completion% crowns. If only I could pay you sorry dogs to do half as good of a job as him!%SPEECH_OFF% | %employer% is found in his garden telling jokes to a group of women. You break into their group, soaked in blood, covered in mud. The women gasp and step away. %employer% laughs.%SPEECH_ON%Ah, the sellsword returns! You\'re such a lady\'s man, mercenary. I wish I could offer one of these fine women to you, but I\'m afraid their fathers would have your nuts if you even so much as touched one.%SPEECH_OFF%One of the ladies runs a hand along her bosom.%SPEECH_ON%He can touch me if he likes.%SPEECH_OFF%%employer% laughs again.%SPEECH_ON%Oh dear, haven\'t you already gotten enough men in trouble? Run along, ladies, and tell one of my guards to fetch a satchel of %reward_completion% crowns.%SPEECH_OFF% | You find %employer% trying to train his cat to shake.%SPEECH_ON%Look at this little bugger. He won\'t even meet my eyes! And when I feed him, he behaves as though it was expected of me. I could punt this little fark out that damn window if I wanted.%SPEECH_OFF%You respond.%SPEECH_ON%It\'d land on its feet.%SPEECH_OFF%The nobleman nods.%SPEECH_ON%That\'s the damnedest part.%SPEECH_OFF%Your employer picks the resilient cat up and throws it out the window. He claps his hands before giving you a satchel of %reward_completion% crowns.%SPEECH_ON%Sorry if I seem preoccupied. You did well out there. %feudfamily%\'s army in retreat and I couldn\'t possibly ask for more these days.%SPEECH_OFF% | You find %employer% having an impromptu trial for one of his commanders. You\'re not sure what it is over, but the commander\'s chin is high and defiant. When it\'s over, he\'s roughed up and taken outside. %employer% beckons you to him.%SPEECH_ON%{Thank you, mercenary. Victory is ours and I\'m not sure that could have been the case without your help. Of course, your reward of %reward_completion% crowns, as agreed upon. | The man refused my orders, it is what it is. You, however, performed exemplarily! Your %reward_completion% crowns, as agreed upon. | That man would not fight for me. Said he wouldn\'t raise a sword against his half-brother who fights for the enemy. What a crock. You did well, sellsword. Your %reward_completion% crowns, as promised.}%SPEECH_OFF% | You return to %employer% who is in the middle of a line of commanders.%SPEECH_ON%{Thank you, mercenary. Victory belongs to us now. Your %reward_completion% crowns, as agreed upon. | The war goes on, but the end is perhaps nigh because of you. With the enemy army in full retreat, we are one step closer to ending this damned thing once and for all. Your %reward_completion% crowns are crowns well-earned, sellsword.}%SPEECH_OFF% | One of %employer%\'s guards stops you from getting close. He carries a satchel of %reward_completion% crowns which are quickly handed over.%SPEECH_ON%My liege tells me that you did well in battle.%SPEECH_OFF%The guard looks around awkwardly.%SPEECH_ON%That... that was all I was supposed to say.%SPEECH_OFF% | %employer% welcomes you into his war room which has been emptied of his commanders.%SPEECH_ON%Good seeing you, sellsword. As I\'m sure you\'re aware, the army of %feudfamily% is already in retreat. Who knows if we could have done it without you. %reward_completion% crowns just for you, as agreed upon.%SPEECH_OFF% | %employer% is feeding a tall, dumb looking bird. You\'ve never seen a bird of that proportion before and so keep your distance. An amused nobleman talks as he lets the creature eat out of his hand.%SPEECH_ON%Nothing to fear here, sellsword. Just so you know, I already have word of your doings. The army of %feudfamily% is in retreat and so we\'re stepping ever closer to ending this damned war. That guard yonder, the one holding the satchel, has your %reward_completion% crowns.%SPEECH_OFF%The bird flaps its wings and squawks as you leave. | You find %employer% hanging out at a man-made pond. He\'s scooping up frogs with a gentle hand. The slimy critters squirm and jump away.%SPEECH_ON%Victory belongs to us. I\'d say that is a job well done, sellsword. I gave you a huge opportunity and you really... jumped, on it.%SPEECH_OFF%You must have visibly cringed for the nobleman quickly gets to his feet, wiping his hands on his pants.%SPEECH_ON%Hell, that wasn\'t so bad, was it? Well, the guard yonder has your payment of %reward_completion% crowns.%SPEECH_OFF%}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Won an important battle");
                            this.World.Contracts.finishActiveContract();

                            if (this.World.FactionManager.isCivilWar())
                            {
                                this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
                            }

                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
                    });
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/confront_warlord_contract", function(o){

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_45.png[/img]{You find %employer% walking through his stables. He runs his hand along the side of one.%SPEECH_ON%Did you know that an orc can break this creature\'s neck through sheer brute strength? I\'ve seen it. I know, because it was my horse that died, its head turned backwards on account of one very angry greenskin.%SPEECH_OFF%Reminiscing is fine and good, but that\'s not why you\'re here. You subtly ask the nobleman to get to the point. He obliges.%SPEECH_ON%Right. The war with the greenskins isn\'t going as well as we\'d like, so I\'ve come to the conclusion that we must kill one of their warlords. Let me be honest with you: an orc that is physically superior to all its shite little brothers is a nightmare in flesh and blood. Best bet to draw him out is to kill as many of his greenskin brothers as you can. I know that sounds rough, but once this is all said and done our odds of winning this damned war will be vastly improved.%SPEECH_OFF% | %employer% welcomes you into his room. He\'s looking rather concernedly at a map.%SPEECH_ON%{My scouts have made reports of a warlord in the area, but we\'re not entirely sure where he is. I have a hunch that if you go out there and cause a lot of problems for these green bastards he just might come out and play. Understand? | We\'ve had reports coming in of an orc warlord roaming the lands. I believe if we can kill him, orc morale will drop and we might just win this damned war yet. Of course, he won\'t be easy to find. You\'ll have to get that big bastard to show himself and I believe the best way to do that is speaking the orcish tongue: killing as much as you can. Of course, kill the greenskins. Don\'t just be indiscriminate about this. | Glad you\'ve come, sellsword, because boy do I have a task for you. We\'ve gotten word that an orc warlord is in the region, but we know not where he is. I want you to go and practice a little bit of orcish diplomacy: kill as many of those green savages as you can and that warlord will for sure make himself known to you. If we can get him out of the picture, this war will be looking a hell of a lot prettier for our side.}%SPEECH_OFF% | %employer% is surrounded by his lieutenants and a very tired looking kid with muddied boots and a sweat slaked face. One of the commanders steps forward and takes you to a side.%SPEECH_ON%We\'ve gotten news of an orc warlord. That kid\'s family paid the price of seeing it with their own eyes. %employer% believes, and I concur with the lord, that if we can kill as many greenskins as possible that we might get this warlord to show himself.%SPEECH_OFF%You lean back and respond.%SPEECH_ON%And lemme guess, you want me to take its head?%SPEECH_OFF%The commander shrugs.%SPEECH_ON%It\'s not so much to ask, is it? My liege is willing to pay a lot of crowns for this job.%SPEECH_OFF% | %employer% sits amongst a pack of conked out dogs. There are pheasant feathers in their maws, fluttering between snoring breaths. The lord waves you in.%SPEECH_ON%Come on in, sellsword. Just got done with a hunt. Coincidentally, I need to send you on one.%SPEECH_OFF%You take a seat. One of the dogs raises its head, huffs, then lowers it back to sleep. You ask what the nobleman wants. He quickly explains while rubbing one of the mutt\'s ears.%SPEECH_ON%I\'ve gotten word that an orc warlord is on the prowl. Where at? I\'ve no idea. But I think you can flush him out. You know just how, right?%SPEECH_OFF%You nod and respond.%SPEECH_ON%Yeah. You keep killing its soldiers until it gets pissed enough to come out and fight you personally. But this is not a cheap request by any means, %employer%.%SPEECH_OFF%The nobleman grins and opens and his hands as if to say, \'let\'s talk business.\' His dog looks up as if to say \'only if that business means you keep scratching my ears.\' | %employer% sits behind a long desk with an even longer map draped over both its ends. One of his scribes whispers into his ear then hurries to you.%SPEECH_ON%My liege has a request. We believe an orc warlord is in the region and, naturally, we want this savage put down. To do this, we...%SPEECH_OFF%You raise your hand and interrupt.%SPEECH_ON%Yeah, I know how to draw it out. We kill as many of these son of a bitches as we can until the big angry green fella comes our way.%SPEECH_OFF%The scribe smiles warmly.%SPEECH_ON%Oh, so you\'ve read the books on this tactic, too? That\'s great!%SPEECH_OFF%Your eyes dim ever so gracefully, but you move on and start asking about the potential pay. | %employer% meets you in his study. He\'s pulling books off the shelves, great plumes of dust trailing after every withdrawal.%SPEECH_ON%Come, have a seat.%SPEECH_OFF%You do and he brings over one of the tomes. He opens it to a page and points at a garish image of an enormous orc.%SPEECH_ON%You know these, yes?%SPEECH_OFF%You nod. It\'s a warlord, the head of an orcish band and the cog around which a whirlwind of violence sputters about the world. The nobleman nods back and continues.%SPEECH_ON%I\'m doing a little bit of research on them as my scouts have brought me sightings of one. Of course, we can never fully keep track of this damned thing. It goes where it pleases, and wherever it goes, it destroys.%SPEECH_OFF%You stop the nobleman and explain to him a simple strategy: if you kill enough of the greenskins, the warlord will take offense, or perhaps be emboldened by the challenge, no one really knows, and it will come out to fight. %employer% smiles.%SPEECH_ON%You see, sellsword, this is why I like you. You know your shite. Of course, I think it\'s safe to assume this sort of thing isn\'t easy to do. The pay for it will be more than up to par.%SPEECH_OFF% | %employer% is poring over a mound of scrolls his scribe is bringing in. He keeps shaking his head.%SPEECH_ON%None of these say how we find it! If we can\'t reliably find it, how can we reliably kill it? This is simple math! I thought you knew math!%SPEECH_OFF%The scribe ducks away, sniffling and staring at the floor as he hurries out of the room. You ask what the problem is. %employer% sighs and states that an orc warlord is in the region but they know not how to stop it. You laugh and answer.%SPEECH_ON%That\'s easy: you speak their language. You kill as many of those bastards as you can until that warlord is forced to come out and see you personally. Orcs love violence, they are born into it and probably even bred by it. Of course, actually killing the warlord isn\'t particularly easy...%SPEECH_OFF%%employer% leans forward and tents his fingers.%SPEECH_ON%Yes, of course not, but you do sound like the man for the job. And this job could truly swing this damned war in our favor. Let\'s talk business.%SPEECH_OFF% | You find %employer% stalking through his garden. He seems particularly taken to the plant stalks.%SPEECH_ON%It\'s odd, isn\'t it? Here we have these things which are so green, yet those greenskin bastards are green, too, and I don\'t think they\'ve eaten a goddam vegetable in all their lives.%SPEECH_OFF%You want to say this is a pretty stupid observation, but hold your tongue. Instead, you ask what\'s the issue with the greenskins as that does seem to be the implied problem. %employer% nods.%SPEECH_ON%Right, of course. My scouts have spotted a warlord in the region. The problem is, we don\'t know where it is or where it goes. The scouts can\'t really stick with it for long or else they\'ll get killed for hopefully obvious reasons. I believe killing this warlord would help move us one step closer to ending this damned war, but I\'ve not a clue on how to do this, do you?%SPEECH_OFF%You nod and respond.%SPEECH_ON%What has you wanting to kill the warlord, the fact he\'s killing your people, right? So what would get him to personally want to kill us? You kill as many of his bastards as you can.%SPEECH_OFF%The nobleman claps and tosses you a bright red tomato.%SPEECH_ON%That right there is good thinking, mercenary. Let\'s talk business!%SPEECH_OFF% | You find %employer% and his commanders standing around a map. They pivot toward you as you enter the room like a bunch of hawks spotting a rabbit. The nobleman welcomes you in.%SPEECH_ON%Hello there, sellsword, we\'re a little on edge. Our scouts have reported an orc warlord is roaming the region as we speak. The problem is we\'re not entirely sure where it\'s going or how to find it. My commanders believe if we kill as many greenskins as possible, the warlord will show itself and then we can kill it. Do you think you\'re up to this task? If so, let\'s talk business.%SPEECH_OFF% | You step into %employer%\'s room to find him consulting with a group of scribes. They\'re visibly shaking, pinching their beady necklaces and squirming around. One of them points at you.%SPEECH_ON%Perhaps he has an idea?%SPEECH_OFF%The others scoff, but you ask what the problem is. %employer% explains that there is an orc warlord roaming the lands, but they\'re having issues tracking it. You nod dutifully then explain a very simple solution.%SPEECH_ON%Kill as many greenskins as you can and the warlord, but the prideful nature of the beast, will come out to fight you. Or, in this case, come out to fight... me?%SPEECH_OFF%%employer% nods.%SPEECH_ON%You\'ve got a good head on your shoulders, sellsword. Let\'s talk business.%SPEECH_OFF% | %employer% stands with his commanders over some maps.%SPEECH_ON%We\'ve got a hell of a task for you, sellsword. Our scouts have spotted a warlord roaming the region and we need you to kill as many greenskins as you can to draw it out of the woodwork. If we can take that warlord\'s head, we\'ll be much closer to ending this damned war.%SPEECH_OFF% | When you enter %employer%\'s room, he asks if you know anything about hunting orc warlords. You shrug and answer.%SPEECH_ON%They respond to the language of violence. So if you want to talk to one, you gotta kill a lot of its fellow orcs. That\'s the one way to get it to come out and play, so to speak.%SPEECH_OFF%The nobleman nods, understandingly. He slides a paper across his desk.%SPEECH_ON%Then I might have something for you. We\'ve become aware of an orc warlord in our region, but are having a hard time tracking it down. I want you to draw it out and kill it. If we can manage this, our odds of winning this war against those green savages will increase ten fold!%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{I trust you\'ll pay amply for this. | Everything can be done, if the pay is right. | Convince me with jingling coin.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{This isn\'t worth it. | We\'re needed elsewhere.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "ClosingIn",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_46.png[/img]{A cairn of humanly skulls freshly removed. %randombrother% stares at the totem of anguished faces and shakes his own head.%SPEECH_ON%You suppose they consider this art? Like did one of them savages take a step back and said, Yeah, that looks good.%SPEECH_OFF%You\'re not sure. You very much hope that humans are not the brush and canvas for the greenskins. | You come across a field of slaughtered farm animals. Entrails have been run down the farm\'s corrugated soils like some sanguinary irrigation. Either a farmer horribly misread the weather, or this is a sure sign of the orcs being close. | Dead bodies. Some cleaved in twain, others rather peaceful with but a few darts pocking their backs. Both forms of finality are a sure sign of greenskins being close. | You come to an abandoned greenskin encampment. There\'s a goblin with its head crushed. Perhaps it got into a fight with a much larger, stronger orc. Some ghastly shape is sitting over a spit. You just hope it\'s not what you think it is. %randombrother% points at the embers crackling beneath the meal.%SPEECH_ON%This is fresh. They aren\'t far off, sir.%SPEECH_OFF% | You come to a barn with its doors creaking open and shut in a pungent wind. %randombrother% peaks inside, then quickly bolts back with a hand to his nose.%SPEECH_ON%Yeah, the greenskins have been here.%SPEECH_OFF%Sparing yourself a look into the barn, you tell the men to prepare for a battle because it is surely coming. | You find a dead orc with a dead goblin splayed across its back. Pushing both bodies over, you find a dead farmer beneath. %randombrother% nods.%SPEECH_ON%Well, he gave a hell of a fight. A shame we couldn\'t have gotten here sooner.%SPEECH_OFF%You point to a running of fresh tracks in the mud.%SPEECH_ON%He was outnumbered and the rest of them aren\'t far off. Tell the men to prepare for battle.%SPEECH_OFF% | You come across a man wrapped in heavy chains and, apparently, squeezed to death by them. His purpled and crushed body chinks and chimes as the chains swing and twist. %randombrother% cuts the body down. The corpse spews dark blood from its mouth and the sellsword jumps away.%SPEECH_ON%Hell, this guy\'s fresh! Whoever did this ain\'t far off!%SPEECH_OFF%You point at tracks in the mud and tell him this is no doubt the work of greenskins and, indeed, they are very close by. | You find a bag made of flesh in the road. Inside it are human ears, tanned and stiff with holes to run keychains through. %randombrother% gags. You inform the men that the greenskins aren\'t far off. No doubt a battle is coming! | You come across the remains of a hovel. Embers crackle in the blackened remains. %randombrother% finds a couple of skeletons, noting that they are missing half their bodies. Seeing some deep tracks in the ashen mud, you inform the men to ready themselves as greenskins are no doubt close by. | You find a man sobbing by the road. He\'s sitting cross-legged, body bobbing forward and back. When you get near, he twists his head around, eyeless and noseless and with the lips cut away.%SPEECH_ON%No more! Please, no more!%SPEECH_OFF%He falls to his side and starts convulsing and then he is still. %randombrother% pokes around the body then stands up, shaking his head.%SPEECH_ON%Greenskins?%SPEECH_OFF%You point at the deep tracks in the mud and nod. | You come across a woman wailing over a corpse. She is dripping blood and gore, and the body beneath her knees has had its head completely caved in. You crouch beside her. She glances at you and moans. You ask who or what did this. The woman clears her throat and answers.%SPEECH_ON%Greenskins. Big ones. Small ones. They laughed as they did it. Their clubs went up, down, over and over, and in between they would not stop laughing.%SPEECH_OFF% | You find a horse dead beside the path with its stomach turned out into the trail. Its rib cage is still pouring a fresh drip. %randombrother% notes that the heart, liver, and other gourmet segments are missing. You point at big and small footprints tracking blood further up the path.%SPEECH_ON%Goblins and orcs.%SPEECH_OFF%And they\'re not far off. You order the %companyname% properly prepare itself for a fight.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Be on your guard!",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "MadeADent",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_81.png[/img]{With this many greenskins dead, it seems only a matter of time until their warlord comes out to play. | You\'ve left a trail of dead greenskins. Their warlord will catch wind of you real soon. | The greenskins\' warlord is surely hearing stories of its warriors being cut down by now. He\'s no doubt getting a scent of you. | If you were the greenskins\' warlord, you\'d probably be readying to hunt down the bastard cutting down your troops. Keep these killings up and you\'ll no doubt see how similarly you and that savage think. | A savage understands violence, and you\'ve surely left a trail of gory teachings all over the region. If the warlord is a learning creature, it\'ll no doubt be heading for you real soon. | By more wrathful estimations, the orc warlord is for sure angered as fark against some wayward human making a mess of his plans. You should expect that savage sooner or later. Most likely the former. | With this many orc and goblin killings, it is only a matter of time until their head master personally comes after you. | If orcs speak the language of violence, then you\'ve been penning a real love letter up and down the region. Surely the orc warlord will be in a requiting mood. | If violence is the orcish language for love, then you\'ve been standing in their warlord\'s yard throwing a lot of rocks through the window trying to get its attention. But, instead of rocks, it\'s the limbs and heads of its soldiers. That brute will be sure to respond any day now. | You\'ve left a long trail of dead greenskins no doubt sure to attract the attention of their warlord. | Business is good for the buzzards: you\'ve cut a path of dead greenskins and it seems likely that, any day now, their warlord will come and see for himself what you are up to. | Killing greenskins like you\'ve been doing is a surefire way to get an orc warlord\'s attention - and that heat is rising. | If things keep going according to plan, that is to say the unimpeded slaughter of green savages, then surely it is only a matter of time until an orc warlord comes to see you personally. | A stampede could hardly make more noise than you have this past week. If you keep it up with slaying greenskins left and right, it is but a matter of time until their warlord shows up. | You have a feeling that somewhere in this region is a very, very mad orc warlord staring at a crude drawing of your face. | You like to think you\'ve generated \'wanted\' posters of yourself within the greenskin circles. A stick figure of a man with a price beneath it. Wanted Dead or Very Dead. Problem is you\'ll keep killing all who come your way until the orc warlord himself makes an appearance - and you got the feeling that will be happening real soon. | Surely by now the greenskins are sharing stories of you around their campfires. Some damned human terrorizing their ranks. And you\'ve little doubt an orc warlord would hear those stories and feel compelled to see for himself if what they say are true... | Keep killing greenskins like this and their warlord will be sure to come around. | You\'re treading dangerous waters now. With this many greenskins slain, the orc warlord is sure to be coming sooner or later. | You\'ve got a strong inclination that the orc warlord is going to be coming around real soon. Might have something to do with you killing all his soldiers. Just a hunch. | You\'ve killed little greenskins and big greenskins. Now, it\'s time to kill the biggest of them all: a warlord. That savage has gotta be footing around here somewhere... | You\'ve made war on the greenskins and for that their warlord is sure to appear sooner or later. | Greenskins dying left and right. At some point their warlord is going to realize that it ain\'t because of natural causes. Once he figures it out, he\'ll be coming for you double time.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "{Victory! | Damn greenskins.}",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "FinalConfrontation1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_81.png[/img]{You\'re hearing a lot of rumors from countryfolk that an orcish warlord is amassing his soldiers and heading your way. If these rumors are true, you should prepare as best you can. | Well, there\'s a lot of buzz about an orc warlord marching through the region. It just so happens to be heading your way - which makes you think your plan has worked! The %companyname% should prepare itself for one hell of a fight. | Word has it that the orc warlord is heading your way! Prepare the %companyname% as they are in for one hell of a fight! | Every peasant you pass seems to be carrying the same rumor: there\'s an orc warlord coming your way! This is most likely not a coincidence and the %companyname% should prepare itself accordingly. | Well, the news on the wind is that that the %companyname% is the target of an orc warlord marching with a small army. It appears your plan has worked. The company should prepare for the incredible battle coming its way! | It seems that every peasant you pass has a story to tell and they\'re all the same: an orc warlord has amassed a small army and just coincidentally happens to be heading your way. The %companyname% should prepare itself for a hell of a fight! | A little old lady comes rushing to you. She explains that everyone is talking about an orc warlord that is heading your way. You\'re not sure if it\'s true, but given your purpose these past days it is certainly far too coincidental. The %companyname% should prepare for battle. | Well, the %companyname% should prepare itself or a battle. Everybody you pass is telling you the same story: an orc warlord has amassed a small army and is heading your way! | It appears the killings have worked: news has it that an orc warlord and his army is heading your way to take care of the company personally. The %companyname% should prepare itself for a fight! | A small kid approaches you. He glances at the %companyname%\'s sigil and then at you. He smiles.%SPEECH_ON%I think y\'all need help.%SPEECH_OFF%That might be true, but it sounds strange coming from the kid. You ask him why and he responds.%SPEECH_ON%My father said a big mean orc is going to kill you all. He said traders have been talking about it allllllll day!%SPEECH_OFF%Hmmm, if true it means the strategy has paid off and the %companyname% should prepare for battle. You thank the kid. He shrugs.%SPEECH_ON%I just saved your life and all I get is a thanks? You people!%SPEECH_OFF%The kid spits and walks off kicking rocks.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We need to be ready for this.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local playerTile = this.World.State.getPlayer().getTile();
                    local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
                    local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
                    local party = this.World.FactionManager.getFaction(nearest_orcs.getFaction()).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    party.getSprite("banner").setBrush(nearest_orcs.getBanner());
                    party.getSprite("body").setBrush("figure_orc_05");
                    party.setDescription("A horde of greenskins led by a fearsome orc warlord.");
                    party.setFootprintType(this.Const.World.FootprintsType.Orcs);
                    this.Contract.m.UnitsSpawned.push(party);
                    local hasWarlord = false;

                    foreach( t in party.getTroops() )
                    {
                        if (t.ID == this.Const.EntityType.OrcWarlord)
                        {
                            hasWarlord = true;
                            break;
                        }
                    }

                    if (!hasWarlord)
                    {
                        this.Const.World.Common.addTroop(party, {
                            Type = this.Const.World.Spawn.Troops.OrcWarlord
                        }, false);
                    }

                    party.getLoot().ArmorParts = this.Math.rand(0, 35);
                    party.getLoot().Ammo = this.Math.rand(0, 10);
                    party.addToInventory("supplies/strange_meat_item");
                    party.addToInventory("supplies/strange_meat_item");
                    party.addToInventory("supplies/strange_meat_item");
                    party.addToInventory("supplies/strange_meat_item");
                    this.Contract.m.Destination = this.WeakTableRef(party);
                    party.setAttackableByAI(false);
                    local c = party.getController();
                    c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
                    local intercept = this.new("scripts/ai/world/orders/intercept_order");
                    intercept.setTarget(this.World.State.getPlayer());
                    c.addOrder(intercept);
                    this.Contract.setState("Running_Warlord");
                }

            });
            this.m.Screens.push({
                ID = "FinalConfrontation2",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_49.png[/img]{The warlord is at the head of a group of orcs and goblins. He stands tall among the already enormous warriors which surround him. You order your men to take battle lines and no sooner do the words leave your lips does the warlord roar and his warriors come running toward you! | A large formation of orcs and goblins stand before you, their warlord standing at the front. He steps forward and heaves a knapsack toward you. It unfurls midair and opens upon hitting the ground. A dozen heads roll forth like mere marbles from a kid\'s playbag. The warlord raises its weapon high and roars. As the greenskins come your way, you quickly order the %companyname% into formation. | The %companyname% stands before a massed array of greenskins: orcs, goblins, and their warlord, a beastly creature that seems ungainly even among the ranks of its own kind. The enormous warrior raises its weapon and roars, flying birds out of trees and sending critters scuttling into holes.\n\nAs the greenskins begin to charge, you shout to your men to fall into formation and remember who they are: the %companyname%! | You and the %companyname% finally come to stand before the warlord and its army of orcs and goblins. This seems the occasion or a speech, but before you can even say a word the brutish savages start charging! | Finally, the forces of man and beast square off. Across from the %companyname% are a small army of orcs and goblins, a brutish warlord standing at their head. You take out your sword and the warlord raises its weapon. If only for a moment, there is an understanding that it is warriors and only warriors who are going to die today. | The orc warlord and its army are charging! You tell the %companyname% that this is what they\'ve trained and prepared for.%SPEECH_ON%We wouldn\'t be here lest we wanted it!%SPEECH_OFF%The men roar and unsheathe their blades and fall into formation. | As a horde of goblins and orcs charge across the battlefield, an enormous warlord at their head, you tell the men to fear not.%SPEECH_ON%We will have much to celebrate tonight, men!%SPEECH_OFF%They unsheathe their weapons and roar, a deafening scream that echoes back upon the greenskins who look, for the first time, momentarily surprised. | %randombrother% comes to you, pointing out a small army of orcs and goblins charging your way, a warlord at their head.%SPEECH_ON%Not to point out the obvious, but the geenskins are here.%SPEECH_OFF%You nod and shout to your men.%SPEECH_ON%Who else is here?%SPEECH_OFF%The men draw out their weapons.%SPEECH_ON%The %companyname%!%SPEECH_OFF% | You and %randombrother% watch as an orc warlord charges your way, a small army of orcs and goblins behind it. The mercenary laughs.%SPEECH_ON%Well, here they come.%SPEECH_OFF%Nodding, you address the men.%SPEECH_ON%They charge because they are afraid. Because they have no ground to stand on. But we do, because we make our stand right here!%SPEECH_OFF%You plant a banner of the %companyname% into the ground. The sigil waves in the wind as the men roar to life. | You watch as the greenskins charge forward with their warlord leading the way. Drawing out your sword, you yell at the men.%SPEECH_ON%A good night\'s to any man who takes a savage\'s head. Who sleeps well tonight?%SPEECH_OFF%Metals rattle as the men draw their weapons and shout.%SPEECH_ON%The %companyname%!%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onCombatWithWarlord(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "FinalConfrontation3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_81.png[/img]{The warlord is right where he should be: dead on the ground. You watch as the rest of the greenskins take for the hills. Your employer, %employer%, will be most pleased with the work the %companyname% has put in this day. | The %companyname% has triumphed this day! The orc warlord is dead in the mud and his army scattered to the hills. This is a result your employer, %employer%, will be most pleased with. | Your employer, %employer%, paid for the best and got just that: the orc warlord is dead and its roaming band of savages has fled. With no leader, there\'s little doubt the beasts will scatter and die off on their own. You should go back to the nobleman for your pay. | You have stamped out the greenskins, killing their warlord and sending them running for the hills. Your employer, %employer%, will be most pleased with the %companyname%. | The orc warlord is dead and with no head, the snake of the greenskin gang will shrivel and die. Your employer, %employer%, will be most pleased by this news. | The orc warlord is dead. It looks surprisingly at peace given the amount of terror and chaos it put on this earth. %randombrother% comes up, laughing.%SPEECH_ON%It\'s big, but it dies. I feel like people always forget that last part.%SPEECH_OFF%You nod and tell the men to prepare a return to %employer% at %townname%. | The warlord is dead at your feet, right where he should be. The %companyname% has earned its payday from %employer%. All that\'s left is to return to the nobleman and give him the news. | %employer% probably didn\'t believe in you. He probably didn\'t foresee this moment where you, a mercenary captain, stands over a dead orc warlord. But that\'s where you are this day, because the %companyname% is not to be trifled with. Time to go back to that nobleman and get your payday. | The orc warlord is dead and its army scattered. You take a look around and yell to your men.%SPEECH_ON%Men, my friend wants to kill his worst enemy, who should he call upon?%SPEECH_OFF%They raise their fists.%SPEECH_ON%The %companyname%!%SPEECH_OFF%You laugh and continue.%SPEECH_ON%An old woman wants us to kill all the rats in her attic, who should she call upon?%SPEECH_OFF%The men, quieter this time.%SPEECH_ON%The %companyname%?%SPEECH_OFF%You grin widely and continue.%SPEECH_ON%If a dainty man is scared of a spider on his wall, who should he call upon?%SPEECH_OFF%%randombrother% spits.%SPEECH_ON%Let\'s just get back to %townname% and %employer% already!%SPEECH_OFF% | You watch as the greenskins scatter like rats. %randombrother% looks ready to give chase, but you stop him.%SPEECH_ON%Let them run.%SPEECH_OFF%The mercenary shakes his head.%SPEECH_ON%But they\'ll speak of us! They know who we are.%SPEECH_OFF%You grin widely and clap the man on the shoulder.%SPEECH_ON%Exactly. C\'mon, let\'s head on back to %townname% and %employer%.%SPEECH_OFF% | You walk through the mounds of the dead, coming to stand before the slain orc warlord. The flies are already upon him. %randombrother% stands beside you, looking down at the beast.%SPEECH_ON%He wasn\'t so bad. I mean, okay, yeah he was pretty scary. A little on the gonna give me nightmares side of things, but all in all, not too bad.%SPEECH_OFF%You smile and clap the man on the shoulder.%SPEECH_ON%I hope one day you\'ll be able to scare you grandchildren with stories of it.%SPEECH_OFF% | The battlefield has settled. The dead are in the places they spent their whole lives getting to. The greenskins are out running for the hills. And the %companyname% is cheering in victory. %employer% will be most pleased with this series of events. | The %companyname% stands triumphant over the greenskin savages. You look down upon the orc warlord, taking into consideration that a lot of things had to die just so... it could die. A strange world with strange rules, but this is simply how it is.\n\n%employer% will be pleased and paying you a lot - and the world of the coin is the world you understand best. | You and %randombrother% look at the orc warlord\'s corpse. Flies are already busying themselves on its tongue, farking one another and spreading their plague. The mercenary looks at you and laughs.%SPEECH_ON%Is that the end you see for yourself, a bunch of insects doing the business on your goddam face?%SPEECH_OFF%You shrug and answer.%SPEECH_ON%It\'s a long ways away from dying while wrapped in a blanket and surrounded by family, that\'s for sure.%SPEECH_OFF%You slap the sellsword on the chest.%SPEECH_ON%C\'mon, enough of that talk. Let\'s get back to %employer% and get our pay.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "{The %companyname% prevailed! | Victory!}",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.setState("Return");
                }

            });
            this.m.Screens.push({
                ID = "Berserkers1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_93.png[/img]While on the path, %randombrother% suddenly straightens up and tells everyone to get quiet. You crouch low and crabwalk to him. He points through some bushes.%SPEECH_ON%There. Trouble. Big, fat trouble.%SPEECH_OFF%You stare through the bushes to see a camp of orc berserkers. They\'ve got a small fire going with a spit of spinning meat. Nearby are a cluster of cages, each one holding a whining dog. You watch as one of the greenskins opens a cage and yanks a dog out. He drags it kicking and screaming toward the fire and holds it over the flames.\n\n The mercenary glances at you.%SPEECH_ON%What should we do, sir?%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'re at war and every battle counts. To arms!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
                            p.CombatID = "Berserkers";
                            p.Music = this.Const.Music.OrcsTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.BerserkersOnly, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    },
                    {
                        Text = "This isn\'t our fight.",
                        function getResult()
                        {
                            return "Berserkers2";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Berserkers2",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_93.png[/img]This isn\'t your fight nor would it ever be. You have the men swing around the encampment, quietly avoiding what could very easily be a devastating fight with a group of berserkers. The howls of dogs seem to chase you away and linger with a few of the men long after you\'ve left the place.",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Keep your heads on straight, men.",
                        function getResult()
                        {
                            this.Flags.set("IsBerserkers", false);
                            this.Flags.set("IsBerserkersDone", false);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local brothers = this.World.getPlayerRoster().getAll();

                    foreach( bro in brothers )
                    {
                        if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.legend_muladi")
                        {
                            bro.worsenMood(1.0, "You didn\'t help wardogs being eaten by orcs");

                            if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
            this.m.Screens.push({
                ID = "Berserkers3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_32.png[/img]The fight over, you take a good look around the berserkers\' encampment. Each of the cages is home to a shriveled, cornered dog. When you open one of the cages, the dog sprints out, yelping and yapping as it darts over the hills and is gone, just like that. Most of the other mutts follow suit. Two, however, remain. They follow you around as you inspect the rest of the encampment. %randombrother% notes that they\'re war dogs.%SPEECH_ON%Look at the size of \'em. Big, burly, nasty farks. Their owners must\'ve been killed by the orcs and now, well, they\'ve reason to trust us. Welcome to the company, little buddies.%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Good work, men.",
                        function getResult()
                        {
                            this.Flags.set("IsBerserkers", false);
                            this.Flags.set("IsBerserkersDone", false);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local item = this.new("scripts/items/accessory/wardog_item");
                    this.World.Assets.getStash().add(item);
                    this.List.push({
                        id = 10,
                        icon = "ui/items/" + item.getIcon(),
                        text = "You gain " + item.getName()
                    });
                    item = this.new("scripts/items/accessory/wardog_item");
                    this.World.Assets.getStash().add(item);
                    this.List.push({
                        id = 10,
                        icon = "ui/items/" + item.getIcon(),
                        text = "You gain " + item.getName()
                    });
                }

            });
            this.m.Screens.push({
                ID = "Berserkers4",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_32.png[/img]With the last of the berserkers slain, you start in on their camp. You find the burnt bones of dogs strewn about the campfire. The meat has been picked clean and a collection of heads was teetering like some sickly cairn. %randombrother% goes about opening the cages. All the dogs, the very second they have a gap, sprint out and run away. The mercenary manages to snag one, but it yelps and goes limp, dying from sheer panic and fear. The rest of the camp has nothing of value aside from disappointment and piles of orc shite.",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We still did good here.",
                        function getResult()
                        {
                            this.Flags.set("IsBerserkers", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% talking to his generals. He turns to you with a smile and arms open.%SPEECH_ON%Well, you did it, sellsword. I gotta admit, I didn\'t think you could. Funny business, killing orcs.%SPEECH_OFF%It wasn\'t especially funny, but you nod anyway. The nobleman goes and gets a satchel of %reward_completion% crowns and hands it to you personally.%SPEECH_ON%Job well done.%SPEECH_OFF% | %employer% is found in bed with a few women. His guard stands at the door, shrugging with a \'you said let him in\' look on his face. The nobleman waves at you.%SPEECH_ON%I\'m a bit busy, but I understand that you have been successful in all your... ehem, endeavors.%SPEECH_OFF%He snaps his fingers and one of the women slides out of the blankets. She daintily crosses the cold stone floor to pick up a satchel and carry it over to you. %employer% speaks again.%SPEECH_ON%%reward_completion% crowns, was it? I think that\'s some pretty pay for what you have done. I hear killing an orc warlord isn\'t exactly easy business.%SPEECH_OFF%The woman stares deep into your eyes as she hands the money over.%SPEECH_ON%You killed an orc warlord? That\'s so brave...%SPEECH_OFF%You nod and the lithe lady twists on her toes. The nobleman snaps his fingers again and she returns to his bed.%SPEECH_ON%Careful, mercenary.%SPEECH_OFF% | A guard takes you to a gardening %employer%. He snips at the vegetables and drops them into a basket held by a servant.%SPEECH_ON%Judging by your not being dead, my deductive skills tells me you were successful in killing the orc warlord.%SPEECH_OFF%You respond.%SPEECH_ON%It wasn\'t easy.%SPEECH_OFF%The nobleman nods, staring at the dirt, then continues clipping off a series of tomatoes.%SPEECH_ON%The guard standing yonder will have your pay. %reward_completion% crowns as we agreed upon. I\'m very busy right now, but you should know that I and the people of this town owe you a lot.%SPEECH_OFF%And by \'a lot\' he just means %reward_completion% crowns, apparently. | %employer% welcomes you into his room.%SPEECH_ON%My little birds have been chirping a lot these days, telling me stories of a sellsword that slew an orc warlord and scattered his army. And I thought to myself, hey, I think I know that guy.%SPEECH_OFF%The nobleman grins and hands over a satchel of %reward_completion% crowns.%SPEECH_ON%Good work, mercenary.%SPEECH_OFF% | %employer% greets you with a satchel of %reward_completion% crowns.%SPEECH_ON%My spies have already told me everything I need to know. You are the man to trust, sellsword.%SPEECH_OFF% | When you enter %employer%\'s room you find the nobleman listening to the whispers of one of his scribes. Seeing you, the man bolts upright.%SPEECH_ON%Speak of the devil and he will come. You are the talk of the town, sellsword. Killing an orc warlord and scattering its army? Well, I\'d say that\'s worth the %reward_completion% crowns we agreed upon.%SPEECH_OFF% | %employer% is staring dutifully at a map.%SPEECH_ON%I\'m gonna have to redraw some of this thank to you - and I mean that in the good way. Killing that orc warlord will allow us to rebuild from the ashes it had sown over these lands.%SPEECH_OFF%You nod, but subtly ask about the pay. The nobleman smiles.%SPEECH_ON%%reward_completion% crowns, was it? Also, you should at least take a moment to let the accolades come in, sellsword. The money isn\'t going nowhere, but the pride you feel now will one day fade.%SPEECH_OFF%You disagree. That money is going to fade its way into a pint of good mead. | %employer% is pacing his room while generals stand by the wayside in almost dutiful silence. You ask what the problem is and the man bolts upright.%SPEECH_ON%By the old gods on a fly\'s ass, I didn\'t think you\'d make it.%SPEECH_OFF%You ignore that soaring vote of confidence and inform the nobleman of all that you\'ve done. He nods repeatedly then takes out a satchel of %reward_completion% crowns and hands it over.%SPEECH_ON%That is a job well done, mercenary. Well damn done!%SPEECH_OFF% | You find %employer% watching a servant chop wood. Seeing your shadow, the nobleman wheels around.%SPEECH_ON%Ah, the man of the hour! I\'ve already heard so much of what you\'ve done. We\'re actually having a celebration - gotta prep the firewood for cooking and nighttime festivities. I\'d invite you, but this is for the highborn only, I\'m sure you understand.%SPEECH_OFF%You shrug and respond.%SPEECH_ON%I\'d understand a lot better if I had the %reward_completion% crowns we agreed upon.%SPEECH_OFF%%employer% laughs and snaps his fingers to a guard who promptly brings your pay over. | %employer% is found talking to the captain of another mercenary band. He\'s a frail leader, probably just getting his start. But upon seeing you, the nobleman quickly dismisses him and welcomes you.%SPEECH_ON%Ah hell, it is good seeing you, mercenary! Things were about to get a little desperate around here.%SPEECH_OFF%You remark that the captain you just saw would be most unfit to handle any job, much less that of hunting an orc warlord. The nobleman hands you a satchel of %reward_completion% crowns and responds.%SPEECH_ON%Look, let\'s just agree that you\'ve done good this day. We can finally start rebuilding what that damned orc savage destroyed and that\'s what matters.%SPEECH_OFF%The crowns in your hand are what matters, but you agree to no longer dawdle on the point.}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Killed a renowned orc warlord");
                            this.World.Contracts.finishActiveContract();

                            if (this.World.FactionManager.isGreenskinInvasion())
                            {
                                this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
                            }

                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
                    });
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/defend_holy_site_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Move to %holysite% and defend it against southern heathens"
                    ];

                    if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
                    {
                        this.Contract.setScreen("Intro");
                    }
                    else
                    {
                        this.Contract.setScreen("Task");
                    }
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    local r = this.Math.rand(1, 100);

                    if (r <= 25)
                    {
                        this.Flags.set("IsQuartermaster", true);
                    }

                    local r = this.Math.rand(1, 100);

                    if (r <= 30)
                    {
                        this.Flags.set("IsSallyForth", true);
                    }
                    else if (r <= 60)
                    {
                        this.Flags.set("IsAlliedSoldiers", true);
                    }

                    local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

                    foreach( c in cityStates )
                    {
                        c.addPlayerRelation(-99.0, "Took sides in the war");
                    }

                    this.Contract.m.Destination.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

                    if (this.Contract.getDifficultyMult() >= 0.95)
                    {
                        local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];
                        local party = cityState.spawnEntity(this.Contract.m.Destination.getTile(), "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                        party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
                        party.setDescription("Conscripted soldiers loyal to their city state.");
                        party.getLoot().Money = this.Math.rand(100, 300);
                        party.getLoot().ArmorParts = this.Math.rand(10, 35);
                        party.getLoot().Medicine = this.Math.rand(5, 15);
                        party.getLoot().Ammo = this.Math.rand(10, 40);
                        local r = this.Math.rand(1, 4);

                        if (r <= 2)
                        {
                            party.addToInventory("supplies/rice_item");
                        }
                        else if (r == 3)
                        {
                            party.addToInventory("supplies/dates_item");
                        }
                        else if (r == 4)
                        {
                            party.addToInventory("supplies/dried_lamb_item");
                        }

                        local arr = [
                            "trade/silk_item",
                            "trade/silk_item",
                            "trade/incense_item",
                            "trade/spices_item"
                        ];

                        for( local i = 0; i < this.Math.round(r / 2); i++ )
                        {
                            party.addToInventory(arr[r - 1]);
                        }

                        local c = party.getController();
                        local roam = this.new("scripts/ai/world/orders/roam_order");
                        roam.setAllTerrainAvailable();
                        roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
                        roam.setTerrain(this.Const.World.TerrainType.Shore, false);
                        roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
                        roam.setPivot(this.Contract.m.Destination);
                        roam.setMinRange(4);
                        roam.setMaxRange(8);
                        roam.setTime(300.0);
                    }

                    local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

                    foreach( e in entities )
                    {
                        if (e.isParty())
                        {
                            e.getController().clearOrders();
                        }
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsQuartermaster") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 3)
                    {
                        this.Contract.setScreen("Quartermaster");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
                    {
                        this.Contract.setScreen("Approaching" + this.Flags.get("DestinationIndex"));
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
            this.m.States.push({
                ID = "Running_Defend",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Defend %holysite% against southern heathens",
                        "Destroy or rout enemy regiments in the vicinity",
                        "Don\'t stray too far away"
                    ];

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }

                    if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
                    {
                        this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 700) || !this.World.FactionManager.isAllied(this.Contract.getFaction(), this.Contract.m.Destination.getFaction()))
                    {
                        this.Contract.setScreen("Failure");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsSallyForthNextWave"))
                    {
                        this.Contract.setScreen("SallyForth3");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsVictory"))
                    {
                        if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
                        {
                            this.Contract.setScreen("Victory");
                            this.World.Contracts.showActiveContract();
                        }
                    }
                    else if (!this.Flags.get("IsTargetDiscovered") && this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isDiscovered())
                    {
                        this.Flags.set("IsTargetDiscovered", true);
                        this.Contract.setScreen("TheEnemyAttacks");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsArrived") && this.Flags.get("AttackTime") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("AttackTime"))
                    {
                        if (this.Flags.get("IsSallyForth"))
                        {
                            this.Contract.setScreen("SallyForth1");
                            this.World.Contracts.showActiveContract();
                        }
                        else if (this.Flags.get("IsAlliedSoldiers"))
                        {
                            this.Contract.setScreen("AlliedSoldiers1");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            this.Flags.set("AttackTime", 0.0);
                            local party = this.Contract.spawnEnemy();
                            party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onDestinationAttacked.bindenv(this));
                            this.Contract.m.Target = this.WeakTableRef(party);
                        }
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerInitiated = false )
                {
                    if (this.Flags.get("IsSallyForthNextWave"))
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "DefendHolySite";
                        p.Music = this.Const.Music.OrientalCityStateTracks;
                        p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
                        ];
                        p.Entities = [];

                        local enemy_party = this.new("scripts/entity/world/party");
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);
                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));

                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
                        }


                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 10, this.Contract.getFaction());
                            p.AllyBanners.push("banner_noble_11");
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                    else if (this.Flags.get("IsSallyForth"))
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "DefendHolySite";
                        p.Music = this.Const.Music.OrientalCityStateTracks;
                        p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.Entities = [];

                        local enemy_party = this.new("scripts/entity/world/party");
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);

                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Southern, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));

                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
                        }
                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
                        ];


                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
                            p.AllyBanners.push("banner_noble_11");
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                    else
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
                        p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
                        p.CombatID = "DefendHolySite";

                        if (this.Contract.isPlayerAt(this.Contract.m.Destination))
                        {
                            p.MapSeed = this.Flags.getAsInt("MapSeed");
                            p.LocationTemplate.Template[0] = "tactical.southern_ruins";
                            p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
                            p.LocationTemplate.CutDownTrees = true;
                            p.LocationTemplate.ShiftX = -2;
                            p.Music = this.Const.Music.OrientalCityStateTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
                            p.AllyBanners = [
                                this.World.Assets.getBanner()
                            ];
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());

                            p.Parties.push(ally_party);
                            if (this.Flags.get("IsAlliedReinforcements"))
                            {
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.Noble, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
                                p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
                            }

                            if (this.Flags.get("IsLocalsRecruited"))
                            {
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
                                p.AllyBanners.push("banner_noble_11");
                            }
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "DefendHolySite")
                    {
                        if (this.Flags.get("IsSallyForthNextWave"))
                        {
                            this.Flags.set("IsSallyForthNextWave", false);
                            this.Flags.set("IsSallyForth", false);
                            this.Flags.set("IsVictory", true);
                        }
                        else if (this.Flags.get("IsSallyForth"))
                        {
                            this.Flags.set("IsSallyForthNextWave", true);
                        }
                        else
                        {
                            this.Flags.set("IsVictory", true);
                        }
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "DefendHolySite")
                    {
                        this.Flags.set("IsFailure", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = false;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

    });


	::mods_hookExactClass("contracts/contracts/defend_holy_site_southern_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Move to %holysite% and defend it against northern heathens"
                    ];
                    this.Contract.setScreen("Task");
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    local r = this.Math.rand(1, 100);

                    if (r <= 25)
                    {
                        this.Flags.set("IsAlchemist", true);
                    }

                    local r = this.Math.rand(1, 100);

                    if (r <= 30)
                    {
                        this.Flags.set("IsSallyForth", true);
                    }
                    else if (r <= 60)
                    {
                        this.Flags.set("IsAlliedSoldiers", true);
                    }

                    local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
                    local houses = [];

                    foreach( n in nobles )
                    {
                        if (n.getFlags().get("IsHolyWarParticipant"))
                        {
                            n.addPlayerRelation(-99.0, "Took sides in the war");
                            houses.push(n);
                        }
                    }

                    this.Contract.m.Destination.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

                    if (this.Contract.getDifficultyMult() >= 0.95)
                    {
                        local f = houses[this.Math.rand(0, houses.len() - 1)];
                        local candidates = [];

                        foreach( s in f.getSettlements() )
                        {
                            if (s.isMilitary())
                            {
                                candidates.push(s);
                            }
                        }

                        local party = f.spawnEntity(this.Contract.m.Destination.getTile(), candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                        party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
                        party.setDescription("Professional soldiers in service to local lords.");
                        party.getLoot().Money = this.Math.rand(100, 300);
                        party.getLoot().ArmorParts = this.Math.rand(10, 35);
                        party.getLoot().Medicine = this.Math.rand(5, 15);
                        party.getLoot().Ammo = this.Math.rand(10, 40);
                        local r = this.Math.rand(1, 4);

                        if (r == 1)
                        {
                            party.addToInventory("supplies/bread_item");
                        }
                        else if (r == 2)
                        {
                            party.addToInventory("supplies/roots_and_berries_item");
                        }
                        else if (r == 3)
                        {
                            party.addToInventory("supplies/dried_fruits_item");
                        }
                        else if (r == 4)
                        {
                            party.addToInventory("supplies/ground_grains_item");
                        }

                        local c = party.getController();
                        local roam = this.new("scripts/ai/world/orders/roam_order");
                        roam.setAllTerrainAvailable();
                        roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
                        roam.setTerrain(this.Const.World.TerrainType.Shore, false);
                        roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
                        roam.setPivot(this.Contract.m.Destination);
                        roam.setMinRange(4);
                        roam.setMaxRange(8);
                        roam.setTime(300.0);
                    }

                    local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

                    foreach( e in entities )
                    {
                        if (e.isParty())
                        {
                            e.getController().clearOrders();
                        }
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsAlchemist") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 2)
                    {
                        this.Contract.setScreen("Alchemist1");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
                    {
                        this.Contract.setScreen("Approaching" + this.Flags.get("DestinationIndex"));
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
            this.m.States.push({
                ID = "Running_Defend",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Defend %holysite% against northern heathens",
                        "Destroy or rout enemy regiments in the vicinity",
                        "Don\'t stray too far away"
                    ];

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                    }

                    if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
                    {
                        this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 700) || !this.World.FactionManager.isAllied(this.Contract.getFaction(), this.Contract.m.Destination.getFaction()))
                    {
                        this.Contract.setScreen("Failure");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsSallyForthNextWave"))
                    {
                        this.Contract.setScreen("SallyForth3");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsVictory"))
                    {
                        if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
                        {
                            this.Contract.setScreen("Victory");
                            this.World.Contracts.showActiveContract();
                        }
                    }
                    else if (!this.Flags.get("IsTargetDiscovered") && this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isDiscovered())
                    {
                        this.Flags.set("IsTargetDiscovered", true);
                        this.Contract.setScreen("TheEnemyAttacks");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsArrived") && this.Flags.get("AttackTime") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("AttackTime"))
                    {
                        if (this.Flags.get("IsSallyForth"))
                        {
                            this.Contract.setScreen("SallyForth1");
                            this.World.Contracts.showActiveContract();
                        }
                        else if (this.Flags.get("IsAlliedSoldiers"))
                        {
                            this.Contract.setScreen("AlliedSoldiers1");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            this.Flags.set("AttackTime", 0.0);
                            local party = this.Contract.spawnEnemy();
                            party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onDestinationAttacked.bindenv(this));
                            this.Contract.m.Target = this.WeakTableRef(party);
                        }
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerInitiated = false )
                {
                    if (this.Flags.get("IsSallyForthNextWave"))
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "DefendHolySite";
                        p.Music = this.Const.Music.NobleTracks;
                        p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.Entities = [];
                        local enemy_party = this.new("scripts/entity/world/party");
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);
                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
                        }


                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
                        ];

                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsSouthern, 10, this.Contract.getFaction());
                            p.AllyBanners.push("banner_noble_11");
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            p.AllyBanners.push("banner_noble_11");
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                    else if (this.Flags.get("IsSallyForth"))
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "DefendHolySite";
                        p.Music = this.Const.Music.NobleTracks;
                        p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                        p.Entities = [];
                        local enemy_party = this.new("scripts/entity/world/party");
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);
                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Noble, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
                        }
                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
                        ];

                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            p.AllyBanners.push("banner_noble_11");
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                    else
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
                        p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
                        p.CombatID = "DefendHolySite";

                        if (this.Contract.isPlayerAt(this.Contract.m.Destination))
                        {
                            p.LocationTemplate.Template[0] = "tactical.southern_ruins";
                            p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
                            p.LocationTemplate.CutDownTrees = true;
                            p.LocationTemplate.ShiftX = -4;
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
                            p.AllyBanners = [
                                this.World.Assets.getBanner()
                            ];
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            if (this.Flags.get("IsAlliedReinforcements"))
                            {
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
                                p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
                            }

                            if (this.Flags.get("IsLocalsRecruited"))
                            {
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
                                p.AllyBanners.push("banner_noble_11");
                            }
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }

                        this.World.Contracts.startScriptedCombat(p, false, true, true);
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "DefendHolySite")
                    {
                        if (this.Flags.get("IsSallyForthNextWave"))
                        {
                            this.Flags.set("IsSallyForthNextWave", false);
                            this.Flags.set("IsSallyForth", false);
                            this.Flags.set("IsVictory", true);
                        }
                        else if (this.Flags.get("IsSallyForth"))
                        {
                            this.Flags.set("IsSallyForthNextWave", true);
                        }
                        else
                        {
                            this.Flags.set("IsVictory", true);
                        }
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "DefendHolySite")
                    {
                        this.Flags.set("IsFailure", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;

                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = false;
                    }
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

    });


	::mods_hookExactClass("contracts/contracts/deliver_item_contract", function(o){

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_112.png[/img]{%employer% shoves a sizeable crate into your hands before he or you even says a word.%SPEECH_ON%Look at that, the cargo I need delivering has already found someone to ship it off! What wonder!%SPEECH_OFF%He drops the theatrics.%SPEECH_ON%I need that taken to %objective% where a man by the name of %recipient% is waiting for it. It may look small, but I\'m willing to pay good crowns to be sure it gets there safe and sound. You interested? Or is it a little too heavy for your arms?%SPEECH_OFF% | You find %employer% closing a box up. He quickly glances up, as though he\'s been caught with his pants down.%SPEECH_ON%Sellsword! Thank you for coming.%SPEECH_OFF%He locks the latches with a few quick snaps. Then he pats the crate a few times, even leans on it as though it needed one more, fat latch.%SPEECH_ON%This here cargo has to be delivered safely to %objective%. A man by the name of %recipient% is waiting for it. I do not believe the task will be easy, as the cargo is rather precious to certain people who\'d go to great lengths to acquire it, which is why I\'m turning to a man of your... experiences. Are you interested in doing this for me?%SPEECH_OFF% | As you enter %employer%\'s room he and one of his servants are nailing a box shut.%SPEECH_ON%Good seeing you, sellsword. One moment, please. No, idiot, hold the nail that way! I know I hit your thumb before, but I won\'t do it again.%SPEECH_OFF%His servant reluctantly holds a nail while the man hammers it home. Finished, he wipes the sweat off his brow and looks to you.%SPEECH_ON%I need this here crate delivered to %objective% about %days% %direction% by road. It\'s going to %recipient%, you know. Him. Alright, maybe you don\'t know him. What I do know is that this may not ordinarily be your line of work, but I\'m willing to pay some serious crowns for you to see it through. That\'s your real business, right? Earning some crowns?%SPEECH_OFF% | %employer% folds his hands together when he sees you.%SPEECH_ON%This might be a strange question, but how interested are you in making a delivery for me?%SPEECH_OFF%You explain that, for the right price, such a journey would be a welcome departure from the usual killing and dying that goes on around you. The man claps his hands together.%SPEECH_ON%Excellent! Unfortunately, I don\'t expect it to be quite like that. It\'s of enough import to garner unsavory attention, which is why I\'m looking to hire sellswords in the first place. It\'s going to %objective%, %days% or so %direction% of here by road, where a man by the name of %recipient% is waiting for it to fall into his hands. So, you see, this won\'t be the \'departure\' you speak of, but it can be a fine payday if you\'re interested.%SPEECH_OFF% | %employer%\'s men are standing around a bit of cargo. Their employer shoos them away when he sees you.%SPEECH_ON%Welcome, welcome. Good seeing you. I\'m in need of armed guards to have this here package delivered to a man by the name of %recipient% in %objective%. I reckon it\'s about %days% of travel for a company as your. How interested would you be in doing that for me?%SPEECH_OFF% | %employer%\'s got his feet up on his table when you enter. He puts his hands behind his head, looking a little too relaxed for your tastes.%SPEECH_ON%Good tidings, captain. What say you take a leave from all that killing and dying.%SPEECH_OFF%He raises an eyebrow at your response, which is precisely none at all.%SPEECH_ON%Huh, I figured you\'d jump on that opportunity. No matter, it was a lie: I need you to take a certain package to %recipient%, a fellow residing in %objective%. This cargo has undoubtedly garnered some ill-intentioned eyes which is why I need your men watching it for me. If you\'re interested, which you should be, let\'s talk numbers.%SPEECH_OFF% | %employer% welcomes you, waving you in.%SPEECH_ON%Very well, now that you\'re here, would you please shut the door behind you?%SPEECH_OFF%One of the man\'s guards pokes his head around the corner. You smile as you slowly shut him out. Turning around, you find %employer% walking toward a window. He stares out as he talks.%SPEECH_ON%I need something... it\'s a, uh, well you don\'t need to know what it is. I need this \'something\' delivered to a fellow called %recipient%. He\'s waiting for it in %objective%. It\'s important that it actually gets there, important enough for an armed escort for %days% of travel, which is why I\'m turning to you and your company. What say you, mercenary?%SPEECH_OFF% | Dim candles barely light the room enough for you to see, it\'s %employer% sitting behind his desk while his shadows dance on the walls by the tune of flickering lights.%SPEECH_ON%Would you lend your swords to me if I paid you good coin? I need {a small chest | something dear to me | something valuable} delivered safely to %recipient% in %objective%, about %days% of travel %direction% of here. Men have killed each other over this, so you must be ready to defend it with your life.%SPEECH_OFF%He takes a pause, measuring your response.%SPEECH_ON%I will write a sealed letter with instructions to pay you as you deliver the item to my contact in %objective%. What say you?%SPEECH_OFF% | A servant bids you to wait for %employer%, who, he says, will be right with you. And so you wait, and wait, and wait. And finally, as you are about to leave for the second time, %employer% throws open the doors and rushes towards you.%SPEECH_ON%Who\'s this, again? The mercenary?%SPEECH_OFF%His assistant nods and %employer% sets on a smile.%SPEECH_ON%Oh most fortuitous to have you in %townname%, good captain!\n\nIt is imperative that some precious commodities of mine reach %objective% as safely and quickly as possible. You are precisely who I need, for no common brigand would dare attack you and your men.\n\nYes, I\'d like to hire you for escort. Make sure the items are delivered to %recipient%, no detours of course. Can we come to an understanding?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{Let\'s talk money. | How many crowns are we talking about?}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | Our travels will not take us there for a while. | This is not the kind of work we\'re looking for.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "TaskSouthern",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_112.png[/img]{One of the Vizier\'s aldermen approaches with a retinue of servants. They\'re laboring a modestly sized crate in your general direction.%SPEECH_ON%Crownling, the Vizier has use for you. Have these servants load the crate into your keeping then take it to %recipient% in %objective%, a good %days% by road to the %direction%.%SPEECH_OFF%The alderman bows.%SPEECH_ON%Though a simple task it may be, the Vizier is willing to pay a plentiful sum for the task\'s completion.%SPEECH_OFF% | You find %employer% awaiting in the foyer. He is listening to a row of merchants, each with their own request or offer, and all the while a scribe at his side makes notations in a ledger which unfurls ever longer across the marbled floor. Seeing you, the Vizier snaps his fingers and a man off to the side approaches.%SPEECH_ON%Crownling, the majesty wishes to make use of your services. Take a crate with this labeling to %recipient% in %objective%, about %days% by road. You will be compensated upon arrival.%SPEECH_OFF% | A man with peacock feathers in a jaunty cap approaches you seemingly out of nowhere. He sidles along with a ledger in hand, though the ledger carries the emblem of one of %townname%\'s Viziers and his guard.%SPEECH_ON%%employer% wishes to employ your services, Crownling. You are to handle a fine material, crated away from your devilish eyes of course, and secret it to %recipient% in %objective%, located %days% by road to the %direction%. Once the material is delivered, you will then be paid at the location upon which you have arrived.%SPEECH_OFF%The man rakes the feathers back and briefly shakes his head.%SPEECH_ON%Do you find this offer congruent with your current financial wishes?%SPEECH_OFF% | You\'re first hailed by a pigeon with a note, the note pointing you to a young boy who then takes you to a servant, the servant guides you through a harem hall of naked women after which you arrive to the room of a wealthy merchant.%SPEECH_ON%Ah, finally, you have arrived. I set out a simple task to my indebted and it takes this long to complete? I\'ll have to look into that.%SPEECH_OFF%The merchant tosses you a ledger and simultaneously falls into a pile of cushions.%SPEECH_ON%I, excuse me, the Vizier needs you to take a crate of goods to %recipient% in %objective%, located %days% on the road to the %direction%. You are not to open said goods, only deliver them. If you open the goods, the Vizier will hear of it. And trust me, Crownling, the Vizier only likes to hear of splendid things. That is why I am here instead of the majesty.%SPEECH_OFF%What a courtesy.}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{Let\'s talk money. | How many crowns are we talking about?}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | Our travels will not take us there for a while. | This is not the kind of work we\'re looking for.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Mercenaries1",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{While on the road, a band of well-armed men cross your path. | Marching toward %objective%, a few men interrupt your quiet travels, the clinky-clank of their weapons and armor filling the air as they step into formation. | Your travels, unfortunately, are not to be simple. A number of men have stepped out in front of you, clearly blocking your way. | Some armed and well armored men have come out to make something of a metal impasse. They look as though they intend to make sure you go no farther. | A few of the men come to a stop. You go to the front to figure out what is going on, only to see a line of well-armed men standing in %companyname%\'s way. Well, this should be interesting.} The enemy lieutenant steps forward and pounds his chest with his fist clenched.%SPEECH_ON%{It is us, the %mercband%, that stand before you. Slayers of beasts beyond imagination, the last hope of this godsforsaken land! | The name is %mercband% and we\'re well known throughout this land as splitters of heads, drinkers of kegs and lovers of ladies! | \'Tis the legendary %mercband% standing before you. It is we, saviors of %randomtown% and slayers of the false king! | Behold my proud band, the %mercband%! We, who fought off a hundred orcs to save a city from certain doom. What have you to your name? | You\'re talking to a man of the %mercband%. No common brigand, foul greenskin, bag of coins or skirt ever escaped from us!}%SPEECH_OFF%After the man finishes his posturing and personal pontificating, he points at the cargo you are carrying.%SPEECH_ON%{So now that you realize the danger you are in, why don\'t you go ahead and hand that cargo over? | I hope you realize who you\'ve come to face, pathetic sellsword, so that you may best make sure your men make it to their beds tonight. All you need to do is hand over the cargo and we won\'t have to add you to the history of %mercband%. | Ah, I bet you\'d like to be a part of our history, wouldn\'t you? Well, good news, all you gotta do is not hand over that cargo and we\'ll scribble you in with our swords. Of course, you can escape the scribe\'s pen if you just give us that cargo. | Now, if it isn\'t the %companyname%. As much as I\'d like add you to our list of victories, I\'ll give you a chance here, mercenary to mercenary. All you have to do is hand over that cargo and we\'ll be on our way. How\'s that sound?}%SPEECH_OFF%{Hmm, well it was a bombastic request if nothing else. | Well, the theatrics were pretty entertaining if nothing else. | You don\'t quite understand the need for showmanship, but there\'s little doubt about the seriousness of this new situation you\'ve found yourself in. | While you appreciated the superlatives and hyperbole, there remains the very terse reality that these men do actually mean business.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "If you want it, come and take it!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "Mercs";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    },
                    {
                        Text = "It\'s not worth dying over. Take that damn cargo and be gone.",
                        function getResult()
                        {
                            return "Mercenaries2";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Mercenaries2",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{Not wanting a fight, you hand the cargo over. They laugh as they take it off your hands.%SPEECH_ON%Good choice, mercenary. Maybe someday you\'ll be the one doing the threatening.%SPEECH_OFF% | The cargo, whatever it is, isn\'t worth the lives of your men. You hand the crate over and the mercenaries take it. They laugh at you as you leave.%SPEECH_ON%Like charming a whore!%SPEECH_OFF% | This does not seem like the time or place to be sacrificing your men in the name of %employer%\'s delivery service. You hand the cargo over. The mercenaries take it then make their leave, their lieutenant flipping you a crown that spins its way into the mud.%SPEECH_ON%Get yerself a shinebox, kid, this work ain\'t cut out for you.%SPEECH_OFF% | The mercenaries are well armed and you don\'t know if you could sleep at night knowing you spent the lives of your men just for some silly crate carrying the old gods know what. With a nod, you hand the cargo over. The mercenary band gladly takes it from you, their lieutenant pausing to nod back with respect.%SPEECH_ON%A wise choice. Don\'t think I didn\'t make many like it when I was coming up.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Hrm...",
                        function getResult()
                        {
                            this.Flags.set("IsMercenaries", false);
                            this.Flags.set("IsMercenariesDialogTriggered", true);

                            if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
                            {
                                this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
                            }
                            else
                            {
                                this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
                            }

                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
                            }

                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BountyHunters1",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{While on the roads, you come across a band of bounty hunters. Their prisoner calls out to you, his voice cracking as he begs for you to save him. He claims he is an innocent man. The bounty hunters tell you to fark off and die. | You\'re traveling the roads when you come across a group of well-armed bounty hunters. They\'re yanking along a man shackled from head to toe.%SPEECH_ON%You want no part of this fellow.%SPEECH_OFF%One man says, striking his prisoner in the back of the shins. The man yelps and crawls to you on bloodied hands and knees.%SPEECH_ON%They\'re all liars! These men will kill me even though I\'ve done nothing wrong! Save me, sirs, I beg of you!%SPEECH_OFF% | You come across a large band of bounty hunters, your two groups oddly mirroring one another, though your purposes in this world clearly diverge. They\'re transporting a prisoner who has been chained and his mouth stuffed with a rag. The man yells out to you, almost pleading, choking on his words until he\'s red in the face. One of the bounty hunters spits.%SPEECH_ON%Pay him no mind, stranger, and get on down the road. Best there be no trouble between men such as we.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "This isn\'t any of our business.",
                        function getResult()
                        {
                            return 0;
                        }

                    },
                    {
                        Text = "Perhaps we can buy the prisoner?",
                        function getResult()
                        {
                            return this.Math.rand(1, 100) <= 50 ? "BountyHunters1" : "BountyHunters1";
                        }

                    },
                    {
                        Text = "If you want it, come and take it!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "Mercs";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Mercenaries, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Thieves1",
                Title = "During camp...",
                Text = "[img]gfx/ui/events/event_05.png[/img]{You raise up from a nap and turn over, looking for the package as though it were a lover. But she\'s not there and neither is the cargo. Quickly getting to your feet, you begin ordering the men to attention. %randombrother% runs up and says he\'s tracked some footprints leading off from the site. | While taking a rest, you hear a disturbance somewhere in the camp. You rush to it to find %randombrother% face down in the dirt, rubbing the back of his head.%SPEECH_ON%Sorry sir, I was taking a piss, and then they went on ahead and took it out of me. Also, they stole the package.%SPEECH_OFF%You tell him to repeat that last part.%SPEECH_ON%Goddamn thieves have stolen the goods!%SPEECH_OFF%Time to track those bastards down and get it back. | Naturally, it wouldn\'t be an ordinary trip. No, this world is too shite for that to be the case. It appears thieves have taken off with the cargo. Luckily, they\'ve left a hell of a lot of evidence, namely footprints and dragmarks from toting the package around. They should be easy to find... | Just once you\'d like to have a nice walk from one town to the next. Instead, your agreement with %employer% has attracted trouble once again. Thieves, somehow, managed to sneak into the camp and make off with the cargo. The good news is that they didn\'t manage to sneak back out: you\'ve found their footprints and they won\'t be hard to follow.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We follow their tracks!",
                        function getResult()
                        {
                            this.Contract.setState("Running_Thieves");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Thieves2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{Thief blood runs thick. You manage to find your employer\'s goods still in the camp, all locked and safe. He doesn\'t need to know about this little excursion. | Well, everything\'s right where it should be. %employer%\'s cargo was found underneath a thief\'s writhing body. You made sure to kick him off before running him through. Wouldn\'t want to get blood on the package, after all. | Killing off the last of the thieves, you and the men spread out through the brigands\' camp looking for the package. %randombrother% spots it right quick, the container still held in the clutches of a dead fool. The mercenary fumbles with the corpse\'s grasp and, in frustration, simply cuts the arms off the bastard. You retrieve the package and hold it a little closer for the trip going forward. | Staring over the bodies of the felled thieves, you wonder if %employer% needs to know about this. The package looks alright. Some blood and bone on it, but you can rub that right off. | The package\'s a little scuffed, but it\'ll be fine. Alright, there\'s blood all over it and a thief\'s degloved finger is all smashed up into one of the latches. Those issues aside, everything is perfectly fine.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Back where it belongs.",
                        function getResult()
                        {
                            this.Flags.set("IsThieves", false);
                            this.Flags.set("IsStolenByThieves", false);
                            this.Contract.setState("Running");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EnragingMessage1",
                Title = "At %objective%",
                Text = "{The cemetery is layered in fog - that or a thick miasma given off by the dead. Wait... that IS the dead! To arms! | You eye a tombstone with a mound of soil unearthed at its base. Blots of mud lead away like a crumb trail. There are no shovels... no men... As you follow the lead, you come across a band of undead moaning and groaning... now staring at you with insatiable hunger... | A man lingers deep in the rows of tombstones. He seems to be wavering, as though ready to pass out. %randombrother% comes to your side and shakes his head.%SPEECH_ON%That\'s no man, sir. There\'s undead afoot.%SPEECH_OFF%Just as he finishes talking, the stranger in the distance slowly turns and there in the light reveals he\'s missing half his face. | You come to find many of the graves are emptied. Not just emptied, but unearthed from below. This is not the work of graverobbers...}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{While on the move, you notice that something else is moving, too: the cargo. The lid on it is jumping around and there\'s a strange glow emerging from its sides. %randombrother% approaches, looks at it, then looks at you.%SPEECH_ON%Should we open it, sir? Or I can take it and throw it in the closest pond because none of that right there is alright.%SPEECH_OFF%You jab the man and ask if he\'s scared. | Moving along the paths, you begin to hear a low hum emanating from the package %employer% had given you. %randombrother% is standing beside it, poking it with a stick. You slap him back. He explains himself.%SPEECH_ON%Sir, there\'s something that ain\'t right with the cargo we\'re tugging...%SPEECH_OFF%You take a good look at it. There\'s a faint color brimming at the edges of the lid. As far as you know, fire can\'t breathe in such a space, and the only thing else that glows in the dark are the moons and the stars. You worry that curiosity is starting to get the better of you... | The cargo rests in the wagon beside you, jostling about to the tilts and turns of the paths. Suddenly, it begins to hum and you swear you saw the lid float upward for just a second. %randombrother% glances over.%SPEECH_ON%You alright, sir?%SPEECH_OFF%Just as he finishes talking, the lid explodes outward, a swirl of colors, mist, ash, fiery heat and brutish cold. You throw your arms up, shielding yourself, and when you take a peek through your elbows the package is completely still, the lid back on. You exchange a glance with the sellsword, then both of you stare at the cargo. This might be a little more than an ordinary delivery... | A low hum emanates from nearby. Thinking a bee hive nearby, you instinctively duck, only to realize the sound is coming from the cargo %employer% had handed you. The lid atop the container is rattling side to side, jostling the latches and nails that are supposed to keep it there. %randombrother% looks a little frightened.%SPEECH_ON%Let\'s just leave it here. That thing ain\'t right.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I want to know what\'s going on.",
                        function getResult()
                        {
                            return "EvilArtifact2";
                        }

                    },
                    {
                        Text = "Leave that thing alone.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact2",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_73.png[/img]{Curiosity gets the best of you. Slowly you start prying at the lid. %randombrother% takes a step back and protests.%SPEECH_ON%I think we should leave it alone, sir. I mean c\'mon, look at it.%SPEECH_OFF%Ignoring him, you tell the men it\'s going to be alright, and then you lift the lid up.\n\n It isn\'t alright. The explosion knocks you off your feet. Horrible shapes and shrieks swirl all around you. The men instinctively arm themselves as the piloted specters spear into the earth. There the ground lifts in mounds, and there, too, the earth begins to groan. You watch as hands shoot forth, dragging decrepit bodies from their pit. The dead live again and surely they mean to add to their ranks! | Against anyone\'s best judgment, you pry the cargo open. At first, there is nothing. It\'s just an empty box. %randombrother% nervously laughs.%SPEECH_ON%Well... I guess that\'s it then.%SPEECH_OFF%But that can\'t be it, can it? Why would %employer% have you delivering an empty container unless -- \n\n You wake up to a ringing slowly fading from your ears. Turning over, you see that the box has completely evaporated, a flurry of snowy sawdust all that remains of it. %randombrother% rushes over, picking you up and dragging you toward the rest of the company. They point, their mouths moving, shouting...\n\n A mob of well-armed men are... shuffling your way? As you get a better sight of them, you realize that they are armed with old wooden shields painted with odd spiritual rites, and their armor is of shapes and sizes you have never seen before, as though they were crafted by men just learning the trade, yet still well learned in what they had learned thus far. These are like ancients... the first men. | %randombrother% shakes his head as you go to pick up the lid. With some effort, it\'s pried open and you quickly step back, expecting the worst. But there\'s nothing. Not even a sound comes out of the box. You take a sword and rattle it around in the empty box, looking for a secret compartment or something. %randombrother% laughs.%SPEECH_ON%Hey, we\'re just delivering a bunch of air! And to think I thought that damned thing was too heavy!%SPEECH_OFF%Just then, the box lifts briefly into the air, spins, and smashes itself into the ground. It breaks perfectly, noiselessly, and with no wasted movements, every piece of wood laid against the grass like ancient stoneworks. An incorporeal shape leers up from the splintered rites, grinning as it twists.%SPEECH_ON%Oh humans, it is truly good to see you again.%SPEECH_OFF%The voice is like ice down your back. You watch as the specter shoots into the sky then slams back down, spearing into the very earth. Not a second passes before the ground is erupting as bodies begin to clamber out. | The box magnetizes you. Without hesitation, you crank the cargo open and take a look inside. You smell before you see - a horrid stench overwhelming you almost to the point of blindness. One of the men pukes. Another retches. When you look back at the box, blackened tendrils of smoke are sifting out of it, stretching long and far, probing the ground as they go. When they find what they\'re looking for, they dive into the earth, yanking up bones of dead men like a lure would a fish. | Ignoring the worries of a few of the men, you bust the package open. A pile of heads are to be found, their glowing eyes flickering awake. Their jaws crackle open, shifting from unmoved states to rattle in laughter. You quickly close the box, but a force pushes it back open. You struggle with it, %randombrother% and a few others trying to help, but it\'s almost as if the utterly silent winds of a storm are pushing back against you.\n\nA bare moment later, you\'re all thrown back, the lid of the crate soaring into the sky, ushered upward by a gust of blackened souls. They zip around, combing the earth, then collectively position opposite the %companyname%. There you watch in horror as the incorporeal begins to take shape, the foggy mists of souls hardening into the very real bones of souls lost long ago. And, of course, they come armed, the crackling jawbones still clattering with hollow laughter.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "EvilArtifact";
                            p.Music = this.Const.Music.UndeadTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;

                            if (this.Flags.get("IsCursedCrystalSkull"))
                            {
                                this.World.Flags.set("IsCursedCrystalSkull", true);
                                p.Loot = [
                                    "scripts/items/accessory/legendary/cursed_crystal_skull"
                                ];
                            }
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact3",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{The battle over, you quickly rush back over to the artifact, finding it floating in the air. %randombrother% runs up to your side.%SPEECH_ON%Destroy it, sir, before it causes any more trouble!%SPEECH_OFF% | Your men weren\'t the only thing to survive the battle - the artifact, or whatever remains of its pulsing power, floats innocently where you\'d last seen it. The thing is an orb swirling with energy, occasionally rattling, sometimes whispering a language you know not of. %randombrother% nods toward it.%SPEECH_ON%Smash it, sir. Smash it and let us be done with this horror.%SPEECH_OFF% | Such power was not meant for this world! The artifact has taken the shape of an orb the size of your fist. It floats off the ground, humming as though singing a song from another world. The thing almost seems to be waiting for you, like a dog would wait its master.%SPEECH_ON%Sir.%SPEECH_OFF%%randombrother% tugs on your shoulder.%SPEECH_ON%Sir, please, destroy it. Let us not take that thing another step with us!%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We have to destroy it.",
                        function getResult()
                        {
                            return "EvilArtifact4";
                        }

                    },
                    {
                        Text = "We\'re paid to deliver this, so that\'s what we\'ll do.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact4",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You take out your sword and stand before the artifact with the blade slowly raised over your head.%SPEECH_ON%Don\'t do it!%SPEECH_OFF%Glancing over your shoulder, you see %randombrother% and the other men scowling at you. Blackness surrounds them and the whole world as far as your eye can see. Their eyes glow red, pulsing furiously with every spoken word.%SPEECH_ON%You shall burn forever! Burn forever! Destroy it and you shall burn! Burn! BURN!%SPEECH_OFF%Screaming, you turn around and slice your sword through the relic. It splits effortlessly in two and a wave of color sweeps back into your world. Sweat pours from your forehead as you find yourself leaning on the pommel of your weapon. You look back to see your mercenary company staring at you.%SPEECH_ON%Sir, are you alright?%SPEECH_OFF%You sheathe your sword and nod, but you\'ve never felt so horrified in all your life. %employer% won\'t be happy, but he and his anger be damned! | Just as soon as the thought of destroying the relic crosses your mind, so too does a wave of horrified screaming. The shrill crying of women and children, their voices cracking with terror as though they had come running at you all on fire. They scream at you in hundreds of languages, but every so often the one you know passes you and it\'s always with the same word: DON\'T.\n\n You draw your sword and swing it back over your head. The artifact hums and vibrates. Smoky tendrils waft off it and a brutish heat washes over you. DON\'T.\n\n You steady your grip.\n\n Davkul. Yekh\'la. Imshudda. Pezrant. DON\'T.\n\nYou swallow and steady your aim.\n\n DON\'T.RAVWEET.URRLA.OSHARO.EBBURRO.MEHT\'JAKA.DON\'T.DON\'T.DON\'T.DO--\n\n The strike is true, the word is lost, the artifact falls to the earth in twine. You fall with it, to your knees, and a few of the company\'s brothers come to lift you back up. %employer% won\'t be happy, but you can\'t help but feel as though you\'ve spared this world a horror it need not ever see or hear.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "It\'s done.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);

                            if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
                            {
                                this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
                            }
                            else
                            {
                                this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
                            }

                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
                            }

                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact5",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You shake your head and get another crate, carefully pushing the floating artifact into it then closing the lid. %employer% was paying you good money and, well, you plan on seeing it through. But for some reason you\'re not sure if that choice is your own, or if this strange relic\'s whispering is guiding your hand for you. | You go and retrieve a wooden chest and lift it up to the artifact, quickly closing the lid over it. A few of the mercenaries shake their head. It\'s probably not the best of ideas, but for some reason you fill compelled to finish your task. | Better judgment says you should destroy this horrible relic, but better judgment fails once more. You take a wooden chest and move it over the artifact before closing the lid and snapping shut the latches. You\'ve no idea what you are doing this, but your body is filled with newfound energy as you get ready to get back on the road.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We should move on.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "At %objective%",
                Text = "[img]gfx/ui/events/event_20.png[/img]{%recipient%\'s waiting for you as you enter the town. He hurriedly takes the cargo off your hands.%SPEECH_ON%Oh, ohhh I did not think you would get here.%SPEECH_OFF%His grubby fingers dance along the chest carrying the cargo. He turns around and barks an order to one of his men. They step forward and hand you a satchel of crowns. | Finally, you\'ve made it. %recipient% is standing there in the middle of the road, his hands clasped over his stomach, a slick grin on his cheeky face.%SPEECH_ON%Sellsword, I was not sure you\'d make it.%SPEECH_OFF%You lug the cargo up and hand it over.%SPEECH_ON%Oh yeah, and why do you say that?%SPEECH_OFF%The man takes the box and hands it off to a robed man who quickly hurries away with it tucked under an arm. %recipient% laughs as he hands you a satchel of crowns.%SPEECH_ON%The roads are rough these days, are they not?%SPEECH_OFF%You understand he\'s making small talk, anything to get your attention off the cargo you just handed over. Whatever, you got your pay, that\'s good enough for you. | %recipient% welcomes you and a few of his men hurry over to take the cargo. He claps you on the shoulders.%SPEECH_ON%I take it your journey went well?%SPEECH_OFF%You spare him the details and inquire about your pay.%SPEECH_ON%Bah, a sellsword through and through. %randomname%! Get this man what he deserves!%SPEECH_OFF%One of %recipient%\'s bodyguards walks over and hands you a small chest of crowns. | After some looking, a man asks who you\'re looking for. When you say %recipient%, he points you out toward a nearby paddock where a man is strutting about on a rather opulent looking horse.\n\n You walk on over and the man rears the steed and asks if that\'s the cargo %employer% sent. You nod.%SPEECH_ON%Leave it there at your feet. I\'ll come and get it.%SPEECH_OFF%You don\'t, instead asking about your pay. The man sighs and whistles to a bodyguard who hurries over.%SPEECH_ON%See to it that this sellsword gets the pay he deserves.%SPEECH_OFF%Finally, you put the crate on the ground and make your leave.} ",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = false,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            local playerRoster = this.World.getPlayerRoster().getAll();
                            local xp = this.Contract.m.Payment.getOnCompletion() * 0.25;

                            foreach( bro in playerRoster )
                            {
                                bro.addXP(xp);
                                bro.updateLevel();
                            }

                            if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
                            {
                                this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Delivered some cargo");
                            }
                            else
                            {
                                this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Delivered some cargo");
                            }

                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Delivered some cargo");
                            }

                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "Success2",
                Title = "At %objective%",
                Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%Ah, the Crownling.%SPEECH_OFF%The voice comes from a nearby alley. Usually that means you\'re about to have some coin lifted off ya, but instead find a man offering you gold.%SPEECH_ON%I am %recipient%, and that package belongs to me. Send %employer% my regards, or don\'t, I don\'t care.%SPEECH_OFF%The man steals away and is gone just as soon as he came. | %recipient% is a squat man and he carries the Vizier\'s emblem and signage as though it were as heavy as the crate you just brought him.%SPEECH_ON%I\'ve given the Vizier much, and what does he use to repay me? A Crownling\'s sweat. May the Gilder blink when gazing upon that man\'s future.%SPEECH_OFF%You say nothing to this, in part because you wonder if it is a \'test\' to see if you\'ll agree with him and turn yourself out to be an enemy of the ever majestic Vizier. The man stares at you for a moment, then shrugs and continues.%SPEECH_ON%I have your payment here. The coin is all accounted for, though I will not take offense if you wish to count it yourself. Ah, I see you already are. Good. See? It\'s all there. Now run along little Crownling.%SPEECH_OFF% | You find %recipient% holding court over a small throng of children. He quickly singles you and teaches them a lesson about keeping to their studies lest they end up like you. After the kids are dismissed, the man comes over with a satchel of crowns.%SPEECH_ON%My men told me you had arrived and that the material was still in good standing. Here is your motly payment, Crownling.%SPEECH_OFF% | You enter %recipient%\'s home where the package is finally dropped off and whisked away by servants. Staring at you from a comfortable looking chair, %recipient% asks if your journey went well. You state that idle talk does not fill your pockets and then inquire about your pay. The man raises an eyebrow.%SPEECH_ON%Ah, have I offended the Crownling with my kind, civilized sensibilities? How dare I. Well then, your pay is in the corner and it is in full as agreed upon.%SPEECH_OFF% | %recipient% is pontificating about the nature of birds to a mirror. When he sees you in the reflection, he turns around and speaks as though nothing unusual had been going on at all.%SPEECH_ON%A Crownling. Of course the Vizier sends a Crownling. I like to imagine you did not dare profane the materials of the crate with your eyes, but I can\'t even trust such professionalism out of your sort. But you can expect it of me: your payment is in the corner, and in full.%SPEECH_OFF%}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = false,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            local playerRoster = this.World.getPlayerRoster().getAll();
                            local xp = this.Contract.m.Payment.getOnCompletion() * 0.25;

                            foreach( bro in playerRoster )
                            {
                                bro.addXP(xp);
                                bro.updateLevel();
                            }

                            if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
                            {
                                this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Delivered some cargo");
                            }
                            else
                            {
                                this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Delivered some cargo");
                            }

                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Delivered some cargo");
                            }

                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local xpGained = this.Math.round(this.Contract.m.Payment.getOnCompletion() * 0.25 * this.Const.Combat.GlobalXPMult);
                    this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns and [color=" + this.Const.UI.Color.PositiveEventValue + "]" + xpGained + "[/color] Experience"
                    });
                }

            });
        }
    });

	::mods_hookExactClass("contracts/contracts/deliver_money_contract", function(o){

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Coin Delivery",
                Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% shoves a sizeable chest into your hands before he or you even says a word.%SPEECH_ON%This is the pay for a nearby merchant, I need to you deliver these crowns!%SPEECH_OFF%He looks at you seriously.%SPEECH_ON%I need that taken to %objective% where a man by the name of %recipient% is waiting for it. It may look small, but that chest is the pay for a whole company of merchants. You interested? Or is it a little too heavy for your arms?%SPEECH_OFF% | You find %employer% closing a small chest of coins. He quickly glances up, as though you might have been theives.%SPEECH_ON%Sellsword! Thank you for coming.%SPEECH_OFF%He locks the chest quickly. Then he pats the chest a few times, even caresses it a little.%SPEECH_ON%This here cargo has to be delivered safely to %objective%. A man by the name of %recipient% is waiting for it. I do not believe the task will be easy, as the chest contains an investment in a new enterprise. There are people who\'d go to great lengths to acquire this kind of coin, which is why I\'m turning to a man of your... experiences. Are you interested in doing this for me?%SPEECH_OFF% | As you enter %employer%\'s room one of his servants is fiddling wit hthe lock on a small chest of coins .%SPEECH_ON%Good seeing you, sellsword. One moment, please. No, idiot, its the other key!.%SPEECH_OFF%His servant bumbles at a ring of keys, trying each one until finally finding the right one. Finished, he wipes the sweat off his brow and looks to you.%SPEECH_ON%I need this here chest delivered to %objective% about %days% %direction% by road. It\'s going to %recipient%, you know. Him. Alright, maybe you don\'t know him. What I do know is that this may not ordinarily be your line of work, but I\'m willing to pay some serious crowns for you to see it through. That\'s your real business, right? Earning some crowns?%SPEECH_OFF% | %employer% folds his hands together when he sees you.%SPEECH_ON%This might be a strange question, but how interested are you in making a delivery for me?%SPEECH_OFF%You explain that, for the right price, such a journey would be a welcome departure from the usual killing and dying that goes on around you. The man claps his hands together.%SPEECH_ON%Excellent! Unfortunately, I don\'t expect it to be quite like that. It\'s of enough import to garner unsavory attention, which is why I\'m looking to hire sellswords in the first place. It\'s going to %objective%, %days% or so %direction% of here by road, where a man by the name of %recipient% is waiting for it to fall into his hands. So, you see, this won\'t be the \'departure\' you speak of, but it can be a fine payday if you\'re interested.%SPEECH_OFF% | %employer%\'s men are standing around a chest of gold. Their employer shoos them away when he sees you.%SPEECH_ON%Welcome, welcome. Good seeing you. I\'m in need of armed guards to have this here package delivered to a man by the name of %recipient% in %objective%. I reckon it\'s about %days% of travel for a company as your. How interested would you be in doing that for me?%SPEECH_OFF% | %employer%\'s got his feet up on his table when you enter. He puts his hands behind his head, looking a little too relaxed for your tastes.%SPEECH_ON%Good tidings, captain. What say you take a leave from all that killing and dying.%SPEECH_OFF%He raises an eyebrow at your response, which is precisely none at all.%SPEECH_ON%Huh, I figured you\'d jump on that opportunity. No matter, it was a lie: I need you to take a certain package to %recipient%, a fellow residing in %objective%. This cargo has undoubtedly garnered some ill-intentioned eyes which is why I need your men watching it for me. If you\'re interested, which you should be, let\'s talk numbers.%SPEECH_OFF% | %employer% welcomes you, waving you in.%SPEECH_ON%Very well, now that you\'re here, would you please shut the door behind you?%SPEECH_OFF%One of the man\'s guards pokes his head around the corner. You smile as you slowly shut him out. Turning around, you find %employer% walking toward a window. He stares out as he talks.%SPEECH_ON%I need something... it\'s a, uh, well you don\'t need to know what it is. I need this \'something\' delivered to a fellow called %recipient%. He\'s waiting for it in %objective%. It\'s important that it actually gets there, important enough for an armed escort for %days% of travel, which is why I\'m turning to you and your company. What say you, mercenary?%SPEECH_OFF% | Dim candles barely light the room enough for you to see, it\'s %employer% sitting behind his desk while his shadows dance on the walls by the tune of flickering lights.%SPEECH_ON%Would you lend your swords to me if I paid you good coin? I need {a small chest | an important investment | business starting funds} delivered safely to %recipient% in %objective%, about %days% of travel %direction% of here. Men have killed each other over this much coin, so you must be ready to defend it with your life.%SPEECH_OFF%He takes a pause, measuring your response.%SPEECH_ON%I will write a sealed letter with instructions to pay you as you deliver the item to my contact in %objective%. What say you?%SPEECH_OFF% | A servant bids you to wait for %employer%, who, he says, will be right with you. And so you wait, and wait, and wait. And finally, as you are about to leave for the second time, %employer% throws open the doors and rushes towards you.%SPEECH_ON%Who\'s this, again? The mercenary?%SPEECH_OFF%His assistant nods and %employer% sets on a smile.%SPEECH_ON%Oh most fortuitous to have you in %townname%, good captain!\n\nIt is imperative that some coin of mine reach %objective% as safely and quickly as possible. You are precisely who I need, for no common brigand would dare attack you and your men.\n\nYes, I\'d like to hire you for escort. Make sure the crowns are delivered to %recipient%, no detours of course. Can we come to an understanding?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{Let\'s talk recompense. | What is the pay?}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | Our travels will not take us there for a while. | This is not the kind of work we\'re looking for.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Mercenaries1",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{While on the road, a band of well-armed men cross your path. | Marching toward %objective%, a few men interrupt your quiet travels, the clinky-clank of their weapons and armor filling the air as they step into formation. | Your travels, unfortunately, are not to be simple. A number of men have stepped out in front of you, clearly blocking your way. | Some armed and well armored men have come out to make something of a metal impasse. They look as though they intend to make sure you go no farther. | A few of the men come to a stop. You go to the front to figure out what is going on, only to see a line of well-armed men standing in %companyname%\'s way. Well, this should be interesting.} The enemy lieutenant steps forward and pounds his chest with his fist clenched.%SPEECH_ON%{It is us, the %mercband%, that stand before you. Slayers of beasts beyond imagination, the last hope of this godsforsaken land! | The name is %mercband% and we\'re well known throughout this land as splitters of heads, drinkers of kegs and lovers of ladies! | \'Tis the legendary %mercband% standing before you. It is we, saviors of %randomtown% and slayers of the false king! | Behold my proud band, the %mercband%! We, who fought off a hundred orcs to save a city from certain doom. What have you to your name? | You\'re talking to a man of the %mercband%. No common brigand, foul greenskin, bag of coins or skirt ever escaped from us!}%SPEECH_OFF%After the man finishes his posturing and personal pontificating, he points at the cargo you are carrying.%SPEECH_ON%{So now that you realize the danger you are in, why don\'t you go ahead and hand that cargo over? | I hope you realize who you\'ve come to face, pathetic sellsword, so that you may best make sure your men make it to their beds tonight. All you need to do is hand over the cargo and we won\'t have to add you to the history of %mercband%. | Ah, I bet you\'d like to be a part of our history, wouldn\'t you? Well, good news, all you gotta do is not hand over that cargo and we\'ll scribble you in with our swords. Of course, you can escape the scribe\'s pen if you just give us that cargo. | Now, if it isn\'t the %companyname%. As much as I\'d like add you to our list of victories, I\'ll give you a chance here, mercenary to mercenary. All you have to do is hand over that cargo and we\'ll be on our way. How\'s that sound?}%SPEECH_OFF%{Hmm, well it was a bombastic request if nothing else. | Well, the theatrics were pretty entertaining if nothing else. | You don\'t quite understand the need for showmanship, but there\'s little doubt about the seriousness of this new situation you\'ve found yourself in. | While you appreciated the superlatives and hyperbole, there remains the very terse reality that these men do actually mean business.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "If you want it, come and take it!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "Mercs";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Mercenaries, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    },
                    {
                        Text = "It\'s not worth dying over. Take that damn cargo and be gone.",
                        function getResult()
                        {
                            return "Mercenaries2";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Mercenaries2",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{Not wanting a fight, you hand the chest over. They laugh as they take it off your hands.%SPEECH_ON%Good choice, mercenary. Maybe someday you\'ll be the one doing the threatening.%SPEECH_OFF% | The cargo, whatever it is, isn\'t worth the lives of your men. You hand the crate over and the mercenaries take it. They laugh at you as you leave.%SPEECH_ON%Like charming a whore!%SPEECH_OFF% | This does not seem like the time or place to be sacrificing your men in the name of %employer%\'s delivery service. You hand the cargo over. The mercenaries take it then make their leave, their lieutenant flipping you a crown that spins its way into the mud.%SPEECH_ON%Get yerself a shinebox, kid, this work ain\'t cut out for you.%SPEECH_OFF% | The mercenaries are well armed and you don\'t know if you could sleep at night knowing you spent the lives of your men just for some silly crate carrying the old gods know what. With a nod, you hand the chest over. The mercenary band gladly takes it from you, their lieutenant pausing to nod back with respect.%SPEECH_ON%A wise choice. Don\'t think I didn\'t make many like it when I was coming up.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Hrm...",
                        function getResult()
                        {
                            this.Flags.set("IsMercenaries", false);
                            this.Flags.set("IsMercenariesDialogTriggered", true);
                            this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail);
                            }

                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BountyHunters1",
                Title = "Along the road...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{While on the roads, you come across a band of bounty hunters. Their prisoner calls out to you, voice cracking, and begging for your mercy and claiming to be innocent. The bounty hunters tell you to fark off and die. | You\'re traveling the roads when you come across a group of well-armed bounty hunters. They\'re yanking along someone shackled from head to toe.%SPEECH_ON%You want no part of this fellow.%SPEECH_OFF%One man says, striking his prisoner in the back of the shins. The prisoner yelps and crawls to you on bloodied hands and knees.%SPEECH_ON%They\'re all liars! These men will kill me even though I\'ve done nothing wrong! Save me, gentlefolk, I beg of you!%SPEECH_OFF% | You come across a large band of bounty hunters, your two groups oddly mirroring one another, though your purposes in this world clearly diverge. They\'re transporting a prisoner who has been chained and mouth stuffed with a rag. The prisoner yells out to you, almost pleading, choking on words until red in the face. One of the bounty hunters spits.%SPEECH_ON%Pay no mind, stranger, and get on down the road. Best there be no trouble between men such as we.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "This isn\'t any of our business.",
                        function getResult()
                        {
                            return 0;
                        }

                    },
                    {
                        Text = "Perhaps we can buy the prisoner?",
                        function getResult()
                        {
                            return this.Math.rand(1, 100) <= 50 ? "BountyHunters1" : "BountyHunters1";
                        }

                    },
                    {
                        Text = "If you want it, come and take it!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "Mercs";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Mercenaries, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Thieves1",
                Title = "During camp...",
                Text = "[img]gfx/ui/events/event_05.png[/img]{You raise up from a nap and turn over, looking for the chest as though it were a lover. But she\'s not there and neither is the money. Quickly getting to your feet, you begin ordering the men to attention. %randombrother% runs up and says there are footprints leading off from the site. | While taking a rest, you hear a disturbance somewhere in the camp. You rush to it to find %randombrother% face down in the dirt, rubbing the back of his head.%SPEECH_ON%Sorry sir, I was taking a piss, and then they went on ahead and took it out of me. Also, they stole the package.%SPEECH_OFF%You ask the mercenary repeat that last part.%SPEECH_ON%Goddamn thieves have stolen the goods!%SPEECH_OFF%Time to track those bastards down and get it back. | Naturally, it wouldn\'t be an ordinary trip. No, this world is too shite for that to be the case. It appears thieves have taken off with the cargo. Luckily, they\'ve left a hell of a lot of evidence, namely footprints and dragmarks from toting the package around. They should be easy to find... | Just once you\'d like to have a nice walk from one town to the next. Instead, your agreement with %employer% has attracted trouble once again. Thieves, somehow, managed to sneak into the camp and make off with the cargo. The good news is that they didn\'t manage to sneak back out: you\'ve found their footprints and they won\'t be hard to follow.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We follow their tracks!",
                        function getResult()
                        {
                            this.Contract.setState("Running_Thieves");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Thieves2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{Thief blood runs thick. You manage to find your employer\'s goods still in the camp, all locked and safe. He doesn\'t need to know about this little excursion. | Well, everything\'s right where it should be. %employer%\'s cargo was found underneath a thief\'s writhing body. You made sure to kick him off before running him through. Wouldn\'t want to get blood on the package, after all. | Killing off the last of the thieves, you and the men spread out through the brigands\' camp looking for the package. %randombrother% spots it right quick, the container still held in the clutches of a dead fool. The mercenary fumbles with the corpse\'s grasp and, in frustration, simply cuts the arms off the bastard. You retrieve the package and hold it a little closer for the trip going forward. | Staring over the bodies of the felled thieves, you wonder if %employer% needs to know about this. The package looks alright. Some blood and bone on it, but you can rub that right off. | The package\'s a little scuffed, but it\'ll be fine. Alright, there\'s blood all over it and a thief\'s degloved finger is all smashed up into one of the latches. Those issues aside, everything is perfectly fine.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Back where it belongs.",
                        function getResult()
                        {
                            this.Flags.set("IsThieves", false);
                            this.Flags.set("IsStolenByThieves", false);
                            this.Contract.setState("Running");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{While on the move, you notice that something else is moving, too: the cargo. The lid on it is jumping around and there\'s a strange glow emerging from its sides. %randombrother% approaches, looks at it, then looks at you.%SPEECH_ON%Should we open it, sir? Or I can take it and throw it in the closest pond because none of that right there is alright.%SPEECH_OFF%You jab the man and ask if he\'s scared. | Moving along the paths, you begin to hear a low hum emanating from the package %employer% had given you. %randombrother% is standing beside it, poking it with a stick. You slap him back. He explains himself.%SPEECH_ON%Sir, there\'s something that ain\'t right with the cargo we\'re tugging...%SPEECH_OFF%You take a good look at it. There\'s a faint color brimming at the edges of the lid. As far as you know, fire can\'t breathe in such a space, and the only thing else that glows in the dark are the moons and the stars. You worry that curiosity is starting to get the better of you... | The cargo rests in the wagon beside you, jostling about to the tilts and turns of the paths. Suddenly, it begins to hum and you swear you saw the lid float upward for just a second. %randombrother% glances over.%SPEECH_ON%You alright, sir?%SPEECH_OFF%Just as he finishes talking, the lid explodes outward, a swirl of colors, mist, ash, fiery heat and brutish cold. You throw your arms up, shielding yourself, and when you take a peek through your elbows the package is completely still, the lid back on. You exchange a glance with the sellsword, then both of you stare at the cargo. This might be a little more than an ordinary delivery... | A low hum emanates from nearby. Thinking a bee hive nearby, you instinctively duck, only to realize the sound is coming from the cargo %employer% had handed you. The lid atop the container is rattling side to side, jostling the latches and nails that are supposed to keep it there. %randombrother% looks a little frightened.%SPEECH_ON%Let\'s just leave it here. That thing ain\'t right.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I want to know what\'s going on.",
                        function getResult()
                        {
                            return "EvilArtifact2";
                        }

                    },
                    {
                        Text = "Leave that thing alone.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact2",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_73.png[/img]{Curiosity gets the best of you. Slowly you start prying at the lid. %randombrother% takes a step back and protests.%SPEECH_ON%I think we should leave it alone, sir. I mean c\'mon, look at it.%SPEECH_OFF%Ignoring him, you tell the men it\'s going to be alright, and then you lift the lid up.\n\n It isn\'t alright. The explosion knocks you off your feet. Horrible shapes and shrieks swirl all around you. The men instinctively arm themselves as the piloted specters spear into the earth. There the ground lifts in mounds, and there, too, the earth begins to groan. You watch as hands shoot forth, dragging decrepit bodies from their pit. The dead live again and surely they mean to add to their ranks! | Against anyone\'s best judgment, you pry the cargo open. At first, there is nothing. It\'s just an empty box. %randombrother% nervously laughs.%SPEECH_ON%Well... I guess that\'s it then.%SPEECH_OFF%But that can\'t be it, can it? Why would %employer% have you delivering an empty container unless -- \n\n You wake up to a ringing slowly fading from your ears. Turning over, you see that the box has completely evaporated, a flurry of snowy sawdust all that remains of it. %randombrother% rushes over, picking you up and dragging you toward the rest of the company. They point, their mouths moving, shouting...\n\n A mob of well-armed men are... shuffling your way? As you get a better sight of them, you realize that they are armed with old wooden shields painted with odd spiritual rites, and their armor is of shapes and sizes you have never seen before, as though they were crafted by men just learning the trade, yet still well learned in what they had learned thus far. These are like ancients... the first men. | %randombrother% shakes his head as you go to pick up the lid. With some effort, it\'s pried open and you quickly step back, expecting the worst. But there\'s nothing. Not even a sound comes out of the box. You take a sword and rattle it around in the empty box, looking for a secret compartment or something. %randombrother% laughs.%SPEECH_ON%Hey, we\'re just delivering a bunch of air! And to think I thought that damned thing was too heavy!%SPEECH_OFF%Just then, the box lifts briefly into the air, spins, and smashes itself into the ground. It breaks perfectly, noiselessly, and with no wasted movements, every piece of wood laid against the grass like ancient stoneworks. An incorporeal shape leers up from the splintered rites, grinning as it twists.%SPEECH_ON%Oh humans, it is truly good to see you again.%SPEECH_OFF%The voice is like ice down your back. You watch as the specter shoots into the sky then slams back down, spearing into the very earth. Not a second passes before the ground is erupting as bodies begin to clamber out. | The box magnetizes you. Without hesitation, you crank the cargo open and take a look inside. You smell before you see - a horrid stench overwhelming you almost to the point of blindness. One of the men pukes. Another retches. When you look back at the box, blackened tendrils of smoke are sifting out of it, stretching long and far, probing the ground as they go. When they find what they\'re looking for, they dive into the earth, yanking up bones of dead men like a lure would a fish. | Ignoring the worries of a few of the men, you bust the package open. A pile of heads are to be found, their glowing eyes flickering awake. Their jaws crackle open, shifting from unmoved states to rattle in laughter. You quickly close the box, but a force pushes it back open. You struggle with it, %randombrother% and a few others trying to help, but it\'s almost as if the utterly silent winds of a storm are pushing back against you.\n\nA bare moment later, you\'re all thrown back, the lid of the crate soaring into the sky, ushered upward by a gust of blackened souls. They zip around, combing the earth, then collectively position opposite the %companyname%. There you watch in horror as the incorporeal begins to take shape, the foggy mists of souls hardening into the very real bones of souls lost long ago. And, of course, they come armed, the crackling jawbones still clattering with hollow laughter.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "EvilArtifact";
                            p.Music = this.Const.Music.UndeadTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;

                            if (this.Flags.get("IsCursedCrystalSkull"))
                            {
                                this.World.Flags.set("IsCursedCrystalSkull", true);
                                p.Loot = [
                                    "scripts/items/accessory/legendary/cursed_crystal_skull"
                                ];
                            }
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }

                            this.World.Contracts.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact3",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{The battle over, you quickly rush back over to the artifact, finding it floating in the air. %randombrother% runs up to your side.%SPEECH_ON%Destroy it, sir, before it causes any more trouble!%SPEECH_OFF% | Your men weren\'t the only thing to survive the battle - the artifact, or whatever remains of its pulsing power, floats innocently where you\'d last seen it. The thing is an orb swirling with energy, occasionally rattling, sometimes whispering a language you know not of. %randombrother% nods toward it.%SPEECH_ON%Smash it, sir. Smash it and let us be done with this horror.%SPEECH_OFF% | Such power was not meant for this world! The artifact has taken the shape of an orb the size of your fist. It floats off the ground, humming as though singing a song from another world. The thing almost seems to be waiting for you, like a dog would wait its master.%SPEECH_ON%Sir.%SPEECH_OFF%%randombrother% tugs on your shoulder.%SPEECH_ON%Sir, please, destroy it. Let us not take that thing another step with us!%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We have to destroy it.",
                        function getResult()
                        {
                            return "EvilArtifact4";
                        }

                    },
                    {
                        Text = "We\'re paid to deliver this, so that\'s what we\'ll do.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact4",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You take out your sword and stand before the artifact with the blade slowly raised over your head.%SPEECH_ON%Don\'t do it!%SPEECH_OFF%Glancing over your shoulder, you see %randombrother% and the other men scowling at you. Blackness surrounds them and the whole world as far as your eye can see. Their eyes glow red, pulsing furiously with every spoken word.%SPEECH_ON%You shall burn forever! Burn forever! Destroy it and you shall burn! Burn! BURN!%SPEECH_OFF%Screaming, you turn around and slice your sword through the relic. It splits effortlessly in two and a wave of color sweeps back into your world. Sweat pours from your forehead as you find yourself leaning on the pommel of your weapon. You look back to see your mercenary company staring at you.%SPEECH_ON%Sir, are you alright?%SPEECH_OFF%You sheathe your sword and nod, but you\'ve never felt so horrified in all your life. %employer% won\'t be happy, but he and his anger be damned! | Just as soon as the thought of destroying the relic crosses your mind, so too does a wave of horrified screaming. The shrill crying of women and children, their voices cracking with terror as though they had come running at you all on fire. They scream at you in hundreds of languages, but every so often the one you know passes you and it\'s always with the same word: DON\'T.\n\n You draw your sword and swing it back over your head. The artifact hums and vibrates. Smoky tendrils waft off it and a brutish heat washes over you. DON\'T.\n\n You steady your grip.\n\n Davkul. Yekh\'la. Imshudda. Pezrant. DON\'T.\n\nYou swallow and steady your aim.\n\n DON\'T.RAVWEET.URRLA.OSHARO.EBBURRO.MEHT\'JAKA.DON\'T.DON\'T.DON\'T.DO--\n\n The strike is true, the word is lost, the artifact falls to the earth in twine. You fall with it, to your knees, and a few of the company\'s brothers come to lift you back up. %employer% won\'t be happy, but you can\'t help but feel as though you\'ve spared this world a horror it need not ever see or hear.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "It\'s done.",
                        function getResult()
                        {
                            this.Flags.set("IsEvilArtifact", false);
                            this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
                            }

                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EvilArtifact5",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_55.png[/img]{You shake your head and get another crate, carefully pushing the floating artifact into it then closing the lid. %employer% was paying you good money and, well, you plan on seeing it through. But for some reason you\'re not sure if that choice is your own, or if this strange relic\'s whispering is guiding your hand for you. | You go and retrieve a wooden chest and lift it up to the artifact, quickly closing the lid over it. A few of the mercenaries shake their head. It\'s probably not the best of ideas, but for some reason you fill compelled to finish your task. | Better judgment says you should destroy this horrible relic, but better judgment fails once more. You take a wooden chest and move it over the artifact before closing the lid and snapping shut the latches. You\'ve no idea what you are doing this, but your body is filled with newfound energy as you get ready to get back on the road.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We should move on.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "EnragingMessage1",
                Title = "Arriving without the crowns",
                Text = "[img]gfx/ui/events/event_43.png[/img]{You arrive at the destination, but without the coins. %SPEECH_ON%Where is the coin?%SPEECH_OFF% they ask, but you shrug and say you spent it already. Most of the villagers look shocked and angry, a few sigh in disapointment and one begins crying as they realise this means no food.  %SPEECH_ON%Get out you filthy cold hearted mercenaries!  Don\'t you ever come back you scum!! %SPEECH_OFF% }  ",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Maybe we shouldn\'t have spent their money",
                        function getResult()
                        {
                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 4, "spent all their money instead of delivering it");
                            }

                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "At %objective%",
                Text = "[img]gfx/ui/events/event_20.png[/img]{%recipient%\'s waiting for you as you enter the town. He hurriedly takes the chest off your hands.%SPEECH_ON%Oh, ohhh I did not think you would get here.%SPEECH_OFF%His grubby fingers dance along the chest carrying the cargo. He turns around and barks an order to one of his men. They step forward and hand you a satchel of crowns. | Finally, you\'ve made it. %recipient% is standing there in the middle of the road, his hands clasped over his stomach, a slick grin on his cheeky face.%SPEECH_ON%Sellsword, I was not sure you\'d make it.%SPEECH_OFF%You lug the cargo up and hand it over.%SPEECH_ON%Oh yeah, and why do you say that?%SPEECH_OFF%The man takes the box and hands it off to a robed man who quickly hurries away with it tucked under an arm. %recipient% laughs as he hands you a satchel of crowns.%SPEECH_ON%The roads are rough these days, are they not?%SPEECH_OFF%You understand he\'s making small talk, anything to get your attention off the cargo you just handed over. Whatever, you got your pay, that\'s good enough for you. | %recipient% welcomes you and a few of his men hurry over to take the cargo. He claps you on the shoulders.%SPEECH_ON%I take it your journey went well?%SPEECH_OFF%You spare him the details and inquire about your pay.%SPEECH_ON%Bah, a sellsword through and through. %randomname%! Get this man what he deserves!%SPEECH_OFF%One of %recipient%\'s bodyguards walks over and hands you a small chest of crowns. | After some looking, a man asks who you\'re looking for. When you say %recipient%, he points you out toward a nearby paddock where a man is strutting about on a rather opulent looking horse.\n\n You walk on over and the man rears the steed and asks if that\'s the cargo %employer% sent. You nod.%SPEECH_ON%Leave it there at your feet. I\'ll come and get it.%SPEECH_OFF%You don\'t, instead asking about your pay. The man sighs and whistles to a bodyguard who hurries over.%SPEECH_ON%See to it that this sellsword gets the pay he deserves.%SPEECH_OFF%Finally, you put the crate on the ground and make your leave.} ",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = false,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            local contractValue = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getInAdvance();
                            this.World.Assets.addMoney(contractValue * -1);
                            local playerRoster = this.World.getPlayerRoster().getAll();
                            local xp = this.Contract.m.Payment.getOnCompletion() * 0.25;

                            foreach( bro in playerRoster )
                            {
                                bro.addXP(xp);
                                bro.updateLevel();
                            }

                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Delivered some cargo");
                            local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

                            if (recipientFaction != null)
                            {
                                recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Delivered the crowns");
                            }

                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local xpGained = this.Math.round(this.Contract.m.Payment.getOnCompletion() * 0.25 * this.Const.Combat.GlobalXPMult);
                    this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns and [color=" + this.Const.UI.Color.PositiveEventValue + "]" + xpGained + "[/color] Experience"
                    });
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/destroy_goblin_camp_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Destroy " + this.Flags.get("DestinationName") + " %direction% of %origin%"
                    ];

                    if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
                    {
                        this.Contract.setScreen("Intro");
                    }
                    else
                    {
                        this.Contract.setScreen("Task");
                    }
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    this.Contract.m.Destination.clearTroops();
                    this.Contract.m.Destination.setLastSpawnTimeToNow();

                    if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
                    {
                        this.Contract.m.Destination.getLoot().clear();
                    }

                    this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
                    this.Contract.m.Destination.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

                    if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
                    {
                        this.Flags.set("IsBetrayal", true);
                    }
                    else
                    {
                        local r = this.Math.rand(1, 100);

                        if (r <= 20 && this.World.Assets.getBusinessReputation() > 1000)
                        {
                            if (this.Contract.getDifficultyMult() >= 0.95)
                            {
                                this.Flags.set("IsAmbush", true);
                            }
                        }
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
                    {
                        if (this.Flags.get("IsBetrayal"))
                        {
                            if (this.Flags.get("IsBetrayalDone"))
                            {
                                this.Contract.setScreen("Betrayal2");
                                this.World.Contracts.showActiveContract();
                            }
                            else
                            {
                                this.Contract.setScreen("Betrayal1");
                                this.World.Contracts.showActiveContract();
                            }
                        }
                        else
                        {
                            this.Contract.setScreen("SearchingTheCamp");
                            this.World.Contracts.showActiveContract();
                            this.Contract.setState("Return");
                        }
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerAttacking = true )
                {
                    if (this.Flags.get("IsAmbush"))
                    {
                        if (!this.Flags.get("IsAttackDialogTriggered"))
                        {
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.setScreen("Ambush");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.LocationTemplate = null;
                            p.CombatID = "Ambush";
                            p.Music = this.Const.Music.GoblinsTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Contract.m.Destination.getFaction());
                            p.Parties.push(party);
                            party.EL_setTroopsResourse(party.EL_getTroopsResourse() * 0.5);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.GoblinRaiders, 50 * this.Contract.getScaledDifficultyMult(), this.Contract.m.Destination.getFaction());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, false, false);
                        }
                    }
                    else
                    {
                        this.World.Contracts.showCombatDialog();
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "Betrayal")
                    {
                        this.Flags.set("IsBetrayalDone", true);
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "Betrayal")
                    {
                        this.Flags.set("IsBetrayalDone", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success1");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_61.png[/img]{%employer%\'s reading a scroll when you enter. He waves you off, perhaps thinking you\'re just a servant. You clank your scabbard against the wall. The man glances up, then quickly drops his papers.%SPEECH_ON%Ah, sellsword! It is good to see you. I have a problem specifically for a man of your... proclivities.%SPEECH_OFF%He pauses as if expecting your input. When you\'ve none, he awkwardly continues.%SPEECH_ON%Yes, of course, the task. There are goblins %direction% of %origin% who have established something of a foothold. I\'d take myself and some of my knights to go take care of it, but as it turns out, \'killing gobbos\' is beneath those men. Hogwash, I say. I think they just don\'t want to die at the hands of the stunty little gits. Honor, valor, all that.%SPEECH_OFF%He smirks and raises a hand.%SPEECH_ON%But it\'s not beneath you, so long as the pay is right, yes?%SPEECH_OFF% | %employer%\'s yelling at a man leaving his room. When he settles down, he bids you a fair greeting.%SPEECH_ON%Farkin\' hell, it\'s good to see you. Do you have any notion as to how hard it is to get your \'loyal\' men to go kill some goblins?%SPEECH_OFF%He spits and wipes his mouth on his sleeve.%SPEECH_ON%Apparently it is not the most noble of tasks. Something about how those little gits don\'t ever fight fair. Can you believe that? Men telling me, a highborn nobleman, what is \'noble\' or not. Well, there it is anyway, sellsword. I need you to go %direction% of %origin% and root out some goblins that have set up a camp. Can you do that for me?%SPEECH_OFF% | %employer%\'s unsheathing and sheathing a sword. He seems to look at himself in the blade\'s reflection before snapping it away again.%SPEECH_ON%The peasants are badgering me again. They say there are goblins camping at a place called %location% %direction% of %origin%. I\'ve no reason to disbelieve them after a young boy was brought to my feet today, a poison dart in his neck.%SPEECH_OFF%He slams the sword into its scabbard.%SPEECH_ON%Are you willing to take care of this problem for me?%SPEECH_OFF% | Red in the face, a drunken %employer% slams a mug down when you enter his room.%SPEECH_ON%Sellsword, right?%SPEECH_OFF%His guard looks in and nods. The nobleman laughs.%SPEECH_ON%Oh. Good. More men to send to their deaths.%SPEECH_OFF%He pauses before bursting into laughter.%SPEECH_ON%I joke, what a joke, right? We are having an issue with some goblins %direction% of %origin%. I need you to go take care of them, are you -hic- up for that or should I go ask someone else to dig their own... I mean...%SPEECH_OFF%He shuts himself up with another drink. | %employer%\'s comparing two scrolls when you enter.%SPEECH_ON%My taxmen are falling a little short these days. A shame, though I guess it\'s good business for you now that I can\'t afford to send my so called \'loyal\' knights anywhere.%SPEECH_OFF%He throws the papers aside and tents his hands over his table.%SPEECH_ON%My spies are reporting goblins have set up camp at a place they call %location% %direction% of %origin%. I need you to go there and do what my bannermen refuse to do.%SPEECH_OFF% | %employer% breaks bread as you enter, but he doesn\'t share any. He dips both ends into a goblet of wine and stuffs his mouth. He speaks, but it\'s more crumbs than words.%SPEECH_ON%Good seeing you, sellsword. I have some goblins %direction% of %origin% that need rooting out. I\'d send my knights to go take care of them, but they\'re, uh, a little more important and less expendable. I\'m sure you understand.%SPEECH_OFF%He manages to stuff the rest of the bread into his ugly maw. For a moment, he chokes, and for a moment you consider shutting the door and letting this end here and now. Unfortunately, his throes of anguish garner the attention of a guard who swoops in and slams the nobleman in the chest, spilling the hazard right out in all its goopy, near-assassinating glory. | When you find %employer%, he\'s sending off a few knights, chasing them out the door with a few parting curses. The sight of you, however, seems to momentarily settle the man.%SPEECH_ON%Sellsword! Good to see you! Better you than those so-called \'men\'.%SPEECH_OFF%He takes a seat and pours himself a drink. He takes a sip, stares at it, then downs it all in one go.%SPEECH_ON%My loyal bannermen refuse to go take on the goblins which have camped %direction% of %origin%. They talk of ambushes, poison, all that...%SPEECH_OFF%His speech is increasingly slurred.%SPEECH_ON%Well... -hic-, you know all that, right? And you know what I\'m asking next, right? Of - of course you do, -hic-, I need you to hand me another drink! Ha, kidding. Go kill those goblins, wouldya?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{Fighting goblins won\'t come cheap. | I trust you\'ll pay amply for this. | Let\'s talk money.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{This isn\'t worth it. | We have other obligations.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Ambush",
                Title = "Approaching the camp...",
                Text = "[img]gfx/ui/events/event_48.png[/img]{You enter the goblin camp to find it empty. But you know better - you know you\'ve just walked into a trap. Just then, the damned greenskins emerge from all around you. With the loudest warcry you can muster, you order the men to prepare for battle! | The goblins have fooled you! They left the camp and maneuvered back around, encircling you. Prepare the men carefully, because this trap will not be easy to escape. | You should have known better: you\'ve stepped right into a goblin trap! They have their soldiers placed all around while the company is standing around like a bunch of sheep to the slaughter!}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Watch out!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Betrayal1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_78.png[/img]{As you finish the last goblin you are suddenly greeted by a heavily armed group of men. Their lieutenant steps forward, his thumbs hooked into a belt holding up a sword.%SPEECH_ON%Well, well, you really are stupid. %employer% does not forget easily - and he hasn\'t forgotten the last time you betrayed him. Consider this a little... return of the favor.%SPEECH_OFF%Suddenly, all the men behind the lieutenant charge forth. Arm yourselves, this was an ambush! | Cleaning gobbo blood off your sword, you suddenly spot a group of men walking toward you. They\'re carrying %employer%\'s banner and are drawing their weapons. The realization that you\'ve been setup dawns on you just as the men begin to charge. They let you fight the goblins first, the bastards! Let them have it! | A man seemingly from nowhere comes to greet you. He\'s well armed, well armored, and apparently quite happy, grinning sheepishly as he approaches.%SPEECH_ON%Evening, mercenaries. Good work on those greenskins, eh?%SPEECH_OFF%He pauses to let his smile fade.%SPEECH_ON%%employer% sends his regards.%SPEECH_OFF%Just then, a group of men swarm out from the sides of the road. It\'s an ambush! That damned nobleman has betrayed you! | A group of armed men wearing the colors of %faction% fall in behind you, the group fanning out to stare at your company. Their leader sizes you up.%SPEECH_ON%I\'m going to enjoy prying that sword from your cold, dead hands.%SPEECH_OFF%You shrug and ask why you\'ve been setup.%SPEECH_ON%%employer% doesn\'t forget those who doublecross him or the house. That\'s about all you need to know. Not like anything I say here will do you good when you\'re dead.%SPEECH_OFF%To arms, then, for this is an ambush! | Your men scour the goblin camp and find not a soul. Suddenly, men in the colors of %faction% appear behind you, the lieutenant of the group walking forward with ill intent. He\'s got a cloth embroidered with %employer%\'s sigil.%SPEECH_ON%A shame those greenskins couldn\'t finish you off. If you\'re wondering why I\'m here, it is to collect a debt owed to %employer%. You promised a task well done. You could not own up to that promise. Now you die.%SPEECH_OFF%You unsheathe your sword and flash its blade at the lieutenant.%SPEECH_ON%Looks like %employer% is about to have another promise broken.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Take up arms!",
                        function getResult()
                        {
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
                            local tile = this.World.State.getPlayer().getTile();
                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
                            p.Tile = tile;
                            p.CombatID = "Betrayal";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Contract.getFaction());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Noble, 140 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Betrayal2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{You wipe your sword on your pant leg and quickly sheathe it. The ambushers lay dead, skewered into this grotesque pose or that one. %randombrother% walks up and inquires what to do now. It appears that %faction% isn\'t going to be on the friendliest of terms. | You kick the dead body of an ambusher off the end of your sword. It appears %faction% isn\'t going to be on the friendliest of terms from now on. Maybe next time, when I agree to do something for these people, I actually do it. | Well, if nothing else, what can be learned from this is to not agree to a task you can\'t complete. The people of these land are not particularly friendly to those who fall short of their promises... | You betrayed %faction%, but that\'s not something to dwell on. They betrayed you, that\'s what is important now! And going into the future, you best be suspicious of them and anyone who flies their banner. | %employer%, judging by the dead bannermen at your feet, appears to no longer be happy with you. If you were to guess, it\'s because of something you did in the past - doublecross, failure, back-talking, sleeping with a nobleman\'s daughter? It all runs together that you try and think about it. What\'s important now is that this wedge between you two will not be easily healed. You best be wary of %faction%\'s men for a little while.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "So much for getting paid...",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SearchingTheCamp",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_83.png[/img]{Having slain the last of the goblins, you take a peek about their encampment. They seem the merry sort - piles of trinkets and instruments, all of which could double as a weapon. All it\'d require would be to dip them in the giant pot of poison resting right in the middle of the ruins. You kick it over and tell the men to get ready to head back to %employer%, your employer. | The goblins put up a good, crafty fight, but you\'ve managed to kill them all. Their camp set aflame, you order the men to get ready to return to %employer% with the good news. | While the short-greenskins put up a hell of a fight, your company managed a better one. The last of the goblins slain, you take a look around their ruined encampment. It appears they were not totally alone - there\'s evidence that other goblins ran off while the fighting was going on. Maybe family? Children? No matter, it\'s time to return to %employer%, the man who hired you. | Ah, it was a good fight. %employer% will be expecting to hear word of it now. | No wonder men do not wish to fight goblins, they put up a fight far beyond their stature. A shame one could not put their minds into a man, but perhaps it is for the best that such ferocity is contained within such small beings!}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to collect our pay.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You enter %employer%\'s room and drop a few goblin heads on the floor. He glances at them.%SPEECH_ON%Huh, they\'re actually a lot bigger than the scribes tell.%SPEECH_OFF%With a few words you report the destruction of the greenskins\' encampment. The nobleman nods, rubbing his chin.%SPEECH_ON%Excellent. Your pay, as promised.%SPEECH_OFF%He hands over a satchel of %reward_completion% crowns. | %employer%\'s throwing rocks at a skittish cat when you enter. He glances at you, giving the poor creature the slightest opening to escape out a window. The nobleman chases it out with a few rocks, thankfully missing with every one.%SPEECH_ON%Good to see you, sellsword. My spies have already told me of your doings. Here\'s your pay, as agreed upon.%SPEECH_OFF%He slides a wooden chest of %reward_completion% crowns across his table. | %employer%\'s shucking nuts when you return. He throws the shells on the ground, jawing and gnashing as he speaks.%SPEECH_ON%Oy, it\'s good to see you again. I take it you were successful, yes?%SPEECH_OFF%You lift a few goblin heads up, each one tethered to a unifying band. They twist and stare at the room and at one another. The man puts his hand up.%SPEECH_ON%Please, we are dignified people here. Put that way.%SPEECH_OFF%You shrug and hand them to %randombrother% who is waiting out in the hall. %employer% walks around his table and hands you a satchel.%SPEECH_ON%%reward_completion% crowns, as agreed upon. Good job, sellsword.%SPEECH_OFF% | %employer% laughs when he sees you come in with the goblin head.%SPEECH_ON%Hell, man, don\'t be bringing those in here. Give \'em to the dogs.%SPEECH_OFF%He\'s a bit drunk. You\'re not sure if he\'s elated that you were successful or if he\'s just naturally merry with a bit of ale in him.%SPEECH_ON%Your payment was -hic- %reward_completion% crowns, right?%SPEECH_OFF%You think to \'alter\' the details, but a guard outside looks in on the talks and shakes his head. Oh well, looks like it was %reward_completion% crowns then. | When you return to %employer% he\'s got a woman over his legs. In fact, she\'s bent over and his hand is in the air. They both stare at you, pausing, then she quickly scurries under his table and he straightens up.%SPEECH_ON%Sellsword! It\'s good to see you! I take it you were successful destroying those greenskins, yes?%SPEECH_OFF%The poor lady bumps her head underneath the desk, but you try to pay it no mind as you inform the man of the expedition\'s success. He claps his hands, looks to stand, then thinks better of it.%SPEECH_ON%If you would, your payment of %reward_completion% crowns is on the bookshelf behind me.%SPEECH_OFF%He smiles awkwardly as you retrieve it.}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a goblin encampment");
                            this.World.Contracts.finishActiveContract();

                            if (this.World.FactionManager.isGreenskinInvasion())
                            {
                                this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
                            }

                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/destroy_orc_camp_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Destroy " + this.Flags.get("DestinationName") + " %direction% of %origin%"
                    ];

                    if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
                    {
                        this.Contract.setScreen("Intro");
                    }
                    else
                    {
                        this.Contract.setScreen("Task");
                    }
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    this.Contract.m.Destination.clearTroops();
                    this.Contract.m.Destination.setLastSpawnTimeToNow();

                    if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
                    {
                        this.Contract.m.Destination.getLoot().clear();
                    }

                    this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
                    this.Contract.m.Destination.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
                    this.Flags.set("HeadsCollected", 0);

                    if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
                    {
                        this.Flags.set("IsBetrayal", true);
                    }
                    else
                    {
                        local r = this.Math.rand(1, 100);

                        if (r <= 5)
                        {
                            this.Flags.set("IsSurvivor", true);
                        }
                        else if (r <= 15 && this.World.Assets.getBusinessReputation() > 800)
                        {
                            if (this.Contract.getDifficultyMult() >= 0.95)
                            {
                                this.Flags.set("IsOrcsAgainstOrcs", true);
                            }
                        }
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
                    {
                        if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
                        {
                            this.Contract.setScreen("Volunteer1");
                            this.World.Contracts.showActiveContract();
                            this.Contract.setState("Return");
                        }
                        else if (this.Flags.get("IsBetrayal"))
                        {
                            if (this.Flags.get("IsBetrayalDone"))
                            {
                                this.Contract.setScreen("Betrayal2");
                                this.World.Contracts.showActiveContract();
                            }
                            else
                            {
                                this.Contract.setScreen("Betrayal1");
                                this.World.Contracts.showActiveContract();
                            }
                        }
                        else
                        {
                            this.Contract.setScreen("SearchingTheCamp");
                            this.World.Contracts.showActiveContract();
                            this.Contract.setState("Return");
                        }
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerAttacking = true )
                {
                    if (this.Flags.get("IsOrcsAgainstOrcs"))
                    {
                        if (!this.Flags.get("IsAttackDialogTriggered"))
                        {
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.setScreen("OrcsAgainstOrcs");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            p.CombatID = "OrcAttack";
                            p.Music = this.Const.Music.OrcsTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
                            p.IsAutoAssigningBases = false;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Const.Faction.Enemy);
                            p.Parties.push(party);
                            party.EL_setTroopsResourse(party.EL_getTroopsResourse() * 0.5);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.OrcRaiders, 150 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                        }
                    }
                    else
                    {
                        local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                        p.CombatID = "OrcAttack";
                        p.Music = this.Const.Music.OrcsTracks;
                        this.World.Contracts.startScriptedCombat(p, true, true, true);
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "Betrayal")
                    {
                        this.Flags.set("IsBetrayalDone", true);
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "Betrayal")
                    {
                        this.Flags.set("IsBetrayalDone", true);
                    }
                }

                function onActorKilled( _actor, _killer, _combatID )
                {
                    if (_combatID == "OrcAttack" || this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Destination.getTile()) <= 1)
                    {
                        if (_actor.getFaction() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
                        {
                            this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
                        }
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success1");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationPerHead);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% huffs and puffs.%SPEECH_ON%Goddammit.%SPEECH_OFF%He goes to his window, looking out it.%SPEECH_ON%I had a jousting tournament recently and there was a bit of a controversy. Now, none of my knights will fight for me until it\'s taken care of.%SPEECH_OFF%You ask if you want sellswords to settle a dispute amongst nobility. The man bursts into laughter.%SPEECH_ON%Gods no, lowborn. I need you to handle some greenskins that are camping %direction% of %origin%. They\'ve been terrorizing the region for awhile now and I\'d like you to return the favor. Does that sound like something you\'re interested in, or should I have to go talk to another sword for hire?%SPEECH_OFF% | %employer% kicks his feet up on his table.%SPEECH_ON%Any opinions on greenskins, sellsword?%SPEECH_OFF%You shake your head no. The man tilts his head.%SPEECH_ON%Interesting. Most say they\'re afraid, or that they\'re nasty brutes who can cleave a man in two. But you... you\'re different. I like it. What say you go %direction% of %origin% to a place the locals have dubbed %location%? We\'ve sighted a large band of orcs there that need scattering.%SPEECH_OFF% | A cat is on %employer%\'s table. He pets it, the feline scrunching up to the scratch, but then it suddenly hisses, bites the man, and sprints out the door you just came through. %employer% dusts himself off.%SPEECH_ON%Farkin\' animals. One moment they love you, the next, well...%SPEECH_OFF%He sucks on a drop of blood coming from his thumb. You ask if you should come back so he can nurse himself back to health.%SPEECH_ON%Very funny, sellsword. No, what I want you to do is go %direction% of %origin% and take on a group of greenskins inhabiting those parts. We need them destroyed, scattered, whatever word you like so long as they\'re \'gone\'. Does that sound like something you could do for us?%SPEECH_OFF% | %employer%\'s rolling up a scroll as he explains his predicament.%SPEECH_ON%A dispute amongst the nobility has me short on good, fighting men. Unfortunately, a band of greenskins have chosen this exact moment to come into these parts. They\'re camping to the %direction% of %origin%. I can\'t get the house in order while simultaneously being raided by these damned things, so I\'m mighty hopeful that this interests you, mercenary...%SPEECH_OFF% | %employer% looks you up and down.%SPEECH_ON%You fit enough to take on a greenskin? What about your men?%SPEECH_OFF%You nod and pretend the hassle would be no more than retrieving a cat from a tree. %employer% smiles.%SPEECH_ON%Good, because I got a whole bunch of them being sighted to the %direction% of %origin%. Go there and destroy them. Simple enough, right? Surely it interests a man of your... confidence.%SPEECH_OFF% | %employer% tends to his dogs, feeding each one a meal some peasants would kill for. He claps his hands of the meaty grease.%SPEECH_ON%My chef made that, can you believe it? Horrid. Disgusting.%SPEECH_OFF%You nod as though you could possibly understand what world this man lives in where shoveling good food to dogs is normal. %employer% pitches his elbows onto his table.%SPEECH_ON%Anyway, the folks who deliver meat to us are reporting that greenskins are killing their cows. Apparently, a camp has been sighted %direction% of %origin%. If you\'re interested, I\'d like you to go there and destroy them all.%SPEECH_OFF% | You find %employer% staring over some scrolls. He glances up at you and offers a chair.%SPEECH_ON%Glad you\'re here, mercenary. I\'ve got an issue with greenskins in these parts - they\'ve made camp %direction% from here.%SPEECH_OFF%He lowers one of the scrolls.%SPEECH_ON%And I can\'t afford to send my own men. Knights are rather... unexpendable. You, however, are just right for the job. What do you say?%SPEECH_OFF% | As you enter %employer%\'s office, a group of men leave. They\'re knights, their scabbards clinking just beneath their garbs. %employer% welcomes you in.%SPEECH_ON%Don\'t worry about them. They\'re just wondering what happened to the last man I hired.%SPEECH_OFF%You raise an eyebrow. The man waves it off.%SPEECH_ON%Oh don\'t give me that shit, sellsword. You know the business as well as I do, sometimes you guys fall short and you know that means...%SPEECH_OFF%You say nothing, but after a pause, give him a nod.%SPEECH_ON%Good, glad you understand. If you want to know, I\'ve got greenskins out %direction% of %origin%. They\'ve set up camp which I presume hasn\'t moved since I last, uh, sent some men there. Are you interested in rooting them out for me?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{Fighting orcs won\'t come cheap. | I trust you\'ll pay amply for this. | Let\'s talk money.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{This isn\'t worth it. | We have other obligations.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "OrcsAgainstOrcs",
                Title = "Before the attack...",
                Text = "[img]gfx/ui/events/event_49.png[/img]{As you order your men to attack, they come across a number of orcs... fighting each other? The greenskins appear to be divided, and they are settling their differences by dividing one another in half. It\'s a gruesome display of violence. When you figure to let them fight it out, two of the orcs battle their way toward you, and soon enough every orc is staring at you. Well, no running now... to arms! | You order the %companyname% to attack, believing you\'ve gained the upperhand on the orcs. But they\'re already armed! And... fighting one another?\n\n One orc cleaves another orc in twine, and another crushes the head of another. This seems to be some sort of clan conflict. A shame you didn\'t wait a moment longer for these brutes to settle their differences, now it\'s a free for all! | The orcs are battling one another! It\'s some sort of greenskinned fracas which you\'ve made yourself a part of. Orc against orc against man, what a sight to behold! Get the men close together and you might just make it out of this goatfark alive. | By the gods, the orcs are greater numbers than you ever could have thought! Luckily, they seem to be murdering one another. You don\'t know if they\'re separate clans or if this is just greenskins\' version of a drunken brawl. Regardless, you\'re in the middle of it now!}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To Arms!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Betrayal1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_78.png[/img]{As you finish the last orc you are suddenly greeted by a heavily armed group of men. Their lieutenant steps forward, his thumbs hooked into a belt holding up a sword.%SPEECH_ON%Well, well, you really are stupid. %employer% does not forget easily - and he hasn\'t forgotten the last time you betrayed %faction%. Consider this a little... return of the favor.%SPEECH_OFF%Suddenly, all the men behind the lieutenant charge forth. Arm yourselves, this was an ambush! | Cleaning orc blood off your sword, you suddenly spot a group of men walking toward you. They\'re carrying %faction%\'s banner and are drawing their weapons. The realization that you\'ve been setup dawns on you just as the men begin to charge. They let you fight the orcs first, the bastards! Let them have it! | A man seemingly from nowhere comes to greet you. He\'s well armed, well armored, and apparently quite happy, grinning sheepishly as he approaches.%SPEECH_ON%Evening, mercenaries. Good work on those greenskins, eh?%SPEECH_OFF%He pauses to let his smile fade.%SPEECH_ON%%employer% sends his regards.%SPEECH_OFF%Just then, a group of men swarm out from the sides of the road. It\'s an ambush! That damned nobleman has betrayed you! | The battle is barely over that a group of armed men wearing the colors of %faction% fall in behind you, the group fanning out to stare at your company. Their leader sizes you up.%SPEECH_ON%I\'m going to enjoy prying that sword from your cold grip.%SPEECH_OFF%You shrug and ask why you\'ve been setup.%SPEECH_ON%%employer% doesn\'t forget those who doublecross him or his house. That\'s about all you need to know. Not like anything I say here will do you good when you\'re dead.%SPEECH_OFF%To arms, then, for this is an ambush! | Your men scour the orc camp and find not a soul. Suddenly, a few strangers appear behind you, the lieutenant of the group walking forward with ill intent. He\'s got a cloth embroidered with %employer%\'s sigil.%SPEECH_ON%A shame those orcs couldn\'t finish you off. If you\'re wondering why I\'m here, it is to pay a debt owed to %faction%. You promised a task well done. You could not own up to that promise. Now you die.%SPEECH_OFF%You unsheathe your sword and flash its blade at the lieutenant.%SPEECH_ON%Looks like %faction% is about to have another promise broken.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Take up arms!",
                        function getResult()
                        {
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
                            local tile = this.World.State.getPlayer().getTile();
                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
                            p.Tile = tile;
                            p.CombatID = "Betrayal";
                            p.Music = this.Const.Music.NobleTracks;
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Contract.getFaction());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Noble, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Betrayal2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{You wipe your sword on your pant leg and quickly sheathe it. The ambushers lay dead, skewered into this grotesque pose or that one. %randombrother% walks up and inquires what to do now. It appears that %faction% isn\'t going to be on the friendliest of terms. | You kick the dead body of an ambusher off the end of your sword. It appears %faction% isn\'t going to be on the friendliest of terms from now on. Maybe next time, when I agree to do something for these people, I actually do it. | Well, if nothing else, what can be learned from this is to not agree to a task you can\'t complete. The people of these land are not particularly friendly to those who fall short of their promises... | You betrayed %faction%, but that\'s not something to dwell on. They betrayed you, that\'s what is important now! And going into the future, you best be suspicious of them and anyone who flies their banner. | %employer%, judging by the dead bannermen at your feet, appears to no longer be happy with you. If you were to guess, it\'s because of something you did in the past - doublecross, failure, back-talking, sleeping with a nobleman\'s daughter? It all runs together that you try and think about it. What\'s important now is that this wedge between you two will not be easily healed. You best be wary of %faction%\'s men for a little while.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "So much for getting paid...",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SearchingTheCamp",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_32.png[/img]{The battle over, you search the orc camp. Amongst the ruins, you find what appears to be heavy armor and human weapons in a very unusable state. Sadly, you do not find those they perhaps once belonged to. | With the orcs slain, you take a look around their camp. It\'s full of shite. Literally, shite is everywhere. The damned things don\'t know a thing about cleanliness. %randombrother% waddles up, wiping his boot on a tentpost.%SPEECH_ON%Sir, shall we move on or keep looking...?%SPEECH_OFF%You\'ve seen, and smelled, enough. | The orc camp is a wasteland filled with all manner of depravity. You can smell their sex and waste. It\'s no wonder they\'re so warlike, for they know not even the beginnings of what a civilized man understands. | The orc camp is destroyed, but you take a moment to sift through the ruins. Amidst the ashen pit of a campfire you find a few human corpses. Judging by their arms, they seem to have been mercenaries like yourself. A shame... that none of their gear is useful now that it\'s all burned up. | A few of your mercenaries walk through the ruins of the orc camp. They pick about the remains, turning up this or that unusable trinket. %randombrother% sheathes his bloody sword.%SPEECH_ON%Naught all here, sir.%SPEECH_OFF%You nod and get the men ready to return to %employer%. | The battle over, you trundle about the camp, looking for anything useful. You find nothing you can take, but you do find a stack of dead knights. Their pale, wormed and maggot-buggered faces suggest they\'d been there awhile. Who knows what the orcs were doing with them.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to collect our pay.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Volunteer1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_32.png[/img]{The battle\'s over, but you still hear screaming. You tell %randombrother% to shut it, as he is somewhat predisposed to the random growl or yelp, but he shakes his head and says it\'s not him. Just then, a shackled man rises up out of a pile of ashes that used to be the orc camp.%SPEECH_ON%Evening, fine sirs! I do believe you have freed me.%SPEECH_OFF%He stumbles forth, a ghostly, twisting cloud of ash spinning off behind him.%SPEECH_ON%I am quite grateful, obviously, and I\'d like to repay the favor. You\'re mercenaries, correct? If so, I\'d like to fight for you.%SPEECH_OFF%He picks a blade up off the ground and twirls it around in hand, weaving it as though it had been his since birth. An interesting offer that just got more interesting... | Cleaning your blade, a voice pipes in from a collapsed orcish tent.%SPEECH_ON%Good sirs, you\'ve done it!%SPEECH_OFF%You watch as a grinning man emerges.%SPEECH_ON%You\'ve freed me! And I\'d like to repay that service you\'ve done by offering my hand!%SPEECH_OFF%He holds his hand out, pauses, then takes it back.%SPEECH_ON%I mean to fight for you! I\'d like to fight for you, sir! If you can do all this, then surely I\'d be in good company, right?%SPEECH_OFF%Hmm, an interesting offer. You toss him a weapon and he catches with ease. He twists the handle about, twirling it hand-over-hand before trying to sheathe it into an invisible scabbard.%SPEECH_ON%The name\'s %dude_name%.%SPEECH_OFF% | A man in tattered and dented armor comes sprinting toward you. His arms are tied behind his back.%SPEECH_ON%You did it! I can\'t believe it! Sorry, let me explain my immodesty. I was captured by the orcs a day ago as we tried to take the camp. I think they were about to put me on a spit when you showed up. I took the first moment I could to make my escape, but now I see you and your group might be worth joining.%SPEECH_OFF%You ask the man to get to the point. He does.%SPEECH_ON%I\'d like to fight for you, sir. I\'ve got experience - been with the lord\'s army, a mercenary, and... well, other things.%SPEECH_OFF%}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Welcome to the company!",
                        function getResult()
                        {
                            this.World.getPlayerRoster().add(this.Contract.m.Dude);
                            this.World.getTemporaryRoster().clear();
                            this.Contract.m.Dude.onHired();
                            this.Contract.m.Dude = null;
                            return 0;
                        }

                    },
                    {
                        Text = "You\'ll have to find your luck elsewhere.",
                        function getResult()
                        {
                            this.World.getTemporaryRoster().clear();
                            this.Contract.m.Dude = null;
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local roster = this.World.getTemporaryRoster();
                    this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
                    this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
                    }

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
                    }

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
                    }

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
                    }

                    if (this.Contract.m.Dude.getTitle() == "")
                    {
                        this.Contract.m.Dude.setTitle("the Survivor");
                    }

                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You return to %employer% and report your doings. He waves you off.%SPEECH_ON%Oh please, sellsword. I already know. You don\'t think I have spies in these parts?%SPEECH_OFF%He gestures toward a satchel on the corner of his table. You take it and the man flicks his wrist.%SPEECH_ON%That should be thanks enough, now please leave my sight.%SPEECH_OFF% | You show %employer% a head of an orc. He stares at it, then at you.%SPEECH_ON%Interesting. So should I take it that you\'ve completed what I\'ve asked of you?%SPEECH_OFF%You nod. The man smiles and hands over a wooden chest with %reward% crowns inside.%SPEECH_ON%I knew I could trust you, sellsword.%SPEECH_OFF% | %employer% stares at you as you return.%SPEECH_ON%I\'ve heard of what you\'ve done.%SPEECH_OFF%It\'s a strange tone in his voice, a tone that has you quickly reviewing everything you\'ve done in the past week. Was that a noble woman at the... no, couldn\'t be.%SPEECH_ON%The orcs are dead. Good work, mercenary.%SPEECH_OFF%He slides you a satchel of %reward% crowns and a wave of relief also washes over you. | You enter %employer%\'s room and take a seat, pouring yourself a cup of wine. The nobleman stares a hole through you.%SPEECH_ON%I dare say that\'s a drawing-and-quartering offense, a hanging one if I\'m feeling kind, a burning one if I ain\'t.%SPEECH_OFF%You finish the drink and then slam an orc head on the man\'s table. The cup totters and rolls around on its side. %employer% reels back, then calms himself.%SPEECH_ON%Ah, yes, a drink well earned. That wasn\'t my best wine, anyway. %randomname%, my guard, is waiting for you outside. He\'ll have the %reward% crowns we agreed upon.%SPEECH_OFF% | You lift an orc head to show %employer%. The green maw falls open, its tongue lolling between the teeth one might mistake for tusks. %employer% nods and flicks his hand.%SPEECH_ON%Please, have some mercy for my dreams and take it away.%SPEECH_OFF%You do as told. The man shakes his head.%SPEECH_ON%How am I to get any sleep these days with things like that being lugged around? Anyhow, you have %reward% crowns already waiting for you outside with one of my guards. Thanks for your work, sellsword.%SPEECH_OFF% | You come to %employer%\'s room to find him looking at a drawing on a scroll. He stares at you, the lip of the paper folding backward.%SPEECH_ON%My daughter thinks herself an artist, can you believe that?%SPEECH_OFF%He shows you the scroll. It\'s a pretty well done drawing of a man who looks suspiciously like %employer%. The drawn figure is facing a hangman. %employer% laughs.%SPEECH_ON%Dumb girl.%SPEECH_OFF%He crumples the scrolls and tosses it aside.%SPEECH_ON%Anyway, my spies have already told me of your successes. Here is your payment as we agreed.%SPEECH_OFF%}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Reward);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed an orc encampment");
                            this.World.Contracts.finishActiveContract();

                            if (this.World.FactionManager.isGreenskinInvasion())
                            {
                                this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
                            }

                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() + this.Flags.get("HeadsCollected") * this.Contract.m.Payment.getPerCount();
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/discover_location_contract", function(o){

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% is looking at a poorly drawn map, then looks up at you as though you\'re the one responsible for making it.%SPEECH_ON%Look, mercenary, this is a strange thing to task you with, but you seem to have a good head on your shoulders. See this dark spot here? Would you be willing to venture that way and try and find the %location%? It\'s somewhere at or around the region of %region%.%SPEECH_OFF% | You step into %employer%\'s room and he shoves a map into your face.%SPEECH_ON%{Sellsword! Time for you to go exploring! See this uncharted spot, %direction% of here in the region of %region%? That\'s where I need you to go in search of the %location%. Do you accept or not? | Alright, this might seem strange, but I need a place by the name of the %location% located and charted. Our maps are incomplete in regards to this spot which, at the very least, I believe is at or near the region of %region% %direction% of here. Go, find it, and come back with the coordinates and you will be properly rewarded. | There are parts of this world man still has yet to find and chart into his maps. I\'m looking for %location% %direction% of here at or near the region of %region%. That\'s about all I know of it, but I do know it exists. So you go and find it for me and you\'ll be properly rewarded. | I need a place found, sellsword. It lies %direction% of here at or near to the region of %region%. The laymen call it %location%, but whatever it is, I need to know WHERE it is, understand? Find it and you will be paid handsomely. | I\'m in need of a soldier and explorer, sellsword, and I think you\'re just the man to be both in one. Now, before you accuse me of being cheap by not hiring both vocations, let\'s just say I have plenty of crowns for you to earn in doing this for me. What is it, hm? Well, I know of a place by the name of %location%, but I know not where it is other than it resides %direction% of here in the strip of land called %region%. Find it, draw its place on the map, and you\'ll get the pay of both a soldier and an explorer!}%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{What does it pay? | For the right price we\'ll find it.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | Our travels will not take us there for a while. | This is not the kind of work we\'re looking for.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "FoundIt",
                Title = "At %location%",
                Text = "[img]gfx/ui/events/event_57.png[/img]{You sight %location% in the glass of your scope and mark it on your maps. Easy enough. Time to return to %employer%. | Well, it\'s already time to return to %employer% as %location% was easier to find than you figured. Marking it on your map, you pause and chuckle and shake your head. What luck. | %location% comes into view and it\'s immediately reborn upon your map to the best of your illustrative capabilities. %randombrother% asks if that\'s all there is to do. You nod. A rough go or an easy one, %employer% will be waiting to pay you all the same.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to head back.",
                        function getResult()
                        {
                            this.Contract.setState("Return");
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Trap",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_07.png[/img]The %location% has been spotted - and so has the %companyname%. The supposed \'altruist\' who had given you the directions is standing there, except now he has a band of hardy and unfriendly men with him.%SPEECH_ON%{Well, looks like you can follow directions after all. Setting an ambush is pretty easy when you tell the idiot where to meet ya. Anyway, kill them all! | Hey there, sellsword. Strange seeing you here. Oh wait, no it isn\'t. Kill them all! | Damn, took you long enough! What, you can\'t follow simple instructions on how to walk into your own graves? Foolish, sellsword, and annoyingly dumb. Well, let\'s get this over with. Kill them all.}%SPEECH_OFF%",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To Arms!",
                        function getResult()
                        {
                            local tile = this.World.State.getPlayer().getTile();
                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.Music = this.Const.Music.BanditTracks;
                            p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
                            p.Tile = tile;
                            p.CombatID = "DiscoverLocation";
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, false, false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SurprisingHelpAltruists",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_76.png[/img]{Waving his hand rather friendly-like, a man approaches. You respond by unsheathing your sword halfway. He laughs.%SPEECH_ON%So many are interested in the %location%, so I can\'t fault you for being so defensive. Look, I\'ll tell you exactly where it\'s at. Just %distance% to the %direction% of here, %terrain%.%SPEECH_OFF%He heads off, cackling with laughter.%SPEECH_ON%I dunno if I\'ve done good or ill, and that\'s just the sort of fun I like!%SPEECH_OFF% | A group of world-weary explorers! They seize up in the middle of the road, half covered in mud and half in leaves and all in unintentional camouflage. One rubs his forehead, eyeing you carefully before a smile widens.%SPEECH_ON%Eh, I know a searcher when I see one. You\'re looking for the %location%, aintcha? Well yer in luck, we was just coming from there! Here, give me your map and I\'ll show you just where it is. You see, %terrain% %distance% to the %direction% of where we are now.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Much appreciated.",
                        function getResult()
                        {
                            if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() > 0.95)
                            {
                                this.Flags.set("IsTrap", true);
                            }

                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SurprisingHelpOpportunists1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_76.png[/img]{The stranger is a lone man who keeps his distance, one foot on the path, the other inching toward escape.%SPEECH_ON%Hey there.%SPEECH_OFF%He glances across your men, slowly smiling as though he can sense our being lost.%SPEECH_ON%Searching for the %location% are ya? Hmm, yeah. Well I\'ll tell you what, hand me %hint_bribe% crowns and I\'ll tell you exactly where it is! Come after me with yer swords and I\'ll be gone quicker than you can blink!%SPEECH_OFF% | You watch as the stranger comes into the light of the path, shielding his eyes so as to keep much of his face hidden.%SPEECH_ON%You look like the sort to be in search of something, but you know not where it be! The %location% is tricky like that. Good thing I know where it is. Good thing you, too, can know where it is by sliding %hint_bribe% crowns my way. I\'m the fastest sprinter you ever did see, so don\'t try and wring it out of me with one of them shiny swords you got.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Fine, here\'s the crowns. Now speak.",
                        function getResult()
                        {
                            return "SurprisingHelpOpportunists2";
                        }

                    },
                    {
                        Text = "No need, we\'ll find it on our own.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "SurprisingHelpOpportunists2",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_76.png[/img]You accept the man\'s offer and he dishes out the details as promised.%SPEECH_ON%You see, it\'s there, of course, %terrain% %distance% to the %direction% of where we are now. Easy.%SPEECH_OFF%He whistles as he walks off, no doubt a very easy payday for him.",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Got it.",
                        function getResult()
                        {
                            this.World.Assets.addMoney(-this.Flags.get("HintBribe"));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("HintBribe") + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "AnotherParty1",
                Title = "At %townname%",
                Text = "[img]gfx/ui/events/event_51.png[/img]{As you and the %companyname% prepare their journey, %randombrother% states that there is a man who wishes to speak to you directly. You nod and have him led to you. He\'s a glum, small man who states that the \'rulers\' of %townname% have no interest in the %location% other than ones of greed. Of course that\'s the case, so what\'s the problem? The man nods.%SPEECH_ON%Look, I\'ve some folks who are interested in keeping the %location% hidden away for good. If you find it, well, talk to me first. We\'ll make you a pretty penny.%SPEECH_OFF% | While the %companyname% readies its trip to find the %location%, a man sidles up next to you. He hands you a note and departs without saying a word. The scroll reads: LEAVE THE %locationC% WHERE IT BE. IF YOU FIND IT, TALK TO US. OUR CROWNS FOR YOUR SILENCE. THE RULERS OF %townnameC% NEED NOT KNOW NOTHIN\'! | A man approaches the company. Behind him you spy a couple of poor families staring on. You\'re not sure if he\'s their ambassador or not, but either way he comes right for you with a proposition spoken low and quiet.%SPEECH_ON%Listen here, sellsword. If you go out and find the %location%, come to us first. The rulers of %townname% need not bring their greed and lust for power to that place. Leave it to us, alright? We\'ll pay you well.%SPEECH_OFF%Before you can say a word, he straightens up and continues on. When you look back down the road those families are no longer around.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I\'ll think about it.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "AnotherParty2",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_51.png[/img]{As you head toward %townname%, a stranger comes out to the path. He\'s the man you talked to before, but this time he has a satchel in hand.%SPEECH_ON%{You\'ve no reason to tell the rulers of this town where the %location% is. Leave its secrets to us, you\'ve no idea what heirlooms and history we have there. For your silence, we\'re willing to give you this as payment, %bribe% crowns. Please, sir, accept. | Look, sellsword, I know you speak one language and that is the language of money. Take this satchel as a token of our appreciation - if you stay silent. You needn\'t tell the rulers of %townname% where the %location% is. That place belongs to our families. Those petty rulers will only ruin it with their greed and power-seeking. So, what say you, will you take this? There are %bribe% crowns in there. All you gotta do is take it and not talk.}%SPEECH_OFF% | Entering %townname%, you\'re headed off by a familiar face: the man who had greeted you just before you had departed in the first place. But this time he has a satchel with him.%SPEECH_ON%{%bribe% crowns for your silence. Tell the rulers of this town absolutely nothing and it\'s yours. They need not know about our deal, they just need not know where this place is. It\'s important to us, with history beyond measure, and all they\'ll do is raid and pillage it. Please, accept. | Take this, it\'s %bribe% crowns. That\'s how much we\'re prepared to give you for your silence. The rulers of %townname% will take your information and use it to pillage the %location%, because they know of our own familial relations to it and, well, we\'ve long since fallen out of favor around here. We\'ve little left so, please, let us keep our heirlooms and old home.}%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I don\'t think so. Only our employer will learn where it is.",
                        function getResult()
                        {
                            return "AnotherParty3";
                        }

                    },
                    {
                        Text = "We have a deal. You and no one else will learn where it is.",
                        function getResult()
                        {
                            return "AnotherParty4";
                        }

                    },
                    {
                        Text = "Why get paid only once if we can get paid twice?",
                        function getResult()
                        {
                            return "AnotherParty5";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "AnotherParty3",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_51.png[/img]{After telling the man no, he falls to his knees and cries out, much to the amusement of the %companyname%. He wails on about how you\'ve left the historic past of his family in the hands of lechers and usurers. You tell him that you don\'t care. | Telling the man that you\'ve no interest in betraying your original employer sets him off. He tries to attack you, launching forward to glom onto you with angry hands. %randombrother% pushes him away and threatens to kill him with a blade. The man backs off. He sits beside the path, head between his knees, sobbing. One of the men gives him a handkerchief as they pass by. | You tell the man no. He begs. You tell him no again. He begs some more. You suddenly realize you\'ve done with this with a woman or two. It really isn\'t a good look. You tell him as much, but the emotion of the moment is too much for him. He starts to wail, going on about how his family name will be ruined by the greedy bastards that run %townname%. You tell him that his supposed family name would be spared if, perhaps, he was the one running this town. This does not clear his tears.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Out of the way.",
                        function getResult()
                        {
                            return "Success1";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "AnotherParty4",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_51.png[/img]{You agree to sell the man the details of your expedition. He\'s overly joyous about the whole affair, but %employer% is not. Apparently, a little child saw this exchange and reported your betrayal to the head of %townname%. Your reputation here has, no doubt, been a little hurt. | Well, on one hand you spared this man\'s supposed familial home from destruction at the hands of those who run %townname%. On the other, those who run %townname% quickly heard of what you\'d done. You should have paid more mind to a small town\'s population to double as rumormills extraordinaire.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Well, %employer% should have just payed us more.",
                        function getResult()
                        {
                            this.World.Assets.addMoney(this.Flags.get("Bribe"));
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Sold the location of " + this.Flags.get("Location") + " to another party");
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "AnotherParty5",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]You tell the man that you\'ll keep the location of his familial home a secret. While he celebrates, you go and tell %employer% where the %location% is. Getting paid by both sides makes for a pretty sweet gig. Catching hate from both not so much, but what did they expect in dealing with a sellsword?",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Those people will never learn.",
                        function getResult()
                        {
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.Assets.addMoney(this.Flags.get("Bribe"));
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 1.5, "Gave information to a competitor");
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
                    });
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Crowns"
                    });
                }

            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% welcomes you back. You hand over your recently illustrated map and he pores over it, swatting the spotted mark with the back of his hand.%SPEECH_ON%Of course that\'s where it is!%SPEECH_OFF%He smirks and pays you what you\'re owed. | You come to %employer%\'s room, a fresh map in hand. He takes it from you and looks it over.%SPEECH_ON%Well then. I\'d mind to think this was a spot too easy, but an agreement is an agreement.%SPEECH_OFF%He hands you a satchel weighed with precisely what is owed. | You report to %employer%, telling him of %location%\'s location. He nods and scribbles, copying the notes from your map. Curious, you ask how he knows you\'re not lying. The man sets down in a chair and leans back, clasping his hands over his belly.%SPEECH_ON%I invested in a tracker who kept close to your company. He made it here before you did and you\'ve but confirmed what I already know. Hope you don\'t mind the measures taken.%SPEECH_OFF%Nodding, you think it a wise move and take your pay and go.}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            local playerRoster = this.World.getPlayerRoster().getAll();
                            local xp = this.Contract.m.Payment.getOnCompletion() * 0.1;

                            foreach( bro in playerRoster )
                            {
                                bro.addXP(xp);
                                bro.updateLevel();
                            }

                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Hired to find the " + this.Flags.get("Location"));
                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local xpGained = this.Math.round(this.Contract.m.Payment.getOnCompletion() * 0.1 * this.Const.Combat.GlobalXPMult);
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns and [color=" + this.Const.UI.Color.PositiveEventValue + "]" + xpGained + "[/color] Experience"
                    });
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/drive_away_bandits_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Drive off brigands at " + this.Flags.get("DestinationName") + " %direction% of %origin%"
                    ];

                    if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
                    {
                        this.Contract.setScreen("Intro");
                    }
                    else
                    {
                        this.Contract.setScreen("Task");
                    }
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    this.Contract.m.Destination.clearTroops();
                    this.Contract.m.Destination.setLastSpawnTimeToNow();

                    if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
                    {
                        this.Contract.m.Destination.getLoot().clear();
                    }

                    this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
                    this.Contract.m.Destination.setDiscovered(true);
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

                    if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
                    {
                        this.Flags.set("IsRobberBaronPresent", true);

                        if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
                        {
                            this.Flags.set("IsBountyHunterPresent", true);
                        }
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
                    }
                }

                function update()
                {
                    if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
                    {
                        if (this.Flags.get("IsRobberBaronDead"))
                        {
                            this.Contract.setScreen("RobberBaronDead");
                            this.World.Contracts.showActiveContract();
                        }
                        else if (this.Math.rand(1, 100) <= 10)
                        {
                            this.Contract.setScreen("Survivors1");
                            this.World.Contracts.showActiveContract();
                        }
                        else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
                        {
                            this.Contract.setScreen("Volunteer1");
                            this.World.Contracts.showActiveContract();
                        }

                        this.Contract.setState("Return");
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerAttacking = true )
                {
                    if (this.Flags.get("IsRobberBaronPresent"))
                    {
                        if (!this.Flags.get("IsAttackDialogTriggered"))
                        {
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.setScreen("AttackRobberBaron");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.Music = this.Const.Music.BanditTracks;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(_dest.getFaction());
                            p.Parties.push(party);
                            party.EL_setTroopsResourse(0);
                            this.Const.World.Common.addTroop(party, {
                                Type = this.Const.World.Spawn.Troops.BanditLeader
                            }, false);
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
                            this.World.Contracts.startScriptedCombat(properties, true, true, true);
                        }
                    }
                    else
                    {
                        this.World.Contracts.showCombatDialog();
                    }
                }

                function onRobberBaronPlaced( _entity, _tag )
                {
                    _entity.getFlags().set("IsRobberBaron", true);
                    _entity.setName(this.Flags.get("RobberBaronName"));
                }

                function onActorKilled( _actor, _killer, _combatID )
                {
                    if (_actor.getFlags().get("IsRobberBaron") == true)
                    {
                        this.Flags.set("IsRobberBaronDead", true);
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        if (this.Flags.get("IsRobberBaronDead"))
                        {
                            this.Contract.setScreen("Success2");
                        }
                        else
                        {
                            this.Contract.setScreen("Success1");
                        }

                        this.World.Contracts.showActiveContract();
                    }

                    if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
                    {
                        this.Contract.setScreen("BountyHunters1");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsBountyHunterRetreat"))
                    {
                        this.Contract.setScreen("BountyHunters3");
                        this.World.Contracts.showActiveContract();
                    }
                }

                function onCombatVictory( _combatID )
                {
                    if (_combatID == "BountyHunters")
                    {
                        this.Flags.set("IsBountyHunterPresent", false);
                    }
                }

                function onRetreatedFromCombat( _combatID )
                {
                    if (_combatID == "BountyHunters")
                    {
                        this.Flags.set("IsBountyHunterPresent", false);
                        this.Flags.set("IsBountyHunterRetreat", true);
                        this.Flags.set("IsRobberBaronDead", false);
                    }
                }

            });
        }

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% angrily shakes his head.%SPEECH_ON%Brigands have been tearing up these parts for far too long! I sent a lad, %randomname%\'s son, to go find them. And you know what? Only his head came back. Of course, the idiot brigands sent one of their own to deliver it. We captured and interrogated him... so now we know where they\'re at.%SPEECH_OFF%The man leans back, pedaling his thumbs over one another in thought.%SPEECH_ON%I do not have the men, but I do have the crowns - what say I slip some your way, and you slip a sword theirs?%SPEECH_OFF% | %employer% pours himself a drink, stares at the cup, and pours himself some more. He seems to drain it in one gulp before belching his news.%SPEECH_ON%Brigands killed %randomname% and his whole family. Can you believe that? I know you don\'t know who they are, but they were a well-liked family in these parts. I\'m sure you can already imagine, but I want these brigands done with. I spent half my men just finding their camp, now I\'m ready to spend ha... some of my crowns for you to go kill them. Are you interested?%SPEECH_OFF% | %employer% is looking out a window, dancing a finger along the rim of a drink as he weighs his thoughts.%SPEECH_ON%Brigands have been taking off with precious livestock. They come in the night, the brigands I mean, and cut the bells to make off all quiet like. I\'m sure livestock aren\'t important to you, but one calf, one cow, one bull? That\'s a fortune to some people around these parts.\n\nSo the other day I have a lad follow the animal tracks out of town and now he\'s told me exactly where those brigands are. As I\'m sure you could guess, I don\'t have the men to spare to take these vagabonds on, but crowns... crowns I am not short on. If I were to cross your palms with copper, would you be willing to cross these brigands with steel?%SPEECH_OFF% | %employer% sighs as if he\'s tired of all these troubles, as though he\'s about to start a conversation he\'s already had many times before.%SPEECH_ON%%randomname%, a man of some import here, states that brigands made a pass on his daughters. Now he\'s worried what they\'ll do the next time. Luckily, that man is of some wealth and could easily track these brigands down. If I were to pay you a decent sum, how earnestly could you drive one of them swords of yours through a brigand or two?%SPEECH_OFF% | %employer% takes a seat in a chair big enough to be comfortable for two. He bandies a mug back and forth.%SPEECH_ON%Brigands have been harrying us for weeks now and just yesterday they tried to set fire to a pub. Can you believe that? Who sets fire to such a thing? Luckily we put it out just in time, but things are getting bad around here. If they threaten our precious drink, what will they do next? Luckily, we managed to find where these vagrants are hiding. So... yes I see your look. It\'s a simple task, sellsword: we want you to go kill every last brigand there. Are you willing to work with us?%SPEECH_OFF% | As you settle into the room, %employer% finishes a goblet of cobra wine and heaves the cup out a window. You hear the din of it clattering hollow far, far away. He turns to you.%SPEECH_ON%While walking the roads, brigands swarmed my wagon and made off with all my goods! They left me my life, which is fine, but the gall of what they did keeps me up at night. I see their sneering faces... hear their laughter... I believe it was a message, to go after me, because I refused to pay their \'tolls\'. Well, now I am ready to pay a toll - to you, sellsword. If you go and slaughter these vagabonds, I\'ll pay a tidy toll indeed. What say you?%SPEECH_OFF% | As you begin to take a seat, %employer% throws a scroll at you. It unfurls just as you catch it. You begin to read, but %employer% starts in with the news anyway.%SPEECH_ON%Traders from %randomtown% have all agreed to no longer patronize %townname% until our little brigand problem is done away with. The history of it is pretty simple, as I\'m sure you\'re aware of the brigands\' methods, but these damn vagabonds have been harrying the roads, pillaging caravans and killing merchants.\n\nI know exactly where they are, I just need a man of guts and in need of glory - or gold! - to go and kill them. So what say you, mercenary? Name a price and we can talk.%SPEECH_OFF% | %employer% is shaking when you greet him. He\'s practically frothing with anger - or maybe he\'s just really drunk.%SPEECH_ON%Citizens of this fine town are starving. Why? Because brigands keep sneaking in during the night to raid the granaries! And if we catch them, they burn the buildings down! Now we can\'t defend ourselves by sitting back... Now... I want to defend myself by killing them all.%SPEECH_OFF%The man teeters for a moment, as if about to spill himself across his desk. He steadies before continuing.%SPEECH_ON%I want you to go kill these vagrants, obviously. All you have to do is be interested and... -hic-... name your price.%SPEECH_OFF% | %employer% looks solemnly at the ground. He unfurls a scroll, showing you a face.%SPEECH_ON%This is %randomname%, a brigand at large who we captured the other day. He once lead an outfit of vagrants that used to harry and raid our town day and night. Problem is, he\'s not really the head of a snake, but one head of a hydra. Kill one criminal head, another takes its place. So what\'s the answer? Why, kill them ALL of course. And that\'s exactly what I want you to do, sellsword. Are you interested?%SPEECH_OFF% | %employer% turns to you as you look for somewhere to sit.%SPEECH_ON%Hoy, mercenary, how long has it been since you\'ve slaked your sword with the blood of evil, cruel men?%SPEECH_OFF%He drops the sarcasm and you figure you\'ll be standing now.%SPEECH_ON%We here at %townname% are having a bit of a tiff with some local brigands. Local to us, that is, with their little rat\'s hole not far from here. Obviously, I think the answer to this issue is to hire some finely armed men such as your little company of goodfellas. So, does that pique your interest, mercenary, or do I need to find sturdier men for this task?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{How many crowns are we talking about? | What is %townname% prepared to pay for their safety? | Let\'s talk money.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | We have more important matters to settle. | I wish you luck, but we\'ll not be part of this.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "AttackRobberBaron",
                Title = "Before the attack...",
                Text = "[img]gfx/ui/events/event_54.png[/img]{While spying on the brigand encampment, you notice the profile of a man you\'ve heard the locals almost fervently describing: it is %robberbaron%, a famed robber baron that terrorizes these parts. He\'s got a retinue of brutish looking men following him everywhere he goes.\n\nYou wager his head is worth a few extra crowns. | You didn\'t plan to see him, but it\'s no doubt the man himself: %robberbaron% is at the brigands\' encampment. The famed killer is apparently paying a visit to one of his criminal offshoots, studiously marching around the thieves, pointing his finger to this or that, remarking about the quality of that and this.\n\nA few bodyguards follow him everywhere. You estimate that between him and the rest of the brigands, there\'s about %totalenemy% men mucking about. | The contract was just to wipe out the brigands, but it appears another, much heavier carrot has been added to the stick: %robberbaron%, the infamous killer and road raider, is at the camp. Followed by a bodyguard, the robber baron seems to be assessing one of his criminal outfits.\n\nYou wonder how much %robberbaron%\'s head would weigh in crowns... | %robberbaron%. It\'s him, you know it. Eyeing through a spyglass, you can easily see the silhouette of the infamous robber baron as he moves about the brigands\' encampment. He wasn\'t in your plans, nor mentioned in the contract, but there\'s little doubt that if you bring his head back to town you\'ll be getting a little extra for your troubles. | While spying on the brigands - you count about %totalenemy% men moving about - you spot a figure you did not at all expect: %robberbaron%, the infamous robber baron. The man and his bodyguard detail must be inspecting the state of the camp.\n\nWhat luck! If you could take his head back to your employer, you might just earn yourself a little bonus.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Prepare the attack!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "RobberBaronDead",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{The battle finished, you walk over to %robberbaron%\'s slain body and remove his head with two quick thwacks of your sword, the first cutting the meat, the second the bone. You drive a hook through the lip of neckflesh and draw a rope so as to attach it your hip. | With the fighting over, you quickly search for and find %robberbaron%\'s corpse amongst the dead. He still looks mighty mean even as the color leaves his body. He still looks quite  mean when you relieve his head of his body and though you can\'t see his face any longer as you toss his head into a burlap sack, you assume he still looks pretty mean then, too. | %robberbaron% lies dead at your feet. You turn the body over and straighten out the neck, giving your sword a better target. It takes two good cuts to remove the head which you quickly put into a mealsack. | Now that he\'s dead, %robberbaron% suddenly reminds you of a lot of men you used to know. You don\'t settle on the deja vu for long: with a few quick slashes of a sword, you remove the man\'s head before tossing it into a sack. | %robberbaron% put up a good fight and his neck put up another, the sinews and bones not letting his head go easily as you collect your bounty. | You collect %robberbaron%\'s head. %randombrother% points at it as you walk past.%SPEECH_ON%What is that? Is that %robberbaron%\'s...?%SPEECH_OFF%You shake your head.%SPEECH_ON%Naw, that man is dead. This here is just bonus pay.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We move out!",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BountyHunters1",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_07.png[/img]{Heading back to collect on your contract, a few men step out onto the road. One of them points at the head of %robberbaron%. %SPEECH_ON%We are the highest paid bounty hunters in these parts and I believe you\'re carrying off a bit of our business. Give us that there head and all parties shall get to sleep in their beds tonight.%SPEECH_OFF%You laugh.%SPEECH_ON%You will have to try better than that. %robberbaron%\'s head is worth a lot of crowns, my friend.%SPEECH_OFF%The leader of these supposed bounty hunters laughs right back at you. He lifts up a bulbously weighted sack.%SPEECH_ON%This here is %randomname%, one of the more wanted fellas in these parts. And this...%SPEECH_OFF%He holds up another sack.%SPEECH_ON%Is the head of the man who killed him. Understand? So hand over the bounty and we can all be on our way.%SPEECH_OFF% | A man steps out onto the road, straightens up, and postures toward you.%SPEECH_ON%Hello good sirs. I believe you have the head of %robberbaron% in your midst.%SPEECH_OFF%You nod. The man smiles.%SPEECH_ON%Would you please kindly turn it over to me.%SPEECH_OFF%You laugh and shake your head. The man doesn\'t smile, instead he raises a hand and snaps his fingers. A throng of well-armed men pour out of some nearby bushes, marching onto the road to the tune of heavy metal clinks and clanks. They look like what a man on death row might dream of the night before his reckoning. Their leader flashes a gold-speckled grin.%SPEECH_ON%I\'m not gonna ask you again.%SPEECH_OFF% | While talking to %randombrother%, a loud yell draws your attention. You look up the road to see a mob of men standing in your way. They got all manner of weaponry and armor. Their ringleader steps forward, announcing that they are famed bounty hunters.%SPEECH_ON%We only wish to have the head of %robberbaron%.%SPEECH_OFF%You shrug.%SPEECH_ON%We killed the man, we\'re collecting on his head. Now get out of our way.%SPEECH_OFF%When you take one step forward, the bounty hunters raise their weapons. Their leader takes one step toward you.%SPEECH_ON%There\'s a choice to be made here that could get a lot of good men killed. I know it isn\'t easy, but I do suggest you think it over very carefully.%SPEECH_OFF% | A sharp whistle draws the attention of you and your men. You turn to the side of the road to see a group of men emerging from some bushes. Everyone draws their weapons, but the strangers don\'t move a foot further. Their ringleader steps forward. He\'s got a bandolier of ears going across his chest, a summation of his handiwork.%SPEECH_ON%Hello fellas. We here are bounty hunters, if you couldn\'t tell, and I do believe you have one of our bounties.%SPEECH_OFF%You lift the head of %robberbaron%.%SPEECH_ON%You mean this?%SPEECH_OFF%The ringleader smiles warmly.%SPEECH_ON%Of course. Now if you could please hand it over, that\'d sit pretty well with me and my friends.%SPEECH_OFF%Tapping the hilt of his sword, the man grins.%SPEECH_ON%It\'s only a matter of business. I\'m sure you understand.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Take the damned head then and leave.",
                        function getResult()
                        {
                            this.Flags.set("IsRobberBaronDead", false);
                            this.Flags.set("IsBountyHunterPresent", false);
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
                            return "BountyHunters2";
                        }

                    },
                    {
                        Text = "{You\'ll have to pay with blood if you want it so badly. | If you want your head to join this one, go on, take your chances.}",
                        function getResult()
                        {
                            this.TempFlags.set("IsBountyHunterTriggered", true);
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            local tile = this.World.State.getPlayer().getTile();
                            local p = this.Const.Tactical.CombatInfo.getClone();
                            p.Music = this.Const.Music.BanditTracks;
                            p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
                            p.Tile = tile;
                            p.CombatID = "BountyHunters";
                            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            p.Parties.push(party);
                            party.EL_setTroopsResourse(party.EL_getTroopsResourse() * 0.5);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
                            foreach(troop in party.getTroops()) {
                                p.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(p, false, true, true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BountyHunters2",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_07.png[/img]You\'ve seen enough bloodshed for today and hand the head over.",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Let\'s move on. We still have payment to collect.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "BountyHunters3",
                Title = "Along the way...",
                Text = "[img]gfx/ui/events/event_07.png[/img]The bounty hunters are too much for the %companyname%! Not wanting your men needlessly killed, you order a hasty retreat. Unfortunately, the head of %robberbaron% was lost in the chaos...",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Oh well. We still have payment to collect.",
                        function getResult()
                        {
                            this.Flags.set("IsBountyHunterRetreat", false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivors1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{With the battle drawing to a close, a few enemies drop to their knees and beg for mercy. %randombrother% looks to you for what to do next. | After the battle, your men round-up what brigands remain. The survivors beg for their lives. One looks more like a kid than a man, but he is the quietest of them all. | Realizing their defeat, the few last standing brigands drop their weapons and ask for mercy. You now wonder what they would do were the shoe on the other foot. | The battle\'s over, but decisions are still yet to be made: a few brigands survived the battle. %randombrother% stands over one, his sword to the prisoner\'s neck, and he asks you what you wish to do.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Slit their throats. ",
                        function getResult()
                        {
                            this.World.Assets.addMoralReputation(-1);
                            return "Survivors2";
                        }

                    },
                    {
                        Text = "Take their arms and chase them away.",
                        function getResult()
                        {
                            this.World.Assets.addMoralReputation(2);
                            return "Survivors3";
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivors2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{Altruism is for the naive. You have the prisoners slaughtered. | You recall how many times brigands slew hapless merchants. The thought is barely out of your mind when you give the order to have the prisoners executed. They pipe up a brief protest, but it is cut short by swords and spears. | You turn away.%SPEECH_ON%Through their necks. Make it quick.%SPEECH_OFF%The mercenaries follow the order and you soon here the gargling of dying men. It is not quick at all. | You shake your head \'no\'. The prisoners cry out, but the men are already upon them, hacking and slashing and stabbing. The lucky ones are decapitated before they can even realize the immediacy of their own demise. Those with some fight in them suffer to the very end. | Mercy requires time. Time to look over your shoulder. Time to wonder if it was the right decision. You\'ve no time. You\'ve no mercy. The prisoners are executed and that takes little time at all.} \n\n [img]gfx/ui/icons/asset_moral_reputation.png[/img] The company\'s Moral reputation decreases slightly",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We have more important things to take care of.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivors3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{There\'s been enough killing and dying today. You let the prisoners go, taking their arms and armor before sending them off. | Clemency for thieves and brigands doesn\'t come often, so when you let the prisoners go they practically kiss your feet as though they were attached to a god. | You think for a time, then nod.%SPEECH_ON%Mercy it is. Take their equipment and cut them loose.%SPEECH_OFF%The prisoners are let go, leaving behind what arms and armor they had with them. | You have the brigands strip to their skivvies - if they even have them - then let the men go. %randombrother% rummages through what equipment is left behind as you watch a group of half-naked men hurry away.} \n\n [img]gfx/ui/icons/asset_moral_reputation.png[/img] The company\'s Moral reputation increases slightly",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'re not getting paid for killing them.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Volunteer1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{Just as the battle ends and things begin to quiet, you hear a man shouting. You move toward the noise to find a prisoner of the brigands. He\'s got ropes over his mouth and hands which you quickly undo. As he catches his breath, he meekly asks if maybe he could join your outfit. | You find a prisoner tied up in the brigands\' camp. Freeing him, he explains that he is from %randomtown%, and was kidnapped by the vagabonds just a few days ago. He asks if maybe he could join your band of mercenaries. | Rummaging what\'s left of the brigands\' camp, you discover a prisoner of theirs. Freeing him, the man sits up and explains that the brigands kidnapped him as he was traveling to %randomtown% in seek of work. You wonder if maybe he could work for you instead... | A man is left behind after the battle. He\'s not a brigand, but in fact a prisoner of theirs. When you ask who he is, he mentions that he is from %randomtown% and that he\'s looking for work. You ask if he can wield a sword. He nods.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "You might as well join us.",
                        function getResult()
                        {
                            return "Volunteer2";
                        }

                    },
                    {
                        Text = "Go home.",
                        function getResult()
                        {
                            return "Volunteer3";
                        }

                    }
                ],
                function start()
                {
                    local roster = this.World.getTemporaryRoster();
                    this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
                    this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
                    }

                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "Volunteer2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{The man joins your ranks, immersing himself in a crowd of brothers who seem to take to him warmly enough for a group of paid killers. The newly hired states he\'s good with all weapons, but you figure you\'ll be the one to decide what he\'s best with. | The prisoner grins from ear to ear as you wave him in. A few brothers ask what weapons they should give him, but you shrug and figure you\'ll see to yourself what to arm the man with.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Let\'s see about a weapon for you.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                    this.World.getPlayerRoster().add(this.Contract.m.Dude);
                    this.World.getTemporaryRoster().clear();
                    this.Contract.m.Dude.onHired();
                    this.Contract.m.Dude = null;
                }

            });
            this.m.Screens.push({
                ID = "Volunteer3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_22.png[/img]{You shake your head no. The man frowns.%SPEECH_ON%Are you sure? I\'m pretty good with...%SPEECH_OFF%You cut him off.%SPEECH_ON%I\'m sure. Now enjoy your newfound freedom, stranger.%SPEECH_OFF% | You appraise the man and figure he\'s not fit for the life of a sellsword.%SPEECH_ON%We appreciate the offer, stranger, but the mercenary life is a dangerous one. Go home to your family, your work, your home.%SPEECH_OFF% | You\'ve enough men to see you through, although you find yourself tempted to replace %randombrother% just to see the man\'s reaction to a demotion. Instead, you offer the prisoner a handshake and send him on his way. Although disappointed, he does thank you for freeing him.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Off you go.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                    this.World.getTemporaryRoster().clear();
                    this.Contract.m.Dude = null;
                }

            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You return to %townname% and talk to %employer%. The details of your journey are simple: you killed the brigands. He nods, smiling tersely before handing over your payment as agreed upon.%SPEECH_ON%Good work, men. Those brigands were giving us plenty of trouble.%SPEECH_OFF% | %employer% opens the door for you as you get to his home. He\'s got a satchel in hand and holds it up.%SPEECH_ON%I take it by your return that the brigands are dead?%SPEECH_OFF%You nod. The man heaves the satchel your way. You tell him you could be lying. %employer% shrugs.%SPEECH_ON%Could be, but word travels fast for those who bite the hands that feed. Good work, sellsword. Unless you\'re lying of course, then I\'ll come find you.%SPEECH_OFF% | %employer% grins as you enter his room and lay a sacked head on his desk.%SPEECH_ON%You need not stain my fineries to show you\'ve completed the task, sellsword. I\'ve already gotten news of your success - the birds in these lands do travel fast, don\'t they? Your payment is in the corner.%SPEECH_OFF% | As you finish your report, %employer% wipes his forehead with a handkerchief.%SPEECH_ON%Really, they\'re all dead then? Boy... you have no idea how much you\'ve lifted off my shoulders, sellsword. No idea at all! Your crowns, as promised.%SPEECH_OFF%He sets a satchel on his desk and you quickly take it. All is there, as promised. | %employer% sips his goblet and nods.%SPEECH_ON%You know, I don\'t take kindly to your sort, but you did a good job, mercenary. %randomname% reported to me, before you even got here, that all the brigands had been slain. It was some mighty fine work by the way he describes it. And, well...%SPEECH_OFF%He heaves a satchel onto the desk.%SPEECH_ON%Here\'s some mighty fine pay, as promised.%SPEECH_OFF% | %employer% leans back in his chair, folding his hands over his lap.%SPEECH_ON%Sellswords don\'t sit right with many folks, I suppose on the account of y\'all killing and destroying whole villages on a shortchanged whim, but I\'ll admit you\'ve done good.%SPEECH_OFF%He nods to a corner of the room where a wooden chest lays unopened.%SPEECH_ON%It\'s all there, but I won\'t be offended if you need to count it.%SPEECH_OFF%You do count it, and it is indeed all there. | %employer%\'s desk is blanketed in dirtied and unfurled scrolls. He\'s smiling warmly over them as if he\'s crooning over a pile of treasure.%SPEECH_ON%Trade deals! Trade deals everywhere! Happy farmers! Happy families! Everyone\'s happy! Ah, it\'s good to be me. And, of course, it\'s good to be you, sellsword, because your pockets just got a little bit heavier!%SPEECH_OFF%The man tosses a small purse your way, then another and another.%SPEECH_ON%I would\'ve paid with a larger satchel, but I just like doing that.%SPEECH_OFF%He cheekily tosses another purse which you casually catch with the sort of unamused aplomb of a man who still has fresh blood on his sword.}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
                }

            });
            this.m.Screens.push({
                ID = "Success2",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{You throw the criminal\'s head on %employer%\'s table. With a grin, you point at it.%SPEECH_ON%That\'s %robberbaron%.%SPEECH_OFF%%employer% stands up and unveils the burlap sack covering the trophy. He nods.%SPEECH_ON%Aye, that\'s him alright. I guess you\'ll be getting extra for that.%SPEECH_OFF%You\'re paid a tidy sum of %reward% crowns for killing the brigands as well as destroying the leadership of many nearby syndicates. | %employer% leans back as you enter his room, carrying a head by its hair. Luckily, it is not dripping.%SPEECH_ON%This here is %robberbaron%. Or should I say was?%SPEECH_OFF%Slowly standing, %employer% takes a cursory look.%SPEECH_ON%\'Was\' works... So, not only did you destroy the brigands\' rat hole, but you\'ve brought me the head of their leader. That is some mighty fine work, sellsword, and you\'ll be getting extra for this.%SPEECH_OFF%The man forks over a satchel of %original_reward% crowns and then takes a purse off his own self and pitches it toward you. | You hold %robberbaron%\'s head up, its sloped gaze turning to the ropes of bloodied hair. A slow smile etches across %employer%\'s face.%SPEECH_ON%You know what you\'ve done, sellsword? Do you know how much relief you\'ve brought to these parts just by removing that man\'s head from his shoulders? You\'ll be getting more than what you bargained for! %original_reward% crowns for the original task and...%SPEECH_OFF%The man slides a chunky purse across his table.%SPEECH_ON%A little something for that... extra weight you\'ve been carrying around.%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
                    this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/drive_away_barbarians_contract", function(o){

        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% sighs as he pushes a scrap of paper toward you. It is a list of crimes. You nod, observing that it is quite a lot of wrongdoing. The man nods back.%SPEECH_ON%T\'was an affair of a mere criminal I\'d spiff a constable or maybe a bounty hunter. But I\'ve brought you here sellsword because this is the work of barbarians. All that they\'ve done, all that is listed there, I need done to them. They\'ve a village %direction% from here. I need you to pay them a visit and show that while we live with hearths and civilization, the spark of the wild has not left us yet, and that barbarian actions will be met with barbaric retribution. Understand?%SPEECH_OFF%You now notice that the page of crimes is smattered with stricken feather tips, as though the one writing it got increasingly upset by its cataloging. | A group of local knights are in the room with %employer%. They regard you plainly, as though you were a dog who had pushed the door open and moseyed in. %employer% reaches down from his chair and retrieves a scroll and throws it your way.%SPEECH_ON%Barbarians left that for me when I went to make sense of a nearby farmstead that was obliterated.%SPEECH_OFF%The paper has runic drawings and what look like depictions of a hanging. %employer% nods.%SPEECH_ON%They massacred the farmers, the men anyway. The old gods know what came of the women. Go %direction% of here, sellsword, and find the barbarians responsible. You\'ll be paid handsomely for their outright, total, and complete annihilation.%SPEECH_OFF% | %employer% is looking rather bugged when you enter the room. He states that %townname% used to have good relations with the barbarians to the north.%SPEECH_ON%But I suppose I was just fooling myself to think we could stay on even terms with those savages.%SPEECH_OFF%He states they have been attacking caravans, murdering travelers, and attacking homesteads.%SPEECH_ON%So I\'ll treat them in kind. Go %direction% of here and slaughter their village whole. You keen to doing that?%SPEECH_OFF% | %employer% laughs when you enter the room.%SPEECH_ON%Not having a jake at your expense, sellsword, only at that cruel congruity of seeking a mercenary for prompt and total erasure of barbarians. You see, just %direction% of here stands a tribe of bearskin wearin\' arsefucks that have been scalping and axing traders and travelers. I won\'t stand for it. Partly because they\'re in the wrong, but especially because I have the coin to pay someone of your ill manners to take care of it for me.%SPEECH_OFF%He laughs to himself again. You get the feeling this man has never put a sword in any breathing being.%SPEECH_ON%So what say you, sellsword, interested in slaughtering some savages?%SPEECH_OFF% | When you enter %employer%\'s room he is staring at a dog\'s head. A steady leak from the neck drips over the table\'s edge. The man is rubbing one of the ears.%SPEECH_ON%Who kills a man\'s dog, cuts off its head, and fucking sends it to him?%SPEECH_OFF%You imagine someone with a hated enemy, but say nothing. %employer% nods at one of his servants and the dog\'s head is taken away. He looks to you now.%SPEECH_ON%Savages to the %direction% did this. First they started in on the merchants and homesteaders, raping and pillaging as the barbarians do. So I sent a response, killed a few of theirs, and this is what I get in return. Well, no more of these whoresons. I want you to go their village and annihilate them to the last.%SPEECH_OFF%You almost ask if that would include the destruction of their dogs. | You find %employer% with a dirtied and mudslaked woman sat beside his chair. Her hair is matted and her flesh stricken with all manner of punishment. She sneers at you as if it was all your doing. %employer% kicks her over.%SPEECH_ON%Don\'t mind this wench, sellsword. We caught her and her friends raiding the granary. Killed the lot of the savages, I\'d say we spared her for the fun of it but beating on her is about as fun as doing it to a dog. Her mannishness just steals the joy.%SPEECH_OFF%He kicks her again and she snarls back.%SPEECH_ON%See? Well, I have news! We have located the stain she came from and I have every intention of burning it to the ground. That\'s where you come in. The barbarian village is %direction% of here. Stomp it out and you\'ll be paid very well.%SPEECH_OFF%The woman doesn\'t know what is being said, but some slack in her stare seems to indicate she\'s beginning to understand why a man of your sort walked through that door in the first place. %employer% grins.%SPEECH_ON%You interested or do I have to find a man of meaner character?%SPEECH_OFF% | %employer% has a crowd of peasants in his room. More of them than any man of his station would be comfortable with in such proximity, but they surprisingly don\'t seem to be interested in lynching him. Seeing you, %employer% calls you forward.%SPEECH_ON%Ah, finally! Our answer is here! Sellsword, the barbarians %direction% of here have been pillaging nearby villages and raping anything with a hole. We\'re sick of it and frankly I don\'t want some mangy savage cock anywhere near my arse no more than the next man.%SPEECH_OFF%The crowd of peons jeers, one man yelling out that the barbarians {cut the head off his mother | also murdered his pet goats | stole all his dogs, the bastards | ate the liver of his youngest son}. %employer% nods.%SPEECH_ON%Aye. Aye, men, aye! And so I say, sellsword, that you plot a path to the barbarians\' village and treat them to measured, appropriate, civilized justice.%SPEECH_OFF% | %employer% waves you into his room. He\'s holding a firepoke, a scalp hanging off its tip.%SPEECH_ON%The northern barbarians sent me this today. It was stuck to its messenger, a man they took the eyes and tongue out of. Such is their nature, these savages, to speak to me without a word. And so I have a feeling I shall return the favor with your help, sellsword. Go %direction% of here, find their little village, and burn it to the ground.%SPEECH_OFF%The scalp unsticks from the firepoke and slaps against the stone floor with a wet slap. | %employer% reluctantly welcomes you in, as is one is wont to do when the world has pressed them into needing a mercenary. He speaks succinctly.%SPEECH_ON%The barbarians have a village %direction% of here from which they are sending raiding parties. They rape, they pillage, they are nothing but insects and varmints in the shape of men. I want them all gone, to the very last. Are you willing to take on this task?%SPEECH_OFF% | %employer%\'s got a cat in his lap, but as you draw near you realize it\'s just the head and he\'s simply been thumbing a delimbed tail around with his thumb. He purses his lips.%SPEECH_ON%The barbarian savages did this. They also raped and pillaged a number of surrounding farmsteads and they hung a pair of twin infants from a tree, but this...%SPEECH_OFF%His palms open up and the cat\'s head rolls out and hits the stone floor with a matted clap.%SPEECH_ON%No more. I want you to go %direction% of here and find the village those savages call home and do unto it what they have done unto us!%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{How many crowns are we talking about? | What is %townname% prepared to pay for their safety? | Let\'s talk money.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{Not interested. | We have more important matters to settle. | I wish you luck, but we\'ll not be part of this.}",
                        function getResult()
                        {
                            this.World.Contracts.removeContract(this.Contract);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Approaching",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_138.png[/img]{You\'ve found the barbarian village and a series of cairns that lead toward it. The stones are stacked in the shapes of men, and at the top of each cairn rests a freshly hewn human head. %randombrother% nods.%SPEECH_ON%I wonder if they believe doing that gets them closer to their gods.%SPEECH_OFF%You suspect you have another way to get them closer to their gods: by killing them all. It\'s time to plan a way of attack. | You find the barbarian village and just to its outskirts lies a round stone in the snow. It\'s so large the entire company could lay foot-to-head and still not stretch across its middle. Runes have been carved into its outer rim, long divots that are caked with dried blood. In the center of the slab is a small square rise with a curve to hold the neck. %randombrother% spits.%SPEECH_ON%Looks like a sacrificial square, er, circle.%SPEECH_OFF%Looking around, you wonder aloud where they put the bodies. The sellsword shrugs.%SPEECH_ON%Dunno. Probably ate \'em.%SPEECH_OFF%It wouldn\'t surprise you if they did. You stare at the village and ponder attacking or waiting. | The barbarian village lies just a little ways away. It\'s a nomadic scene, tents surrounded by ad hoc smithy sites and tarped wagons for granaries. You get the feeling that they are not long for any particular part of the world. %randombrother% laughs.%SPEECH_ON%Look at that one. He\'s shittin\'. What a fucker.%SPEECH_OFF%Indeed, one of the savages is squatting while talking to his fellow villagers. It is almost a metaphor in and of itself for catching the entire encampment with their pants down. | The village of savages is surprisingly not the hellscape you expected. Aside from the flayed corpse hanging upside down from a wooden holy totem, it looks like any other place with ordinary folks. Aside from the heavy set clothes and every individual carrying an axe or sword of some kind. All quite normal. There\'s a guy chopping a corpse\'s legs off and feeding them to pigs, but you\'ll see that just about anywhere. %randombrother% nods.%SPEECH_ON%Well, we\'re ready to attack. Just give the word, captain.%SPEECH_OFF% | You find the barbarian village squatting in the snowy wastes. It couldn\'t have been there long: it\'s mostly tents and the tops of them don\'t carry much snow. They must set up for a time then get back on the road, either to keep hunts fresh or to avoid the retribution of those they raid. What a shame they\'ve failed to do the latter. You ready the company for action. | You find the village of savages. Though, from first glance, they look an ordinary sort. Men, women, children. There\'s a blacksmith, a tanner, a one-eyed guy making arrows, and a huge executioner disemboweling corpses and washing the offal scum on a donkey. That one. That one reminds you of why you\'re here. | You find the barbarian village. The savages are in the midst of some religious ritual. An elderly man with a tortoise shell necklace has his fist up the decapitated and shaved head. He\'s letting the blood run down his forearm where children take horsehair brushes and sweep up the \'paint\' and go to run it against a wooden holy totem that stands a good ten feet high. The primitives watch and chant in a tongue totally foreign to you. %randombrother% whispers as though out of respect for the ritual moreso than fear of them hearing.%SPEECH_ON%Well. I say we go on down there and make an introduction, yeah?%SPEECH_OFF% | You find the barbarians moseying about their village. It\'s mostly tents and impromptu snow houses. Elderly women sit in a circle weaving baskets and younger women are making arrows while throwing glances at the burly men walking around. The men themselves pretend they don\'t care, but you know a peacock in action when you see it. There are also children hurrying to and fro this task or that. And just outside the village stand a series of wooden stakes impaling naked corpses from anus to mouth, and their chest cavities have been spread apart like butterfly wings and the insides draped down like loosened embroidering.%SPEECH_ON%Horrid.%SPEECH_OFF%%randombrother% says. You nod. It is, but that\'s why you\'re here.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Prepare to attack.",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "TheDuel1",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/event_139.png[/img]{Just as it seems the %companyname% is ready to clash with the savages, a lone figure steps out and stands between the battle lines. He\'s got a parted long beard knotted around tortoise shells and his head is sheltered beneath a sloping snout of a wolf\'s skull. The elder stands unarmed save for a long staff which clatters with tethered deer horns. Shockingly, he speaks in your tongue.%SPEECH_ON%Outsiders. Welcome to the North. We are not so inhospitable as you may think. As is our tradition, we believe that battle between two men is just as honorable and of value as that between two armies. So it is, I offer my strongest champion, %barbarianname%.%SPEECH_OFF%A burly man steps forward. He unhooks the pelts and tosses them aside to reveal a body of pure muscle, tendon, and scars. The elder nods.%SPEECH_ON%Put forth your champion, Outsiders, and we shall share a day that all our ancestors will smile upon.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "I\'d rather burn down this whole camp. Attack!",
                        function getResult()
                        {
                            this.Flags.set("IsDuel", false);
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local raw_roster = this.World.getPlayerRoster().getAll();
                    local roster = [];

                    foreach( bro in raw_roster )
                    {
                        if (bro.getPlaceInFormation() <= 17)
                        {
                            roster.push(bro);
                        }
                    }

                    roster.sort(function ( _a, _b )
                    {
                        if (_a.getXP() > _b.getXP())
                        {
                            return -1;
                        }
                        else if (_a.getXP() < _b.getXP())
                        {
                            return 1;
                        }

                        return 0;
                    });
                    local name = this.Flags.get("ChampionName");
                    local difficulty = this.Contract.getDifficultyMult();
                    local e = this.Math.min(3, roster.len());

                    for( local i = 0; i < e; i = i )
                    {
                        local bro = roster[i];
                        this.Options.push({
                            Text = roster[i].getName() + " will fight your champion!",
                            function getResult()
                            {
                                this.Flags.set("ChampionBrotherName", bro.getName());
                                this.Flags.set("ChampionBrother", bro.getID());
                                local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                                properties.CombatID = "Duel";
                                properties.Music = this.Const.Music.BarbarianTracks;
                                properties.Entities = [];
                                local party = this.new("scripts/entity/world/party");
                                party.setFaction(this.Contract.m.Destination.getFaction());
                                p.Parties.push(party);
                                party.EL_setTroopsResourse(0);
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.BarbarianChampion
                                }, false, 0, difficulty >= 1.15 ? 1 : 0);
                                foreach(troop in party.getTroops()) {
                                    p.Entities.push(troop);
                                }
                                properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
                                properties.Players.push(bro);
                                properties.IsUsingSetPlayers = true;
                                properties.BeforeDeploymentCallback = function ()
                                {
                                    local size = this.Tactical.getMapSize();

                                    for( local x = 0; x < size.X; x = x )
                                    {
                                        for( local y = 0; y < size.Y; y = y )
                                        {
                                            local tile = this.Tactical.getTileSquare(x, y);
                                            tile.Level = this.Math.min(1, tile.Level);
                                            y = ++y;
                                        }

                                        x = ++x;
                                    }
                                };
                                this.World.Contracts.startScriptedCombat(properties, false, true, false);
                                return 0;
                            }

                        });
                          // [050]  OP_CLOSE          0      7    0    0
                        i = ++i;
                    }
                }

            });
            this.m.Screens.push({
                ID = "TheDuel2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% sheathes his weapons and stands over the corpse of the slain savage. Nodding, the victorious sellsword stares back at you.%SPEECH_ON%Finished, sir.%SPEECH_OFF%The elder comes forward again and raises his staff.%SPEECH_ON%So it is, what is it that you wish to have been solved by the violence you sought coming here?%SPEECH_OFF%You tell him that those to the south are furious and want them gone from these lands. The elder nods.%SPEECH_ON%If by battle you would have accomplished, then by honorable duel it is finished. We shall leave.%SPEECH_OFF%The savages are told in their tongue to pack up and go. Surprisingly, there\'s little backtalk or complaining. If they\'re true to their word then you can go and tell %employer% now.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "A good end.",
                        function getResult()
                        {
                            this.Contract.setState("Return");
                            this.Contract.m.Destination.die();
                            this.Contract.m.Destination = null;
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local bro = this.Tactical.getEntityByID(this.Flags.get("ChampionBrother"));
                    this.Characters.push(bro.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "TheDuel3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_138.png[/img]{It was a good fight, a clash between men upon the earth with those in observation silent as though in awe of some timeless and honorable rite. But. %champbrother% lies dead on the ground. Bested and killed. The elder steps forward again. He does not carry any hint of gloating or grin.%SPEECH_ON%Outsiders, the battle between two men is as such as it were between all of us combined. We have won, blessed is the Far Rock\'s gaze, and so we request that you depart these lands and do not return.%SPEECH_OFF%A few of the sellswords look to you with anger. One says he doesn\'t think the savages would abide the agreement were things the other way around, that the company should wipe these barbarians out regardless of the outcome.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We will stay true to our word and leave you in peace. (Increase morals)",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.Assets.addMoralReputation(5);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to destroy a barbarian encampment threatening " + this.Contract.m.Home.getName());
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    },
                    {
                        Text = "Everyone, charge! (Decrease morals)",
                        function getResult()
                        {
                            this.World.Assets.addMoralReputation(-3);
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivor1",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_145.png[/img]{The battle over, %randombrother% beckons you over. In one of the tents is a barbarian nursing a wound. Men, women, and children litter the floor around him. The sellsword points to him.%SPEECH_ON%We chased the savage in here. I think that\'s his family all around him, or someone he knows, cause he just collapsed and hasn\'t moved since.%SPEECH_OFF%You walk toward the man and crouch before him. You tap one of his deerskin boots and ask if he understand you. He nods and shrugs.%SPEECH_ON%Little. You did this. Didn\'t have to, but did. Finish me, or I fight with you. One, the other, all honorable.%SPEECH_OFF%It seems he\'s offering his hand to fight with the company, no doubt part of some northern code that\'s foreign to yourself. He\'s also offering his head if you want that, too, and he seems totally unafraid of giving it up.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll leave no one alive.",
                        function getResult()
                        {
                            this.World.Assets.addMoralReputation(-1);
                            return "Survivor2";
                        }

                    },
                    {
                        Text = "Let him go.",
                        function getResult()
                        {
                            this.World.Assets.addMoralReputation(2);
                            return "Survivor3";
                        }

                    }
                ],
                function start()
                {
                    if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
                    {
                        this.Options.push({
                            Text = "We could need a man like this.",
                            function getResult()
                            {
                                return "Survivor4";
                            }

                        });
                    }
                }

            });
            this.m.Screens.push({
                ID = "Survivor2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_145.png[/img]{You unsheathe your sword and lower the blade toward the man, the corpses in the tent blurring along its metal curvature, and the surviving barbarian\'s face blobbing at the tip. He grins and grips the edges, sheathing it in his huge hands. Blood drips steadily from his palms.%SPEECH_ON%Death, killing, no dishonor. For us both. Yes?%SPEECH_OFF%Nodding, you push the blade into his chest and sink him back to the floor. The weight of him on the sword is like a stone and when you unstick him the corpse claps back against the pile of corpses. Sheathing the sword, you tell the company to round up what goods they can and to ready a return to %employer%.} \n\n [img]gfx/ui/icons/asset_moral_reputation.png[/img] The company\'s Moral reputation decreases slightly",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to get paid.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivor3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_145.png[/img]{You unsheathe your blade halfway, hold it long enough that the savage sees it, then you slam it back into the scabbard. Nodding, you ask.%SPEECH_ON%Understand?%SPEECH_OFF%The barbarian stands up, briefly slumping against the tent\'s post. You turn and hold your hand out to the tent flap. He nods.%SPEECH_ON%Aye, I know.%SPEECH_OFF%He stumbles out and into the light and away into the northern wastes, his shape tottering side to side, shrinking, and is then gone. You tell the company to get ready to return to %employer% for some well-earned pay.} \n\n [img]gfx/ui/icons/asset_moral_reputation.png[/img] The company\'s Moral reputation increases slightly",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Time to get paid.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Survivor4",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_145.png[/img]{You stare at the man, then take out your dagger and slice the inside of your palm. Squeezing the blood, you toss the dagger to the barbarian and then hold your hand out, the blood dripping steadily. The savage takes the blade and cuts himself in turn. He stands and puts his hand out and you shake. He nods.%SPEECH_ON%Honor, always. With you, the only way, all the way.%SPEECH_OFF%The man stumbles out of the tent. You tell the men to not kill him, but instead to arm him which raises some eyebrows. His addition to the company is unforeseen, but useful. The southern sellswords will get used to it in time, but for now the %companyname% needs to return to %employer%.}",
                Image = "",
                List = [],
                Characters = [],
                Options = [
                    {
                        Text = "Welcome to the %companyname%.",
                        function getResult()
                        {
                            this.World.getPlayerRoster().add(this.Contract.m.Dude);
                            this.World.getTemporaryRoster().clear();
                            this.Contract.m.Dude.worsenMood(1.0, "Has seen his village being slaughtered");
                            this.Contract.m.Dude.onHired();
                            this.Contract.m.Dude = null;
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    local roster = this.World.getTemporaryRoster();
                    this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
                    this.Contract.m.Dude.setStartValuesEx([
                        "barbarian_background"
                    ]);

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
                    }

                    if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
                    {
                        this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
                    }

                    this.Characters.push(this.Contract.m.Dude.getImagePath());
                }

            });
            this.m.Screens.push({
                ID = "Revenge1",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_135.png[/img]{A man stands out into your path. He\'s an elder and not of southern reaches.%SPEECH_ON%Ah, the Outsiders. You come to our lands and ravage an undefended village.%SPEECH_OFF%You spit and nod. %randombrother% yells out that it\'s what the savages themselves do. The old man smiles.%SPEECH_ON%So we are in cycle, and through this violence we all shall regenerate, but violence there shall be. When we are through with you, %townname% will not be spared.%SPEECH_OFF%A line of strongmen get up out of the terrain where they were hiding. By the looks of it, this is the main war party of the village you burned down. They may have been out raiding when you sacked the place. Now here they are seeking barbarian retribution.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "To arms!",
                        function getResult()
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.CombatID = "Revenge";
                            properties.Music = this.Const.Music.BarbarianTracks;
                            properties.EnemyBanners.push(this.Flags.get("EnemyBanner"));
                            properties.Entities = [];
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
                            properties.Parties.push(party);
                            this.Const.World.Common.addUnitsToCombat(party, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(properties, false, true, false);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Revenge2",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_145.png[/img]{The savages are driven from %townname%. Despite the results, it takes time for the villagers to emerge and see your victory in full. %employer% eventually comes out clapping and hollering. There\'s a retinue of sheepish lieutenants looking around, their knees muddied, stray straw and clods of earth all over them. It appears they were hiding.%SPEECH_ON%Well done, sellsword, well done! The old gods surely all of that and will reward you in good time!%SPEECH_OFF%You sheathe your sword and nod at the man\'s useless lieutenants.%SPEECH_ON%Maybe, but you better do it first anyway. The old gods would surely appreciate your acting on their behalf given that others, shall we say, could not?%SPEECH_OFF%The man purses his lips and glances at his lieutenants who glance away. Your employer smiles and nods.%SPEECH_ON%Of course, of course, sellsword. I understand you well. You shall be paid in full and then some! All well-earned, truly!%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "A hard day\'s work.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You saved " + this.Contract.m.Home.getName() + " from barbarian revenge");
                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
                }

            });
            this.m.Screens.push({
                ID = "Revenge3",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_94.png[/img]{You\'re run off the field of battle and retreat to a safe enough spot to watch the ruination of %townname%. The savages dip into homes and start raping and murdering of both men and women. Children are collected up and heaved into cages made of bone and hide where the elder gently hands them sliced apples and cups of camphor. At the town square you watch as the primitives set upon %employer%\'s home. A few guards step forward, but they\'re cut down almost immediately. One man is laid out upon the ground and is stripped and kicked toward a pair of dogs who tear at him from every which way and he survives and uncomfortably long time. \n\n Finally, %employer% is dragged out of his home. The barbarian leader stares down at him, nods, then grabs him by the neck with one hand and covers his face with the other. In this suspension the man is suffocated. The corpse is then thrown to the warband who have it stripped, desecrated, and then impaled from anus to mouth and lifted high up in the town square. Once the pillaging is done, the savages take what look they want and depart. The last you see of them is a dog trotting with a human ribcage in its maw. %randombrother% comes to your side.%SPEECH_ON%Well. I don\'t think we\'re getting paid, sir.%SPEECH_OFF%No. You suspect not.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "All is lost.",
                        function getResult()
                        {
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
                            this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
                            this.Contract.m.Home.setLastSpawnTimeToNow();
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "You failed to save " + this.Contract.m.Home.getName() + " from barbarians out for revenge");
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ]
            });
            this.m.Screens.push({
                ID = "Success1",
                Title = "Near %townname%...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your entrance with applause.%SPEECH_ON%My scouts tracked your company to the north and to its, dare I say, inevitable success! Splendid work murdering those savages. Surely this will make them think twice about venturing down here again!%SPEECH_OFF%The man pays you what you\'re owed. | You enter %employer%\'s room and find him slackened into his chair. He\'s watching a naked woman saunter from one side of the room to the other. Shaking his head, he talks to you while not taking his eyes from the show.%SPEECH_ON%My scouts have already told me of your doings. Said you put it to the barbarians like they\'d done their wrongs against you personally. I like that. I like the lack of restraint. Wish more of my own men had it.%SPEECH_OFF%A servant, previously unseen, quickly marches across the room. He\'s got a red candle atop his head and a chest of crowns in his hands. You take your pay and leave the room as quick as you can. | You find %employer% and a group of armored men standing around a table. A barbarian\'s corpse is on it. The flesh is greyed, but the body\'s musculature and grit has not yet been decayed. They ask if you truly fought men of this sort. You cut to the chase and ask for your pay. %employer% claps and shows you off to the group.%SPEECH_ON%Gentlemen, this is the sort of man I want in my ranks! Unfearful and always focused.%SPEECH_OFF%One of the nobles spits and says something you don\'t hear. You ask him to speak up if he\'s something to say, but %employer% rushes forward, chest of crowns in hand, and sends you on your way. | Finding %employer% proves a little difficult, a hunt that ends in a seemingly abandoned barn. You see him standing before a dead barbarian, the corpse hanging from the rafters by his legs like a fisherman\'s haul. The body has been burned, mutilated, and all else. %employer% crouches and washes his hands in a bucket.%SPEECH_ON%I\'ve to say, sellsword, you killing a whole number of these savages is most impressive. This one here lasted a good long while. Took to the pain like he was gonna pay it forward to me tenfold. But he never did. Did you?%SPEECH_OFF%The man gently slaps the barbarian\'s face and the chains clink as the body gently twists. %employer% nods.%SPEECH_ON%A servant outside will have your pay. A job well done, sellsword.%SPEECH_OFF% | You find %employer% and a group of men overseeing the defense of %townname%, no doubt preparing themselves for whatever attack may come next. Judging by the appearance of the men, their ambitions of survival will meet a reality far more cruel than they are ready for. But you keep that to yourself. %employer% thanks you for a job well done and pays you what is owed. | A few denizens of %townname% see your return with horrified confusion, mistaking you for the savages that they\'d come to know. Windows are shuttered, doors slammed closed, children hurried away, and a few braver souls step out with pitchforks. %employer% hurries out of his abode and sets them straight, explaining you are the heroes of the tale, that you went north and annihilated the savages, burned their village, and scattered them to the wastes. Windows swing wide and doors creak open and the children return to their play. Just when you think order has returned, an old woman snarls.%SPEECH_ON%A sellsword is just a savage by another name!%SPEECH_OFF%Sighing, you tell %employer% to pay what is owed. | %employer% is studying a few scrolls. He\'s also penning notes into them and crossing others out. Looking up, he explains that he\'s putting you into the records as a \'hero who went to the wastes\' and \'slaughtered the savages in a fashion most proper and southernly.\' He asks you to remind him what your name is. You ask him to pay you what you\'re owed. | %employer% is in the company of a group of sobbing women. He\'s consoling them and when you enter he stands and points you out to them.%SPEECH_ON%Behold! The man who has slain those who murdered your husbands!%SPEECH_OFF%The women wail and clamber to you, one after the other, and you know what to do besides nod sternly and stoically. %employer% is the last of the crowd to find you, a chest of crowns in his arm and a wry smile on his lips. You take your pay and the man returns to the women.%SPEECH_ON%There there, fine ladies, the world will see a new dawn. Please, come with me. Does anyone want wine?%SPEECH_OFF% | %employer% welcomes you with open arms. You decline a hug and ask for your pay. He returns to his desk.%SPEECH_ON%I wasn\'t trying to hug you, sellsword.%SPEECH_OFF%He taps the chest rather despondently.%SPEECH_ON%But you did a good job slaughtering those savages. I\'ve a number of scouts who reported it as a \'splendid time\' you had out there. You\'ve earned this.%SPEECH_OFF%He pushes the chest across the desk and you take it at arm\'s length, meeting a slight bit of resistance as he holds onto it. You hurriedly leave the room without looking at him again. | You have a hard time finding %employer%, eventually finding him halfway down a well shaft plugging a hole with a stone slab. He shouts up to you.%SPEECH_ON%Ah, the sellsword. Hoist me up, men!%SPEECH_OFF%A pulley system draws up the plank upon which he sits. He swings his legs off and rests them on the rim of the wellhead.%SPEECH_ON%Our mason was killed by a donkey so I thought I\'d lend a hand myself. Nothing like a little dirty work to get a good man up in the morn\'.%SPEECH_OFF%He slaps your chest with his glove, it leaves a powdered outline. He nods and fetches a servant to go get your pay.%SPEECH_ON%A job well done, sellsword. Very, very well done. Heh.%SPEECH_OFF%You don\'t humor him. | %employer% is found giving a speech to a crowd of peasants. He describes an unnamed force of southerners that headed north and annihilated the savage scum. At no point are you or the %companyname% named. When he\'s done, the mob of peons cheer and clap and flowers are thrown and a general state of festivity takes over. %employer% seeks you out and shakes your hand while pushing a chest of crowns toward you.%SPEECH_ON%I wish I could call you the hero to these fine folk, but mercenaries are not seen in the best of light.%SPEECH_OFF%You wrap your hands around the payment and lean forward.%SPEECH_ON%All I want is the pay. Have fun out there, %employer%.%SPEECH_OFF% | You find %employer% attending a funeral ceremony. They\'re burning a pyre weighed with three corpses and what may possibly be a fourth, smaller one. Possibly a whole family. %employer% says a few kind words and then sets the woodwork ablaze. A servant surprises you with a chest of crowns.%SPEECH_ON%%employer% does not wish to be bothered. Here is your pay, sellsword. Please count if you do not trust it is all there.%SPEECH_OFF%}",
                Image = "",
                Characters = [],
                List = [],
                ShowEmployer = true,
                Options = [
                    {
                        Text = "Crowns well deserved.",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
                            this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
                            this.World.Contracts.finishActiveContract();
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_money.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
                    });
                    this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
                }

            });
        }

    });

	::mods_hookExactClass("contracts/contracts/drive_away_nomads_contract", function(o){

        o.createStates = function()
        {
            this.m.States.push({
                ID = "Offer",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Drive off nomads at " + this.Flags.get("DestinationName") + " %direction% of %origin%"
                    ];
                    this.Contract.setScreen("Task");
                }

                function end()
                {
                    this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
                    this.Contract.m.Destination.clearTroops();
                    this.Contract.m.Destination.setLastSpawnTimeToNow();

                    if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
                    {
                        this.Contract.m.Destination.getLoot().clear();
                    }

                    this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                    this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
                    this.Contract.m.Destination.setDiscovered(true);
                    this.Contract.m.Destination.resetDefenderSpawnDay();
                    this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
                    local r = this.Math.rand(1, 100);

                    if (r <= 10)
                    {
                        if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
                        {
                            this.Flags.set("IsSandGolems", true);
                        }
                    }
                    else if (r <= 25)
                    {
                        if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
                        {
                            this.Flags.set("IsTreasure", true);
                            this.Contract.m.Destination.clearTroops();
                            this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                        }
                    }
                    else if (r <= 35)
                    {
                        if (this.World.Assets.getBusinessReputation() > 800)
                        {
                            this.Flags.set("IsAssassins", true);
                        }
                    }
                    else if (r <= 45)
                    {
                        if (this.World.getTime().Days >= 3)
                        {
                            this.Flags.set("IsNecromancer", true);
                            this.Contract.m.Destination.clearTroops();
                            local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
                            this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
                            this.Contract.m.Destination.setFaction(zombies.getID());
                            zombies.addSettlement(this.Contract.m.Destination.get(), false);
                            this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NecromancerSouthern, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
                        }
                    }
                    else if (r <= 50)
                    {
                        this.Flags.set("IsFriendlyNomads", true);
                    }

                    this.Contract.setScreen("Overview");
                    this.World.Contracts.setActiveContract(this.Contract);
                }

            });
            this.m.States.push({
                ID = "Running",
                function start()
                {
                    if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
                    {
                        this.Contract.m.Destination.getSprite("selection").Visible = true;
                        this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));

                        if (this.Flags.get("IsNecromancer"))
                        {
                            this.Contract.m.Destination.m.IsShowingDefenders = false;
                        }
                    }
                }

                function update()
                {
                    if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
                    {
                        if (this.Flags.get("IsTreasure"))
                        {
                            this.Flags.set("IsTreasure", false);
                            this.Contract.setScreen("Treasure2");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            this.Contract.setState("Return");
                        }
                    }
                }

                function onDestinationAttacked( _dest, _isPlayerAttacking = true )
                {
                    if (this.Flags.get("IsSandGolems"))
                    {
                        if (!this.Flags.get("IsAttackDialogTriggered"))
                        {
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.setScreen("SandGolems");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.Music = this.Const.Music.OrientalBanditTracks;
                            properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
                            local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Const.Faction.Enemy);
                            properties.Parties.push(party);
                            for( local i = 0; i < e; i = ++i )
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.SandGolem
                                }, false);
                            }
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(properties, true, true, true);
                        }
                    }
                    else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
                    {
                        this.Flags.set("IsAttackDialogTriggered", true);
                        this.Contract.setScreen("Treasure1");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsNecromancer") && !this.Flags.get("IsAttackDialogTriggered"))
                    {
                        this.Flags.set("IsAttackDialogTriggered", true);
                        this.Contract.setScreen("Necromancer");
                        this.World.Contracts.showActiveContract();
                    }
                    else if (this.Flags.get("IsAssassins"))
                    {
                        if (!this.Flags.get("IsAttackDialogTriggered"))
                        {
                            this.Flags.set("IsAttackDialogTriggered", true);
                            this.Contract.setScreen("Assassins");
                            this.World.Contracts.showActiveContract();
                        }
                        else
                        {
                            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
                            properties.Music = this.Const.Music.OrientalBanditTracks;
                            properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
                            local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);
                            local party = this.new("scripts/entity/world/party");
                            party.setFaction(this.Contract.m.Destination.getFaction());
                            properties.Parties.push(party);
                            for( local i = 0; i < e; i = ++i )
                            {
                                this.Const.World.Common.addTroop(party, {
                                    Type = this.Const.World.Spawn.Troops.Assassin
                                }, false);
                            }
                            foreach(troop in party.getTroops()) {
                                properties.Entities.push(troop);
                            }
                            this.World.Contracts.startScriptedCombat(properties, true, true, true);
                        }
                    }
                    else
                    {
                        this.World.Contracts.showCombatDialog();
                    }
                }

            });
            this.m.States.push({
                ID = "Return",
                function start()
                {
                    this.Contract.m.BulletpointsObjectives = [
                        "Return to " + this.Contract.m.Home.getName()
                    ];
                    this.Contract.m.Home.getSprite("selection").Visible = true;
                }

                function update()
                {
                    if (this.Contract.isPlayerAt(this.Contract.m.Home))
                    {
                        this.Contract.setScreen("Success1");
                        this.World.Contracts.showActiveContract();
                    }
                }

            });
        }

    });


});

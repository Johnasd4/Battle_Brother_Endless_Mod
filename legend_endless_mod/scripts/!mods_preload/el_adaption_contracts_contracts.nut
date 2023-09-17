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
                            party.getFlags().set("isContractLocation", true);
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
            party.getFlags().set("isContractLocation", true);
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
                        ally_party.getFlags().set("isContractLocation", true);
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
                        enemy_party.getFlags().set("isContractLocation", true);
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
                            party.getFlags().set("isContractLocation", true);
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
                            party.getFlags().set("isContractLocation", true);
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
                        enemy_party.getFlags().set("isContractLocation", true);
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);
                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));


                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.getFlags().set("isContractLocation", true);
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 10, this.Contract.getFaction());
                            p.AllyBanners.push("banner_noble_11");
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }



                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
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
                        enemy_party.getFlags().set("isContractLocation", true);
                        enemy_party.setFaction(this.Flags.get("EnemyID"));
                        p.Parties.push(enemy_party);

                        this.Const.World.Common.addUnitsToCombat(enemy_party, this.Const.World.Spawn.Southern, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
                        p.EnemyBanners = [
                            this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
                        ];

                        if (this.Flags.get("IsLocalsRecruited"))
                        {
                            local ally_party = this.new("scripts/entity/world/party");
                            ally_party.getFlags().set("isContractLocation", true);
                            ally_party.setFaction(this.Contract.getFaction());
                            p.Parties.push(ally_party);
                            this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
                            p.AllyBanners.push("banner_noble_11");
                            foreach(troop in ally_party.getTroops()) {
                                p.Entities.push(troop);
                            }
                        }

                        foreach(troop in enemy_party.getTroops()) {
                            p.Entities.push(troop);
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

                            if (this.Flags.get("IsAlliedReinforcements"))
                            {
                                local ally_party = this.new("scripts/entity/world/party");
                                ally_party.getFlags().set("isContractLocation", true);
                                ally_party.setFaction(this.Contract.getFaction());
                                p.Parties.push(ally_party);
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.Noble, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
                                foreach(troop in ally_party.getTroops()) {
                                    p.Entities.push(troop);
                                }
                                p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
                            }

                            if (this.Flags.get("IsLocalsRecruited"))
                            {
                                local ally_party = this.new("scripts/entity/world/party");
                                ally_party.getFlags().set("isContractLocation", true);
                                ally_party.setFaction(this.Contract.getFaction());
                                p.Parties.push(ally_party);
                                this.Const.World.Common.addUnitsToCombat(ally_party, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
                                foreach(troop in ally_party.getTroops()) {
                                    p.Entities.push(troop);
                                }
                                p.AllyBanners.push("banner_noble_11");
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
        o.createScreens = function()
        {
            this.importScreens(this.Const.Contracts.NegotiationDefault);
            this.importScreens(this.Const.Contracts.Overview);
            this.m.Screens.push({
                ID = "Task",
                Title = "Negotiations",
                Text = "[img]gfx/ui/events/event_45.png[/img]{%SPEECH_START%Dune rune bastards.%SPEECH_OFF%This is the first thing you hear upon entering %employer%\'s room. He begrudgingly waves you in.%SPEECH_ON%The war with the South continues, but they\'ve taken it upon themselves to break bonds of unspoken agreements: they\'re moving on %holysite% and I\'ve no means to protect it. I\'m not one to dally on how important the grounds are, but if I were to let it slide the public will undoubtedly clip my nuts. Being that I quite like my balls, I\'ll put %reward% crowns on the table for you to go there and defend %holysite%.%SPEECH_OFF% | You find %employer% trying to talk his way over a throng of peasants. It appears news has arrived that Southern soldiers are approaching %holysite%.%SPEECH_ON%We\'ve unspoken rules that these sacred grounds, they\'re, they\'re... they\'re sacred!%SPEECH_OFF%Seeing you, the nobleman clears a path, announcing you as brave warriors that he beckoned a week ago. When he gets near, however, he shelters his voice in a whisper.%SPEECH_ON%These idiots don\'t need to know you\'re sellswords. Look, the Southerners jammed a stick far up my ass on this one. The savages truly are making a move on %holysite% and I need you to get there and stop them. %reward% crowns should be sufficient for this task, yeah?%SPEECH_OFF%}",
                Image = "",
                List = [],
                ShowEmployer = true,
                ShowDifficulty = true,
                Options = [
                    {
                        Text = "{The %companyname% can help you with this. | Defending against a southern host better pay well. | I\'m interested, go on.}",
                        function getResult()
                        {
                            return "Negotiation";
                        }

                    },
                    {
                        Text = "{This isn\'t worth it. | We\'re needed elsewhere. | I won\'t risk the company against southern machines of war.}",
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
                ID = "Approaching1",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{The great caldera has been mostly emptied of its faithful and curious occupants. Even the slightest suggestion of war has dispersed believers back to the shelters of their respective priories. After all, there will be a winner and a loser in the hours to come. A certain level of vigor may entreat the former to overindulging themselves on righteousness...}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll set up camp here.",
                        function getResult()
                        {
                            return "Preparation1";
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsArrived", true);
                }

            });
            this.m.Screens.push({
                ID = "Approaching0",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{The Oracle isn\'t as you last remember it: many of the faithful have departed and the drums of war have come to the ancient temple\'s doorstep. Not that it matters. You\'ve no visions to seek here, no dreams to unwind, only nightmares to provide your enemies.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll set up camp here.",
                        function getResult()
                        {
                            return "Preparation1";
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsArrived", true);
                }

            });
            this.m.Screens.push({
                ID = "Approaching2",
                Title = "As you approach...",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{Ironically, the leveled city which dwells beneath the half-blown mountain finally feels eerily abandoned. Few of the faithful linger, the rest having departed long before the religious strife arrives upon their tent cities and spiritual interloping.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll set up camp here.",
                        function getResult()
                        {
                            return "Preparation1";
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsArrived", true);
                }

            });
            this.m.Screens.push({
                ID = "Preparation1",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{You believe you have made a modest defense out of what positions %holysite% can give. With what little time remains, there\'s probably at least one serious task you can set the %companyname% to completing. It\'s just a question of what exactly would suit the company best.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Build palisades to further bolster the walls!",
                        function getResult()
                        {
                            return "Preparation2";
                        }

                    },
                    {
                        Text = "Search these grounds for anything that could be of use to us!",
                        function getResult()
                        {
                            return "Preparation3";
                        }

                    },
                    {
                        Text = "Recruit some of the faithful to help us in the defense!",
                        function getResult()
                        {
                            return "Preparation4";
                        }

                    }
                ],
                function start()
                {
                    this.Contract.setState("Running_Defend");
                }

            });
            this.m.Screens.push({
                ID = "Preparation2",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{Looting the holy site itself, which you\'ll tell no one of your doing, and pilfering through the abandoned belongings of the faithful, you manage to scrap together enough wood to reinforce a set of walls that ring a corner of %holysite%. It is in your estimation the best spot for an attacker to come in, and thus the one you\'ll want to defend most.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Now we wait.",
                        function getResult()
                        {
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsPalisadeBuilt", true);
                }

            });
            this.m.Screens.push({
                ID = "Preparation3",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{You have the men scour the area for battle supplies. A litany of items are pilfered and piled. Once the whole of %holysite% has been combed, you and the men spend a few minutes figuring out what would be of most use...}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Now we wait.",
                        function getResult()
                        {
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    for( local i = 0; i < 2; i = i )
                    {
                        local r = this.Math.rand(1, 12);
                        local item;

                        switch(r)
                        {
                        case 1:
                            item = this.new("scripts/items/weapons/oriental/saif");
                            break;

                        case 2:
                            item = this.new("scripts/items/tools/throwing_net");
                            break;

                        case 3:
                            item = this.new("scripts/items/weapons/oriental/polemace");
                            break;

                        case 4:
                            item = this.new("scripts/items/weapons/ancient/broken_ancient_sword");
                            break;

                        case 5:
                            item = this.Const.World.Common.pickArmor([
                                [
                                    1,
                                    "ancient/ancient_mail"
                                ]
                            ]);
                            break;

                        case 6:
                            item = this.new("scripts/items/supplies/ammo_item");
                            break;

                        case 7:
                            item = this.new("scripts/items/supplies/armor_parts_item");
                            break;

                        case 8:
                            item = this.new("scripts/items/shields/ancient/tower_shield");
                            break;

                        case 9:
                            item = this.new("scripts/items/loot/ancient_gold_coins_item");
                            break;

                        case 10:
                            item = this.new("scripts/items/loot/silver_bowl_item");
                            break;

                        case 11:
                            item = this.new("scripts/items/weapons/wooden_stick");
                            break;

                        case 12:
                            local helmet = [
                                [
                                    1,
                                    "oriental/spiked_skull_cap_with_mail"
                                ]
                            ];
                            item = this.Const.World.Common.pickHelmet(helmet);
                            break;
                        }

                        if (item.getConditionMax() > 1)
                        {
                            item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 50) * 0.01));
                        }

                        this.World.Assets.getStash().add(item);
                        this.List.push({
                            id = 10,
                            icon = "ui/items/" + item.getIcon(),
                            text = "You gain " + item.getName()
                        });
                        i = ++i;
                    }

                    local amount = this.Math.rand(10, 30);
                    this.World.Assets.addArmorParts(amount);
                    this.List.push({
                        id = 10,
                        icon = "ui/icons/asset_supplies.png",
                        text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
                    });
                }

            });
            this.m.Screens.push({
                ID = "Preparation4",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{What few faithful still linger around the %holysite% must be the most fervid and zealous. Being that you are here representing the north, you have the men pick out a few hardy looking old gods zealots and ask that they fight for their gods. It is a convenient recruiting tool if there ever was one, and they are quick to arm themselves and undergo the shortest of training. You can only hope they are of any use in the actual battle to come.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Now we wait.",
                        function getResult()
                        {
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsLocalsRecruited", true);
                }

            });
            this.m.Screens.push({
                ID = "TheEnemyAttacks",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_164.png[/img]{The southerners appear over the horizon. Followers of the Gilded One is an apt description for their armor glints and shines even at great distance. %randombrother% spits and looks over.%SPEECH_ON%They look far too dapper for a buncha dead men. You ever wonder if we just dressed ourselves like a buncha djinn and rode out with all the confidence of little devils them southerners would just up and leave?%SPEECH_OFF%Smiling, you draw out your sword and command the men to battle.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Take formation!",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Quartermaster",
                Title = "At %townname%",
                Text = "[img]gfx/ui/events/event_158.png[/img]{Leaving %townname%, you\'re approached by a man flying %employerfaction%\'s banner off the back end of a wagon. He states that he is a quartermaster for your employer and he has a few supplies to offload.%SPEECH_ON%Got a couple of wardogs, nets and throwing spears. I\'ve been told you can have one or the other, but not all as there are plenty of fightin\' men in need around here.%SPEECH_OFF%}",
                Image = "",
                Banner = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll take the wardogs.",
                        function getResult()
                        {
                            for( local i = 0; i < 3; i = i )
                            {
                                local item = this.new("scripts/items/accessory/wardog_item");
                                this.World.Assets.getStash().add(item);
                                i = ++i;
                            }

                            return 0;
                        }

                    },
                    {
                        Text = "We\'ll take the nets.",
                        function getResult()
                        {
                            for( local i = 0; i < 4; i = i )
                            {
                                local item = this.new("scripts/items/tools/throwing_net");
                                this.World.Assets.getStash().add(item);
                                i = ++i;
                            }

                            return 0;
                        }

                    },
                    {
                        Text = "We\'ll take the throwing spears.",
                        function getResult()
                        {
                            if (this.Const.DLC.Wildmen)
                            {
                                for( local i = 0; i < 4; i = i )
                                {
                                    local item = this.new("scripts/items/weapons/throwing_spear");
                                    this.World.Assets.getStash().add(item);
                                    i = ++i;
                                }
                            }
                            else
                            {
                                for( local i = 0; i < 4; i = i )
                                {
                                    local item = this.new("scripts/items/weapons/javelin");
                                    this.World.Assets.getStash().add(item);
                                    i = ++i;
                                }
                            }

                            return 0;
                        }

                    },
                    {
                        Text = "We have all that we need. Save it for the others.",
                        function getResult()
                        {
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsQuartermaster", false);
                    this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
                }

            });
            this.m.Screens.push({
                ID = "SallyForth1",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_164.png[/img]{The southerners appear, but it is not in full force, and nor is it necessarily just their scouts. It seems they have spent little time keeping cohesion and have instead spread themselves out on the approach. If you were to sally forth and attack now, you\'d likely catch them with their drawers down.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We need to seize this opportunity. Prepare the men to sally forth!",
                        function getResult()
                        {
                            return this.Math.rand(1, 100) <= 50 ? "SallyForth2" : "SallyForth4";
                        }

                    },
                    {
                        Text = "We have a defensible position here. We stay put.",
                        function getResult()
                        {
                            return "SallyForth5";
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "SallyForth2",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the southerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons.\n\nJudging by his shrill voice, the only commander in the area isn\'t trained for this sort of thing as his voice cracks with every barked order as some semblance of a formation tries to take shape. Wasting no more time, you charge into the fray!}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Charge!",
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
                ID = "SallyForth3",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_90.png[/img]{You finish off the last of the soldiers, the look of surprise still grimly shaped across their faces.%SPEECH_ON%Captain, got the rest coming.%SPEECH_OFF%%randombrother% says, returning from a quick gaze of the horizon. Nodding, you order the men to get ready. This time, the southerners are making an approach in good formation, though it briefly waivers at the sight of you and the dead littered about your feet. Their banner rises into the sky and the southerners are revivified, charging forth with anger and energy. Shouts of \'for the Gilder!\' ripple through the air. You point your sword forward.%SPEECH_ON%Admirable in their faith they might be, no god shall find them here, only the %companyname% awaits and we\'ve but one prayer to offer.%SPEECH_OFF%The men roar as the battle hastens upon them.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Rally! Rally! Get ready!",
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
                ID = "SallyForth4",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the southerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons. Just when you think you have the upper hand, another contingent arrives from the side.%SPEECH_ON%The Gilder smiles only upon those who deserve His gleam, Crownling!%SPEECH_OFF%The southern commander shouts mockingly. With the defenses too far, and the enemy too close, there\'s only one place to go now. You raise your sword and ready the men to charge.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "We\'ll fight our way out of this!",
                        function getResult()
                        {
                            this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Flags.set("IsEnemyReinforcements", true);
                }

            });
            this.m.Screens.push({
                ID = "SallyForth5",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{You figure it\'s best to man the defenses. It might let an opportunity slip, but it is in part the safest of all available options.%SPEECH_ON%Shoulda went out. We missed something there on that one, captain.%SPEECH_OFF%Looking over you find %randombrother% shrugging. You tell him to mind his tongue, or he\'ll be missing something himself.}",
                Image = "",
                List = [],
                Options = [
                    {
                        Text = "Everyone, get ready. They\'ll soon attack in full force.",
                        function getResult()
                        {
                            this.Flags.set("IsSallyForth", false);
                            this.Flags.set("AttackTime", 1.0);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "AlliedSoldiers1",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_78.png[/img]{As you await the southerners, a troop of northerners arrives. Their lieutenant tips his helmet.%SPEECH_ON%When they told me to come out this way to aide a sellsword, I said they can go shit that command out their arse. But you know what convinced me? Knowing it was the %companyname%. You\'ve reputation, and I\'ve men to spare for this fight.%SPEECH_OFF%Judging by their equipment, they\'d be best used as a screening force to perhaps draw away elements of the oncoming enemy force. That, or perhaps it\'d be best to just fold them into the company, bolstering your ranks where you\'re already strongest.}",
                Image = "",
                Banner = "",
                List = [],
                Options = [
                    {
                        Text = "I need you and your men to flank their gunners, lieutenant.",
                        function getResult()
                        {
                            this.Flags.set("IsEnemyLuredAway", true);
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return "AlliedSoldiers2";
                        }

                    },
                    {
                        Text = "I need you and your men to lure away some of their infantry, lieutenant.",
                        function getResult()
                        {
                            this.Flags.set("IsEnemyLuredAway", true);
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return "AlliedSoldiers2";
                        }

                    },
                    {
                        Text = "I need you and your men to fight at our side, lieutenant.",
                        function getResult()
                        {
                            this.Flags.set("IsAlliedReinforcements", true);
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return "AlliedSoldiers3";
                        }

                    }
                ],
                function start()
                {
                    this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
                    this.Flags.set("IsAlliedSoldiers", false);
                }

            });
            this.m.Screens.push({
                ID = "AlliedSoldiers2",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_78.png[/img]{You take out a long-glass and scope the battlefield ahead. The northern troop charge toward the enemy in a chevron formation, and then split off at the wings to run off in separate directions. It seems a suicidal charge, but much to your surprise they\'ve made a tasty retreat the southerners can\'t quite resist. You watch as the Gilder\'s followers don\'t keep their eye on the shine, instead depleting their ranks to chase down the feint.%SPEECH_ON%Worked like a charm, captain.%SPEECH_OFF%%randombrother% says.}",
                Image = "",
                Banner = "",
                List = [],
                Options = [
                    {
                        Text = "Very good.",
                        function getResult()
                        {
                            this.Flags.set("IsAlliedSoldiers", false);
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
                }

            });
            this.m.Screens.push({
                ID = "AlliedSoldiers3",
                Title = "At %holysite%",
                Text = "[img]gfx/ui/events/event_78.png[/img]{You\'d rather the soldiers stay with you. The lieutenant nods.%SPEECH_ON%Yessir, captain, uh, what\'s your name?%SPEECH_OFF%Ignoring him, you tell %randombrother% to accommodate the northern troop to the defenses.%SPEECH_ON%Make sure they know it well, but not too well.%SPEECH_OFF%The sellsword leans in and whispers.%SPEECH_ON%Ah, if they\'re spies we don\'t want to give them too much detail, aye captain?%SPEECH_OFF%You lean in and whisper back.%SPEECH_ON%No. Put them where we are weakest. Hopefully they all eat shit on the frontline and then we\'ll have their belongings.%SPEECH_OFF%}",
                Image = "",
                List = [],
                Banner = "",
                Options = [
                    {
                        Text = "Now we wait again.",
                        function getResult()
                        {
                            this.Flags.set("IsAlliedSoldiers", false);
                            this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
                            return 0;
                        }

                    }
                ],
                function start()
                {
                    this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
                }

            });
            this.m.Screens.push({
                ID = "Victory",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/event_168.png[/img]{The last southern soldier looks up at you.%SPEECH_ON%By the Gilder\'s gleam, I am ready.%SPEECH_OFF%You draw out your sword.%SPEECH_ON%And of what use was that gleam if I\'m the one here, and you there?%SPEECH_OFF%Before he can respond, you put the blade through his neck. You tell the sellswords to loot the remains and ready a return to %employer%. | You find the last of the southern soldiers perched against a rock, his arm slung across its top as though it were a drinking buddy. He spits blood and nods.%SPEECH_ON%Perhaps my path was not so gilded as I thought.%SPEECH_OFF%Nodding back, you tell him that he can ask the Gilder about that himself real soon here.%SPEECH_ON%And I\'ll ask Him about you, too.%SPEECH_OFF%He responds. You pause for a moment on that comment, then run him through with the sword. The rest of the remains will need to be looted. %employer% should be happy to see you. | The battle is over and the dead litter the field. You stand over the last breathing southerner. He stares over your shoulder at the sky. When you ask if he thinks his \'Gilder\' is watching, the man smiles.%SPEECH_ON%He\'s watching us both.%SPEECH_OFF%You nod and then end his life. With a sharp whistle, you get the %companyname%\'s attention. Your orders are simple: loot what\'s worthwhile, and then ready to return to %employer%.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Victory!",
                        function getResult()
                        {
                            this.Contract.spawnAlly();
                            this.Contract.setState("Return");
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Failure",
                Title = "After the battle...",
                Text = "[img]gfx/ui/events/%illustration%.png[/img]{The southerners raise their banners over %holysite%.%SPEECH_ON%I suppose that\'s it, then.%SPEECH_OFF%%randombrother% says. If by \'it\' you mean there\'s no reason to see %employer% about the end of the contract then yes, that is indeed it.}",
                Image = "",
                Characters = [],
                List = [],
                Options = [
                    {
                        Text = "Disaster!",
                        function getResult()
                        {
                            this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend a holy site");
                            this.World.Contracts.finishActiveContract(true);
                            return 0;
                        }

                    }
                ],
                function start()
                {
                }

            });
            this.m.Screens.push({
                ID = "Success",
                Title = "On your return...",
                Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%I take it them southern shits squealed when you put an end to their farkin\' around.%SPEECH_OFF%%employer% bites into half a chicken breast before you can respond. And he keeps talking anyway, mouth only full of contents insofar as they have not yet launched out and spread across the table.%SPEECH_ON%Ya know, I\'d doubt of the old gods, but now, with this, I can see their ways are true, and their divinity most righteous.%SPEECH_OFF%He swallows what\'s left and slams the chicken on his plate.%SPEECH_ON%Pay the sellsword his money.%SPEECH_OFF% | You find %employer% in the company of a few monks, their prior, and women who don\'t look in remotely marital status with anyone. The nobleman is grinning ear to ear.%SPEECH_ON%Word of your doings reached us a few days ago. The old gods raise their chalices to your men, sellsword. I\'m sure you gave them southerners all the hells they deserve, and in which they no doubt dwell. Your payment, as promised.%SPEECH_OFF%A few of the women go toward you, but are quickly reeled back.%SPEECH_ON%Ladies, ladies, please, be proper. Sellsword.%SPEECH_OFF%%employer% points toward a chest of %reward% crowns. | You find %employer% in a priory. He is praying alone at an altar, and when he finishes he speaks without turning back.%SPEECH_ON%I believe the old gods spoke to me last night. Said you were returning with good news and indeed, here you are. Because we are alone, I\'ll tell you something. The \'Gilded\' ones riding around in that desert, I think them an earnest sort. I think whatever buildings they pray in, they\'re praying in them now. You\'ve not shook their faith at all, and someday we\'ll be out there again.%SPEECH_OFF%The nobleman stands up and turns around.%SPEECH_ON%Defeat hardens the faithful. I\'ve taken my licks, and now they have theirs. When you take your gold for the job, put in a prayer that it\'s the last you take for it.%SPEECH_OFF%You\'ll not be doing that, but feel it improper to tell the truth to an opened heart. %reward% crowns, however, makes a very proper entrance into the company\'s purse strings.}",
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
                            this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Defended a holy site");
                            this.World.Contracts.finishActiveContract();

                            if (this.World.FactionManager.isHolyWar())
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


});

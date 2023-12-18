local gt = getroottable();

::mods_registerMod("el_adaption_ambitions", 1, "el_adaption_ambitions");
::mods_queue(null, "el_ambitions", function ()
{
    ::mods_hookExactClass("ambitions/ambitions/allied_civilians_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

            foreach( a in allies )
            {
                local f = this.World.FactionManager.getFaction(a);

                if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
                {
                    _vars.push([
                        "friendlytown",
                        f.getName()
                    ]);
                    break;
                }
            }

            local brothers = this.World.getPlayerRoster().getAll();

            foreach( bro in brothers )
            {
                if (bro.getBackground().getID() == "background.brawler")
                {
                    _vars.push([
                        "brawler",
                        bro.getName()
                    ]);
                    return;
                }
            }

            foreach( bro in brothers )
            {
                if (bro.getBackground().isBackgroundType(this.Const.BackgroundType.Combat))
                {
                    _vars.push([
                        "brawler",
                        bro.getName()
                    ]);
                    return;
                }
            }

            _vars.push([
                "brawler",
                brothers[this.Math.rand(0, brothers.len() - 1)].getName()
            ]);
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/defeat_orc_location_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local fearful = [];
            local lowborn = [];

            foreach( bro in brothers )
            {
                if (bro.getSkills().hasSkill("trait.superstitious"))
                {
                    fearful.push(bro);
                }
                else if (bro.getBackground().isBackgroundType(this.Const.BackgroundType.Lowborn))
                {
                    lowborn.push(bro);
                }
            }

            local fear;

            if (fearful.len() != 0)
            {
                fear = fearful[this.Math.rand(0, fearful.len() - 1)];
            }
            else if (lowborn.len() != 0)
            {
                fear = lowborn[this.Math.rand(0, lowborn.len() - 1)];
            }
            else
            {
                fear = brothers[this.Math.rand(0, brothers.len() - 1)];
            }

            _vars.push([
                "fearful_brother",
                fear.getName()
            ]);
            _vars.push([
                "recently_destroyed",
                this.World.Statistics.getFlags().get("LastLocationDestroyedName")
            ]);
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/defeat_undead_location_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local fearful = [];
            local lowborn = [];

            foreach( bro in brothers )
            {
                if (bro.getSkills().hasSkill("trait.superstitious"))
                {
                    fearful.push(bro);
                }
                else if (bro.getBackground().isBackgroundType(this.Const.BackgroundType.Lowborn))
                {
                    lowborn.push(bro);
                }
            }

            local fear;

            if (fearful.len() != 0)
            {
                fear = fearful[this.Math.rand(0, fearful.len() - 1)];
            }
            else if (lowborn.len() != 0)
            {
                fear = lowborn[this.Math.rand(0, lowborn.len() - 1)];
            }
            else
            {
                fear = brothers[this.Math.rand(0, brothers.len() - 1)];
            }

            _vars.push([
                "fearful_brother",
                fear.getName()
            ]);
            _vars.push([
                "recently_destroyed",
                this.World.Statistics.getFlags().get("LastLocationDestroyedName")
            ]);
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/find_and_destroy_location_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local farmers = [];
            local workers = [];
            local not_farmers = [];

            foreach( bro in brothers )
            {
                if (bro.getBackground().getID() == "background.farmhand" || bro.getBackground().getID() == "background.female_farmhand")
                {
                    farmers.push(bro);
                }
                else if (bro.getBackground().getID() == "background.shepherd" || bro.getBackground().getID() == "background.miller" || bro.getBackground().getID() == "background.female_miller" || bro.getBackground().getID() == "background.daytaler")
                {
                    workers.push(bro);
                }
                else
                {
                    not_farmers.push(bro);
                }
            }

            local farmer;

            if (farmers.len() != 0)
            {
                farmer = farmers[this.Math.rand(0, farmers.len() - 1)];
            }
            else if (workers.len() != 0)
            {
                farmer = workers[this.Math.rand(0, workers.len() - 1)];
            }
            else
            {
                farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
            }

            local not_farmer;

            if (not_farmers.len() != 0)
            {
                not_farmer = not_farmers[this.Math.rand(0, not_farmers.len() - 1)];
            }
            else
            {
                not_farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
            }

            _vars.push([
                "farmer",
                farmer.getName()
            ]);
            _vars.push([
                "notfarmer",
                not_farmer.getName()
            ]);
            _vars.push([
                "recently_destroyed",
                this.World.Statistics.getFlags().get("LastLocationDestroyedName")
            ]);
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/hammer_mastery_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local candidates = [];
            local not_candidates = [];

            foreach( bro in brothers )
            {
                local p = bro.getCurrentProperties();

                if (p.IsSpecializedInHammers)
                {
                    candidates.push(bro);
                }
                else
                {
                    not_candidates.push(bro);
                }
            }
            
            if (candidates.len() == 0)
            {
                candidates = not_candidates;
            }

            _vars.push([
                "hammerbrother",
                candidates[this.Math.rand(0, candidates.len() - 1)].getName()
            ]);
            _vars.push([
                "nothammerbrother",
                not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
            ]);
        }

    });

    ::mods_hookExactClass("ambitions/ambitions/visit_settlements_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local bestBravery = 0;
            local bravest;

            foreach( bro in brothers )
            {
                if (bro.getCurrentProperties().getBravery() > bestBravery)
                {
                    bestBravery = bro.getCurrentProperties().getBravery();
                    bravest = bro;
                }
            }

            _vars.push([
                "sergeantbrother",
                bravest.getName()
            ]);
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/weapon_mastery_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
            local brothers = this.World.getPlayerRoster().getAll();
            local candidates = [];
            local not_candidates = [];

            foreach( bro in brothers )
            {
                local p = bro.getCurrentProperties();

                if (p.IsSpecializedInBows)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInCrossbows)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInThrowing)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInSwords)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInCleavers)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInMaces)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInHammers)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInAxes)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInFlails)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInSpears)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInPolearms)
                {
                    candidates.push(bro);
                }
                else if (p.IsSpecializedInDaggers)
                {
                    candidates.push(bro);
                }
                else
                {
                    not_candidates.push(bro);
                }
            }

            if (not_candidates.len() == 0)
            {
                not_candidates = brothers;
            }

            _vars.push([
                "weaponbrother",
                candidates[this.Math.rand(0, candidates.len() - 1)].getName()
            ]);
            _vars.push([
                "notweaponbrother",
                not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
            ]);
        }
    });

});
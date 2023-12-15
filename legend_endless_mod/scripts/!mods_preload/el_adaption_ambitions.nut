local gt = getroottable();

::mods_registerMod("el_adaption_ambitions", 1, "el_adaption_ambitions");
::mods_queue(null, "el_ambitions", function ()
{
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

    ::mods_hookExactClass("ambitions/ambitions/weapon_mastery_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/weapon_mastery_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
        }
    });

    ::mods_hookExactClass("ambitions/ambitions/weapon_mastery_ambition", function(o)
    {
        o.onPrepareVariables = function( _vars )
        {
        }
    });

});
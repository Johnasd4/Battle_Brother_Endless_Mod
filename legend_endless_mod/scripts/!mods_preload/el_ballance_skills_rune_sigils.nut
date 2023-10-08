local gt = getroottable();

::mods_registerMod("el_ballance_skills_rune_sigils", 1, "el_ballance_skills_rune_sigils");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/rune_sigils/legend_RSA_safety", function(o){

        o.onUpdate = function( _properties )
        {
            if (this.getItem() == null)
            {
                return;
            }

            _properties.Hitpoints += this.getItem().getRuneBonus1();
            _properties.DamageReceivedTotalMult *= 1.0 - this.getItem().getRuneBonus2() * 1.0 / 100.0;
        }

	});

	::mods_hookExactClass("skills/rune_sigils/legend_RSH_bravery", function(o){

        o.onUpdate = function( _properties )
        {
            if (this.getItem() == null)
            {
                return;
            }

            _properties.Bravery += this.getItem().getRuneBonus1();
            _properties.MoraleCheckBravery[0] += this.getItem().getRuneBonus2();
            _properties.MoraleCheckBravery[1] += this.getItem().getRuneBonus2();
            _properties.MoraleCheckBravery[2] += this.getItem().getRuneBonus2();
        }

	});

	::mods_hookExactClass("skills/rune_sigils/legend_RSS_defense", function(o){

        o.onUpdate = function( _properties )
        {
            if (this.getItem() == null)
            {
                return;
            }

            _properties.MeleeDefense += this.getItem().getRuneBonus1();
            _properties.RangedDefense += this.getItem().getRuneBonus2();
        }

	});

	::mods_hookExactClass("skills/rune_sigils/legend_RSS_radiance_effect", function(o){

        o.onUpdate = function( _properties )
        {
            this.m.IsHidden = true;
            local actor = this.getContainer().getActor();

            if (actor == null)
            {
                return;
            }

            local targets = this.Tactical.Entities.getAllInstances();
            local BlindAdjacent = false;

            foreach( tar in targets )
            {
                foreach( t in tar )
                {
                    if (!t.isAlliedWith(actor) && t.getSkills().hasSkill("special.legend_RSS_radiance") && t.getTile().getDistanceTo(actor.getTile()) == 1)
                    {
                        BlindAdjacent = true;
                        break;
                    }
                }
            }

            if (BlindAdjacent)
            {
                this.m.IsHidden = false;
                _properties.MeleeSkill -= this.m.MalusOne;
                _properties.MeleeDefense -= this.m.MalusTwo;
            }

            this.updateEffect();
        }

	});

	::mods_hookExactClass("skills/rune_sigils/legend_RSW_accuracy", function(o){

        o.onUpdate = function( _properties )
        {
            if (this.getItem() == null)
            {
                return;
            }

            _properties.MeleeSkill += this.getItem().getRuneBonus1();
            _properties.RangedSkill += this.getItem().getRuneBonus2();
        }

	});

});

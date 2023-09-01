local gt = getroottable();

::mods_registerMod("el_skills_effects_ballance", 1, "el_skills_effects_ballance");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/effects/bleeding_effect", function(o){

        o.applyDamage = function()
        {
            if (this.m.LastRoundApplied != this.Time.getRound())
            {
                this.m.LastRoundApplied = this.Time.getRound();
                local actor = this.getContainer().getActor();
                this.spawnIcon("status_effect_01", actor.getTile());
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.m.Damage * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0);
                hitInfo.DamageRegular =
                hitInfo.DamageDirect = 1.0;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.BodyDamageMult = 1.0;
                hitInfo.FatalityChanceMult = 0.0;
                actor.onDamageReceived(this.getAttacker(), this, hitInfo);

                if (--this.m.TurnsLeft <= 0)
                {
                    this.removeSelf();
                }
            }
        }

        o.getDescription = function()
        {
            return "This character is bleeding profusely from a recently received wound and will lose [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.ceil(this.m.Damage * this.getContainer().getActor().getBaseProperties().Hitpoints / 100) + "[/color] hitpoints each turn for [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] more turn(s).";
        }
	});

});

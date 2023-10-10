local gt = getroottable();

::mods_registerMod("el_ballance_skills_racial", 1, "el_ballance_skills_racial");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("skills/racial/ghost_racial", function ( o )
	{
		o.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
		{
			local actor = this.getContainer().getActor();
			if(actor.getHitpoints() > 1) {
				_properties.DamageReceivedTotalMult = 0;
				actor.setHitpoints(actor.getHitpoints() - 1);
			}
		}
	});

});

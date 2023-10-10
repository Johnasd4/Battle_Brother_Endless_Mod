local gt = getroottable();

::mods_registerMod("el_adaption_followers", 1, "el_adaption_followers");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function ( o )
	{
		o.onUpdate = function ()
		{
			this.World.Assets.m.ChampionChanceAdditional += 3;
		};
	});

});

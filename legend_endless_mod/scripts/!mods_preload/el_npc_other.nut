local gt = getroottable();

::mods_registerMod("el_npc_other", 1, "el_npc_other");
::mods_queue(null, ">el_npc", function ()
{
	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function ( o )
	{
		o.onUpdate = function ()
		{
			this.World.Assets.m.ChampionChanceAdditional += 3;
		};
	});

});

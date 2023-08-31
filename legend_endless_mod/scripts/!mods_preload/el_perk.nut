local gt = getroottable();

::mods_registerMod("el_perk", 1, "el_perk");
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

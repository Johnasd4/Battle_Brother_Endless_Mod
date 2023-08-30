local gt = getroottable();

::mods_registerMod("el_npc_other", 1, "el_npc_other");
::mods_queue(null, "el_npc", function ()
{
	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function ( o )
	{
		o.onUpdate = function ()
		{
			this.World.Assets.m.ChampionChanceAdditional += 3;
		};
	});

	for(local i = 0; i < this.Const.EL_NPC_Other.EL_Boss_Location.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPC_Other.EL_Boss_Location[i], function ( o )
		{
			local create = o.create;
			o.create = function ()
			{
				create();
				this.m.EL_IsBossTroop = true;
			};
		});
	}

});

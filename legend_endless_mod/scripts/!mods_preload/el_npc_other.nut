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

	// for(local i = 0; i < this.Const.EL_NPC_Other.EL_Boss_Location.len(); ++i) {

	// 	::mods_hookExactClass(this.Const.EL_NPC_Other.EL_Boss_Location[i], function ( o )
	// 	{
	// 		local create = o.create;
	// 		o.create = function ()
	// 		{
	// 			create();
	// 			this.m.EL_IsBossTroop = true;
	// 		};
	// 	});
	// }

	::mods_hookNewObject("entity/world/locations/legendary/black_monolith_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/legendary/kraken_cult_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/legendary/tundra_elk_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/legendary/unique_goblin_city_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/legendary/waterwheel_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/legendary/witch_hut_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});


	::mods_hookNewObject("entity/world/locations/goblin_city_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/undead_monolith_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/orc_fortress_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});

	::mods_hookNewObject("entity/world/locations/sunken_library_location", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.EL_IsBossTroop = true;
		};
	});
});

local gt = getroottable();

::mods_registerMod("EL_NPCOther", 1, "EL_NPCOther");
::mods_queue(null, "el_npc", function ()
{
	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function ( o )
	{
		o.onUpdate = function ()
		{
			this.World.Assets.m.ChampionChanceAdditional += 3;
		};
	});

	for(local i = 0; i < this.Const.EL_NPCOther.EL_BossLocation.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPCOther.EL_BossLocation[i], function ( o )
		{
			local create = o.create;
			o.create = function ()
			{
				create();
				this.m.EL_IsBossParty = true;
			};
		});
	}

	for(local i = 0; i < this.Const.EL_NPCOther.EL_getNameFunctionReplace.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPCOther.EL_getNameFunctionReplace[i], function ( o )
		{
			o.getName = function ()
			{
				return this.actor.getName();
			};
		});
	}

	::mods_hookExactClass("entity/tactical/enemies/direwolf_high", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.Name = "Frenzied Direwolf";
		};
	});

	::mods_hookExactClass("entity/tactical/enemies/hyena_high", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.Name = "Frenzied Hyena";
		};
	});


});

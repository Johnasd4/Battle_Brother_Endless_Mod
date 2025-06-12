local gt = getroottable();

::mods_registerMod("EL_NPCOther", 1, "EL_NPCOther");
::mods_queue(null, "el_npc", function ()
{

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

	for(local i = 0; i < this.Const.EL_NPCOther.EL_ContractsWithAddUnitsToEntity.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPCOther.EL_ContractsWithAddUnitsToEntity[i], function ( o )
		{
			o.EL_getMaxContractLevel <- function()
			{
				return 8;
			}
		});
	}

});

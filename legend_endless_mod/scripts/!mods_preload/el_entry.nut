local gt = getroottable();

::mods_registerMod("el_entry", 1, "el_entry");
::mods_queue(null, "el_item", function ()
{
	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
		o.EL_onNewDayItemEntry <- function() {
            local items = this.World.Assets.getStash().getItems();
            foreach( item in items )
            {
                if (item != null)
                {
                    //this.logInfo("item:" + item.getName());
                    foreach(entry in item.m.EL_EntryList)
                    {
                        entry.EL_onNewDay(item);
                    }
                }
            }

            local roster = this.World.getPlayerRoster().getAll();
            foreach( bro in roster )
            {
                local items = bro.getItems().getAllItems();
                foreach( item in items )
                {
                    if (item != null)
                    {
                        foreach(entry in item.m.EL_EntryList)
                        {
                            entry.EL_onNewDay(item);
                        }
                    }
                }
            }
		}
	});

    ::mods_hookClass("skills/skill", function(o) {
		while(!("attackEntity" in o)) o = o[o.SuperName];

		o.EL_isEntryEffect <- function() {
			return false;
		}
	});
});
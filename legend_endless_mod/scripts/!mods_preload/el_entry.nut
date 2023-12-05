local gt = getroottable();

::mods_registerMod("el_entry", 1, "el_entry");
::mods_queue(null, "el_item", function ()
{
	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
		local update = o.update;
		o.update = function( _worldState )
		{
            if(this.World.getTime().Hours != this.m.LastHourUpdated)
            {
                local times = this.World.getTime().Hours - this.m.LastHourUpdated;
                //this.logInfo("time:" + times); 
                for(local i = 0; i < times; ++i)
                {
                    this.EL_onNewHour();
                }
            }
			update(_worldState);
		}

		o.EL_onNewHour <- function() {
            local items = this.World.Assets.getStash().getItems();
            foreach( item in items )
            {
                if (item != null)
                {
                    //this.logInfo("item:" + item.getName());
                    foreach(entry in item.m.EL_EntryList)
                    {
                        entry.EL_onNewHour(item);
                    }
                    if(item.EL_getArmorType() == this.Const.EL_Item.ArmorType.BaseArmor)
                    {
                        foreach(upgrade in this.m.Upgrades)
                        {
                            if(upgrade != null)
                            {
                                foreach(entry in upgrade.m.EL_EntryList)
                                {
                                    entry.EL_onNewHour(item);
                                }
                            }
                        }
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
                            entry.EL_onNewHour(item);
                        }
                        if(item.EL_getArmorType() == this.Const.EL_Item.ArmorType.BaseArmor)
                        {
                            foreach(upgrade in this.m.Upgrades)
                            {
                                if(upgrade != null)
                                {
                                    foreach(entry in upgrade.m.EL_EntryList)
                                    {
                                        entry.EL_onNewHour(item);
                                    }
                                }
                            }
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
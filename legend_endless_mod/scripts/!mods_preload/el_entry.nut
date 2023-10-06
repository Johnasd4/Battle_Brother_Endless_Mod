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
                    foreach(entry in item.m.EL_Entrylist)
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
                        foreach(entry in item.m.EL_Entrylist)
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

        // o.onAfterUpdate <- function( _properties )
        // {
        //     onAfterUpdate(_properties);
		//     this.m.AdditionalAccuracy = this.m.Item.getAdditionalAccuracy();
        // }
	});

    ::mods_hookClass("skills/skill_container", function(o) {
		while(!("add" in o)) o = o[o.SuperName];
		o.add = function( _skill, _order = 0 )
        {
            if (!_skill.isStacking())
            {
                foreach( i, skill in this.m.Skills )
                {
                    if (!skill.isGarbage() && skill.getID() == _skill.getID())
                    {
                        if(skill.EL_isEntryEffect())
                        {
                            //this.logInfo("词条重复叠加成功" + _skill.getID());
                        }
                        else
                        {
                            skill.onRefresh();
                            return;
                        }
                    }
                }

                foreach( i, skill in this.m.SkillsToAdd )
                {
                    if (skill.getID() == _skill.getID())
                    {
                        return;
                    }
                }
            }

            _skill.setContainer(this);
            _skill.setOrder(_skill.getOrder() + _order);

            if (this.m.IsUpdating)
            {
                this.m.SkillsToAdd.push(_skill);
            }
            else
            {
                this.m.Skills.push(_skill);
                _skill.onAdded();
                _skill.m.IsNew = false;
                this.m.Skills.sort(this.compareSkillsByOrder);
                this.update();
            }
        }

        o.onSerialize = function( _out )
        {
            local numSkills = 0;

            foreach( skill in this.m.Skills )
            {
                if (skill.isSerialized() && !skill.EL_isEntryEffect())
                {
                    numSkills = ++numSkills;
                    numSkills = numSkills;
                }
            }

            _out.writeU16(numSkills);

            foreach( skill in this.m.Skills )
            {
                if (skill.isSerialized() && !skill.EL_isEntryEffect())
                {
                    _out.writeI32(skill.ClassNameHash);
                    skill.onSerialize(_out);
                }
            }
        }
	});
});
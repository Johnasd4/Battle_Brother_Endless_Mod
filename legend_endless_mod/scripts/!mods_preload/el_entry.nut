local gt = getroottable();

::mods_registerMod("el_entry", 1, "el_entry");
::mods_queue(null, "el_item", function ()
{
    ::mods_hookClass("skills/skill", function(o) {
		while(!("attackEntity" in o)) o = o[o.SuperName];

		o.EL_isEntryEffect <- function() {
			return false;
		}
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
                            this.logInfo("词条重复叠加成功1");
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
	});
});
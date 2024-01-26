this.el_accessory_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_CurrentLevel = 1.0,
        EL_StrengthLevel = 1
    },
    function EL_setCurrentLevel(_EL_currentLevel)
	{
        if(_EL_currentLevel > 1.0)
        {
		    this.m.EL_CurrentLevel = 1.0;
        }
        else if(_EL_currentLevel < 0.0)
        {
		    this.m.EL_CurrentLevel = 0.0;
        }
        else
        {
            this.m.EL_CurrentLevel = _EL_currentLevel;
        }
        //this.logInfo("ID:" + this.m.ID + " currentLevel:" + this.m.EL_CurrentLevel);
	}

    function EL_setStrengthLevel( _EL_level )
	{
        this.m.EL_StrengthLevel = _EL_level;
	}

    function EL_upgradeLevel( _EL_level )
	{
        if(this.m.EL_CurrentLevel <= 1)
        {
            this.m.EL_CurrentLevel += _EL_level;
        }
	}
});
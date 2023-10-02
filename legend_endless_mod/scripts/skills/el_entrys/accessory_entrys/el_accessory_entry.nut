this.el_accessory_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_CurrentLevel = 1.0
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
    function EL_upgrade( _EL_level )
	{
        if(this.m.EL_CurrentLevel <= 1)
        {
            this.m.EL_CurrentLevel += _EL_level;
        }
	}
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_CurrentLevel);
	}

	function onDeserialize( _in )
	{
		this.m.EL_CurrentLevel = _in.readF32();
	}

});
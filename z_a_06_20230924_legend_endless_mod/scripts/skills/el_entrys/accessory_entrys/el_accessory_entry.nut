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
	},
    function EL_upgrade()
	{
        if(this.m.EL_CurrentLevel <= 1)
        {
            this.m.EL_CurrentLevel += this.Const.EL_Accessory.EL_Entry.EntryNumFactor.NormalAccessory[this.getItem().m.EL_RankLevel];
        }
	},
});
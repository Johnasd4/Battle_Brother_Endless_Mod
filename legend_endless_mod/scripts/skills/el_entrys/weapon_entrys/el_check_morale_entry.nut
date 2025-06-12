this.el_check_morale_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {},
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_CheckMorale.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]命中目标时，根据敌我决心差使其进行一次士气降低判定[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}
	
    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        local actor = this.getContainer().getActor();
		if (_targetEntity == null || _targetEntity.isDying() || !_targetEntity.isAlive()) {
			return;
		}
		//this.logInfo("check morale");
		local difficulty = -actor.getBravery() * (_targetEntity.EL_getCombatLevel() - actor.EL_getCombatLevel()) + this.Const.EL_Weapon.EL_Entry.Factor.EL_CheckMorale.BaseOffset;
        _targetEntity.checkMorale(-1, difficulty);
	}

	function EL_getEntryColour()
	{
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special];
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_CheckMorale = true;
	}
});
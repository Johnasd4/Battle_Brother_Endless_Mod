this.el_repair_by_engrgy_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_ConditionRecoverDaliy = 100
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = "el_special_entry.repair_by_engrgy";
	}
	
	function EL_onNewHour( _item )
	{
		if(_item != null && _item.getConditionMax() != _item.getCondition() && this.World.Assets.EL_getSoulEnergy() >= 1)
		{
            local need_conditon = _item.getConditionMax() - _item.getCondition() > this.m.EL_ConditionRecoverDaliy ? this.m.EL_ConditionRecoverDaliy : _item.getConditionMax() - _item.getCondition();
            this.World.Assets.EL_addSoulEnergy(-(need_conditon / 100.0));
			_item.setCondition(this.Math.min(_item.getConditionMax(), _item.getCondition() + need_conditon));
		}
	}
});
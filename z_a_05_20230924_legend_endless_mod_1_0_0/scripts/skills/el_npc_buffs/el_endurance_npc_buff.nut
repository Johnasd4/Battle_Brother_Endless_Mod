this.el_endurance_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {},
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.endurance";
		this.m.Name = "Endurance";
		this.m.Description = "";
	}

	function onUpdate( _properties )
	{
        if(this.m.EL_RankLevel == 1) {
            _properties.IsImmuneToStun = true;
            _properties.IsImmuneToDaze = true;
            _properties.IsImmuneToRoot = true;
            _properties.IsImmuneToKnockBackAndGrab = true;
            _properties.IsImmuneToRotation = true;
        }
        else if(this.m.EL_RankLevel == 2) {
            _properties.IsImmuneToOverwhelm = true;
            _properties.IsImmuneToStun = true;
            _properties.IsImmuneToDaze = true;
            _properties.IsImmuneToRoot = true;
            _properties.IsImmuneToKnockBackAndGrab = true;
            _properties.IsImmuneToRotation = true;
            _properties.IsImmuneToDisarm = true;
            _properties.IsImmuneToSurrounding = true;
            _properties.IsImmuneToBleeding = true;
            _properties.IsImmuneToPoison = true;
            _properties.IsImmuneToDamageReflection = true;
            _properties.IsImmuneToFire = true;
            _properties.IsResistantToAnyStatuses = true;
            _properties.IsResistantToPhysicalStatuses = true;
            _properties.IsResistantToMiasma = true;
        }
	}

});


this.el_summon_ballance_effect <- this.inherit("scripts/skills/skill", {
	m = {
		EL_HitpointsOffset = 0
	},
	function create()
	{
		this.m.ID = "el_effects.summon_ballance";
		this.m.Name = "弱化";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.IconMini = "";
		this.m.Overlay = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAfterUpdate( _properties )
	{
        _properties.Hitpoints += this.m.EL_HitpointsOffset;
	}

    function EL_addHitpointsOffset(_EL_hitpointOffset)
    {
        local actor = this.getContainer().getActor();
        this.m.EL_HitpointsOffset += _EL_hitpointOffset;
        actor.setHitpoints(this.Math.min(actor.getHitpointsMax() + _EL_hitpointOffset, actor.getHitpoints()));
    }

});


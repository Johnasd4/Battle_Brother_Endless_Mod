this.el_summon_ballance_effect <- this.inherit("scripts/skills/skill", {
	m = {
		EL_HitpointsMinusPersent = 0
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

	function onUpdate( _properties )
	{
        _properties.
		_properties.Bravery -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenBravery * this.m.Count;
		_properties.Initiative -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenInitiative * this.m.Count;
		_properties.MeleeSkill -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenMeleeSkill * this.m.Count;
		_properties.RangedSkill -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenRangedSkill * this.m.Count;
		_properties.MeleeDefense -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenMeleeDefense * this.m.Count;
		_properties.RangedDefense -= this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenRangedDefense * this.m.Count;
		_properties.DamageReceivedTotalMult *= (this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenDamageReceivedTotalMult * this.m.Count + 1);
	}

    function EL_addHitpointsMinusPersent(_EL_hitpointPersent)
    {
        this.m.EL_HitpointsMinusPersent += _EL_hitpointPersent;
    }

});


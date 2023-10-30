
this.el_engrgy_shield_effect <- this.inherit("scripts/skills/skill", {
	m = {
        EL_StackMax = 0,
        EL_Stack = 0
    },
	function create()
	{
		this.m.ID = "el_effects.engrgy_shield";
		this.m.Name = "Engrgy Shield";
		this.m.Icon = "ui/perks/omens_circle.png";
		this.m.IconMini = "mini_omens_circle";
		this.m.Overlay = "omens_circle";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		return this.m.Name + ": " + this.m.EL_Stack + "/" + this.m.EL_StackMax
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 6,
				type = "text",
				text = "能量护盾: " + this.m.EL_Stack + "/" + this.m.EL_StackMax
			},
			{
				id = 7,
				type = "text",
				text = "受到伤害时会减少1层护盾层数来免疫此次伤害"
			}
		]);
		return tooltip;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
    {
        if(this.m.EL_Stack != 0) 
		{
            _properties.DamageReceivedTotalMult = 0;
            --this.m.EL_Stack;
        }
    }

	function onTurnStart()
	{
        this.m.EL_Stack += this.Math.max(1, this.Math.round(this.m.EL_StackMax * this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.StackRecoverPersentPurTurn));
		this.m.EL_Stack = this.m.EL_Stack > this.m.EL_StackMax ? this.m.EL_StackMax : this.m.EL_Stack;
	}

    function EL_setStackMax( _stackMax )
	{
		this.m.EL_StackMax += _stackMax;
	}
});





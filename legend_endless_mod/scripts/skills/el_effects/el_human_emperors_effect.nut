this.el_human_emperors_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "el_rarity_effects.into_the_breach";
		this.m.Name = "荣光";
		this.m.Icon = "skills/status_effect_73.png";
		this.m.IconMini = "status_effect_73_mini";
		this.m.Overlay = "status_effect_73";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function getDescription()
	{
		return "这个角色对从众人的支持中获取了力量。";
	}

	function getTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
        local stack = EL_getAllyNum();
		if(stack > 0)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + stack * 1 + "[/color] Melee Skill"
			});
			tooltip.push({
				id = 14,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + stack * 1 + "[/color] Melee Defense"
			});
			tooltip.push({
				id = 15,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ stack * 1 + "[/color] Ranged Defense"
			});
			tooltip.push({
				id = 16,
                type = "text",
                icon = "ui/icons/damage_dealt.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ stack * 0.08 * 100 + "%[/color] Damage Dealt"
			});
			tooltip.push({
				id = 17,
                type = "text",
                icon = "ui/icons/damage_received.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]-" + this.Math.round((1 / (1 + stack * 0.08) - 1) * 10000) * 0.01 + "%[/color] Damage Received"
			});
		}
		return tooltip;
	}

	function onUpdate( _properties )
	{
		local stack = EL_getAllyNum();
        _properties.MeleeSkill += this.Math.floor(stack * 1);
		_properties.MeleeDefense += this.Math.floor(stack * 1);
		_properties.RangedDefense += this.Math.floor(stack * 1);
		_properties.DamageTotalMult *= 1.0 + stack * 0.08;
		_properties.DamageReceivedTotalMult /= 1.0 + stack * 0.08;
	}

    function EL_getAllyNum()
    {
        local num = 0;
		if(this.Tactical.isActive())
		{
			local user = this.getContainer().getActor();
			local targets = this.Tactical.Entities.getAllInstances();

			foreach( tar in targets )
			{
				foreach( t in tar )
				{
					if (t != null && !t.isDying() && t.isAlive() && t.isAlliedWith(user))
					{
						++num;
					}
				}
			}
		}
        return num;
    }
});


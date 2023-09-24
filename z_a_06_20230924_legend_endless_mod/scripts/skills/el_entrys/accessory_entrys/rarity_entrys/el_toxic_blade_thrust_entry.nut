this.el_toxic_blade_thrust_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "entry.el_toxic_blade_thrust";
		this.m.Name = "Toxic Blade Thrust(Dagger)";
		this.m.Description = "An ominous aura lingers on the dagger, and its enemies will suffer unimaginable pain and torment.";//不详的气息在匕首上萦绕，它的敌人将遭受难以想象的痛楚与折磨
		this.m.Icon = "el_entrys/el_toxic_blade_thrust_entry.png";
		//this.m.IconMini = "el_toxic_blade_thrust_entry_mini";
		this.m.Overlay = "el_toxic_blade_thrust_entry";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getTooltip()
	{
        local result = [
            {
				id = 1,
				type = "title",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.getName() + "[/color]"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you hit an enemy, impose 3 negative effects to the target.(Elite:2, Leader:1)[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Each negative effect on the target increases your damage by an additional " + this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_ToxicBladeThrust.DamageBonus * 100 + "%[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]The health damage you cause will ignore the armor.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Dagger))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Dagger to take effect..[/color]"
            });
        }
		return result;
	}
    
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (_targetEntity != null && item != null && item.isWeaponType(this.Const.Items.WeaponType.Dagger))
		{
            local count = this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_ToxicBladeThrust.DebuffNum[_targetEntity.EL_getRankLevel()];
            for(local i = 0; i < count; ++i)
            {
                local r = this.Math.rand(0, this.Const.EL_Item_Other.NegativeEffectScripts.len() - 5);
			    _targetEntity.getSkills().add(this.new(this.Const.EL_Item_Other.NegativeEffectScripts[r]));
            }
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (_targetEntity != null && item != null && item.isWeaponType(this.Const.Items.WeaponType.Dagger) && _skill.m.IsWeaponSkill)
		{
			//this.logInfo("Use Skill name:"+_skill.getID());
			_properties.IsIgnoringArmorOnAttack = true;
			local number = EL_hasNegativeEffectNumber(_targetEntity);
			//this.logInfo("target negative effect num:" + number);
			_properties.DamageTotalMult *= (1.0 + number * this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_ToxicBladeThrust.DamageBonus);
			_properties.DamageDirectAdd = 1;
		}
	}

    function EL_hasNegativeEffectNumber( _targetEntity )
    {
        local skills = _targetEntity.getSkills();
        local number = 0;
        foreach( skill in skills.m.Skills ) {
            local skill_id = skill.getID();
            foreach(effects_id in this.Const.EL_Item_Other.NegativeEffectID)
            {
                if(skill_id == effects_id)
                {
					//this.logInfo("negative effect name:"+skill_id);
                    ++number;
                    break;
                }
            }
        }
        return number;
    }
});


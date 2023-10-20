this.el_curling_immortal_sound_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_replacedSkills = []
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.curling_immortal_sound";
		this.m.Name = "Curling Immortal Sound(Musical Instrument)";
		this.m.Description = "Like the sound of heaven.";//如闻天籁
		this.m.Icon = "el_entrys/el_curling_immortal_sound_entry.png";
		//this.m.IconMini = "el_curling_immortal_sound_entry_mini";
		this.m.Overlay = "el_curling_immortal_sound_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Gain 4 powerful music skillss.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]These skills are effective for friendly forces within a range of " + this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillRange + ".[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Musical Instrument to take effect.[/color]"
            });
        }
		return result;
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			// foreach(skill_script in this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillScriptList);
			// {
			// 	if(skill_script != null)
			// 	{
			// 		this.getContainer().add(this.new(skill_script));
			// 	}
			// }
			for(local i = 0; i < this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillScriptList.len(); ++i)
			{
				this.getContainer().add(this.new(this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillScriptList[i]));
			}
		}
		else
		{
			for(local i = 0; i < this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillIDList.len(); ++i)
			{
				this.getContainer().removeByID(this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillIDList[i]);
			}
			// foreach(skill_id in this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillIDList);
			// {
			// 	if(skill_id != null)
			// 	{
			// 		this.getContainer().removeByID(skill_id);
			// 	}
			// }
		}
	}

	function onRemoved()
	{
		for(local i = 0; i < this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillIDList.len(); ++i)
		{
			this.getContainer().removeByID(this.Const.EL_Rarity_Entry.Factor.EL_CurlingImmortalSound.SkillIDList[i]);
		}
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Musical))
		{
			return true;
		}
		return false;
	}
});
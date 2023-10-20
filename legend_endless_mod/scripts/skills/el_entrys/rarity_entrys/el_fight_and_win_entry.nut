this.el_fight_and_win_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.fight_and_win";
		this.m.Name = "Fight And Win(One-Handed Flail)";
		this.m.Description = "Storm like suppression, target riddled with flaws, victory in control.";//暴风般的压制，目标破绽百出，胜利已尽在掌握
		this.m.Icon = "el_entrys/el_fight_and_win_entry.png";
		//this.m.IconMini = "el_fight_and_win_entry_mini";
		this.m.Overlay = "el_fight_and_win_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When you attack the enemy, make the target Resolve - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenBravery + ", Initiative - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenInitiative + ", Melee Skill - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenMeleeSkill + ", Ranged Skill - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenRangedSkill + ", Melee Defense - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenMeleeDefense + ", Ranged Defense - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenRangedDefense + ", Received damage + " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.TempWeakenDamageReceivedTotalMult * 100 + "%, until the end of your turn[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]After landing a hit, make the target Resolve - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenBravery + ", Initiative - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenInitiative + ", Melee Skill - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenMeleeSkill + ", Ranged Skill - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenRangedSkill + ", Melee Defense - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenMeleeDefense + ", Ranged Defense - " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenRangedDefense + ", Received damage + " + this.Const.EL_Rarity_Entry.Factor.EL_FightAndWin.WeakenDamageReceivedTotalMult * 100 + "%, , in this combat[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip One-Handed Flail to take effect.[/color]"
            });
        }
		return result;
	}
    
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/el_effects/el_temp_weaken_effect"));
			_targetEntity.getSkills().add(this.new("scripts/skills/el_effects/el_weaken_effect"));
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/el_effects/el_temp_weaken_effect"));
		}
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Flail))
		{
			return true;
		}
		return false;
	}
});


this.el_into_the_breach_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_Fat = 0,
		EL_replacedSkills = []
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.into_the_breach";
		this.m.Name = "Into The Breach(One-Handed Spear)";
		this.m.Description = "Gathering! Deadly battle!";//集结！死战！
		this.m.Icon = "el_entrys/el_into_the_breach_entry.png";
		//this.m.IconMini = "el_into_the_breach_entry_mini";
		this.m.Overlay = "el_into_the_breach_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When in a spearwall state, increase the melee skill based on your's own weight.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]When using a spear,chain all nearby melee friendly forces to enter this state together.[/color]"
			},
			{
				id = 5,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Each chain unit will add " + this.Const.EL_Rarity_Entry.Factor.EL_IntoTheBreach.MeleeSkillChainOffset + " melee skill and " + this.Const.EL_Rarity_Entry.Factor.EL_IntoTheBreach.MeleeDefenseChainOffset + " melee defense to all allied units being chained.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip One-Handed Spear to take effect.[/color]"
            });
        }
		else if(this.getContainer().getActor().getSkills().hasSkill("el_rarity_effects.into_the_breach"))
		{
            result.push({
                id = 13,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+ this.m.EL_Fat + "[/color] Melee Skill"
            });
		}
		return result;
	}

	function onUpdate( _properties )
	{
		if (EL_isUsable() && this.getContainer().getActor().getSkills().hasSkill("el_rarity_effects.into_the_breach"))
		{
            this.m.EL_Fat = 0;
            local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
            local mainhand = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
            local offhand = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

            if (body != null)
            {
                this.m.EL_Fat += body.getStaminaModifier();
            }
            if (head != null)
            {
                this.m.EL_Fat += head.getStaminaModifier();
            }
            if (mainhand != null)
            {
                this.m.EL_Fat += mainhand.getStaminaModifier();
            }
            if (offhand != null)
            {
                this.m.EL_Fat += offhand.getStaminaModifier();
            }
            _properties.MeleeSkill += this.Math.abs(this.m.EL_Fat * this.Const.EL_Rarity_Entry.Factor.EL_IntoTheBreach.ConvertWeightIntoMeleeSkillPercent);
		}
	}

	function onTurnStart()
	{
        local user = this.getContainer().getActor();
		local my_tile = user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(user.getFaction());

		foreach( actor in actors )
		{
			if (actor.getFaction() == user.getFaction())
			{
				actor.getSkills().removeByID("el_rarity_effects.into_the_breach");
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			this.Const.EL_Rarity_Entry.EL_ReplaceSkill(this.getContainer().getActor(), this.m.EL_replacedSkills, this.Const.EL_Rarity_Entry.Factor.EL_IntoTheBreach.ReplaceSkillList);
			this.getContainer().add(this.new("scripts/skills/el_actives/el_into_the_breach_skill"));
		}
		else
		{
			this.m.EL_replacedSkills.clear();
			this.getContainer().removeByID("el_rarity_actives.into_the_breach_skill");
		}
	}

	function onRemoved()
	{
		this.Const.EL_Rarity_Entry.EL_ReturnSkill(this.getContainer().getActor(), this.m.EL_replacedSkills);
		this.getContainer().removeByID("el_rarity_actives.into_the_breach_skill");
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Spear))
		{
			return true;
		}
		return false;
	}
});


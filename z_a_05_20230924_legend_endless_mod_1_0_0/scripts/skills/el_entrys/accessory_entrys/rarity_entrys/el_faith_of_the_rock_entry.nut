this.el_faith_of_the_rock_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "entrys.el_faith_of_the_rock";
		this.m.Name = "Faith of The Rock(Shield)";
		this.m.Description = "Accumulating Hostility,Towering Protector, Resistant to All.";//聚集敌意，高塔般的守护者，抵抗一切
		this.m.Icon = "el_entrys/el_faith_of_the_rock_entry.png";
		//this.m.IconMini = "el_faith_of_the_rock_entry_mini";
		this.m.Overlay = "el_faith_of_the_rock_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]The character gains 1000 times more threat.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Recover all shield condition at the beginning of each turn.[/color]"
			},
			{
				id = 5,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Automatically release shieldwall at the beginning of each turn.[/color]"
			},
			{
				id = 6,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Immune to all negative effects.[/color]"
			}
        ]
        local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
		}
        else
        {
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Shield to take effect..[/color]"
            });
        }
		return result;
	}

	function onUpdate( _properties )
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
            _properties.TargetAttractionMult *= this.Const.EL_Accessory.EL_RarityEntry.Factor.EL_FaithOfTheRock.TargetAttractionMult;
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

	function onTurnStart()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
			this.m.Container.add(this.new("scripts/skills/effects/shieldwall_effect"));
			item.m.Condition = item.m.ConditionMax;
		}
	}
});


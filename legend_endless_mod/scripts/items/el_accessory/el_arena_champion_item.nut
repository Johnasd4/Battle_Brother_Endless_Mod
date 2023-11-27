this.el_arena_champion_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "el_accessory.arena_champion";
		this.m.Name = "Arena Champion";
		this.m.Description = "The sysbol of the arena champion.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		//OVERRIDE
		this.m.Icon = "accessory/el_arena_champion.png";
		this.m.Sprite = "gladiator_necklace_01";
		this.m.Value = 0;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0, -100000);
	}

	function getTooltip()
	{
		local result = [
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.EL_getResolveBonus() + "[/color] Resolve"
		});
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "Morale increases once each turn."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if(actor != null) {
			actor.actor.checkMorale(1, 1000, this.Const.MoraleCheckType.Default, "", false);
		}
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Bravery += this.EL_getResolveBonus();
	}

	function EL_getResolveBonus()
	{
		return this.m.EL_Level * 1;
	}

});

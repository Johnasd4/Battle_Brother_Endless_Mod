this.el_arena_collar_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "el_special_item.arena_collar";
		this.m.Name = "Arena Collar";
		this.m.Description = "A collar worn by combatants for the Legendary tournament location.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/gladiator_necklace.png";
		this.m.Value = 0;
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
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to use. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onNewDay() {
		stash.remove(this);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/el_items/el_arena_collar_skill"));
		return true;
	}

});


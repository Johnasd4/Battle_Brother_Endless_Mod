this.el_rarity_entry_stone_item <- this.inherit("scripts/items/item", {
	m = {
		EL_RarityEntry = null
	},
	function create()
	{
		this.m.ID = "el_item.rarity_entry_stone";
		this.m.Name = "Rarity Entry Stone";
		this.m.Description = "A rarity stone, can be used to make your Accessory to get the rarity entry.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable | this.Const.Items.ItemType.Misc;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "el_misc/el_rarity_entry_stone.png";
		this.m.Value = 50000;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text ="[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.getName() + "[/color]"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + "It keeps: " + this.m.EL_RarityEntry.getName() + "[/color]"
			}
		];
		result.push({
			id = 65,
			type = "text",
			text = "Right-click onto the currently selected character in order to use. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function EL_addRarityEntry( _EL_rarityEntry )
	{
		this.m.EL_RarityEntry = _EL_rarityEntry;
	}

	function onUse( _actor, _item = null )
	{
		local accessory = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		if(accessory != null && accessory.EL_isValid() && accessory.m.EL_RarityEntry == null)
		{
			accessory.EL_addRarityEntry(this.m.EL_RarityEntry);
			accessory.addSkill(this.m.EL_RarityEntry);
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav",  this.Const.Sound.Volume.Inventory);
			return true;
		}
		return false;
	}

	function onSerialize( _out )
	{
		if(this.m.EL_RarityEntry != null)
		{
			_out.writeU8(1);
			_out.writeI32(this.m.EL_RarityEntry.ClassNameHash);
			this.m.EL_RarityEntry.onSerialize(_out);
		}
		else
		{
			_out.writeU8(0);
		}
	}

	function onDeserialize( _in )
	{
		local has_rarity_entry = _in.readU8();
		if(has_rarity_entry)
		{
			this.m.EL_RarityEntry = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.EL_RarityEntry.onDeserialize(_in);
		}
	}
});


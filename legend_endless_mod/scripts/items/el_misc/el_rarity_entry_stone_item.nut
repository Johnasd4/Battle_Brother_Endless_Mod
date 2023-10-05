this.el_rarity_entry_stone_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {
		EL_RarityEntry = null
	},
	function create()
	{
		this.m.ID = "el_item.rarity_entry_stone";
		this.m.Name = "Rarity Entry Stone";
		this.m.Description = "A rarity stone, can be used to make your Accessory to get the rarity entry.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.TradeGood | this.Const.Items.ItemType.Usable | this.Const.Items.ItemType.Misc;
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
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 3,
			type = "text",
			text = "It keeps the rarity entry is " + "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.m.EL_RarityEntry.getName() + "[/color]"
		});
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

	function onUse( _actor, _item = null )
	{
		local skill = _actor.getSkills().getSkillByID("el_items.core_skill");
		if(skill == null) {
			skill = this.new("scripts/skills/el_items/el_core_skill");
			_actor.getSkills().add(skill);
		}
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			skill.EL_addPropertiesXP(this.m.EL_PropertiesXP[i], i);
		}
		this.Sound.play("sounds/combat/eat_01.wav", this.Const.Sound.Volume.Inventory);
		return true;
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


this.el_equipment_essence_item <- this.inherit("scripts/items/item", {
	m = {
		EL_Amount = 0
	},

	function getAmountString()
	{
		if(this.m.EL_Amount < this.Math.pow(10, 3)) {
			return this.m.EL_Amount;
		}
		else if(this.m.EL_Amount < this.Math.pow(10, 6)) {
			return this.Math.floor(this.m.EL_Amount / this.Math.pow(10, 3)) + 'k';
		}
		else if(this.m.EL_Amount < this.Math.pow(10, 9)) {
			return this.Math.floor(this.m.EL_Amount / this.Math.pow(10, 6)) + 'm';
		}
		else {
			return this.Math.floor(this.m.EL_Amount / this.Math.pow(10, 9)) + 'b';
		}
	}

	function isAmountShown()
	{
		return true;
	}

	function create()
	{
		this.m.ID = "el_supplies.equipment_essence_rank_" + this.m.EL_RankLevel;
		this.m.Name = "[color=" + this.Const.EL_Item.Colour[this.m.EL_RankLevel] + "]Equipment Essence[/color]";
		this.m.Icon = "el_supplies/equipment_essence_rank_" + this.m.EL_RankLevel + ".png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Supply;
		this.m.IsConsumed = true;
		this.m.Value = 0;
		this.m.EL_Amount = 0;
	}

	function consume()
	{
		this.World.Assets.EL_addEquipmentEssence(this.m.EL_RankLevel, this.m.EL_Amount);
	}

	function playInventorySound(_eventType)
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
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
				text = "The amount of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.EL_Amount + "[/color] equipment essences, the currency in these lands. Will be added to your global stock once you\'re back on the worldmap."
			}
		];

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
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		return result;
	}


	function EL_getAmount()
	{
		return this.m.EL_Amount;
	}

	function EL_setAmount(_EL_Amount)
	{
		this.m.EL_Amount = this.Math.floor(_EL_Amount);
	}

	function EL_addAmount(_EL_Amount)
	{
		this.m.EL_Amount += this.Math.floor(_EL_Amount);
	}






});


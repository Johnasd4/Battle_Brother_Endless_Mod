this.el_arena_champion_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "el_armor.arena_champion";
		this.m.Name = "Arena Champion Armor";
		this.m.Description = "The sysbol of the arena champion.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IsIndestructible = true;
		this.m.Value = 2000;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -25;
		this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
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
			text = "护甲存在时免疫穿甲伤害。"
		});
		return result;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.armor.onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties);
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body && this.getArmor() != 0)
		{
			_properties.DamageReceivedDirectMult = 0;
		}
	}

});

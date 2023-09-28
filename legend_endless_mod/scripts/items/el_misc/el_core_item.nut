this.el_core_item <- this.inherit("scripts/items/item", {
	m = {
		EL_PropertiesXP = [],
		EL_XP = 0
	},
	function create()
	{
		this.m.ID = "accessory.el_core_rank_" + this.m.EL_RankLevel;
		this.m.Name = "Core";
		this.m.Description = "A core, can be used to strengthen your men or sell it for crowns.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable | this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "el_misc/el_core_rank_" + this.m.EL_RankLevel + ".png";
		local total_xp = 0;
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			local xp = 0;
			local chance = this.Const.EL_Misc.EL_Core.XPChance[i][this.m.EL_RankLevel];
			while(this.Math.rand(1, 100) <= chance) {
				chance *= 0.5;
				xp += 1;
				total_xp += 1;
			}
			this.m.EL_PropertiesXP.push(xp);
		}
		this.m.Value = this.Math.floor(this.Const.EL_Misc.EL_Core.Value[this.m.EL_RankLevel] * (1 + total_xp * this.Const.EL_Misc.EL_Core.ValueIncreacePurXP));
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.addXP(this.m.EL_XP);
		_actor.updateLevel();
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

	function getSellPrice()
	{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
			{
				return this.Math.floor(this.getValue() * this.getSellPriceMult() * this.World.Assets.m.SellPriceTradeMult * this.World.State.getCurrentTown().getSellPriceMult() * this.Const.World.Assets.SellPriceNotProducedHere * this.Const.World.Assets.SellPriceNotLocalCulture);
			}
			else
			{
				return this.Math.floor(this.getValue() * this.Const.World.Assets.BaseSellPrice);
			}
	}

	function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_XP);
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			_out.writeI32(this.m.EL_PropertiesXP[i]);
		}
	}

	function onDeserialize( _in )
	{
		this.m.EL_XP = _in.readI32();
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			this.m.EL_PropertiesXP[i] = _in.readI32();
		}
	}

	function EL_setXP( _EL_xp )
	{
		this.m.EL_XP = _EL_xp;
	}

});


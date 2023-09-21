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
			id = 10,
			type = "text",
			text = this.getValueString()
		});
		if(this.m.EL_XP > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_XP +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.Hitpoints] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Hitpoints XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.Hitpoints] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.Bravery] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Resolve XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.Bravery] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.Fatigue] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Stamina XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.Fatigue] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.Initiative] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Initiative XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.Initiative] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.MeleeSkill] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Melee Skill XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.MeleeSkill] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.RangedSkill] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "Ranged Skill XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.RangedSkill] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.MeleeDefense] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Melee Defense XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_PropertiesXP[this.Const.Attributes.MeleeDefense] +
					   "[/color]"
			});
		}
		if(this.m.EL_PropertiesXP[this.Const.Attributes.RangedDefense] > 0) {
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Ranged Defense XP [color=" + this.Const.UI.Color.PositiveValue + "]+" +
					   this.m.EL_Properties[this.Const.Attributes.RangedDefense] +
					   "[/color]"
			});
		}
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to drink. This item will be consumed in the process."
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
			_actor.getSkills().push(skill);
		}
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			skill.EL_addPropertiesXP(this.m.EL_PropertiesXP[i]);
		}
		this.Sound.play("sounds/combat/eat_01.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function onSerialize( _out )
	{
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			_out.writeI32(this.m.EL_PropertiesXP[i]);
		}
	}

	function onDeserialize( _in )
	{
		for(local i = 0; i < this.Const.Attributes.COUNT; ++i) {
			this.m.EL_PropertiesXP[i] = _in.readI32();
		}
	}

	function EL_setXP( _EL_xp )
	{
		this.m.EL_XP = _EL_xp;
	}

});


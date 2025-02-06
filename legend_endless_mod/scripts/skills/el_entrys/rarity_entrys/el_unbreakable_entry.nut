this.el_unbreakable_entry <- this.inherit("scripts/skills/skill", {
	m = {
		EL_PreviousTurnHitpoint = 0,
		EL_PreviousTurnBodyConditon = 0,
		EL_PreviousTurnHeadConditon = 0
	},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.ID = "el_rarity_entry.unbreakable";
		this.m.Name = "不可撼动(单手锤)";
		this.m.Description = "身如铁塔，屹立不倒";//Like an iron tower, standing still.
		this.m.Icon = "el_entrys/el_unbreakable_entry.png";
		//this.m.IconMini = "el_master_feat_entry_mini";
		this.m.Overlay = "el_unbreakable_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]回合开始时自动“不屈”效果[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]血量、头盔、盔甲每损失3.3%，提升自身1%减伤率[/color]"
			},
			{
				id = 5,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]回合开始时，恢复上回合受到伤害的50%[/color]"
			}
        ]
		if (EL_getDamageReceivedMult(this.getContainer().getActor().getCurrentProperties()) != 1)
		{
            result.push({
				id = 8,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]当前效果: 仅受到 " + EL_getDamageReceivedMult(this.getContainer().getActor().getCurrentProperties()) * 100 + "%的伤害[/color]"
			});
        }
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]你需要装备单手锤来发挥效果[/color]"
            });
        }
		return result;
	}

	function onCombatStarted()
	{
		local user = this.getContainer().getActor();	
		local armor = user.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local head = user.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		this.m.EL_PreviousTurnHitpoint = user.getHitpoints();
		this.m.EL_PreviousTurnBodyConditon = armor == null ? 0 : armor.getCondition();
		this.m.EL_PreviousTurnHeadConditon = head == null ? 0 : head.getCondition();
	}

	function onTurnStart()
	{
		if (EL_isUsable())
		{
			this.m.Container.add(this.new("scripts/skills/effects/indomitable_effect"));
			local user = this.getContainer().getActor();	
			user.setHitpoints(this.Math.min(user.getHitpointsMax(), user.getHitpoints() + this.Math.floor((this.m.EL_PreviousTurnHitpoint - user.getHitpoints()) * this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageRecover)));
			local armor = user.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local head = user.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			if(armor != null)
			{
				armor.setCondition(this.Math.min(armor.getConditionMax(), armor.getCondition() + this.Math.floor((this.m.EL_PreviousTurnBodyConditon - armor.getCondition()) * this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageRecover)));
			}
			if(head != null)
			{
				head.setCondition(this.Math.min(head.getConditionMax(), head.getCondition() + this.Math.floor((this.m.EL_PreviousTurnheadConditon - head.getCondition()) * this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageRecover)));
			}
			this.m.EL_PreviousTurnHitpoint = user.getHitpoints();
			this.m.EL_PreviousTurnBodyConditon = armor == null ? 0 : armor.getCondition();
			this.m.EL_PreviousTurnHeadConditon = head == null ? 0 : head.getCondition();
		}
	}

	function EL_getDamageReceivedMult( _properties )
	{
		local actor = this.getContainer().getActor();
        local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local stack_hitpoints = this.Math.floor((100 - actor.getHitpoints() / actor.getHitpointsMax() * 100) / this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageReceivedCiv) / 100;
		local stack_body = (armor == null) ? 0 : this.Math.floor((100 - _properties.Armor[this.Const.BodyPart.Body] * _properties.ArmorMult[this.Const.BodyPart.Body] / 
																	    _properties.ArmorMax[this.Const.BodyPart.Body] * _properties.ArmorMult[this.Const.BodyPart.Body] * 100) / this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageReceivedCiv) / 100;
		local stack_head = (head == null) ? 0 : this.Math.floor((100 - _properties.Armor[this.Const.BodyPart.Head] * _properties.ArmorMult[this.Const.BodyPart.Head] / 
																	   _properties.ArmorMax[this.Const.BodyPart.Head] * _properties.ArmorMult[this.Const.BodyPart.Head] * 100) / this.Const.EL_Rarity_Entry.Factor.EL_Unbreakable.DamageReceivedCiv) / 100;								
		return (1 - stack_hitpoints - stack_body - stack_head);
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= EL_getDamageReceivedMult(_properties);
	}
	
	function isHidden()
	{
		return this.getContainer().getActor().getFaction() != this.Const.Faction.Player && !EL_isUsable();
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		if (item != null && item.getID() == "el_accessory.core")
		{
			return false;
		}
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Hammer))
		{
			return true;
		}
		return false;
	}
});


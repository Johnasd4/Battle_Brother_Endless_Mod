this.el_vehemence_of_the_sky_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.vehemence_of_the_sky";
		this.m.Name = "Vehemence of The Sky(Gassenhauer)";
		this.m.Description = "The momentum is as strong as the sky, crushing and corrupting.";//势若天倾，摧垮拉朽
		this.m.Icon = "el_entrys/el_vehemence_of_the_sky_entry.png";
		//this.m.IconMini = "el_vehemence_of_the_sky_entry_mini";
		this.m.Overlay = "el_vehemence_of_the_sky_entry";
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
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Maintain confident.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Convert " + this.Const.EL_Rarity_Entry.Factor.EL_VehemenceOfTheSky.ConvertArmorIntoDamagePercent * 100 +"% of armor condition max value into weapon panel damage.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
                text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Release a free split shield during the attack, deals " + this.Const.EL_Rarity_Entry.Factor.EL_VehemenceOfTheSky.ShieldDamageMult * 100 + "% damage to the weapon panel.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Gassenhauer to take effect.[/color]"
            });
        }
		return result;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			this.Const.EL_Rarity_Entry.EL_useFreeSplitShield(this.getContainer().getActor(), _targetEntity);
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}
		if (EL_isUsable())
		{
			this.Const.EL_Rarity_Entry.EL_useFreeSplitShield(this.getContainer().getActor(), _targetEntity);
		}
	}

	function onAfterUpdate( _properties )
	{
		if (EL_isUsable())
		{
			local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if(item.m.EL_EntryList[item.m.EL_EntryList.len() - 1].getID() != "el_rarity_entry.vehemence_of_the_sky_subsidiary")
			{
				item.EL_addEntryToList(this.new("scripts/skills/el_entrys/rarity_entrys/el_vehemence_of_the_sky_subsidiary_entry"));
			}
		}
	}
	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.TwoHanded) && item.isWeaponType(this.Const.Items.WeaponType.Sword))
		{
			return true;
		}
		return false;
	}
});
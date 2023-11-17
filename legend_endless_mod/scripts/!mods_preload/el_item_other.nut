local gt = getroottable();

::mods_registerMod("el_item_other", 1, "el_item_other");
::mods_queue(null, "el_item", function ()
{
	::mods_hookExactClass("skills/backgrounds/character_background", function ( o )
	{
		o.addEquipment = function ()
		{
			this.onAddEquipment();
			this.Const.EL_Item_Other.EL_actorItemInit(this.getContainer().getActor());
			this.adjustHiringCostBasedOnEquipment();
		}
	});

	::mods_hookExactClass("entity/tactical/actor", function(o){
        o.EL_assignRandomEquipment <- function() {
			this.assignRandomEquipment();
			this.Const.EL_Item_Other.EL_actorItemInit(this, true);
        }
	});

	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
        local setCampaignSettings = o.setCampaignSettings;
		o.setCampaignSettings = function( _settings )
		{
			setCampaignSettings(_settings);
			local bros = this.World.getPlayerRoster().getAll();

			foreach( bro in bros )
			{
				this.Const.EL_Item_Other.EL_actorItemInit(bro);
			}
		}
	});

	::mods_hookNewObject("items/item_container", function(o) {

		o.unequip = function( _item )
		{

			if (_item == null || _item == -1)
			{
				return false;
			}

			if (_item.getCurrentSlotType() == this.Const.ItemSlot.None || _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
			{
				this.logWarning("Attempted to unequip item " + _item.getName() + ", but is not equipped");
				return false;
			}
			if(_item.getSlotType() == -1) {
				this.logWarning("attempt to unequip none slot item " + _item.getID());
				return false;
			}

			if (_item != null && _item != -1 && _item.getCurrentSlotType() != ::Const.ItemSlot.None && _item.getCurrentSlotType() != ::Const.ItemSlot.Bag && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive())
			{
				foreach (item in this.m.Items[_item.getSlotType()])
				{
					if (item == _item)
					{
						this.m.Actor.getSkills().onUnequip(_item);
						break;
					}
				}
			}

			for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getSlotType()][i] == _item)
				{
					_item.onUnequip();
					_item.setContainer(null);
					_item.setCurrentSlotType(this.Const.ItemSlot.None);
					this.m.Items[_item.getSlotType()][i] = null;

					if (_item.getBlockedSlotType() != null)
					{
						for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
						{
							if (this.m.Items[_item.getBlockedSlotType()][i] == -1)
							{
								this.m.Items[_item.getBlockedSlotType()][i] = null;
								break;
							}

							i = ++i;
						}
					}

					if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isAlive())
					{
						this.m.Actor.getSkills().update();
					}

					return true;
				}

				i = ++i;
			}

			return false;
		}
	});

    ::mods_hookClass("items/stash_container", function(o) {
		//while(!("add" in o)) o = o[o.SuperName];
        // local add = o.add;
        // o.add = function( _item )
        // {
		// 	this.Const.EL_Item_Other.EL_otherItemInit(_item);
		// 	return add(_item);
        // }
		o.getActor <- function()
		{
			return null;
		}

		o.onItemCompare = function( _item1, _item2 )
		{
			if (_item1 == null && _item2 == null)
			{
				return 0;
			}
			else if (_item1 == null && _item2 != null)
			{
				return 1;
			}
			else if (_item1 != null && _item2 == null)
			{
				return -1;
			}
			else if (_item1.getItemType() > _item2.getItemType())
			{
				return -1;
			}
			else if (_item1.getItemType() < _item2.getItemType())
			{
				return 1;
			}
			else if (_item1.getCategories() > _item2.getCategories())
			{
				return -1;
			}
			else if (_item1.getCategories() < _item2.getCategories())
			{
				return 1;
			}
			else if (_item1.getID() > _item2.getID())
			{
				return -1;
			}
			else if (_item1.getID() < _item2.getID())
			{
				return 1;
			}
			//OVERRIDE
			else if (_item1.EL_getRankLevel() > _item2.EL_getRankLevel())
			{
				return -1;
			}
			else if (_item1.EL_getRankLevel() < _item2.EL_getRankLevel())
			{
				return 1;
			}
			else if (_item1.EL_getLevel() > _item2.EL_getLevel())
			{
				return -1;
			}
			else if (_item1.EL_getLevel() < _item2.EL_getLevel())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	});

	// ::mods_hookClass("entity/world/world_entity", function(o) {
	// 	while(!("getTroops" in o)) o = o[o.SuperName];

	// 	local onDropLootForPlayer = o.onDropLootForPlayer;
	// 	o.onDropLootForPlayer = function (_lootTable)
	// 	{
    //         onDropLootForPlayer(_lootTable);
	// 		foreach(item in _lootTable)
	// 		{
	// 			this.Const.EL_Item_Other.EL_otherItemInit(item);
	// 		}
	// 	}
	// });

    ::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function(o) {
		local tactical_helper_addHintsToTooltip = o.tactical_helper_addHintsToTooltip;
		o.tactical_helper_addHintsToTooltip = function( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
		{
			local tooltip = tactical_helper_addHintsToTooltip(_activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);
            switch(_itemOwner)
            {
            case "camp-screen-repair-dialog-module.stash":
			case "camp-screen-workshop-dialog-module.stash":
			case "world-town-screen-shop-dialog-module.stash":
                if(this.World.State.getCurrentTown().getCurrentBuilding().isRepairOffered() && _item.m.EL_Level != -1)
                {
					local EquipmentEssence_upgrade_level = _item.EL_getUpgradeLevelEquipmentEssenceNum();
					local EquipmentEssence_upgrade_rank = _item.EL_getUpgradeRankEquipmentEssenceNum();
					local EquipmentEssence_recraft = _item.EL_getRecraftEquipmentEssenceNum();
					local EquipmentEssence_disassemble = _item.EL_getDisassembleEquipmentEssenceNum();
					local upgrade_level_index_pool = [];
					local upgrade_rank_index_pool = [];
					local recraft_index_pool = [];
					local disassemble_index_pool = [];
					for(local rank = 0; rank < EquipmentEssence_upgrade_level.len(); ++rank)
					{
						if(EquipmentEssence_upgrade_level[rank] != 0)
						{
							upgrade_level_index_pool.push(rank);
						}
						if(EquipmentEssence_upgrade_rank[rank] != 0)
						{
							upgrade_rank_index_pool.push(rank);
						}
						if(EquipmentEssence_recraft[rank] != 0)
						{
							recraft_index_pool.push(rank);
						}
						if(EquipmentEssence_disassemble[rank] != 0)
						{
							disassemble_index_pool.push(rank);
						}
					}
					local upgrade_rank_string = _item.EL_getRankLevel() == _item.EL_getRankLevelMax() ? " 将它的词条强化" : " 将它升阶";
					if(_item.EL_isNeedRarityEntry())
					{
						upgrade_rank_string = "来获取稀有词条";
					}
					switch(upgrade_level_index_pool.len())
					{
					case 0:
						break;
					case 1:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[0]] + " 将它升级"
						});
						break;
					case 2:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[0]] + " 将它升级"
						});
						break;
					case 3:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[0]] + " 将它升级"
						});
						break;
					case 4:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[3] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[0]] + " 将它升级"
						});
						break;
					case 5:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[4] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[4]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[3] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_level_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_level[upgrade_level_index_pool[0]] + " 将它升级"
						});
						break;
					}
					switch(upgrade_rank_index_pool.len())
					{
					case 0:
						break;
					case 1:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_alt.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[0]] + upgrade_rank_string
						});
						break;
					case 2:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_alt.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[0]] + upgrade_rank_string
						});
						break;
					case 3:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_alt.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[0]] + upgrade_rank_string
						});
						break;
					case 4:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_alt.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[3] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[0]] + upgrade_rank_string
						});
						break;
					case 5:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_alt.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[4] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[4]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[3] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[2] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[1] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + upgrade_rank_index_pool[0] + ".png[/img]" + EquipmentEssence_upgrade_rank[upgrade_rank_index_pool[0]] + upgrade_rank_string
						});
						break;
					}
					switch(recraft_index_pool.len())
					{
					case 0:
						break;
					case 1:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_shift.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[0] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[0]] + " 将它重铸"
						});
						break;
					case 2:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_shift.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[1] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[0] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[0]] + " 将它重铸"
						});
						break;
					case 3:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_shift.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[2] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[1] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[0] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[0]] + " 将它重铸"
						});
						break;
					case 4:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_shift.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[3] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[2] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[1] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[0] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[0]] + " 将它重铸"
						});
						break;
					case 5:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_shift.png",
							text = "支付 [img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[4] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[4]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[3] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[2] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[1] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + recraft_index_pool[0] + ".png[/img]" + EquipmentEssence_recraft[recraft_index_pool[0]] + " 将它重铸"
						});
						break;
					}
					switch(disassemble_index_pool.len())
					{
					case 0:
						break;
					case 1:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
							text = "将它分解，获得[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[0] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[0]]
						});
						break;
					case 2:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
							text = "将它分解，获得[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[1] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[0] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[0]]
						});
						break;
					case 3:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
							text = "将它分解，获得[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[2] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[1] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[0] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[0]]
						});
						break;
					case 4:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
							text = "将它分解，获得[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[3] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[2] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[1] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[0] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[0]]
						});
						break;
					case 5:
						tooltip.push({
							id = 4,
							type = "hint",
							icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
							text = "将它分解，获得[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[4] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[4]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[3] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[3]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[2] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[2]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[1] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[1]]
							+ "[img]gfx/ui/tooltips/equipment_essence_rank_" + disassemble_index_pool[0] + ".png[/img]" + EquipmentEssence_disassemble[disassemble_index_pool[0]]
						});
						break;
					}
                }
            }
			return tooltip;
		}
	});

	::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o){
		o.EL_onUpgradeLevelItem <- function( _itemIndex )
		{
			local item = this.Stash.getItemAtIndex(_itemIndex).item;
			if (!this.m.Shop.isRepairOffered() && item != null)
			{
				return null;
			}
			if(item == null)
			{
				return null;
			}

			local equipment_essence_need = item.EL_getUpgradeLevelEquipmentEssenceNum();
			for(local rank = 0; rank < this.Const.EL_Item.Type.Legendary; ++rank)
			{
				if(equipment_essence_need[rank] > this.World.Assets.EL_getEquipmentEssence(rank))
				{
					local num = this.Math.ceil((equipment_essence_need[rank] - this.World.Assets.EL_getEquipmentEssence(rank)) / this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank]);
					equipment_essence_need[rank + 1] += num;
					equipment_essence_need[rank] -= num * this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank];
				}
			}

			if(equipment_essence_need[this.Const.EL_Item.Type.Legendary] <= this.World.Assets.EL_getEquipmentEssence(this.Const.EL_Item.Type.Legendary))
			{
				for(local rank = 0; rank <= this.Const.EL_Item.Type.Legendary; ++rank)
				{
					this.World.Assets.EL_addEquipmentEssence(rank, -equipment_essence_need[rank]);
				}
				item.EL_upgradeLevel();
			}

			local result = {
				Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			return result;
		}

		o.EL_onUpgradeRankItem <- function( _itemIndex )
		{
			local item = this.Stash.getItemAtIndex(_itemIndex).item;
			if (!this.m.Shop.isRepairOffered() && item != null)
			{
				return null;
			}
			if(item == null)
			{
				return null;
			}

			local equipment_essence_need = item.EL_getUpgradeRankEquipmentEssenceNum();
			for(local rank = 0; rank < this.Const.EL_Item.Type.Legendary; ++rank)
			{
				if(equipment_essence_need[rank] > this.World.Assets.EL_getEquipmentEssence(rank))
				{
					local num = this.Math.ceil((equipment_essence_need[rank] - this.World.Assets.EL_getEquipmentEssence(rank)) / this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank]);
					equipment_essence_need[rank + 1] += num;
					equipment_essence_need[rank] -= num * this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank];
				}
			}

			if(equipment_essence_need[this.Const.EL_Item.Type.Legendary] <= this.World.Assets.EL_getEquipmentEssence(this.Const.EL_Item.Type.Legendary))
			{
				for(local rank = 0; rank <= this.Const.EL_Item.Type.Legendary; ++rank)
				{
					this.World.Assets.EL_addEquipmentEssence(rank, -equipment_essence_need[rank]);
				}
				item.EL_upgradeRank();
			}

			local result = {
				Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			return result;
		}

		o.EL_onRecraftItem <- function( _itemIndex )
		{
			local item = this.Stash.getItemAtIndex(_itemIndex).item;
			if (!this.m.Shop.isRepairOffered() && item != null)
			{
				return null;
			}
			if(item == null)
			{
				return null;
			}
			local equipment_essence_need = item.EL_getRecraftEquipmentEssenceNum();
			for(local rank = 0; rank < this.Const.EL_Item.Type.Legendary; ++rank)
			{
				if(equipment_essence_need[rank] > this.World.Assets.EL_getEquipmentEssence(rank))
				{
					local num = this.Math.ceil((equipment_essence_need[rank] - this.World.Assets.EL_getEquipmentEssence(rank)) / this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank]);
					equipment_essence_need[rank + 1] += num;
					equipment_essence_need[rank] -= num * this.Const.EL_Item_Other.EquipmentEssenceRankDownFactor[rank];
				}
			}
			
			if(equipment_essence_need[this.Const.EL_Item.Type.Legendary] <= this.World.Assets.EL_getEquipmentEssence(this.Const.EL_Item.Type.Legendary))
			{
				for(local rank = 0; rank <= this.Const.EL_Item.Type.Legendary; ++rank)
				{
					this.World.Assets.EL_addEquipmentEssence(rank, -equipment_essence_need[rank]);
				}
				item.EL_recraft();
			}

			local result = {
				Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			return result;
		}

		o.EL_onDisassembleItem <- function( _itemIndex )
		{
			local item = this.Stash.getItemAtIndex(_itemIndex).item;
			if (!this.m.Shop.isRepairOffered() && item != null)
			{
				return null;
			}
			if(item == null)
			{
				return null;
			}
			local equipment_essence_need = item.EL_getDisassembleEquipmentEssenceNum();
			for(local rank = 0; rank <= this.Const.EL_Item.Type.Legendary; ++rank)
			{
				this.World.Assets.EL_addEquipmentEssence(rank, equipment_essence_need[rank]);
			}
			item.EL_disassemble(_itemIndex);

			local result = {
				Result = 0,
				Assets = this.m.Parent.queryAssetsInformation(),
				Shop = [],
				Stash = [],
				StashSpaceUsed = this.Stash.getNumberOfFilledSlots(),
				StashSpaceMax = this.Stash.getCapacity(),
				IsRepairOffered = this.m.Shop.isRepairOffered()
			};
			this.UIDataHelper.convertItemsToUIData(this.m.Shop.getStash().getItems(), result.Shop, this.Const.UI.ItemOwner.Shop);
			result.Stash = this.UIDataHelper.convertStashToUIData(false, this.m.InventoryFilter);
			return result;
		}
	});
});
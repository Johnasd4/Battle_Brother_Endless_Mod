local gt = getroottable();

::mods_registerMod("el_item_other", 1, "el_item_other");
::mods_queue(null, "el_item", function ()
{
	::mods_hookExactClass("skills/backgrounds/character_background", function ( o )
	{
		o.addEquipment = function ()
		{
			this.onAddEquipment();

			local actor = this.getContainer().getActor();
			local level = actor.getLevel();
			//this.logInfo("actor："+actor.getName());
			local main_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
            local off_hand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
            local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local accessory = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
			if(main_hand != null)
			{
				//this.logInfo("main_hand："+main_hand.getName());
				main_hand.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			if(off_hand != null)
			{
				//this.logInfo("off_hand："+off_hand.getName());
				off_hand.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			if(body != null)
			{
				//this.logInfo("body："+body.getName());
				body.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			if(head != null)
			{
				//this.logInfo("head："+head.getName());
				head.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			if(accessory != null)
			{
				//this.logInfo("accessory："+accessory.getName());
				accessory.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			this.adjustHiringCostBasedOnEquipment();
		}
	});

	::mods_hookExactClass("entity/tactical/actor", function(o){
        o.EL_assignRandomEquipment <- function() {
			this.assignRandomEquipment();
			local rank_level = this.EL_getRankLevel();
			local world_level = this.Math.min(this.Const.EL_Item.MaxLevel, this.World.Assets.m.EL_WorldLevel);
            local main_hand = this.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
            local off_hand = this.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
            local body = this.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local head = this.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local accessory = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
			
			//this.logInfo(this.getName());
			if(accessory == null)
			{
				if(main_hand == null && off_hand == null)
				{
					this.m.Items.equip(this.new("scripts/items/el_accessory/el_core_item"));
				}
				else
				{
					local r = this.Math.rand(0, this.Const.EL_Accessory.EL_NormalAccessoryList.len() - 1);
					this.m.Items.equip(this.new("scripts/items/" + this.Const.EL_Accessory.EL_NormalAccessoryList[r]));
				}
				accessory = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
			}

			local items = [];
			for( local i = 0; i < this.getItems().getUnlockedBagSlots(); i = i )
			{
				local bag_item = this.getItems().getItemAtBagSlot(i);
				if (bag_item != null)
				{
					items.push(bag_item);
				}
				i = ++i;
			}
			if(main_hand != null)
			{
				items.push(main_hand);
			}
			if(off_hand != null)
			{
				items.push(off_hand);
			}
			if(body != null)
			{
				items.push(body);
			}
			if(head != null)
			{
				items.push(head);
			}
			if(accessory != null)
			{
				items.push(accessory);
				if(this.m.WorldTroop.EL_IsBossUnit)
				{
					local r = this.Math.rand(0, this.Const.EL_Accessory.EL_RarirtyEntry.Pool.Entrys.len() - 1);
					accessory.EL_addRarityEntry(this.new(this.Const.EL_Accessory.EL_RarityEntry.Pool.Entrys[r].Scripts));
				}
			}

			foreach(item in items)
			{
				item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, this.EL_getLevel());
				if(world_level > this.Const.EL_Item_Other.EL_NPCEquipment.RankUpMinWorldLevel)
				{
					local r = this.Math.rand(1, 1000);
					if(this.Math.rand(1, 1000) < this.Const.EL_Item.EL_NPCEquipmentRankUpChanceFactor[r] * (world_level - this.Const.EL_Item_Other.EL_NPCEquipment.RankUpMinWorldLevel))
					{
						item.EL_addRankLevel();
					}
				}
				if(rank_level == 2)
				{
					item.EL_addRankLevel();
				}
				//this.logInfo("item ID = "+ item.m.ID+", rank:"+item.m.EL_RankLevel+", level:"+item.m.EL_Level);
			}
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
				local level = bro.getLevel();
				//this.logInfo("bro："+bro.getName());
				local main_hand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
				local off_hand = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
				local body = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
				local head = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
				local accessory = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if(main_hand != null)
				{
					//this.logInfo("main_hand："+main_hand.getName());
					main_hand.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
				if(off_hand != null)
				{
					//this.logInfo("off_hand："+off_hand.getName());
					off_hand.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
				if(body != null)
				{
					//this.logInfo("body："+body.getName());
					body.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
				if(head != null)
				{
					//this.logInfo("head："+head.getName());
					head.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
				if(accessory != null)
				{
					//this.logInfo("accessory："+accessory.getName());
					accessory.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
				}
				for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = i )
				{
					local item = bro.getItems().getItemAtBagSlot(i);
					if (item != null)
					{
						item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
					}
					i = ++i;
				}
			}
		}
	});

// 	// ::mods_hookNewObject("items/item_container", function(o) {
// 	// 	//while(!("addToBag" in o)) o = o[o.SuperName];
//     //     local addToBag = o.addToBag;
//     //     o.addToBag = function( _item, _slot = -1, _force = false )
//     //     {
//     //         if(_item != null)
//     //         {
//     //             local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
//     //             local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
//     //             local random = this.Math.rand(1, 1000);
//     //             if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
//     //             {
//     //                 _item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Premium, level);
//     //                 //this.logInfo("物品升阶");
//     //             }
//     //             else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
//     //             {
//     //                 _item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, level);
//     //                 //this.logInfo("物品升阶大成功");
//     //             }
//     //             else
//     //             {
//     //                 _item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
//     //             }
//     //         }
//     //         //this.logInfo("item generate: LV"+_item.m.EL_Level+"rank:"+_Item.m.EL_RankLevel);
//     //         addToBag( _item, _slot, _force );
//     //     }
// 	// });

    ::mods_hookClass("items/stash_container", function(o) {
		//while(!("add" in o)) o = o[o.SuperName];
        local add = o.add;
        o.add = function( _item )
        {
            //this.logInfo("item generate: LV"+_item.m.EL_Level+"rank:"+_Item.m.EL_RankLevel);
			if(_item != null)
			local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
			local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
			local random = this.Math.rand(1, 1000);

			local EL_worldLevel = this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.EL_Item.MaxLevel);
			local level = this.Math.rand(this.Math.max(0 ,EL_worldLevel - this.Const.EL_Item_Other.MinLevelInEventAndCraft), EL_worldLevel + this.Const.EL_Item_Other.MaxLevelInEventAndCraft);
			local random = this.Math.rand(1, 1000);
			
			if(random <= this.Const.EL_Shop.EL_ItemRankUpOnceChance.EL_getChance(EL_worldLevel))
			{
				_item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Premium, level);
				//this.logInfo("物品升阶");
			}
			else if(random > this.Const.EL_Shop.EL_ItemRankUpTwiceChance.EL_getChance(EL_worldLevel))
			{
				_item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Fine, level);
				//this.logInfo("物品升阶大成功");
			}
			else
			{
				_item.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Normal, level);
			}
			return add(_item);
        }
	});

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
					local essence_upgrade = _item.EL_getUpgradeEssence();
					local essence_recraft = _item.EL_getRecraftEssence();
					local essence_disassemble = _item.EL_getDisassembleEssence();
					local rank = _item.EL_getRankLevel();
					tooltip.push({
						id = 4,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Pay [img]gfx/ui/tooltips/equipment_essence_rank_" + rank + ".png[/img]" + essence_upgrade + " to have it upgrade"
					});
					tooltip.push({
                        id = 4,
                        type = "hint",
                        icon = "ui/icons/mouse_right_button_shift.png",
                        text = "Pay [img]gfx/ui/tooltips/equipment_essence_rank_" + rank + ".png[/img]" + essence_recraft + " to have it recraft"
                    });
					tooltip.push({
                        id = 4,
                        type = "hint",
                        icon = "ui/icons/mouse_right_button_ctrl_and_shift.png",
                        text = "Disassemble it to get [img]gfx/ui/tooltips/equipment_essence_rank_" + rank + ".png[/img]" + essence_recraft
                    });
                }
            }
			return tooltip;
		}
	});

    // ::mods_hookClass("skills/skill", function(o) {
	// 	while(!("onItemSet" in o)) o = o[o.SuperName];
	// 	o.onItemSet = function() {
	// 		local item = this.getItem();
	// 		if(item != null && item.isItemType(this.Const.Items.ItemType.Weapon))
	// 		{
	// 	    	this.m.MaxRange = this.Math.max(this.m.MaxRange, item.getRangeMax());
	// 		}
	// 	}
	// });

	::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o){
        o.EL_onUpgradeItem <- function( _itemIndex )
		{
			local item = this.Stash.getItemAtIndex(_itemIndex).item;
			if (!this.m.Shop.isRepairOffered() && item != null)
			{
				return null;
			}
			//this.logInfo("use onUpgradeItem !!!!!!!!!!!!!!");

			local essence_need = item.EL_getUpgradeEssence();
			local rank = item.EL_getRankLevel();
			local essence_have = this.World.Assets.EL_getEquipmentEssence(rank);
			local essence_need_rank = [0,0,0,0,0];
			while(rank > 0 && essence_need > essence_have)
			{
				essence_need_rank[rank] = essence_have;
				--rank;
				essence_have = this.World.Assets.EL_getEquipmentEssence(rank);
				essence_need *= this.Const.EL_Item_Other.EssenceRankUpNeedFactor;
			}
			if(essence_need < essence_have)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				essence_need_rank[rank] = essence_need;
				for(local rank = 0; rank < this.Const.EL_Item.Type.Legendary; ++rank)
				{
					this.World.Assets.EL_addEquipmentEssence(rank, -essence_need_rank[rank]);
				}
				item.EL_upgrade();
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
			//this.logInfo("use onRecraftItem !!!!!!!!!!!!!!");

			local essence_need = item.EL_getUpgradeEssence();
			local rank = item.EL_getRankLevel();
			local essence_have = this.World.Assets.EL_getEquipmentEssence(rank);
			local essence_need_rank = [0,0,0,0,0];
			while(rank > 0 && essence_need > essence_have)
			{
				essence_need_rank[rank] = essence_have;
				--rank;
				essence_have = this.World.Assets.EL_getEquipmentEssence(rank);
				essence_need *= this.Const.EL_Item_Other.EssenceRankUpNeedFactor;
			}
			if(essence_need < essence_have)
			{
				this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
				essence_need_rank[rank] = essence_need;
				for(local rank = 0; rank < this.Const.EL_Item.Type.Legendary; ++rank)
				{
					this.World.Assets.EL_addEquipmentEssence(rank, -essence_need_rank[rank]);
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
			this.Sound.play("sounds/ambience/buildings/blacksmith_hammering_0" + this.Math.rand(0, 6) + ".wav", 1.0);
			//this.logInfo("use onDisassembleItem !!!!!!!!!!!!!!");

			local essence_need = item.EL_getDisassembleEssence();
			this.World.Assets.EL_addEquipmentEssence(item.EL_getRankLevel(), essence_need);

			local result = {
				Item = this.UIDataHelper.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash),
				Assets = this.m.Parent.queryAssetsInformation()
			};
			item.EL_disassemble();
			return result;
		}
	});
});
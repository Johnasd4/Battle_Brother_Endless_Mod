WorldTownScreenShopDialogModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
{
	var self = this;

	var result = _parentDiv.createListItem(true);
	result.attr('id', 'slot-index_' + _index);

	// update item data
	var itemData = result.data('item') || {};
	itemData.index = _index;
	itemData.owner = _owner;
	result.data('item', itemData);

	// add event handler
	var dropHandler = function (_source, _target)
	{
		var sourceData = _source.data('item');
		var targetData = _target.data('item');

		var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
		var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;

		if(sourceOwner === null || targetOwner === null)
		{
			console.error('Failed to drop item. Owner are invalid.');
			return;
		}

		var sourceItemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;
		var targetItemIdx = (targetData !== null && 'index' in targetData) ? targetData.index : null;

		if(sourceItemIdx === null)
		{
			console.error('Failed to drop item. Source idx is invalid.');
			return;
		}

		self.swapItem(sourceItemIdx, sourceOwner, targetItemIdx, targetOwner);
	};

	var dragEndHandler = function (_source, _target)
	{
		if(_source.length === 0 || _target.length === 0)
		{
			return false;
		}

		var sourceData = _source.data('item');
		var targetData = _target.data('item');

		var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
		var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;
		var itemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;

		if(sourceOwner === null || targetOwner === null)
		{
			console.error('Failed to drop item. Owner is invalid.');
			return false;
		}

		// we don't allow swapping within the shop container
		if(sourceOwner === WorldTownScreenShop.ItemOwner.Shop && targetOwner === WorldTownScreenShop.ItemOwner.Shop)
		{
			//console.error('Failed to swap item within shop container. Not allowed.');
			return false;
		}

		// we don't allow swapping if there is not enough money or space left
		if(sourceOwner === WorldTownScreenShop.ItemOwner.Shop)
		{
			return self.hasEnoughMoneyToBuy(itemIdx) && self.isStashSpaceLeft();
		}

		return true;
	};

	result.assignListItemDragAndDrop(_screenDiv, null, dragEndHandler, _owner === WorldTownScreenShop.ItemOwner.Stash ? dropHandler : null);

	//EL_OVERRIDE
	result.assignListItemRightClick(function (_item, _event)
	{
		var data = _item.data('item');

		var isEmpty = (data !== null && 'isEmpty' in data) ? data.isEmpty : true;
		var owner = (data !== null && 'owner' in data) ? data.owner : null;
		//var itemId = (data !== null && 'id' in data) ? data.id : null;
		var itemIdx = (data !== null && 'index' in data) ? data.index : null;
		var destroyItem = false;
		var repairItem = KeyModiferConstants.AltKey in _event && _event[KeyModiferConstants.AltKey] === true;
		var EL_recraftItem = KeyModiferConstants.ShiftKey in _event && _event[KeyModiferConstants.ShiftKey] === true;
		var EL_upgradeLevelItem = KeyModiferConstants.CtrlKey in _event && _event[KeyModiferConstants.CtrlKey] === true;
		var EL_upgradeRankItem = EL_upgradeLevelItem && repairItem;
		var EL_disassembleItem = EL_upgradeLevelItem && EL_recraftItem;
		if(/*doSomething &&*/ isEmpty === false && owner !== null /*&& itemId !== null*/ && itemIdx !== null)
		{
			switch(owner)
			{
				case WorldTownScreenShop.ItemOwner.Stash:
				{
					if (EL_disassembleItem === true)
					{
						self.EL_disassembleItem(itemIdx);
					}
					else if (EL_upgradeRankItem === true)
					{
						self.EL_upgradeRankItem(itemIdx);
					}
					else if(EL_upgradeLevelItem === true)
					{
						self.EL_upgradeLevelItem(itemIdx);
					}
					else if(EL_recraftItem === true)
					{
						self.EL_recraftItem(itemIdx);
					}
					else if (repairItem === true)
					{
						console.info('destroy');
						self.repairItem(itemIdx);
					}
					else
					{
						//console.info('sell');
						self.swapItem(itemIdx, owner, null, WorldTownScreenShop.ItemOwner.Shop);
					}
				} break;
				case WorldTownScreenShop.ItemOwner.Shop:
				{
					if (destroyItem !== true)
					{
						//console.info('buy');
						/*if(*/self.swapItem(itemIdx, owner, null, WorldTownScreenShop.ItemOwner.Stash);//))
// 						{
// 							var slot = self.querySlotByIndex(self.mShopSlots, data.index);
// 							slot.assignListItemImage();
// 						}
					}
				} break;
			}
		}
	});

	return result;
};

WorldTownScreenShopDialogModule.prototype.EL_disassembleItem = function(_itemIdx)
{
	var self = this;
	this.EL_notifyBackendDisassembleItem(_itemIdx, function (data)
    {
		self.mParent.loadAssetData(data.Assets);
		self.updateStashList(data.Stash);
    });
}

WorldTownScreenShopDialogModule.prototype.EL_upgradeRankItem = function(_itemIdx)
{
	var self = this;
	this.EL_notifyBackendUpgradeRankItem(_itemIdx, function(_result)
	{
		if(_result.Item != undefined)
		{
			self.updateSlotItem(WorldTownScreenShop.ItemOwner.Stash, self.mStashSlots, _result.Item, _itemIdx, WorldTownScreenShop.ItemFlag.Updated);
		}

		self.mParent.loadAssetData(_result.Assets);
	});
}

WorldTownScreenShopDialogModule.prototype.EL_upgradeLevelItem = function(_itemIdx)
{
	var self = this;
	this.EL_notifyBackendUpgradeLevelItem(_itemIdx, function(_result)
	{
		if(_result.Item != undefined)
		{
			self.updateSlotItem(WorldTownScreenShop.ItemOwner.Stash, self.mStashSlots, _result.Item, _itemIdx, WorldTownScreenShop.ItemFlag.Updated);
		}

		self.mParent.loadAssetData(_result.Assets);
	});
}

WorldTownScreenShopDialogModule.prototype.EL_recraftItem = function(_itemIdx)
{
	var self = this;
	this.EL_notifyBackendRecraftItem(_itemIdx, function(_result)
	{
		if(_result.Item != undefined)
		{
			self.updateSlotItem(WorldTownScreenShop.ItemOwner.Stash, self.mStashSlots, _result.Item, _itemIdx, WorldTownScreenShop.ItemFlag.Updated);
		}

		self.mParent.loadAssetData(_result.Assets);
	});
}

WorldTownScreenShopDialogModule.prototype.EL_notifyBackendDisassembleItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onDisassembleItem', _itemIdx, _callback);
};
WorldTownScreenShopDialogModule.prototype.EL_notifyBackendUpgradeRankItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onUpgradeRankItem', _itemIdx, _callback);
};
WorldTownScreenShopDialogModule.prototype.EL_notifyBackendUpgradeLevelItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onUpgradeLevelItem', _itemIdx, _callback);
};
WorldTownScreenShopDialogModule.prototype.EL_notifyBackendRecraftItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onRecraftItem', _itemIdx, _callback);
};

CharacterScreenPaperdollModule.prototype.createEquipmentSlot = function (
	_slot,
	_parentDiv,
	_screenDiv
) {
	var self = this;

	var layout = $(
		'<div class="l-slot-container ' + _slot.ContainerClasses + '"/>'
	);
	_parentDiv.append(layout);

	_slot.Container = layout.createPaperdollItem(
		_slot.ContainerIsBig,
		_slot.BackgroundImage
	);

	// update item data
	var itemData = _slot.Container.data("item");
	itemData.owner = CharacterScreenIdentifier.ItemOwner.Paperdoll;
	itemData.slotType = _slot.SlotType;

	// add event handler
	var dropHandler = function (_source, _target, _proxy) {
		//var sourceData = _source.data('item');
		var sourceData = _proxy.data("item");
		var targetData = _target.data("item");

		var sourceOwner =
			sourceData !== null && "owner" in sourceData ? sourceData.owner : null;
		var targetOwner =
			targetData !== null && "owner" in targetData ? targetData.owner : null;

		// dont allow drop animation just yet
		sourceData.isAllowedToDrop = false;
		_proxy.data("item", sourceData);

		if (sourceOwner === null || targetOwner === null) {
			console.info("Failed to drop item. Owners are invalid.");
			return;
		}

		// we don't allow swapping within the paperdoll
		if (sourceOwner === targetOwner) {
			//console.error('Failed to drop item. Owners are equal.');
			return;
		}

		if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground) {
			// bullshit hack, fuck you imp
			$(".is-equipable").each(function () {
				$(this).removeClass("is-equipable");
			});
		}

		var entityId =
			sourceData !== null && "entityId" in sourceData ?
			sourceData.entityId :
			null;
		var itemId =
			sourceData !== null && "itemId" in sourceData ? sourceData.itemId : null;

		var sourceSlotType =
			sourceData !== null && "slotType" in sourceData ?
			sourceData.slotType :
			null;
		var targetSlotType =
			targetData !== null && "slotType" in targetData ?
			targetData.slotType :
			null;
		var sourceItemId =
			sourceData !== null && "itemId" in sourceData ? sourceData.itemId : null;
		var sourceItemIdx =
			sourceData !== null && "index" in sourceData ? sourceData.index : null;
		var sourceIsBlockingOffhand =
			sourceData !== null && "isBlockingOffhand" in sourceData ?
			sourceData.isBlockingOffhand :
			false;
		var targetIsBlockingOffhand =
			targetData !== null && "isBlockingOffhand" in targetData ?
			targetData.isBlockingOffhand :
			false;
		var isUsable =
			sourceData !== null && "isUsable" in sourceData ? sourceData.isUsable : 0;


		if (sourceItemIdx === null) {
			console.error("Failed to drop item. Source idx is invalid. #1");
			return;
		}

		if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Backpack) {
			if (
				sourceData.isAllowedInBag === false ||
				targetData.isAllowedInBag === false
			) {
				console.info("Paperdoll::dropHandler: Not allowed in bag!");
				return;
			}

			var ignoreSlotType = false;

			if (
				sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
				sourceIsBlockingOffhand === true &&
				(targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand ||
					targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
			) {
				if (
					self.mDataSource.hasItemEquipped(
						CharacterScreenIdentifier.ItemSlot.Mainhand
					) &&
					self.mDataSource.hasItemEquipped(
						CharacterScreenIdentifier.ItemSlot.Offhand
					) &&
					self.mDataSource.isBagSpaceLeft(1) === false
				) {
					console.info("Paperdoll::dropHandler: Not enough bag space!");
					return;
				}

				ignoreSlotType = true;
			}
			if (ignoreSlotType === false && targetSlotType !== null) {
				if (sourceSlotType !== targetSlotType) {
					console.info(
						"Paperdoll::dropHandler: Item must be the same slot type!"
					);
					return;
				}
			}

			if (self.mDataSource.hasEnoughAPToEquip() === false) {
				console.info("Paperdoll::dropHandler: Not enough Action points!");
				return;
			}

			sourceData.isAllowedToDrop = true;
			_proxy.data("item", sourceData);

			console.info(
				"Backpack -> Paperdoll (sourceItemIdx: " + sourceItemIdx + ")"
			);
			self.mDataSource.equipBagItem(entityId, sourceItemId, sourceItemIdx);

			return;
		}

		if (
			sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash ||
			sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground
		) {
			var ignoreSlotType = false;

			if (
				sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
				sourceIsBlockingOffhand === true &&
				(targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand ||
					targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
			) {
				if (
					self.mDataSource.hasItemEquipped(
						CharacterScreenIdentifier.ItemSlot.Mainhand
					) &&
					self.mDataSource.hasItemEquipped(
						CharacterScreenIdentifier.ItemSlot.Offhand
					) &&
					self.mDataSource.isInStashMode() === true &&
					self.mDataSource.isStashSpaceLeft(2) === false
				) {
					console.info("Paperdoll::dropHandler: Not enough stash space!");
					return;
				}

				ignoreSlotType = true;
			}

			if (ignoreSlotType === false && targetSlotType !== null) {
				if (sourceSlotType !== targetSlotType && !isUsable) {
					console.info("isUsable = " + isUsable);
					console.info(
						"Paperdoll::dropHandler: Item must be the same slot type!"
					);
					return;
				}
			}

			if (self.mDataSource.hasEnoughAPToEquip() === false) {
				console.info("Paperdoll::dropHandler: Not enough Action points!");
				return;
			}

			if (
				self.mDataSource.isInGroundMode() === true &&
				(sourceSlotType === CharacterScreenIdentifier.ItemSlot.Head ||
					sourceSlotType === CharacterScreenIdentifier.ItemSlot.Body)
			) {
				console.info("Paperdoll::dropHandler: #3");
				return;
			}

			sourceData.isAllowedToDrop = true;
			_proxy.data("item", sourceData);
			self.mDataSource.equipInventoryItem(entityId, itemId, sourceItemIdx);
		}
	};

	var dragEndHandler = function (_source, _target, _proxy) {
		$(".is-equipable").each(function () {
			$(this).removeClass("is-equipable");
		});

		if (_source.length === 0 || _target.length === 0) {
			return false;
		}

		//var sourceData = _source.data('item');
		var sourceData = _proxy.data("item");
		var targetData = _target.data("item");

		var isAllowedToDrop =
			sourceData !== null &&
			"isAllowedToDrop" in sourceData &&
			targetData !== undefined &&
			targetData !== null ?
			sourceData.isAllowedToDrop :
			false;
		if (isAllowedToDrop === false) {
			console.info(
				"Paperdoll::dragEndHandler: Failed to drop item. Not allowed."
			);
			return false;
		}

		var sourceOwner =
			sourceData !== null && "owner" in sourceData ? sourceData.owner : null;
		var targetOwner =
			targetData !== null && "owner" in targetData ? targetData.owner : null;
		var hasTargetIndex =
			targetData !== null && "index" in targetData && targetData.index !== null;
		var isEmpty =
			targetData !== null && "isEmpty" in targetData ?
			targetData.isEmpty :
			true;
		if (
			sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash &&
			!hasTargetIndex
		) {
			console.info("Failed to drop item. Stash is full.");
			return self.mDataSource.isStashSpaceLeft();
		}

		self.mDataSource.getInventoryModule().updateSlotsLabel();

		return true;
	};

	var dragStartHandler = function (_source, _proxy) {
		var paperdollModule = $(".paperdoll-module");

		if (_source.length === 0) {
			return false;
		}

		var sourceData = _proxy.data("item");
		var sourceSlotType =
			sourceData !== null && "slotType" in sourceData ?
			sourceData.slotType :
			null;

		switch (sourceSlotType) {
			case CharacterScreenIdentifier.ItemSlot.Mainhand:
				var leftColumn = paperdollModule.find(".equipment-column:first");
				var mainhandContainer = leftColumn.find(
					".ui-control.paperdoll-item.has-slot-frame.is-big:first"
				);
				mainhandContainer.addClass("is-equipable");
				break;
			case CharacterScreenIdentifier.ItemSlot.Head:
				var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
				var headContainer = middleColumn.find(
					".ui-control.paperdoll-item.has-slot-frame:first"
				);
				headContainer.addClass("is-equipable");
				break;
			case CharacterScreenIdentifier.ItemSlot.Offhand:
				var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
				var offhandContainer = rightColumn.find(
					".ui-control.paperdoll-item.has-slot-frame.is-big:first"
				);
				offhandContainer.addClass("is-equipable");
				break;
			case CharacterScreenIdentifier.ItemSlot.Body:
				var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
				var bodyArmorContainer = middleColumn.find(
					".ui-control.paperdoll-item.has-slot-frame.is-big:first"
				);
				bodyArmorContainer.addClass("is-equipable");
				break;
			case CharacterScreenIdentifier.ItemSlot.Ammo:
				var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
				var ammoContainer = rightColumn.find(
					".ui-control.paperdoll-item.has-slot-frame:first"
				);
				ammoContainer.addClass("is-equipable");
				break;
			case CharacterScreenIdentifier.ItemSlot.Accessory:
				var leftColumn = paperdollModule.find(".equipment-column:first");
				var accessoryContainer = leftColumn.find(
					".ui-control.paperdoll-item.has-slot-frame:first"
				);
				accessoryContainer.addClass("is-equipable");
		}

		if (sourceData.isAllowedInBag) {
			$("div.l-backpack-row div.paperdoll-item.has-slot-frame").addClass(
				"is-equipable"
			);
		}
	};

	// add event handler
	_slot.Container.assignPaperdollItemDragAndDrop(
		_screenDiv,
		dragStartHandler,
		dragEndHandler,
		dropHandler
	);

	_slot.Container.assignPaperdollItemRightClick(function (_item, _event) {
		var data = _item.data("item");

		var isEmpty = data !== null && "isEmpty" in data ? data.isEmpty : true;
		var itemId = data !== null && "itemId" in data ? data.itemId : null;
		//var itemIdx = (data !== null && 'index' in data) ? data.index : null;
		var entityId = data !== null && "entityId" in data ? data.entityId : null;
		var dropIntoInventory =
			KeyModiferConstants.CtrlKey in _event &&
			_event[KeyModiferConstants.CtrlKey] === true;
		var repairItem =
			KeyModiferConstants.AltKey in _event &&
			_event[KeyModiferConstants.AltKey] === true;
		var unequipAllLayers =
				KeyModiferConstants.ShiftKey in _event &&
				_event[KeyModiferConstants.ShiftKey] === true;
		var EL_upgradeRankItem = dropIntoInventory && repairItem;

		if (
			isEmpty === false &&
			itemId !== null &&
			entityId !== null /*&& itemIdx !== null*/
		) {
			if (EL_upgradeRankItem === true)
			{
				
				//self.mDataSource.dropPaperdollItem(entityId, itemId, null);
				self.mDataSource.notifyBackendUpgradeRankItem(entityId, itemId);
			}
			else if (repairItem === true) {
				self.mDataSource.toggleInventoryItem(itemId, entityId, function (ret) {
					data["repair"] = ret["repair"];
					data["salvage"] = ret["salvage"];
					_slot.Container.setRepairImageVisible(
						data["repair"],
						data["salvage"]
					);
					//result.setSalvageImageVisible(data['salvage']);
				});
			}
			// equip or drop in bag
			else if (dropIntoInventory === true) {
				//console.info('drop item: ' + itemId);
				self.mDataSource.dropPaperdollItem(entityId, itemId, null);
			}
			else if (unequipAllLayers === true) {
				self.mDataSource.notifyBackendRemovePaperdollItemUpgrades(entityId, itemId);
			}
			else if (data.isAllowedInBag === true) {
				//console.info('drop item into bag: ' + itemId);
				self.mDataSource.dropPaperdollItemIntoBag(entityId, itemId, null);
			}

			self.mDataSource.getInventoryModule().updateSlotsLabel();
		}
	});
};

CharacterScreenDatasource.prototype.notifyBackendUpgradeRankItem = function (_brotherId, _sourceItemId)
{
	var brotherId = _brotherId;
	if (brotherId === null)
	{
		var selectedBrother = this.getSelectedBrother();
		if (selectedBrother === null || !(CharacterScreenIdentifier.Entity.Id in selectedBrother))
		{
			console.error('ERROR: Failed to remove paperdoll item layers. No entity selected.');
			return;
		}

		brotherId = selectedBrother[CharacterScreenIdentifier.Entity.Id];
	}

	var self = this;

	SQ.call(this.mSQHandle, 'EL_upgradeItemRankInBagOrStash', [brotherId, _sourceItemId], function (data) {
		if (data === undefined || data == null || typeof (data) !== 'object')
		{
			console.error('ERROR: Failed to remove Paperdoll Item Upgrades. Invalid data result.');
			return;
		}

		//Still try to do the rest as error can be no stash space when removing multiple layers
		if (ErrorCode.Key in data)
		{
			self.notifyEventListener(ErrorCode.Key, data[ErrorCode.Key]);
		}
		if ('stashSpaceUsed' in data)
			self.mStashSpaceUsed = data.stashSpaceUsed;

		if ('stashSpaceMax' in data)
			self.mStashSpaceMax = data.stashSpaceMax;

		self.mInventoryModule.updateSlotsLabel();

		if (CharacterScreenIdentifier.QueryResult.Stash in data)
		{
			var stashData = data[CharacterScreenIdentifier.QueryResult.Stash];
			if (stashData !== null && jQuery.isArray(stashData))
			{
				self.updateStash(stashData);
			}
		}
		if (CharacterScreenIdentifier.QueryResult.Brother in data)
		{
			var brotherData = data[CharacterScreenIdentifier.QueryResult.Brother];
			if (CharacterScreenIdentifier.Entity.Id in brotherData)
			{
				self.updateBrother(brotherData);
			}
		}
	});
};
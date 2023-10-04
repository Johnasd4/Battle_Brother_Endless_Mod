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
		var EL_upgradeItem = KeyModiferConstants.CtrlKey in _event && _event[KeyModiferConstants.CtrlKey] === true;
		var EL_recraftItem = KeyModiferConstants.ShiftKey in _event && _event[KeyModiferConstants.ShiftKey] === true;
		var EL_disassembleItem = EL_upgradeItem && EL_recraftItem;
		if(/*doSomething &&*/ isEmpty === false && owner !== null /*&& itemId !== null*/ && itemIdx !== null)
		{
			// buy, sell or destroy
			switch(owner)
			{
				case WorldTownScreenShop.ItemOwner.Stash:
				{
					if (EL_disassembleItem === true)
					{
						self.EL_disassembleItem(itemIdx);
					}
					else if (repairItem === true)
					{
						console.info('destroy');
						self.repairItem(itemIdx);
					}
					else if(EL_upgradeItem === true)
					{
						self.EL_upgradeItem(itemIdx);
					}
					else if(EL_recraftItem === true)
					{
						self.EL_recraftItem(itemIdx);
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

WorldTownScreenShopDialogModule.prototype.EL_upgradeItem = function(_itemIdx)
{
	var self = this;
	this.EL_notifyBackendUpgradeItem(_itemIdx, function(_result)
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
WorldTownScreenShopDialogModule.prototype.EL_notifyBackendUpgradeItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onUpgradeItem', _itemIdx, _callback);
};
WorldTownScreenShopDialogModule.prototype.EL_notifyBackendRecraftItem = function (_itemIdx, _callback)
{
	SQ.call(this.mSQHandle, 'EL_onRecraftItem', _itemIdx, _callback);
};
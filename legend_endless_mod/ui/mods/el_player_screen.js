CharacterScreenLeftPanelHeaderModule.prototype.setXP = function(_xpValue, _xpValueMax, _level, _levelUpTimes, _hasPerkPoints)
{
	if(_level >= 11)
	{
		this.mXPProgressbar.addClass('xp-paragon');
	}
	else
	{
		this.mXPProgressbar.removeClass('xp-paragon');
	}

	if (_levelUpTimes)
	{
		this.mXPProgressbar.changeProgressbarNormalWidth(100, 100);
        this.mXPProgressbar.changeProgressbarLabel(TranslateCharacterScreenLeftPanelHeaderModule('点击此处升级！(<span class="font-bold font-color-positive-value">' + _levelUpTimes + '</span>)'));
	}
	else if (_hasPerkPoints)
	{
		this.mXPProgressbar.changeProgressbarNormalWidth(100, 100);
        this.mXPProgressbar.changeProgressbarLabel(TranslateCharacterScreenLeftPanelHeaderModule('使用特技点升级!'));
	}
	else
	{
		this.mXPProgressbar.changeProgressbarNormalWidth(_xpValue, _xpValueMax);
		this.mXPProgressbar.changeProgressbarLabel('' + _xpValue + ' / ' + _xpValueMax);
	}
};

CharacterScreenLeftPanelHeaderModule.prototype.updateControls = function(_id, _data)
{
	/*this.mLevelContainer.css('backgroundColor', 'transparent');
	this.mLevelContainer.stop();*/

	if (_data === null || typeof(_data) !== 'object')
	{
		return;
	}

	// update image
	if (CharacterScreenIdentifier.Entity.Character.ImagePath in _data)
	{
		this.setPortraitImage(_data[CharacterScreenIdentifier.Entity.Character.ImagePath]);
	}

	// update name & title
	if (CharacterScreenIdentifier.Entity.Character.Name in _data)
	{
		var titel = '';
		if (CharacterScreenIdentifier.Entity.Character.Title in _data)
		{
			titel = _data[CharacterScreenIdentifier.Entity.Character.Title];
		}
		this.setNameAndTitle(_data[CharacterScreenIdentifier.Entity.Character.Name], titel);
	}

	// update level
	if (CharacterScreenIdentifier.Entity.Character.Level in _data)
	{
		this.setLevel(_data[CharacterScreenIdentifier.Entity.Character.Level], _data[CharacterScreenIdentifier.Entity.Character.LevelUp.Key] !== null);
	}
	// update xp
	if (CharacterScreenIdentifier.Entity.Character.XPValue in _data && CharacterScreenIdentifier.Entity.Character.XPValueMax in _data)
	{
		this.setXP(_data[CharacterScreenIdentifier.Entity.Character.XPValue], _data[CharacterScreenIdentifier.Entity.Character.XPValueMax], _data[CharacterScreenIdentifier.Entity.Character.Level], _data[CharacterScreenIdentifier.Entity.Character.LevelUpTimes], _data[CharacterScreenIdentifier.Entity.Character.PerkPoints]);
	}

	// update dismiss button
    
	if (this.mDataSource.getNumBrothers() > 1 && !this.mDataSource.isTacticalMode() && !_data[CharacterScreenIdentifier.Entity.Character.IsPlayerCharacter])
	{
		this.mDismissButton.removeClass('display-none').addClass('display-block');
	}
	else
	{
		this.mDismissButton.addClass('display-none').removeClass('display-block');
	}
	
	// update reserve button
	if (!this.mDataSource.isTacticalMode())
	{
		this.mReserveButton.removeClass('display-none').addClass('display-block');
	}
	else
	{
		this.mReserveButton.addClass('display-none').removeClass('display-block');
	}
	
	if (_data['inReserves'])
	{
		this.mReserveButton.changeButtonImage(Path.GFX + "ui/buttons/mood_heal.png")
	}
	else
	{
		this.mReserveButton.changeButtonImage(Path.GFX + "ui/icons/stat_screen_dmg_dealt.png")
	}
	this.mReserveButton.unbindTooltip();
	this.mReserveButton.bindTooltip({ contentType: 'ui-element', entityId: _id, elementId: TooltipIdentifier.CharacterScreen.LeftPanelHeaderModule.Reserves });
};


// CharacterScreenLeftPanelHeaderModule.prototype.onBrotherUpdated = function (_dataSource, _brother)
// {
// 	/*this.mLevelContainer.css('backgroundColor', 'transparent');
// 	this.mLevelContainer.stop();*/
	
// 	if (this.mDataSource.isSelectedBrother(_brother) && CharacterScreenIdentifier.Entity.Character.Key in _brother)
// 	{
// 		this.updateControls(_brother[CharacterScreenIdentifier.Entity.Id], _brother[CharacterScreenIdentifier.Entity.Character.Key], this.mDataSource.getBrotherPerkPoints(_brother));
// 	}
// };

// CharacterScreenLeftPanelHeaderModule.prototype.onBrotherSelected = function (_dataSource, _brother)
// {
// 	/*this.mLevelContainer.css('backgroundColor', 'transparent');
// 	this.mLevelContainer.stop();*/
	
// 	if (_brother !== null && (CharacterScreenIdentifier.Entity.Id in _brother && CharacterScreenIdentifier.Entity.Character.Key in _brother))
// 	{
// 		this.updateControls(_brother[CharacterScreenIdentifier.Entity.Id], _brother[CharacterScreenIdentifier.Entity.Character.Key], this.mDataSource.getBrotherPerkPoints(_brother));
// 	}
// };
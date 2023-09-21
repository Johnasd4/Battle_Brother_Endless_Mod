this.el_battle_standard_ambition_rank_3 <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.el_battle_standard_ambition_rank_3";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Our battle standard needs an upgrade, so we shall gather 100,000 crowns for this.";
		this.m.RewardTooltip = "The battle standard rank will +1, and the level will reset, don't worry, the essence spent on the standard will return.";
		this.m.UIText = "Have at least 100,000 crowns";
		this.m.TooltipText = "Gather the amount of 100,000 crowns or more, so that you can upgrade your battle standard. You can make money by completing contracts, looting camps and ruins, or trading.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Your battle standard have been upgraded.";
		this.m.SuccessButtonText = "Yeah!";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}
		if (!this.World.Ambitions.getAmbition("ambition.el_battle_standard_ambition_rank_2").isDone())
		{
			return;
		}
		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 100000 && this.World.Assets.getStash().hasEmptySlot())
		{
			return true;
		}
		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		local standard = stash.getItemByID("weapon.player_banner");
		local level = standard.EL_getLevel();
		local payment = 50000 - level * 250;
		stash.remove(standard);
		this.World.Assets.addMoney(-payment);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + payment + "[/color] Crowns"
		});
		item = this.new("scripts/items/tools/player_banner");
		item.EL_generateByRankAndLevel(3, 0);
		item.setVariant(this.World.Assets.getBannerID());
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});


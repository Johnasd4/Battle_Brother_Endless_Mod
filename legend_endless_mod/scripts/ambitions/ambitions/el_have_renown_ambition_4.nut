this.el_have_renown_ambition_4 <- this.inherit("scripts/ambitions/ambition", {
	m = {
        EL_ReputationNeed = 20000
    },
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.el_have_renown_4";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Already we are known in some parts of the land, yet we are still far from being\na legendary company. We shall increase our renown further!";
		this.m.UIText = "拥有 " + this.m.EL_ReputationNeed + " 声望。";
		this.m.TooltipText = "拥有 " + this.m.EL_ReputationNeed + " 声望。 You can increase your renown by completing contracts and winning battles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Marching through forests and over plains, the band has smashed any opposition they\'ve been sent after. Trampling foes, shattering battle lines, and sending heads flying, the %companyname% find that they are seldom alone. Crows circle high over the company as they march, they sing as the men take their supper, and more often than not they feast well after their daily work is done.\n\nIn their wake, the men leave scorched earth and outlandish rumors everywhere their booted feet have tread, each tale burgeoning in the telling until everyone from milkmaids to blacksmiths to burgomeisters seems to be talking about your exploits. Gossip is a currency valued in every corner of the land, and neither broad rivers nor tall peaks will slow the tales of your victories, and in turn, the prices you can now demand for your services.";
		this.m.SuccessButtonText = "People know of the %companyname% now!";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.World.Assets.getBusinessReputation() + "/" + this.m.EL_ReputationNeed + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.el_have_renown_3").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= this.m.EL_ReputationNeed)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item = this.new("scripts/items/el_accessory/el_have_renown_ambition_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "You gain " + item.getName()
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


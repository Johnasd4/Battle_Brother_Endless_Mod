this.el_upgrade_item_ambition_3 <- this.inherit("scripts/ambitions/ambition", {
	m = {
        EL_AmountNeed = 100000
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.el_upgrade_item_3";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "战场局势多变，提升你的装备能大大增强战队的实力。";
		this.m.UIText = "强化你的装备, 消耗精华";
		this.m.TooltipText = "通过强化装备共计消耗" + this.m.EL_AmountNeed + "精华。";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]The thought bore down on you from the start, and it is one that escapes many a mercenary captain. A thought so simple that perhaps its very simplicity camouflages it from a sword wielding leader\'s ego. If the %companyname% is to be traveling from city to city looking for sellsword work, it may as already have one foot in another vocation altogether: that of upgrade_item. You picked up on it quick, realizing that goods carry a different sort of currency than which appears at face, a value hidden from the eye, and hidden in the ripples of time and location themselves. Now you spend evenings struggling to tabulate the crowns. For once, it\'s a good problem to have.";
		this.m.SuccessButtonText = "That\'s the bottom line.";
	}

	function getUIText()
	{
        local consume_amount = this.World.Statistics.getFlags().getAsInt("UpgradeGreyEssenceConsume");
		return this.m.UIText + " (" + consume_amount + "/" + this.m.EL_AmountNeed + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.el_upgrade_item_2").isDone())
		{
			return;
		}
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("UpgradeGreyEssenceConsume") >= this.m.AmountNeed)
		{
			return true;
		}

		return false;
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


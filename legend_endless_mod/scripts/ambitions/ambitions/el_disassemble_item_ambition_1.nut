this.el_disassemble_item_ambition_1 <- this.inherit("scripts/ambitions/ambition", {
	m = {
        EL_AmountNeed = 10000
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.el_disassemble_item_1";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "强化装备需要大量的精华，仅靠战场掉落的蚊子腿太少了，让我们去武器店或盔甲店将不用的装备分解，获取更多精华！。";
		this.m.UIText = "分解你的装备, 获取精华";
		this.m.TooltipText = "依靠分解装备共计获取" + this.m.EL_AmountNeed + "精华。";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]The thought bore down on you from the start, and it is one that escapes many a mercenary captain. A thought so simple that perhaps its very simplicity camouflages it from a sword wielding leader\'s ego. If the %companyname% is to be traveling from city to city looking for sellsword work, it may as already have one foot in another vocation altogether: that of disassemble_item. You picked up on it quick, realizing that goods carry a different sort of currency than which appears at face, a value hidden from the eye, and hidden in the ripples of time and location themselves. Now you spend evenings struggling to tabulate the crowns. For once, it\'s a good problem to have.";
		this.m.SuccessButtonText = "That\'s the bottom line.";
	}

	function getUIText()
	{
        local consume_amount = this.World.Statistics.getFlags().getAsInt("DisassembleGreyEssenceGain");
		return this.m.UIText + " (" + consume_amount + "/" + this.m.EL_AmountNeed + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.el_disassemble_item_0").isDone())
		{
			return;
		}
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("DisassembleGreyEssenceGain") >= this.m.AmountNeed)
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


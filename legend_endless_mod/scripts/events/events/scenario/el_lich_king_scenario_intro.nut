this.el_lich_king_scenario_intro <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.el_lich_king_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/lich_king.png[/img]{命运给了我再来一次的机会，在这片新的大地上。战乱、饥荒、兽人、亡灵在肆无忌惮的摧残着这片土地，我虽已非人，但圣光的教诲还历历在目。纵使因为现在的亡灵之身而不被世界所接纳，我依然要奋力而战，斩杀邪恶。\n特有机制：战场上有人死亡时会积累灵魂能量，用于作战，恢复装备耐久与强化装备。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我将再次踏上征途。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The " + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
	}

	function onClear()
	{
	}

});


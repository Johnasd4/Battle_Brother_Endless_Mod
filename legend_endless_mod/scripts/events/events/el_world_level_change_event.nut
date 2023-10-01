this.el_world_level_change_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.el_world_level_change";
		this.m.Title = "World Level Customization";
		this.m.Cooldown = this.Const.EL_World.EL_WorldChangeEvent.LevelCooldown * this.World.getTime().SecondsPerDay;
		local select_screen_num = this.Math.ceil(this.Const.EL_World.EL_WorldChangeEvent.OptionNum / this.Const.EL_World.EL_WorldChangeEvent.OptionNumPurPage);
		for(local page = 0; page < select_screen_num; ++page) {
			local screen = {
				ID = "el_world_level_change_event_select_page_" + page,
				Text = "Nothing in particular but a periodical event for you to optimize the world level after played a fair long time, aiming to help you have a better experience.\n\n",
				Image = "",
				List = [],
				Characters = [],
				Options = [],
				function start( _event )
				{
				}
			}
			local current_page_option_num = this.Const.EL_World.EL_WorldChangeEvent.OptionNumPurPage;
			if((page + 1) * this.Const.EL_World.EL_WorldChangeEvent.OptionNumPurPage > this.Const.EL_World.EL_WorldChangeEvent.OptionNum) {
				current_page_option_num = this.Const.EL_World.EL_WorldChangeEvent.OptionNum % this.Const.EL_World.EL_WorldChangeEvent.OptionNumPurPage;
			}
			for(local option_num = 0; option_num < current_page_option_num; ++option_num) {
				local option_index = page * this.Const.EL_World.EL_WorldChangeEvent.OptionNumPurPage + option_num;
				local world_level_offset = this.Const.EL_World.EL_WorldChangeEvent.WorldLevelOffset[option_index];
				local option = {
					Text = "World Level " + world_level_offset,
					Index = option_index,
					function getResult( _event )
					{
						this.World.Assets.m.EL_WorldLevelOffset += this.Const.EL_World.EL_WorldChangeEvent.WorldLevelOffset[option_index];
						this.World.Assets.EL_UpdateWorldStrengthAndLevel();
						return "el_world_level_change_event_result_page_" + this.Index;
					}
				}
				screen.Options.push(option);
			}
			if(select_screen_num > 1) {
				local next_page_option = {
					Text = "Next Page.",
					Index = (page + 1) % select_screen_num,
					function getResult( _event )
					{
						return "el_world_level_change_event_select_page_" + this.Index;
					}
				}
				local previous_page_option = {
					Text = "Previous Page.",
					Index = (page + select_screen_num - 1) % select_screen_num,
					function getResult( _event )
					{
						return "el_world_level_change_event_select_page_" + this.Index;
					}
				}
				screen.Options.push(next_page_option);
				screen.Options.push(previous_page_option);
			}
			this.m.Screens.push(screen);
		}
		for(local page = 0; page < this.Const.EL_World.EL_WorldChangeEvent.OptionNum; ++page) {
			local screen = {
				ID = "el_world_level_change_event_result_page_" + page,
				Index = page,
				Text = "Have a nice game.\n",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "Let us continue on with our journey。",
						function getResult( _event )
						{
							return 0;
						}
					}
				],
				function start( _event )
				{
					local brothers = this.World.getPlayerRoster().getAll();
					local xp_level = this.Math.max(1, this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.LevelXP.len() - 1));
					local xp = this.Math.floor((this.Const.LevelXP[xp_level] - this.Const.LevelXP[xp_level - 1]) * 0.2 * this.Index);
					foreach( brother in brothers )
					{
						brother.addXP(xp);
						brother.updateLevel();
					}
					local info = "All brothers gains: XP+[color=" + this.Const.UI.Color.PositiveEventValue + "]" + xp + "[/color]";
					if(xp != 0){
						this.List.push({
							id = 16,
							text = info
						});
					}
				}
			}
			this.m.Screens.push(screen);
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < this.Const.EL_World.EL_WorldChangeEvent.LevelCooldown)
		{
			this.m.Score = 0;
			return;
		}
		if(this.Time.getVirtualTimeF() < this.m.CooldownUntil)
		{
			this.m.Score = 0;
			return;
		}
		this.m.Score = 9999;
	}



	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		local page_index = 0;
		return "el_world_level_change_event_select_page_" + page_index;
	}

});


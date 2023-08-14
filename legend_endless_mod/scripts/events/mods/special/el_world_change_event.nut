this.el_world_change_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.el_world_change";
		this.m.Title = "Difficulty Customization";
		this.World.Flags.set("EL_WorldChangeEvent", 3);
		this.m.Cooldown = this.Const.EL_World.EL_WorldChangeEventCooldown * this.World.getTime().SecondsPerDay;
		local select_screen_num = this.Math.floor((this.Const.EL_World.EL_WorldChangeEventOptionNum + 1) / this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage) + 1;
		for(local page = 0; page < select_screen_num; ++page) {
			local screen = {
				ID = "el_world_change_event_select_page_" + page,
				Index = page,
				Text = "Nothing in particular but a periodical event for you to optimize the strength difficulty after played a fair long time, aiming to help you have a better experience.\n\n" +
					   "World Strength : " + this.World.Assets.m.EL_WorldStrength + "\n" +
					   "World Level : " + this.World.Assets.m.EL_WorldLevel + "\n" +
					   "World Difficulty : " + this.Const.EL_World.EL_WorldChangeEventDifficultyMultFactor[this.World.Flags.get("EL_WorldChangeEvent")] * 100 + "%\n",
				Image = "",
				List = [],
				Characters = [],
				Options = [],
				function start( _event )
				{
				}
			}
			local current_page_option_num = this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage;
			if((page + 1) * this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage > this.Const.EL_World.EL_WorldChangeEventOptionNum) {
				current_page_option_num = this.Const.EL_World.EL_WorldChangeEventOptionNum % this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage;
			}
			for(local option_num = 0; option_num < current_page_option_num; ++option_num) {
				local option_index = page * this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage + option_num;
				local world_level_offset = this.Const.EL_World.EL_WorldChangeEventWorldLevelOffset[option_index];
				local mult_persent = this.Const.EL_World.EL_WorldChangeEventDifficultyMultFactor[option_index] * 100;
				local option = {
					Text = "World Difficulty " + mult_persent + "%, ",
					function getResult( _event )
					{
						this.World.Flags.set("EL_WorldChangeEvent", option_index);
						this.World.Assets.m.EL_WorldLevelOffset += this.Const.EL_World.EL_WorldChangeEventWorldLevelOffset[this.World.Flags.get("EL_WorldChangeEvent")];
						this.World.Assets.EL_UpdateWorldStrengthAndLevel();
						return "el_world_change_event_result_page_" + option_index;
					}
				}
				if(world_level_offset > 0) {
					option.Text += "World Level + " + world_level_offset + ".";
				}
				else if(world_level_offset < 0){
					option.Text += "World Level - " + -world_level_offset + ".";
				}
				else{
					option.Text += "World Level does't change.";
				}
				screen.Options.push(option);
			}

			local previous_page_option = {
				Text = "Previous Page.",
				function getResult( _event )
				{

					return "el_world_change_event_select_page_" + ((this.Index - 1 < 0) ? 0 : (this.Index - 1));
				}
			}
			local next_page_option = {
				Text = "Next Page.",
				function getResult( _event )
				{
					return "el_world_change_event_select_page_" + ((page + 1 == select_screen_num) ? (select_screen_num - 1) : (page + 1));
				}
			}
			screen.Options.push(previous_page_option);
			screen.Options.push(next_page_option);

			this.m.Screens.push(screen);
		}
		for(local page = 0; page < this.Const.EL_World.EL_WorldChangeEventOptionNum; ++page) {
			local screen = {
				ID = "el_world_change_event_result_page_" + page,
				Text = " World Strength : " + this.World.Assets.m.EL_WorldStrength + "\n" +
					   " World Level : " + this.World.Assets.m.EL_WorldLevel + "\n" +
					   " World Difficulty : " + this.Const.EL_World.EL_WorldChangeEventDifficultyMultFactor[this.World.Flags.get("EL_WorldChangeEvent")] * 100 + "%\n",
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
					foreach( brother in brothers )
					{
						local hitpoints = 0;
						local bravery = 0;
						local stamina = 0;
						local initiative = 0;
						local melee_skill = 0;
						local ranged_skill = 0;
						local melee_defense = 0;
						local ranged_defense = 0;
						local total_reward_times = this.Const.EL_World.EL_WorldChangeEventRewardTimesPurLevel * page;
						for(local reward_times = 0; reward_times < total_reward_times; ++reward_times) {
							local attribute_type = this.Math.rand(0, this.Const.Attributes.COUNT - 1);
							switch (attribute_type)
							{
								case this.Const.Attributes.Hitpoints:
									hitpoints += 1;
									break;
								case this.Const.Attributes.Bravery:
									bravery += 1;
									break;
								case this.Const.Attributes.Fatigue:
									stamina += 1;
									break;
								case this.Const.Attributes.Initiative:
									initiative += 1;
									break;
								case this.Const.Attributes.MeleeSkill:
									melee_skill += 1;
									break;
								case this.Const.Attributes.RangedSkill:
									ranged_skill += 1;
									break;
								case this.Const.Attributes.MeleeDefense:
									melee_defense += 1;
									break;
								case this.Const.Attributes.RangedDefense:
									ranged_defense += 1;
									break;
							}
						}
						bro.getBaseProperties().Initiative += initiative;
						bro.getBaseProperties().Bravery += bravery;
						bro.getBaseProperties().Stamina += stamina;
						bro.getBaseProperties().Hitpoints += hitpoints;
						bro.getBaseProperties().RangedDefense += ranged_defense;
						bro.getBaseProperties().MeleeDefense += melee_defense;
						bro.getBaseProperties().RangedSkill += ranged_skill;
						bro.getBaseProperties().MeleeSkill += melee_skill;
						bro.getSkills().update();
						local info = brother.getName() + " gains:[color=" + this.Const.UI.Color.PositiveEventValue + "]";
						local if_add = false;
						if(hitpoints > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/health_va11.png[/img]+" + hitpoints + "";
						}
						if(bravery > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/bravery_va11.png[/img]+" + bravery + "";
						}
						if(stamina > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/fatigue_va11.png[/img]+" + stamina + "";
						}
						if(initiative > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/initiative_va11.png[/img]+" + initiative + "";
						}
						if(melee_skill > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/melee_skill_va11.png[/img]+" + melee_skill + "";
						}
						if(ranged_skill > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/ranged_skill_va11.png[/img]+" + ranged_skill + "";
						}
						if(melee_defense > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/melee_defense_va11.png[/img]+" + melee_defense + "";
						}
						if(ranged_defense > 0){
							if_add = true;
							info = info + " [img]gfx/ui/icons/ranged_defense_va11.png[/img]+" + ranged_defense + "";
						}
						info = info + "[/color]";
						if(ifAdd == 1){
							this.List.push({
								id = 16,
								text = info
							});
						}
					}
				}
			}
			this.m.Screens.push(screen);
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < this.Const.EL_World.EL_WorldChangeEventCooldown)
		{
			return;
		}

		this.m.Score = 999;
	}



	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		local page_index = this.Math.floor(this.World.Flags.get("EL_WorldChangeEvent") / this.Const.EL_World.EL_WorldChangeEventOptionNumPurPage);
		return "el_world_change_event_select_page_" + page_index;
	}

});


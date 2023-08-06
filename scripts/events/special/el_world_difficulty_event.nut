this.el_world_difficulty_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.el_world_difficulty_event";
		this.m.Title = "Difficulty Customization";
		this.m.Cooldown = this.Const.EL_WorldDifficulty.EL_WorldDifficultySelectDistanceDay * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "el_world_difficulty_event_select",
			Text = "[img]gfx/ui/events/event_91.png[/img]没有什么特别的发生，只是调整世界难度。根据难度选择会有额外奖励",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "弱鸡(10%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_0";
					}

				},
				{
					Text = "新手(40%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_1";
					}

				},
				{
					Text = "简单(70%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_2";
					}

				},
				{
					Text = "一般(100%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_3";
					}

				},
				{
					Text = "困难(150%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_4";
					}

				},
				{
					Text = "专家(220%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_5";
					}

				},
				{
					Text = "疯狂(330%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_6";
					}

				},
				{
					Text = "传奇(500%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_7";
					}

				},
				{
					Text = "神(750%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_8";
					}

				},
				{
					Text = "???(1000%)。",
					function getResult( _event )
					{
						return "el_world_difficulty_event_9";
					}

				}

			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_0",
			Text = "[img]gfx/ui/events/event_85.png[/img]弱鸡难度。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 0);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = 0;
					local bravery = 0;
					local stamina = 0;
					local hitpoints = 0;
					local ranged_defense = 0;
					local melee_defense = 0;
					local ranged_skill = 0;
					local melee_skill = 0;
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_1",
			Text = "[img]gfx/ui/events/event_85.png[/img]新手。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 1);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = 0;
					local bravery = 0;
					local stamina = 0;
					local hitpoints = 0;
					local ranged_defense = 0;
					local melee_defense = 0;
					local ranged_skill = 0;
					local melee_skill = 0;
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_2",
			Text = "[img]gfx/ui/events/event_69.png[/img]简单。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 2);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(0, 1);
					local bravery = this.Math.rand(0, 1);
					local stamina = 0;
					local hitpoints = 0;
					local ranged_defense = 0;
					local melee_defense = 0;
					local ranged_skill = 0;
					local melee_skill = 0;
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_3",
			Text = "[img]gfx/ui/events/event_69.png[/img]普通。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(0, 2);
					local bravery = this.Math.rand(0, 2);
					local stamina = this.Math.rand(0, 1);
					local hitpoints = this.Math.rand(0, 1);
					local ranged_defense = 0;
					local melee_defense = 0;
					local ranged_skill = 0;
					local melee_skill = 0;
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_4",
			Text = "[img]gfx/ui/events/event_69.png[/img]困难。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 4);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(1, 2);
					local bravery = this.Math.rand(1, 2);
					local stamina = this.Math.rand(0, 2);
					local hitpoints = this.Math.rand(0, 2);
					local ranged_defense = this.Math.rand(0, 1);
					local melee_defense = this.Math.rand(0, 1);
					local ranged_skill = 0;
					local melee_skill = 0;
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_5",
			Text = "[img]gfx/ui/events/event_69.png[/img]专家。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 5);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(1, 3);
					local bravery = this.Math.rand(1, 3);
					local stamina = this.Math.rand(1, 2);
					local hitpoints = this.Math.rand(1, 2);
					local ranged_defense = this.Math.rand(0, 2);
					local melee_defense = this.Math.rand(0, 2);
					local ranged_skill = this.Math.rand(0, 1);
					local melee_skill = this.Math.rand(0, 1);
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_6",
			Text = "[img]gfx/ui/events/event_69.png[/img]疯狂。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 6);
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(2, 3);
					local bravery = this.Math.rand(2, 3);
					local stamina = this.Math.rand(1, 3);
					local hitpoints = this.Math.rand(1, 3);
					local ranged_defense = this.Math.rand(1, 2);
					local melee_defense = this.Math.rand(1, 2);
					local ranged_skill = this.Math.rand(0, 2);
					local melee_skill = this.Math.rand(0, 2);
					local perk_points = 0;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_7",
			Text = "[img]gfx/ui/events/event_69.png[/img]传说。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 7);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(2, 4);
					local bravery = this.Math.rand(2, 4);
					local stamina = this.Math.rand(2, 3);
					local hitpoints = this.Math.rand(2, 3);
					local ranged_defense = this.Math.rand(1, 3);
					local melee_defense = this.Math.rand(1, 3);
					local ranged_skill = this.Math.rand(1, 2);
					local melee_skill = this.Math.rand(1, 2);
					local perk_points = this.Math.rand(0, 1);
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();
					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_8",
			Text = "[img]gfx/ui/events/event_69.png[/img]神。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 8);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(3, 4);
					local bravery = this.Math.rand(3, 4);
					local stamina = this.Math.rand(2, 4);
					local hitpoints = this.Math.rand(2, 4);
					local ranged_defense = this.Math.rand(2, 3);
					local melee_defense = this.Math.rand(2, 3);
					local ranged_skill = this.Math.rand(1, 3);
					local melee_skill = this.Math.rand(1, 3);
					local perk_points = this.Math.rand(0, 1);
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();

					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
					}
					if(perk_points > 0){
						ifAdd = 1;
						info = info + " " + perk_points + "特技点";
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
		});
		this.m.Screens.push({
			ID = "el_world_difficulty_event_9",
			Text = "[img]gfx/ui/events/event_69.png[/img]???。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们继续我们的旅程。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("EL_WorldDifficultyEvent", 9);
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					local initiative = this.Math.rand(3, 5);
					local bravery = this.Math.rand(3, 5);
					local stamina = this.Math.rand(3, 4);
					local hitpoints = this.Math.rand(3, 4);
					local ranged_defense = this.Math.rand(2, 4);
					local melee_defense = this.Math.rand(2, 4);
					local ranged_skill = this.Math.rand(2, 3);
					local melee_skill = this.Math.rand(2, 3);
					local perk_points = 1;
					bro.getBaseProperties().Initiative += initiative;
					bro.getBaseProperties().Bravery += bravery;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Hitpoints += hitpoints;
					bro.getBaseProperties().RangedDefense += ranged_defense;
					bro.getBaseProperties().MeleeDefense += melee_defense;
					bro.getBaseProperties().RangedSkill += ranged_skill;
					bro.getBaseProperties().MeleeSkill += melee_skill;
					bro.setPerkPoints(bro.getPerkPoints() + perk_points);
					bro.getSkills().update();

					local info =  bro.getName() + " 获得：[color=" + this.Const.UI.Color.PositiveEventValue + "]";
					local ifAdd = 0;
					if(initiative > 0){
						ifAdd = 1;
						info = info + " " + initiative + "主动";
					}
					if(bravery > 0){
						ifAdd = 1;
						info = info + " " + bravery + "决心";
					}
					if(stamina > 0){
						ifAdd = 1;
						info = info + " " + stamina + "疲劳";
					}
					if(hitpoints > 0){
						ifAdd = 1;
						info = info + " " + hitpoints + "生命";
					}
					if(ranged_defense > 0){
						ifAdd = 1;
						info = info + " " + ranged_defense + "远防";
					}
					if(melee_defense > 0){
						ifAdd = 1;
						info = info + " " + melee_defense + "近防";
					}
					if(ranged_skill > 0){
						ifAdd = 1;
						info = info + " " + ranged_skill + "远攻";
					}
					if(melee_skill > 0){
						ifAdd = 1;
						info = info + " " + melee_skill + "近攻";
					}
					if(perk_points > 0){
						ifAdd = 1;
						info = info + " " + perk_points + "特技点";
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
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < this.Const.EL_WorldDifficulty.EL_WorldDifficultySelectDistanceDay)
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
		if (this.World.Flags.get("EL_WorldDifficultyEvent") == 0)
		{
			return "el_world_difficulty_event_0";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 1)
		{
			return "el_world_difficulty_event_1";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 2)
		{
			return "el_world_difficulty_event_2";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 3)
		{
			return "el_world_difficulty_event_3";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 4)
		{
			return "el_world_difficulty_event_4";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 5)
		{
			return "el_world_difficulty_event_5";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 6)
		{
			return "el_world_difficulty_event_6";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 7)
		{
			return "el_world_difficulty_event_7";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 8)
		{
			return "el_world_difficulty_event_8";
		}
		else if (this.World.Flags.get("EL_WorldDifficultyEvent") == 9)
		{
			return "el_world_difficulty_event_9";
		}

		return "el_world_difficulty_event_3";
	}

});


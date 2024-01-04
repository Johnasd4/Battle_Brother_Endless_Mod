this.el_world_arena_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
    {
        this.logInfo("Creating tournament event");
        this.m.ID = "event.location.el_world_arena";
        this.m.Title = "世界竞技场";
        this.m.Cooldown = 100;
        this.m.IsSpecial = true;

        local fight_screen = {
            ID = "fight_screen",
            Text = "[img]gfx/ui/events/legend_tournament.png[/img]欢迎来到世界竞技场，在这里你会挑战来自世界各地甚至世界之外的的各种强者，请选择你的对手，要么胜利要么死亡！",
            Image = "",
            List = [],
            Characters = [],
            Options = [],
            function start( _event )
            {
            }
        }

        fight_screen.Options.push({
            Text = "我准备好了！",
            function getResult( _event )
            {
                _event.registerToShowAfterCombat("win_screen", "lose_screen");

                if(!this.World.Flags.has("EL_WorldArenaNorthHuman"))
                {
                    this.World.Flags.set("EL_WorldArenaNorthHuman", 0);
                }
                if(!this.World.Flags.has("EL_WorldArenaOrc"))
                {
                    this.World.Flags.set("EL_WorldArenaOrc", 0);
                }
                if(!this.World.Flags.has("EL_WorldArenaGoblin"))
                {
                    this.World.Flags.set("EL_WorldArenaGoblin", 0);
                }
                if(!this.World.Flags.has("EL_WorldArenaUndead"))
                {
                    this.World.Flags.set("EL_WorldArenaUndead", 0);
                }
                if(!this.World.Flags.has("EL_WorldArenaBarbarion"))
                {
                    this.World.Flags.set("EL_WorldArenaBarbarion", 0);
                }
                if(!this.World.Flags.has("EL_WorldArenaVampire"))
                {
                    this.World.Flags.set("EL_WorldArenaVampire", 0);
                }

                local min_level = 0;

                local north_human_level = this.World.Flags.get("EL_WorldArenaNorthHuman");
                min_level = min_level < north_human_level ? min_level : north_human_level;

                local fight_enemy = [];

                if(north_human_level == min_level) {
                    fight_enemy.push({
                        level = north_human_level,
                        team = "EL_WorldArenaNorthHuman",
                        func = _event.el_generateNorthHumanParty
                    });
                }
                local r = this.Math.rand(0, fight_function.len() - 1);
                this.World.Flags.set("EL_WorldArenaTeam", fight_enemy[r].team);

                local p = this.Const.Tactical.CombatInfo.getClone();
                p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
                p.TerrainTemplate = "tactical.arena";
                p.LocationTemplate.Template[0] = "tactical.arena_floor";
                p.CombatID = "Legend Tournament";
                p.Music = this.Const.Music.ArenaTracks;
                p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
                p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
                p.IsUsingSetPlayers = false;
                p.IsFleeingProhibited = true;
                p.IsLootingProhibited = true;
                p.IsWithoutAmbience = true;
                p.IsFogOfWarVisible = false;
                p.IsArenaMode = true;
                p.IsAutoAssigningBases = false;
                p.Players = [];
                p.Entities = [];

                local party = this.new("scripts/entity/world/party");
                local level = fight_enemy[r].level;
                party.EL_setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Arena).getID());
                party.EL_tempPartyInit();
                party.EL_setTroopsResourse(0);
                party.EL_setHaveRandomLeader(false);
                party.EL_setHaveStrongestLeader(false);
                party.EL_setIsEliteParty(true);
                party.EL_setIsBossParty(false);
                p.Parties.push(party);

                fight_function[r].func(party);

                _event.el_strengthenUnitByLevel(party, level);

                foreach(troop in party.getTroops()) {
                    p.Entities.push(troop);
                }

                this.World.State.startScriptedCombat(p, false, false, false);
                //_event.el_generateNorthHumanParty();
                return 0;
            }
        });

        fight_screen.Options.push({
            Text = "我没准备好，下次再来。",
            function getResult( _event )
            {
                return 0;
            }
        });

        local win_screen = {
            ID = "win_screen",
            Text = "[img]gfx/ui/events/legend_tournament.png[/img]你胜利了！为我们的冠军欢呼！",
            Image = "",
            List = [],
            Characters = [],
            Options = [],
            function start( _event )
            {
                local team = this.World.Flags.get("EL_WorldArenaTeam");
                local level = this.World.Flags.get(team);
                this.World.Flags.set(team, level + 1);

                if(level == 0) {
                    if(team == "EL_WorldArenaNorthHuman") {
                        local reward_item = this.new("scripts/items/el_weapon/el_human_emperors_sword");
                        this.World.Assets.getStash().makeEmptySlots(1);
                        this.World.Assets.getStash().add(reward_item);
                        this.List.push({
                            id = 16,
                            text = "你获得了传奇装备 人皇剑"
                        });
                    }
                }
                local xp_level = this.Math.max(1, this.Math.min(this.World.Assets.m.EL_WorldLevel, this.Const.LevelXP.len() - 1));
                local core_xp = this.Math.floor(0.25 * (this.Const.LevelXP[xp_level] - this.Const.LevelXP[xp_level - 1]) * this.World.Assets.EL_getHalfWorldDifficultFactor());
                for(local i = 0; i < level * 3 + 3; ++i)
                {
                    local reward_item = this.new("scripts/items/el_misc/el_core_rank_4_item");
                    reward_item.EL_generateCoreXPByActorXP(core_xp);
                    this.World.Assets.getStash().makeEmptySlots(1);
                    this.World.Assets.getStash().add(reward_item);
                }
                this.List.push({
                    id = 16,
                    text = "你获得了 传奇魔核 * " + (level * 3 + 3)
                });

                this.World.Assets.EL_addEquipmentEssence(4, 3 * level);
                if(level != 0) {
                    this.List.push({
                        id = 16,
                        text = "你获得了 传奇精华 * " + (level * 3)
                    });
                }
                local reward_money = this.Math.floor(100000 * (level + 1) * this.World.Assets.EL_getHalfWorldDifficultFactor() * (1 + 0.08 * this.World.Assets.EL_WorldLevel));
                this.World.Assets.addMoney(reward_money);
                this.List.push({
                    id = 16,
                    text = "你获得了 克朗 * " + reward_money
                });
            }
        }

        local lose_screen = {
            ID = "lose_screen",
            Text = "[img]gfx/ui/events/legend_tournament.png[/img]你输了！带着你活着的人离开，这里不欢迎弱者！",
            Image = "",
            List = [],
            Characters = [],
            Options = [],
            function start( _event )
            {
            }
        }

        this.m.Screens.push(fight_screen);
        this.m.Screens.push(win_screen);
        this.m.Screens.push(lose_screen);

    }

	function onUpdateScore()
	{
		if (this.World.getTime().Days < this.Const.EL_World.EL_WorldChangeEvent.DifficultyCooldown)
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

    function el_strengthenUnitByLevel( _party, _level ) {

        for(local i = 0; i < _level; ++i) {
            foreach(troop in _party.getTroops()) {
                troop.EL_ExtraCombatLevel += 2;
                troop.EL_ExtraBuffNum[troop.EL_RankLevel] += 1;
            }
        }
    }

    function el_generateNorthHumanParty(_party) {

        //generate units
        for( local i = 0; i < 4; ++i )
        {
            this.Const.World.Common.addTroop(_party, {
                Type = this.Const.World.Spawn.Troops.Swordmaster
            }, false, 0, i < 1 ? 2 : 0);
        }
        for( local i = 0; i < 4; ++i )
        {
            this.Const.World.Common.addTroop(_party, {
                Type = this.Const.World.Spawn.Troops.MasterArcher
            }, false, 0, i < 1 ? 2 : 0);
        }
        for( local i = 0; i < 12; ++i )
        {
            this.Const.World.Common.addTroop(_party, {
                Type = this.Const.World.Spawn.Troops.HedgeKnight
            }, false, 0, i < 3 ? 2 : 0);
        }
    }

	function onDetermineStartScreen()
	{
		return "fight_screen";
	}

});


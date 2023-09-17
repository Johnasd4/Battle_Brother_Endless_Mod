local gt = getroottable();

::mods_registerMod("el_adaption_events_events_legends_locaiton", 1, "el_adaption_events_events_legends_locaiton");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("events/events/legends/location/legend_tournament_enter_event", function(o){

        o.selectFight = function( _scale, _type, _lootingStopped )
        {
            local round = this.World.Flags.get("LegendTournamentRound");
            local roundDifficulty = 0.7 + round * 0.3;
            this.World.Flags.increment("LegendTournamentRound", 1);
            local p = this.Const.Tactical.CombatInfo.getClone();
            p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
            p.TerrainTemplate = "tactical.tournament";
            p.LocationTemplate.Template[0] = "tactical.legend_tournament_floor";
            p.CombatID = "Legend Tournament";
            local tracks = [
                this.Const.Music.OrcsTracks,
                this.Const.Music.NobleTracks,
                this.Const.Music.UndeadTracks,
                this.Const.Music.BanditTracks,
                this.Const.Music.CivilianTracks,
                this.Const.Music.BeastsTracks,
                this.Const.Music.GoblinsTracks,
                this.Const.Music.OrientalBanditTracks,
                this.Const.Music.OrientalCityStateTracks,
                this.Const.Music.BarbarianTracks,
                this.Const.Music.BattleTracks
            ];
            p.Music = tracks[this.Math.rand(0, tracks.len() - 1)];
            p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
            p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
            p.IsUsingSetPlayers = false;
            p.IsFleeingProhibited = true;
            p.IsLootingProhibited = _lootingStopped;
            p.IsWithoutAmbience = true;
            p.IsFogOfWarVisible = false;
            p.IsArenaMode = true;
            p.IsAutoAssigningBases = false;
            p.Players = [];

            this.logInfo("push party");
            local party = this.new("scripts/entity/world/party");
            party.getFlags().set("isContractLocation", true);
            party.setFaction(this.Const.Faction.Enemy);
            //party.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Arena).getID());
            //Stop copying troops.
            party.EL_setTroopsResourse(0);
            p.Parties.push(party);
            this.Const.World.Common.addUnitsToCombat(party, _type, this.Math.pow(_scale, roundDifficulty), this.Const.Faction.Enemy);
            p.Entities = [];
            foreach(troop in party.getTroops()) {
                p.Entities.push(troop);
            }
            p.AfterDeploymentCallback = function ()
            {
                this.Tactical.getWeather().setAmbientLightingPreset(1);
                this.Tactical.getWeather().setAmbientLightingSaturation(1.1);
            };
            return p;
        }

    });


});

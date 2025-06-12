local gt = getroottable();

::mods_registerMod("el_adaption_events_events_scenario", 1, "el_adaption_events_events_scenario");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("events/events/scenario/ptr_swordmaster_scenario_student_local_duel_event", function(o){

        o.startCombat = function(_event)
        {
            //this.logInfo("ptr_swordmaster_scenario_student_local_duel_event startCombat");

            local name = _event.m.Flags.get("EnemyChampionName");
            local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
            properties.Music = this.Const.Music.NobleTracks;
            properties.Entities = [];
            local party = this.new("scripts/entity/world/party");
            party.EL_setFaction(this.Const.Faction.Enemy);
            party.EL_tempPartyInit();
            party.EL_setHaveRandomLeader(false);
            party.EL_setHaveStrongestLeader(false);
            party.EL_setTroopsResourse(0);
            properties.Parties.push(party);
            this.Const.World.Common.addTroop(party, {
                Type = this.Const.World.Spawn.Troops.Swordmaster
            }, false);foreach(troop in party.getTroops()) {
                properties.Entities.push(troop);
            }

            properties.Players.push(_event.m.Champion);
            properties.IsUsingSetPlayers = true;
            properties.IsFleeingProhibited = true;
            properties.IsAttackingLocation = true;
            properties.BeforeDeploymentCallback = function ()
            {
                local size = this.Tactical.getMapSize();

                for( local x = 0; x < size.X; x++ )
                {
                    for( local y = 0; y < size.Y; y++ )
                    {
                        local tile = this.Tactical.getTileSquare(x, y);
                        tile.Level = this.Math.min(1, tile.Level);
                    }
                }
            };
            _event.registerToShowAfterCombat("Victory", "Defeat");
            this.World.State.startScriptedCombat(properties, false, false, false);
        }
    });

});

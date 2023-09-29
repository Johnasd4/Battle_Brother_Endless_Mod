local gt = getroottable();

::mods_registerMod("el_adaption_skills_racial", 1, "el_adaption_skills_racial");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/racial/legend_greenwood_schrat_racial", function(o){

        o.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
        {
            local actor = this.getContainer().getActor();

            if (_damageHitpoints >= actor.getHitpointsMax() * 0.01)
            {
                local candidates = [];
                local myTile = actor.getTile();

                for( local i = 0; i < 6; i = i )
                {
                    if (!myTile.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local nextTile = myTile.getNextTile(i);

                        if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
                        {
                            candidates.push(nextTile);
                        }
                    }

                    i = ++i;
                }

                if (candidates.len() != 0)
                {
                    local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
                    local sapling = this.Const.World.Common.EL_addEntity({
                        ID = 0,
                        Variant = 0,
                        Strength = 280,
                        Cost = 210,
                        Row = 0,
                        Script = "scripts/entity/tactical/enemies/legend_greenwood_schrat_small"
                    }, spawnTile, actor.getFaction(), actor.EL_getRankLevel(), actor.EL_getLevel());
                    sapling.riseFromGround();
                }
            }
        }
	});

	::mods_hookExactClass("skills/racial/schrat_racial", function(o){

        o.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
        {
            local actor = this.getContainer().getActor();

            if (_damageHitpoints >= actor.getHitpointsMax() * 0.1)
            {
                local candidates = [];
                local myTile = actor.getTile();

                for( local i = 0; i < 6; i = i )
                {
                    if (!myTile.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local nextTile = myTile.getNextTile(i);

                        if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
                        {
                            candidates.push(nextTile);
                        }
                    }

                    i = ++i;
                }

                if (candidates.len() != 0)
                {
                    local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
                    local sapling = this.Const.World.Common.EL_addEntity({
                        ID = 0,
                        Variant = 0,
                        Strength = 70,
                        Cost = 70,
                        Row = 0,
                        Script = "scripts/entity/tactical/enemies/schrat_small"
                    }, spawnTile, actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction(), actor.EL_getRankLevel(), actor.EL_getLevel());
                    sapling.riseFromGround();
                }
            }
        }
	});

});

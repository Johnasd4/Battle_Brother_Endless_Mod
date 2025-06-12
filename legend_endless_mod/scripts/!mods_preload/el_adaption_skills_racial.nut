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

	::mods_hookExactClass("skills/racial/legend_rock_unhold_racial", function(o){

        o.onTurnStart = function()
        {
            local actor = this.getContainer().getActor();
            local properties = actor.getCurrentProperties();

            if (!actor.getSkills().hasSkill("effects.spider_poison_effect") && !actor.getSkills().hasSkill("effects.legend_redback_spider_poison_effect") && !actor.getSkills().hasSkill("effects.legend_RSW_poison_effect"))
            {
                local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
                local body_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Body] * properties.ArmorMult[this.Const.BodyPart.Body]);
                if(body != null) {
                    body.setArmor(this.Math.min(body.getArmorMax(), body.getArmor() + this.Math.round(body.getArmorMax() * this.Const.EL_NPC.EL_NPCBuff.Factor.Recovery.ArmorRecoveryRate[actor.EL_getRankLevel()])));
                    body.updateAppearance();
                }
                else {
                    properties.Armor[this.Const.BodyPart.Body] = this.Math.min(properties.ArmorMax[this.Const.BodyPart.Body], properties.Armor[this.Const.BodyPart.Body] + this.Math.round(properties.ArmorMax[this.Const.BodyPart.Body] * this.Const.EL_NPC.EL_NPCBuff.Factor.Recovery.ArmorRecoveryRate[actor.EL_getRankLevel()]));
                }
                body_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Body] * properties.ArmorMult[this.Const.BodyPart.Body]) - body_armor_added;
                if (!actor.isHiddenToPlayer() && body_armor_added != 0)
                {
                    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " regenerated " + body_armor_added + " points of body armor");
                }

                local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
                local head_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Head] * properties.ArmorMult[this.Const.BodyPart.Head]);
                if(head != null) {
                    head.setArmor(this.Math.min(head.getArmorMax(), head.getArmor() + this.Math.round(head.getArmorMax() * this.Const.EL_NPC.EL_NPCBuff.Factor.Recovery.ArmorRecoveryRate[actor.EL_getRankLevel()])));
                    head.updateAppearance();
                }
                else {
                    properties.Armor[this.Const.BodyPart.Head] = this.Math.min(properties.ArmorMax[this.Const.BodyPart.Head], properties.Armor[this.Const.BodyPart.Head] + this.Math.round(properties.ArmorMax[this.Const.BodyPart.Head] * this.Const.EL_NPC.EL_NPCBuff.Factor.Recovery.ArmorRecoveryRate[actor.EL_getRankLevel()]));
                }
                head_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Head] * properties.ArmorMult[this.Const.BodyPart.Head]) - head_armor_added;
                if (!actor.isHiddenToPlayer() && head_armor_added != 0)
                {
                    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " regenerated " + head_armor_added + " points of head armor");
                }
            }
        }
	});

	::mods_hookExactClass("skills/racial/mummy_racial", function(o){

        o.onDeathWithInfo = function( _killer, _skill, _deathTile, _corpseTile, _fatalityType )
        {
            if (_killer != null && !_killer.isDying() && _killer.isAlive())
            {
                _killer.getSkills().add(this.new("scripts/skills/effects/mummy_curse_effect"));
            }
        }
	});

});

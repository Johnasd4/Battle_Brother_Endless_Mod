local gt = getroottable();

::mods_registerMod("el_ballance_items_legend_armor_legendary", 1, "el_ballance_items_legend_armor_legendary");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/legend_armor/legendary/legend_armor_mountain_named", function(o){


        o.getTooltip = function()
        {
            local result = this.legend_armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/health.png",
                text = "Repairs [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] of its armor each turn"
            });
            return result;
        }

        o.onTurnStart = function()
        {
            local actor = this.getContainer().getActor();
            local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local bodyMissing = body.getArmorMax() - body.getArmor();
            local bodyAdded = this.Math.min(bodyMissing, this.Math.floor(body.getArmorMax() * 0.2));

            if (bodyAdded <= 0)
            {
                return;
            }

            body.setArmor(body.getArmor() + bodyAdded);
            actor.setDirty(true);

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
                this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
                this.Tactical.EventLog.log(this.Const.UI.getColorized(this.m.Name, "#1e468f") + " heals for " + bodyAdded + " points");
            }
        }

    });

	::mods_hookExactClass("items/legend_armor/legendary/legend_armor_mountain", function(o){

        o.getTooltip = function()
        {
            local result = this.legend_armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/health.png",
                text = "Repairs [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] of its armor each turn"
            });
            return result;
        }

        o.onTurnStart = function()
        {
            local actor = this.getContainer().getActor();
            local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
            local bodyMissing = body.getArmorMax() - body.getArmor();
            local bodyAdded = this.Math.min(bodyMissing, this.Math.floor(body.getArmorMax() * 0.2));

            if (bodyAdded <= 0)
            {
                return;
            }

            body.setArmor(body.getArmor() + bodyAdded);
            actor.setDirty(true);

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
                this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
                this.Tactical.EventLog.log(this.Const.UI.getColorized(this.m.Name, "#1e468f") + " heals for " + bodyAdded + " points");
            }
        }

    });

	::mods_hookExactClass("items/legend_armor/legendary/legend_armor_named_warlock_cloak", function(o){

        local create = o.create;
        o.create = function()
        {
            //this.logInfo("legend_armor_named_warlock_cloak create");
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }


        o.getTooltip = function()
        {
            local result = this.legend_named_armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Melee skill when at confident morale."
            });
            result.push({
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Melee defense when at confident morale."
            });
            result.push({
                id = 8,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "] +10[/color] Ranged defense when at confident morale."
            });
            result.push({
                id = 9,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Increase max hitpoints by [color=" + this.Const.UI.Color.PositiveValue + "] +20[/color]."
            });
            return result;
        }

        o.onUpdateProperties = function( _properties )
        {
            this.legend_named_armor.onUpdateProperties(_properties);
            _properties.Hitpoints += 20;

            if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident)
            {
                _properties.MeleeSkill += 10;
                _properties.MeleeDefense += 10;
                _properties.RangedDefense += 10;
            }
        }


    });



    ::mods_hookExactClass("items/legend_armor/legendary/legend_armor_of_davkul", function(o){

        local create = o.create;
        o.create = function()
        {
            //this.logInfo("legend_armor_of_davkul create");
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }


        o.getTooltip = function()
        {
            local result = this.legend_armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] points of durability each turn."
            });
            return result;
        }

        o.onTurnStart = function()
        {
            this.m.Condition = this.Math.minf(this.m.ConditionMax, this.Math.floor(this.m.Condition + this.m.ConditionMax * 0.4));
            this.updateAppearance();
        }

    });

	::mods_hookExactClass("items/legend_armor/legendary/legend_emperors_armor_fake", function(o){

        o.getTooltip = function()
        {
            local result = this.armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reflects [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] of damage taken in melee back to the attacker"
            });
            return result;
        }

        o.onDamageReceived = function( _damage, _fatalityType, _attacker )
        {
            this.armor.onDamageReceived(_damage, _fatalityType, _attacker);

            if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) == 1 && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
            {
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.Math.maxf(1.0, _damage * 0.5);
                hitInfo.DamageArmor = this.Math.maxf(1.0, _damage * 0.5);
                hitInfo.DamageDirect = 0.0;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.BodyDamageMult = 1.0;
                hitInfo.FatalityChanceMult = 0.0;
                _attacker.onDamageReceived(_attacker, null, hitInfo);
            }
        }

    });

	::mods_hookExactClass("items/legend_armor/legendary/legend_emperors_armor", function(o){

        local create = o.create;
        o.create = function()
        {
            //this.logInfo("legend_emperors_armor create");
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }


        o.getTooltip = function()
        {
            local result = this.armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Reflects [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] of damage taken in melee back to the attacker"
            });
            return result;
        }

        o.onDamageReceived = function( _damage, _fatalityType, _attacker )
        {
            this.armor.onDamageReceived(_damage, _fatalityType, _attacker);

            if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) == 1 && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
            {
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.Math.maxf(1.0, _damage * 0.5);
                hitInfo.DamageArmor = this.Math.maxf(1.0, _damage * 0.5);
                hitInfo.DamageDirect = 0.0;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.BodyDamageMult = 1.0;
                hitInfo.FatalityChanceMult = 0.0;
                _attacker.onDamageReceived(_attacker, null, hitInfo);
            }
        }

    });

    ::mods_hookExactClass("items/legend_armor/legendary/legend_ijirok_armor", function(o){

        local create = o.create;
        o.create = function()
        {
            //this.logInfo("legend_ijirok_armor create");
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }


        o.getTooltip = function()
        {
            local result = this.armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/health.png",
                text = "Heals [color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] hitpoints of the wearer each turn"
            });
            return result;
        }

        o.onTurnStart = function()
        {
            local actor = this.getContainer().getActor();
            local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
            local healthAdded = this.Math.min(healthMissing, this.Math.floor(actor.getHitpointsMax() * 0.4));

            if (healthAdded <= 0)
            {
                return;
            }

            actor.setHitpoints(actor.getHitpoints() + healthAdded);
            actor.setDirty(true);

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
                this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
            }
        }

    });


    ::mods_hookExactClass("items/legend_armor/legendary/legend_skin_armor", function(o){

        local create = o.create;
        o.create = function()
        {
            //this.logInfo("legend_skin_armor create");
            create();
            this.EL_generateByRankAndLevel(this.Const.EL_Item.Type.Legendary, 0);
        }


        o.getTooltip = function()
        {
            local result = this.armor.getTooltip();
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/health.png",
                text = "Heals [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] of the hitpoints of the wearer each turn"
            });
            return result;
        }

        o.onTurnStart = function()
        {
            local actor = this.getContainer().getActor();
            local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
            local healthAdded = this.Math.min(healthMissing, actor.getHitpointsMax() * 0.2);

            if (healthAdded <= 0)
            {
                return;
            }

            actor.setHitpoints(actor.getHitpoints() + healthAdded);
            actor.setDirty(true);

            if (!actor.isHiddenToPlayer())
            {
                this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
                this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
            }
        }

    });


});

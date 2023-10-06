local gt = getroottable();

::mods_registerMod("el_ballance_skills_actives", 1, "el_ballance_skills_actives");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("skills/actives/slash_lightning", function(o){

        o.getTooltip = function()
        {
            local ret = this.getDefaultTooltip();
            ret.extend([
                {
                    id = 6,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Inflicts an additional [color=" + this.Const.UI.Color.DamageValue + "]5%[/color] targets current hitpoints + [color=" + this.Const.UI.Color.DamageValue + "]20[/color] damage that ignores armor. The lightning won't hit the same target and will pass on until no targets left."
                },
                {
                    id = 7,
                    type = "text",
                    icon = "ui/icons/hitchance.png",
                    text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to hit"
                }
            ]);
            return ret;
        }

        o.applyEffect = function( _data, _delay )
        {
            this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay, function ( _data )
            {
                for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
                {
                    this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, _data.TargetTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
                }
            }, _data);

            if (_data.Target == null)
            {
                return;
            }

            this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay + 200, function ( _data )
            {
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.Math.ceil(_data.Target.getHitpoints() * 0.05) + 20;
                hitInfo.DamageDirect = 1.0;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.BodyDamageMult = 1.0;
                hitInfo.FatalityChanceMult = 0.0;
                _data.Target.onDamageReceived(_data.User, _data.Skill, hitInfo);
            }, _data);
        }

        o.onUse = function( _user, _targetTile )
        {
            this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
            local success = this.attackEntity(_user, _targetTile.getEntity());
            local myTile = _user.getTile();
            if (success && _user.isAlive())
            {
                local selectedTargets = [];
                local potentialTargets = [];
                local potentialTiles = [];
                local target;
                local have_next_target = true;
                local delay_time = 100;
                local targetTile = _targetTile;

                if (this.m.SoundOnLightning.len() != 0)
                {
                    this.Sound.play(this.m.SoundOnLightning[this.Math.rand(0, this.m.SoundOnLightning.len() - 1)], this.Const.Sound.Volume.Skill * 2.0, _user.getPos());
                }

                if (!targetTile.IsEmpty && targetTile.getEntity().isAlive())
                {
                    target = targetTile.getEntity();
                    selectedTargets.push(target.getID());
                }
                else {
                    target = null;
                }

                while(have_next_target) {

                    local data = {
                        Skill = this,
                        User = _user,
                        TargetTile = targetTile,
                        Target = target
                    };
                    this.applyEffect(data, delay_time);
                    delay_time += 50;
                    potentialTargets = [];
                    potentialTiles = [];
                    for( local i = 0; i < 6; i = ++i )
                    {
                        if (targetTile.hasNextTile(i))
                        {
                            local tile = targetTile.getNextTile(i);
                            if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && !tile.getEntity().isAlliedWith(_user) && selectedTargets.find(tile.getEntity().getID()) == null)
                            {
                                potentialTargets.push(tile);
                            }
                        }
                    }
                    if (potentialTargets.len() != 0)
                    {
                        target = potentialTargets[this.Math.rand(0, potentialTargets.len() - 1)].getEntity();
                        selectedTargets.push(target.getID());
                        targetTile = target.getTile();
                    }
                    else
                    {
                        have_next_target = false;
                    }
                }
            }
            return success;
        }


	});

	::mods_hookNewObject("skills/actives/legend_staff_lunge_skill", function(o){

        function onAnySkillUsed( _skill, _targetEntity, _properties )
        {
            if (_skill == this)
            {
                local actor = this.getContainer().getActor();
                _properties.DamageTotalMult *= this.Math.max(1 + actor.getInitiative() * 0.005, 0);

                if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
                {
                    _properties.MeleeSkill += 5;
                }
            }
        }
	});

	::mods_hookNewObject("skills/actives/lunge_skill", function(o){

        function onAnySkillUsed( _skill, _targetEntity, _properties )
        {
            if (_skill == this)
            {
                local actor = this.getContainer().getActor();
                _properties.DamageTotalMult *= this.Math.max(1 + actor.getInitiative() * 0.005, 0);

                if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
                {
                    _properties.MeleeSkill += 5;
                }
            }
        }



	});

});

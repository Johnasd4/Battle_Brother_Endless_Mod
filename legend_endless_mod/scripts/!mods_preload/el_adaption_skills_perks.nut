local gt = getroottable();

::mods_registerMod("el_adaption_skills_perks", 1, "el_adaption_skills_perks");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("skills/perks/legend_vala_warden", function(o){

        o.summonWarden = function()
        {
            if (this.m.WardenSummonSpent == false && this.m.WardenEntity == null)
            {
                local WardenSpawnTile = this.findTileToSpawnWarden();

                if (WardenSpawnTile != null)
                {
                    local actor = this.getContainer().getActor();
                    local entity = this.Const.World.Common.EL_addEntityByScript("scripts/entity/tactical/legend_vala_warden_script", WardenSpawnTile, this.Const.Faction.PlayerAnimals, 0, actor.EL_getLevel());
                    entity.setName(actor.m.Name + "\'s Warden");
                    entity.setVala(this);
                    entity.setWardenStats(this.getContainer().getActor().getBravery());
                    this.m.WardenSummonSpent = true;
                    this.m.WardenEntity = entity;

                    if (this.getContainer().getActor().getSkills().hasSkill("perk.legend_vala_spiritual_bond"))
                    {
                        if (!this.getContainer().getActor().getSkills().hasSkill("effects.legend_vala_spiritual_bond_effect"))
                        {
                            local bond = this.new("scripts/skills/effects/legend_vala_spiritual_bond_effect");
                            bond.setVala(this);
                            this.getContainer().getActor().getSkills().add(bond);
                        }

                        local WardenScaling = this.new("scripts/skills/effects/legend_vala_warden_damage");
                        WardenScaling.setDamageBonus(this.getContainer().getActor().getBravery());
                        this.m.WardenEntity.getSkills().add(WardenScaling);
                    }

                    local effect = {
                        Delay = 0,
                        Quantity = 12,
                        LifeTimeQuantity = 12,
                        SpawnRate = 100,
                        Brushes = [
                            "bust_ghost_01"
                        ],
                        Stages = [
                            {
                                LifeTimeMin = 1.0,
                                LifeTimeMax = 1.0,
                                ColorMin = this.createColor("ffffff5f"),
                                ColorMax = this.createColor("ffffff5f"),
                                ScaleMin = 1.0,
                                ScaleMax = 1.0,
                                RotationMin = 0,
                                RotationMax = 0,
                                VelocityMin = 80,
                                VelocityMax = 100,
                                DirectionMin = this.createVec(-1.0, -1.0),
                                DirectionMax = this.createVec(1.0, 1.0),
                                SpawnOffsetMin = this.createVec(-10, -10),
                                SpawnOffsetMax = this.createVec(10, 10),
                                ForceMin = this.createVec(0, 0),
                                ForceMax = this.createVec(0, 0)
                            },
                            {
                                LifeTimeMin = 1.0,
                                LifeTimeMax = 1.0,
                                ColorMin = this.createColor("ffffff2f"),
                                ColorMax = this.createColor("ffffff2f"),
                                ScaleMin = 0.9,
                                ScaleMax = 0.9,
                                RotationMin = 0,
                                RotationMax = 0,
                                VelocityMin = 80,
                                VelocityMax = 100,
                                DirectionMin = this.createVec(-1.0, -1.0),
                                DirectionMax = this.createVec(1.0, 1.0),
                                ForceMin = this.createVec(0, 0),
                                ForceMax = this.createVec(0, 0)
                            },
                            {
                                LifeTimeMin = 0.1,
                                LifeTimeMax = 0.1,
                                ColorMin = this.createColor("ffffff00"),
                                ColorMax = this.createColor("ffffff00"),
                                ScaleMin = 0.1,
                                ScaleMax = 0.1,
                                RotationMin = 0,
                                RotationMax = 0,
                                VelocityMin = 80,
                                VelocityMax = 100,
                                DirectionMin = this.createVec(-1.0, -1.0),
                                DirectionMax = this.createVec(1.0, 1.0),
                                ForceMin = this.createVec(0, 0),
                                ForceMax = this.createVec(0, 0)
                            }
                        ]
                    };
                    this.Tactical.spawnParticleEffect(false, effect.Brushes, this.m.WardenEntity.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
                    this.Sound.play("sounds/enemies/ghost_death_01.wav");
                }
            }
        }
	});

    local onApplyFire = gt.Const.Tactical.Common.onApplyFire;
    gt.Const.Tactical.Common.onApplyFire = function( _tile, _entity ) {
        if(_entity == null || _entity.isDying() || !_entity.isAlive()) {
            return;
        }
        onApplyFire(_tile, _entity);
    }

    local onApplyFirefield = gt.Const.Tactical.Common.onApplyFirefield;
    gt.Const.Tactical.Common.onApplyFirefield = function( _tile, _entity ) {
        if(_entity == null || _entity.isDying() || !_entity.isAlive()) {
            return;
        }
        onApplyFirefield(_tile, _entity);
    }

});

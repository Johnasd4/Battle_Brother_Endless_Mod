local gt = getroottable();

::mods_registerMod("el_adaption_items_accessory", 1, "el_adaption_items_accessory");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookExactClass("items/accessory/accessory_dog", function(o){

        function onActorDied( _onTile )
        {
            if (!this.isUnleashed() && _onTile != null)
            {
                local actor = this.getContainer().getActor();
                local entity = this.Const.World.Common.EL_addEntityByScript(this.getScript(), _onTile, this.Const.Faction.PlayerAnimals, this.EL_getRankLevel(), actor.EL_getLevel());
                entity.setItem(this);
                entity.setName(this.getName());
                entity.setVariant(this.getVariant());

                if (actor.getSkills().hasSkill("perk.legend_dogwhisperer"))
                {
                    entity.getSkills().add(this.new("scripts/skills/perks/perk_fortified_mind"));
                    entity.getSkills().add(this.new("scripts/skills/perks/perk_colossus"));
                    entity.getSkills().add(this.new("scripts/skills/perks/perk_underdog"));
                }

                this.setEntity(entity);

                if (this.m.ArmorScript != null)
                {
                    local item = this.new(this.m.ArmorScript);
                    entity.getItems().equip(item);
                }

                this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
            }
        }


    });

	::mods_hookExactClass("items/accessory/legend_catapult_item", function(o){

        function onActorDied( _onTile )
        {
            if (!this.isUnleashed() && _onTile != null)
            {
                local actor = this.getContainer().getActor();
                local entity = this.Const.World.Common.EL_addEntityByScript(this.getScript(), _onTile, this.Const.Faction.PlayerAnimals, this.EL_getRankLevel(), actor.EL_getLevel());
                entity.setItem(this);
                entity.setName(this.getName());
                entity.setVariant(this.getVariant());
                this.setEntity(entity);
                if (this.m.ArmorScript != null)
                {
                    local item = this.new(this.m.ArmorScript);
                    entity.getItems().equip(item);
                }

                this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
            }
        }


    });

	::mods_hookExactClass("items/accessory/legend_warbear_item", function(o){

        function onActorDied( _onTile )
        {
            if (!this.isUnleashed() && _onTile != null)
            {
                local actor = this.getContainer().getActor();
                local entity = this.Const.World.Common.EL_addEntityByScript(this.getScript(), _onTile, this.Const.Faction.PlayerAnimals, this.EL_getRankLevel(), actor.EL_getLevel());
                entity.setItem(this);
                entity.setName(this.getName());
                this.setEntity(entity);
                this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
            }
        }


    });


});

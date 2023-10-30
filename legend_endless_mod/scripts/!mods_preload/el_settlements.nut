local gt = getroottable();

::mods_registerMod("el_settlements", 1, "el_settlements");
::mods_queue(null, "el_world", function ()
{
    ::mods_hookExactClass("entity/world/settlement", function(o) {
        local onEnter = o.onEnter;
        o.onEnter = function()
        {
            foreach( item in this.World.Assets.getStash().getItems() )
            {
                if (item == null)
                {
                    continue;
                }

                if (item.isBought())
                {
                    if (item.isItemType(this.Const.Items.ItemType.TradeGood))
                    {
                        this.World.Statistics.getFlags().increment("TradeGoodsBought");

                        if (::Legends.Mod.ModSettings.getSetting("WorldEconomy").getValue())
                        {
                            this.setResources(this.getResources() + item.getResourceValue());
                        }
                    }
                }

                item.setBought(false);
            }

            foreach( bro in this.World.getPlayerRoster().getAll() )
            {
                foreach( item in bro.getItems().getAllItems() )
                {
                    item.setBought(false);
                }
            }

            return onEnter();
        }
    });

    ::mods_hookNewObject("entity/world/settlements/buildings/arena_building", function(o)
    {
        o.refreshCooldown = function()
        {
            this.m.CooldownUntil = 0;
        }
    });

    ::mods_hookNewObject("entity/world/settlements/buildings/port_building", function(o)
    {
		o.getCostTo = function( _to )
		{
			local myTile = this.getSettlement().getTile();
			local dist = _to.getTile().getDistanceTo(myTile);
			local cost = dist * this.World.getPlayerRoster().getSize() * (1 + 0.04 * this.World.Assets.m.EL_WorldLevel);
			cost = this.Math.round(cost);
			return cost;
		}
    });

	::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_temple_dialog_module", function(o) {

		o.queryRosterInformation = function()
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local roster = [];

			foreach( b in brothers )
			{
				local injuries = [];

				local allInjuries = b.getSkills().query(this.Const.SkillType.TemporaryInjury);
				for( local i = 0; i != allInjuries.len(); i = i )
				{
					local inj = allInjuries[i];

	//				if (!inj.isTreated() && inj.isTreatable())
					if (inj.isTreatable())
					{
						injuries.push({
							id = inj.getID(),
							icon = inj.getIconColored(),
							name = inj.getNameOnly(),
							price = this.Math.floor(inj.getPrice() * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * b.getLevel())),
						});
					}

					i = ++i;
				}

	//add SemiInjury
				local allInjuries = b.getSkills().query(this.Const.SkillType.SemiInjury);
				for( local i = 0; i != allInjuries.len(); i = i )
				{
					local inj = allInjuries[i];

					if (inj.isTreatable() || !inj.isTreatable())
					{
						injuries.push({
							id = inj.getID(),
							icon = inj.getIconColored(),
							name = inj.getNameOnly(),
							price = this.Math.floor(inj.getPrice() * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * b.getLevel())),
						});
					}

					i = ++i;
				}

	//add PermanentInjury
				local allInjuries = b.getSkills().query(this.Const.SkillType.PermanentInjury);
				for( local i = 0; i != allInjuries.len(); i = i )
				{
					local inj = allInjuries[i];
					if ( inj.getID() == "injury.missing_finger" || inj.getID() == "injury.missing_nose" || inj.getID() == "injury.missing_ear" )
					{
						injuries.push({
							id = inj.getID(),
							icon = inj.getIconColored(),
							name = inj.getNameOnly(),
							price = this.Math.floor(500 * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * b.getLevel()) * this.Const.EL_Player.EL_HealInjury.PermanentMult),
						});
					}
					else if ( inj.getID() == "injury.weakened_heart" || inj.getID() == "injury.traumatized" || inj.getID() == "injury.missing_hand" || inj.getID() == "injury.missing_eye" || inj.getID() == "injury.maimed_foot" || inj.getID() == "injury.collapsed_lung_part" || inj.getID() == "injury.broken_knee" || inj.getID() == "injury.broken_elbow_joint" || inj.getID() == "injury.brain_damage" )
					{
						injuries.push({
							id = inj.getID(),
							icon = inj.getIconColored(),
							name = inj.getNameOnly(),
							price = this.Math.floor(1000 * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * b.getLevel()) * this.Const.EL_Player.EL_HealInjury.PermanentMult),
						});
					}

					i = ++i;
				}
	//

				if (injuries.len() == 0) { continue; }

				local background = b.getBackground();
				local e = {
					ID = b.getID(),
					Name = b.getName(),
					ImagePath = b.getImagePath(),
					ImageOffsetX = b.getImageOffsetX(),
					ImageOffsetY = b.getImageOffsetY(),
					BackgroundImagePath = background.getIconColored(),
					BackgroundText = background.getDescription(),
					Injuries = injuries
				};
				roster.push(e);
			}

			return {
				Title = "Temple",
				SubTitle = "Remove Injuries", //Have your wounded treated and prayed for by priests
				Roster = roster,
				Assets = this.m.Parent.queryAssetsInformation()
			};
		}


	// Treat //
		o.onTreatInjury = function( _data )
		{
			local entityID = _data[0];
			local injuryID = _data[1];
			local entity = this.Tactical.getEntityByID(entityID);
			local injury = entity.getSkills().getSkillByID(injuryID);

	//		injury.setTreated(true);
	//		this.World.Assets.addMoney(-injury.getPrice());

			if ( _data[1] == "injury.missing_finger" || _data[1] == "injury.missing_nose" || _data[1] == "injury.missing_ear" )
			{ this.World.Assets.addMoney(-this.Math.floor(500 * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * entity.getLevel()) * this.Const.EL_Player.EL_HealInjury.PermanentMult)); }
			else if ( _data[1] == "injury.weakened_heart" || _data[1] == "injury.traumatized" || _data[1] == "injury.missing_hand" || _data[1] == "injury.missing_eye" || _data[1] == "injury.maimed_foot" || _data[1] == "injury.collapsed_lung_part" || _data[1] == "injury.broken_knee" || _data[1] == "injury.broken_elbow_joint" || _data[1] == "injury.brain_damage" )
			{ this.World.Assets.addMoney(-this.Math.floor(1000 * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * entity.getLevel()) * this.Const.EL_Player.EL_HealInjury.PermanentMult)); }
			else
			{ this.World.Assets.addMoney(-this.Math.floor(injury.getPrice() * (1 + this.Const.EL_Player.EL_HealInjury.LevelMult * entity.getLevel()))) }
	//removeSelf
			injury.removeSelf();
			entity.improveMood(0.15, "Removed an injury");
	//
			entity.updateInjuryVisuals();
			local injuries = [];

			local allInjuries = entity.getSkills().query(this.Const.SkillType.TemporaryInjury);
			foreach( inj in allInjuries )
			{
	//			if (!inj.isTreated())
				if (inj.isTreatable())
				{
					injuries.push({
						id = inj.getID(),
						icon = inj.getIconColored(),
						name = inj.getNameOnly(),
						price = inj.getPrice()
					});
				}
			}

	//add SemiInjury
			local allInjuries = entity.getSkills().query(this.Const.SkillType.SemiInjury);
			foreach( inj in allInjuries )
			{
				if (inj.isTreatable() || !inj.isTreatable())
				{
					injuries.push({
						id = inj.getID(),
						icon = inj.getIconColored(),
						name = inj.getNameOnly(),
						price = inj.getPrice()
					});
				}
			}

	//add PermanentInjury
			local allInjuries = entity.getSkills().query(this.Const.SkillType.PermanentInjury);
			foreach( inj in allInjuries )
			{
				if ( inj.getID() == "injury.missing_finger" || inj.getID() == "injury.missing_nose" || inj.getID() == "injury.missing_ear" )
				{
					injuries.push({
						id = inj.getID(),
						icon = inj.getIconColored(),
						name = inj.getNameOnly(),
						price = 500,
					});
				}
				else if ( inj.getID() == "injury.weakened_heart" || inj.getID() == "injury.traumatized" || inj.getID() == "injury.missing_hand" || inj.getID() == "injury.missing_eye" || inj.getID() == "injury.maimed_foot" || inj.getID() == "injury.collapsed_lung_part" || inj.getID() == "injury.broken_knee" || inj.getID() == "injury.broken_elbow_joint" || inj.getID() == "injury.brain_damage" )
				{
					injuries.push({
						id = inj.getID(),
						icon = inj.getIconColored(),
						name = inj.getNameOnly(),
						price = 1000,
					});
				}
			}
	//

			local background = entity.getBackground();
			local e = {
				ID = entity.getID(),
				Name = entity.getName(),
				ImagePath = entity.getImagePath(),
				ImageOffsetX = entity.getImageOffsetX(),
				ImageOffsetY = entity.getImageOffsetY(),
				BackgroundImagePath = background.getIconColored(),
				BackgroundText = background.getDescription(),
				Injuries = injuries
			};
			local r = {
				Entity = e,
				Assets = this.m.Parent.queryAssetsInformation()
			};
			this.World.Statistics.getFlags().increment("InjuriesTreatedAtTemple");
			this.updateAchievement("PatchedUp", 1, 1);
			return r;
		}
	});


});

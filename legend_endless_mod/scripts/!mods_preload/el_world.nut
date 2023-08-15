local gt = getroottable();

::mods_registerMod("el_world", 1, "el_world");
::mods_queue(null, ">endless_mod", function ()
{

	::mods_hookExactClass("states/world_state", function ( o )
	{
		local onInit = o.onInit;
		o.onInit = function() {
			onInit();
			this.World.Flags.set("EL_WorldChangeEvent", this.Const.EL_World.EL_WorldChangeEventDefaultOption);
			this.m.Events.m.Events.push(this.new("scripts/events/mods/special/el_world_change_event"));
		}
	});

	::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function ( o )
	{
		local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
		o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
		{
			local super_ret = general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
			local entity;
			if (_entityId != null)
			{
				entity = this.Tactical.getEntityByID(_entityId);
			}

			switch(_elementId)
			{
				case "assets.Brothers":
					local ret = [
						{
							id = 1,
							type = "title",
							text = "Roster (I, C)"
						},
						{
							id = 2,
							type = "description",
							text = "Show the roster of the fighting force of your mercenary company. Increase your Renown to increase the Roster Size!"
						}
					];
					local data = this.World.Assets.getRosterDescription();
					local id = 4;

					if (this.World.Assets.getOrigin().getRosterTier() < this.World.Assets.getOrigin().getRosterTierMax())
					{
						local nextRenown = 0;

						foreach( rep in this.World.Assets.getOrigin().getRosterReputationTiers() )
						{
							if (this.World.Assets.getBusinessReputation() < rep)
							{
								nextRenown = rep;
								break;
							}
						}

						ret.push({
							id = id,
							type = "description",
							text = "Next Roster Size increase at Renown: " + nextRenown
						});
						id = ++id;
						id = id;
					}
					else
					{
						ret.push({
							id = id,
							type = "description",
							text = "Maximum Roster Size achieved!"
						});
						id = ++id;
						id = id;
					}

					ret.push({
						id = id,
						type = "text",
						text = "Terrain Movement Modifiers:"
					});
					id = ++id;
					id = id;

					foreach( bro in data.TerrainModifiers )
					{
						ret.push({
							id = id,
							type = "text",
							text = bro[0] + " [color=" + this.Const.UI.Color.PositiveValue + "]" + bro[1] + "%[/color]"
						});
						id = ++id;
						id = id;
					}

					ret.push({
						id = id,
						type = "hint",
						text = "World Strength: " + this.World.Assets.m.EL_WorldStrength +
						       "\nWorld Level: " + this.World.Assets.m.EL_WorldLevel +
							   "\nWorld Difficulty: " + (this.Const.EL_World.EL_WorldChangeEventDifficultyMultFactor[this.World.Flags.get("EL_WorldChangeEvent")] * 100) + "%"
					});

					id = ++id;
					id = id;

					foreach( bro in data.Brothers )
					{
						ret.push({
							id = id,
							type = "hint",
							icon = bro.Mood,
							text = "Lv" + bro.Level + "(" + (this.Math.round(bro.EL_CombatLevel * 100) / 100) + ") " + bro.Name
						});
						id = ++id;
						id = id;
					}
					return ret;
			}

			return super_ret;
		}
	});

	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
		o.m.EL_BaseWorldLevel <- this.Const.EL_World.EL_WorldLevelMin;
		o.m.EL_WorldLevel <- this.Const.EL_World.EL_WorldLevelMin;
		o.m.EL_WorldLevelOffset <- 0;
		o.m.EL_WorldStrength <- this.Const.EL_World.EL_WorldStrengthMin;
		o.m.EL_CurrentUpdateDay <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize(_out);
			_out.writeI32(this.m.EL_BaseWorldLevel);
			_out.writeI32(this.m.EL_WorldLevel);
			_out.writeI32(this.m.EL_WorldLevelOffset);
			_out.writeI32(this.m.EL_WorldStrength);
			_out.writeI32(this.m.EL_CurrentUpdateDay);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);
			this.m.EL_BaseWorldLevel = _in.readI32();
			this.m.EL_WorldLevel = _in.readI32();
			this.m.EL_WorldLevelOffset = _in.readI32();
			this.m.EL_WorldStrength = _in.readI32();
			this.m.EL_CurrentUpdateDay = _in.readI32();
		}

		o.EL_UpdateWorldStrengthAndLevel <- function() {
			local day = this.World.getTime().Days;
			this.m.EL_CurrentUpdateDay = day;
			//Calculate world level.
			if(this.m.EL_BaseWorldLevel < this.Const.EL_World.EL_BaseWorldLevelStableLevel){
				if(day * this.Const.EL_World.EL_WorldStartMultFactor[this.getCombatDifficulty()] >
				   this.Const.EL_World.EL_BaseWorldLevelDay[this.m.EL_BaseWorldLevel]){
					this.m.EL_BaseWorldLevel += 1;
					this.logInfo("Day " + day + " : World Level max");
				}
			}
			else {
				if(day * this.Const.EL_World.EL_WorldStartMultFactor[this.getCombatDifficulty()] >
				   this.Const.EL_World.EL_BaseWorldLevelDay[this.Const.EL_World.EL_BaseWorldLevelStableLevel - 1] +
						 (this.m.EL_BaseWorldLevel - this.Const.EL_World.EL_BaseWorldLevelStableLevel) * this.Const.EL_World.EL_BaseWorldLevelStableGrowthMultFactor){
					this.m.EL_BaseWorldLevel += 1;
					this.logInfo("Day " + day + " : World Level max");
				}
			}
			this.m.EL_WorldLevel = this.m.EL_BaseWorldLevel + this.m.EL_WorldLevelOffset;
			if(this.m.EL_WorldLevel < this.Const.EL_World.EL_WorldLevelMin){
				this.m.EL_WorldLevel = this.Const.EL_World.EL_WorldLevelMin;
			}
			//Calculate world strength.
			local temp_world_strength = 0;
			if(day < this.Const.EL_World.EL_WorldStrengthAddSpeedChangeDay[this.Const.EL_World.EL_WorldStrengthAddSpeedChangeDay.len() - 1]){
				for(local count = 0; count < this.Const.EL_World.EL_WorldStrengthAddSpeedChangeDay.len() - 1; ++count) {
					if(day < this.Const.EL_World.EL_WorldStrengthAddSpeedChangeDay[count + 1]){
						temp_world_strength += (day - this.Const.EL_World.EL_WorldStrengthAddSpeedChangeDay[count]) *
											   this.Const.EL_World.EL_WorldStrengthAddSpeed[count] +
											   this.Const.EL_World.EL_WorldStrengthOffset[count];
						break;
					}
				}
			}
			else {
				temp_world_strength = (day - this.Const.EL_World.EL_WorldStrengthOffset[this.Const.EL_World.EL_WorldStrengthOffset.len() - 1]) *
									this.Const.EL_World.EL_WorldStrengthAddSpeed[this.Const.EL_World.EL_WorldStrengthAddSpeed.len() - 1];
			}

			local difficult_mult = 1;
			if(this.World.Flags.has("EL_WorldChangeEvent")) {
				difficult_mult *= this.Const.EL_World.EL_WorldChangeEventDifficultyMultFactor[this.World.Flags.get("EL_WorldChangeEvent")];
			}
			difficult_mult *= this.Const.EL_World.EL_WorldStartMultFactor[this.getCombatDifficulty()];

			temp_world_strength *= difficult_mult;

			if(temp_world_strength > this.Const.EL_World.EL_WorldStrengthMin){
				this.m.EL_WorldStrength = this.Math.floor(temp_world_strength);
			}
			else {
				this.m.EL_WorldStrength = this.Const.EL_World.EL_WorldStrengthMin;
			}
			this.logInfo("Day " + day + " : World Level " + this.m.EL_WorldLevel);
			this.logInfo("Day " + day + " : World Strength " + this.m.EL_WorldStrength);

			// if(day == 1){
			// 	this.World.Events.m.Events.push(this.new("scripts/mods/special/el_world_change_event"));
			// 	this.logInfo("push event");
			// }
		}

		o.getRosterDescription = function()
		{
			local ret = {
				TerrainModifiers = [],
				Brothers = []
			};

			for( local i = 0; i < 11; i = i )
			{
				ret.TerrainModifiers.push([
					"",
					0
				]);
				i = ++i;
			}

			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				local terrains = bro.getBackground().getModifiers().Terrain;
				ret.TerrainModifiers[0][0] = "Plains";
				ret.TerrainModifiers[0][1] += terrains[2] * 100.0;
				ret.TerrainModifiers[1][0] = "Swamp";
				ret.TerrainModifiers[1][1] += terrains[3] * 100.0;
				ret.TerrainModifiers[2][0] = "Hills";
				ret.TerrainModifiers[2][1] += terrains[4] * 100.0;
				ret.TerrainModifiers[3][0] = "Forests";
				ret.TerrainModifiers[3][1] += terrains[5] * 100.0;
				ret.TerrainModifiers[4][0] = "Mountains";
				ret.TerrainModifiers[4][1] += terrains[9] * 100.0;
				ret.TerrainModifiers[5][0] = "Farmland";
				ret.TerrainModifiers[5][1] += terrains[11] * 100.0;
				ret.TerrainModifiers[6][0] = "Snow";
				ret.TerrainModifiers[6][1] += terrains[12] * 100.0;
				ret.TerrainModifiers[7][0] = "Highlands";
				ret.TerrainModifiers[7][1] += terrains[14] * 100.0;
				ret.TerrainModifiers[8][0] = "Stepps";
				ret.TerrainModifiers[8][1] += terrains[15] * 100.0;
				ret.TerrainModifiers[9][0] = "Deserts";
				ret.TerrainModifiers[9][1] += terrains[17] * 100.0;
				ret.TerrainModifiers[10][0] = "Oases";
				ret.TerrainModifiers[10][1] += terrains[18] * 100.0;
				ret.Brothers.push({
					Name = bro.getName(),
					Mood = this.Const.MoodStateIcon[bro.getMoodState()],
					Level = bro.getLevel(),
					EL_CombatLevel = bro.EL_getCombatLevel(),
					Background = bro.getBackground().getNameOnly()
				});
			}

			local sortfn = function ( first, second )
			{
				if (first.Level == second.Level)
				{
					return 0;
				}

				if (first.Level > second.Level)
				{
					return -1;
				}

				return 1;
			};
			ret.Brothers.sort(sortfn);
			return ret;
		}

	});

	::mods_hookExactClass("entity/world/player_party", function ( o )
	{
		o.updateStrength = function ()
		{
			local day = this.World.getTime().Days;
			if(this.World.Assets.m.EL_CurrentUpdateDay != day) {
				this.World.Assets.EL_UpdateWorldStrengthAndLevel();
			}
			this.m.Strength = this.World.Assets.m.EL_WorldStrength;
		};
	});

});

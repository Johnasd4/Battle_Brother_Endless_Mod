local gt = getroottable();

::mods_registerMod("el_world_difficulty", 1, "el_world_difficulty");
::mods_queue(null, ">endless_mod", function ()
{
	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
		o.m.EL_WorldLevel <- gt.Const.EL_WorldDifficulty.EL_WorldLevelMin;
		o.m.EL_WorldStrength <- gt.Const.EL_WorldDifficulty.EL_WorldStrengthMin;
		o.m.EL_CurrentUpdateDay <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize(_out);
			_out.writeI32(this.m.EL_WorldLevel);
			_out.writeI32(this.m.EL_WorldStrength);
			_out.writeI32(this.m.EL_CurrentUpdateDay);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize(_in);
			this.m.EL_WorldLevel = _in.readI32();
			this.m.EL_WorldStrength = _in.readI32();
			this.m.EL_CurrentUpdateDay = _in.readI32();
		}
	});

	::mods_hookExactClass("entity/world/player_party", function ( o )
	{
		o.updateStrength = function ()
		{
			local day = this.World.getTime().Days;
			if(this.World.Assets.m.EL_CurrentUpdateDay != day) {
				this.World.Assets.m.EL_CurrentUpdateDay = day;
				//Calculate world level.
				if(this.World.Assets.m.EL_WorldLevel < this.Const.EL_WorldDifficulty.EL_WorldLevelStableLevel){
					if(day > this.Const.EL_WorldDifficulty.EL_WorldLevelDay[this.World.Assets.m.EL_WorldLevel]){
						this.World.Assets.m.EL_WorldLevel += 1;
						this.logInfo("Day " + day + " : World Level max");
					}
				}
				else {
					if(day > this.Const.EL_WorldDifficulty.EL_WorldLevelDay[this.Const.EL_WorldDifficulty.EL_WorldLevelStableLevel - 1] +
						     (this.World.Assets.m.EL_WorldLevel - this.Const.EL_WorldDifficulty.EL_WorldLevelStableLevel) * this.Const.EL_WorldDifficulty.EL_WorldLevelStableGrowthMultFactor){
						this.World.Assets.m.EL_WorldLevel += 1;
						this.logInfo("Day " + day + " : World Level max");
					}
				}

				//Calculate world strength.
				local temp_world_strength = 0;
				if(day < gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay[gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay.len() - 1]){
					for(local count = 0; count < gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay.len() - 1; ++count) {
						if(day < gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay[count + 1]){
							temp_world_strength += (day - gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeedChangeDay[count]) *
												   gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeed[count] +
												   gt.Const.EL_WorldDifficulty.EL_WorldStrengthOffset[count];
							break;
						}
					}
				}
				else {
					temp_world_strength = (day - gt.Const.EL_WorldDifficulty.EL_WorldStrengthOffset[gt.Const.EL_WorldDifficulty.EL_WorldStrengthOffset.len() - 1]) *
										gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeed[gt.Const.EL_WorldDifficulty.EL_WorldStrengthAddSpeed.len() - 1];
				}

				local difficult_mult = 1;
				if(this.World.Flags.has("EL_WorldDifficultyEvent")) {
					difficult_mult *= gt.Const.EL_WorldDifficulty.EL_WorldDifficultyEventMultFactor[this.World.Flags.get("EL_WorldDifficultyEvent")];
				}
				if (this.World.Assets.getCombatDifficulty() == gt.Const.Difficulty.Easy)
				{
					difficult_mult *= gt.Const.EL_WorldDifficulty.EL_WorldDifficultyStartMultFactor[0];
				}
				else if (this.World.Assets.getCombatDifficulty() == gt.Const.Difficulty.Normal)
				{
					difficult_mult *= gt.Const.EL_WorldDifficulty.EL_WorldDifficultyStartMultFactor[1];
				}
				else if (this.World.Assets.getCombatDifficulty() == gt.Const.Difficulty.Hard)
				{
					difficult_mult *= gt.Const.EL_WorldDifficulty.EL_WorldDifficultyStartMultFactor[2];
				}
				else if (this.World.Assets.getCombatDifficulty() == gt.Const.Difficulty.Legendary)
				{
					difficult_mult *= gt.Const.EL_WorldDifficulty.EL_WorldDifficultyStartMultFactor[3];
				}

				temp_world_strength *= difficult_mult;

				if(temp_world_strength > gt.Const.EL_WorldDifficulty.EL_WorldStrengthMin){
					this.World.Assets.m.EL_WorldStrength = this.Math.floor(temp_world_strength);
				}
				else {
					this.World.Assets.m.EL_WorldStrength = gt.Const.EL_WorldDifficulty.EL_WorldStrengthMin;
				}
				this.logInfo("Day " + day + " : World Level " + this.World.Assets.m.EL_WorldLevel);
				this.logInfo("Day " + day + " : World Strength " + this.World.Assets.m.EL_WorldStrength);

				//Test levelXP
				// for(local level = 0; level < this.Const.LevelXP.len(); ++level){
				// 	this.logInfo("LV" + level + " : " + this.Const.LevelXP[level]);
				// }

			}
			this.m.Strength = this.World.Assets.m.EL_WorldStrength;
		};
	});

});

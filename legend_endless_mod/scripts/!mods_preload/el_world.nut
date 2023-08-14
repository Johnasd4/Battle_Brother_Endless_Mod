local gt = getroottable();

::mods_registerMod("el_world", 1, "el_world");
::mods_queue(null, ">endless_mod", function ()
{
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

		o.EL_RenewWorldStrengthAndLevel <- function() {
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
			this.m.EL_WorldLevel = this.m.EL_BaseWorldLevel + this.m.EL_BaseWorldLevelOffset;
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
		}
	});

	::mods_hookExactClass("entity/world/player_party", function ( o )
	{
		o.updateStrength = function ()
		{
			local day = this.World.getTime().Days;
			if(this.World.Assets.m.EL_CurrentUpdateDay != day) {
				this.World.Assets.EL_RenewWorldStrengthAndLevel();
			}
			this.m.Strength = this.World.Assets.m.EL_WorldStrength;
		};
	});

});

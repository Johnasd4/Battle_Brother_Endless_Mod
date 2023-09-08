local gt = getroottable();

::mods_registerMod("el_world", 1, "el_world");
::mods_queue(null, "endless_mod", function ()
{

	::mods_hookExactClass("states/world_state", function ( o )
	{
		local onInit = o.onInit;
		o.onInit = function() {
			onInit();
			this.m.Events.m.Events.push(this.new("scripts/events/mods/el_world/el_world_change_event"));
		}
	});

	::mods_hookNewObjectOnce("states/world/asset_manager", function ( o )
	{
		o.m.EL_BaseWorldLevel <- this.Const.EL_World.EL_WorldLevel.Min;
		o.m.EL_WorldLevel <- this.Const.EL_World.EL_WorldLevel.Min;
		o.m.EL_WorldLevelOffset <- 0;
		o.m.EL_WorldStrength <- this.Const.EL_World.EL_WorldStrength.Min;
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
			if(!this.World.Flags.has("EL_WorldChangeEvent")) {
				this.World.Flags.set("EL_WorldChangeEvent", this.Const.EL_World.EL_WorldChangeEvent.DefaultOption);
			}
			//Calculate world level.
			if(this.m.EL_BaseWorldLevel < this.Const.EL_World.EL_WorldLevel.BaseStableLevel){
				if(day * this.Const.EL_World.EL_WorldStartMult[this.getCombatDifficulty()] >
				    	this.Const.EL_World.EL_WorldLevel.Table[this.m.EL_BaseWorldLevel]){
					this.m.EL_BaseWorldLevel += 1;
				}
			}
			else {
				if(day * this.Const.EL_World.EL_WorldStartMult[this.getCombatDifficulty()] >
						this.Const.EL_World.EL_WorldLevel.Table[this.Const.EL_World.EL_WorldLevel.BaseStableLevel - 1] +
						(this.m.EL_BaseWorldLevel - this.Const.EL_World.EL_WorldLevel.BaseStableLevel) * this.Const.EL_World.EL_WorldLevel.BaseStableMult){
					this.m.EL_BaseWorldLevel += 1;
				}
			}
			this.m.EL_WorldLevel = this.m.EL_BaseWorldLevel + this.m.EL_WorldLevelOffset;
			if(this.m.EL_WorldLevel < this.Const.EL_World.EL_WorldLevel.Min){
				this.m.EL_WorldLevel = this.Const.EL_World.EL_WorldLevel.Min;
			}
			//Calculate world strength.
			local temp_world_strength = this.Const.EL_World.EL_WorldStrength.getWorldStrength(day);
			local difficult_mult = this.Const.EL_World.EL_WorldChangeEvent.DifficultyMult[this.World.Flags.get("EL_WorldChangeEvent")] *
								   this.Const.EL_World.EL_WorldStartMult[this.getCombatDifficulty()];
			temp_world_strength *= difficult_mult;

			if(temp_world_strength > this.Const.EL_World.EL_WorldStrength.Min){
				this.m.EL_WorldStrength = this.Math.floor(temp_world_strength);
			}
			else {
				this.m.EL_WorldStrength = this.Const.EL_World.EL_WorldStrength.Min;
			}
			this.logInfo("Day " + day + " : World Level " + this.m.EL_WorldLevel);
			this.logInfo("Day " + day + " : World Strength " + this.m.EL_WorldStrength);
		}


		local update = o.update;
		o.update = function( _worldState )
		{
			if(this.m.EL_CurrentUpdateDay < this.World.getTime().Days) {
				this.EL_UpdateWorldStrengthAndLevel();
			}
			update(_worldState);
		}


	});

	::mods_hookExactClass("entity/world/player_party", function ( o )
	{
		o.updateStrength = function ()
		{
			// local day = this.World.getTime().Days;
			// if(this.World.Assets.m.EL_CurrentUpdateDay != day) {
			// 	this.World.Assets.EL_UpdateWorldStrengthAndLevel();
			// }
			this.m.Strength = this.World.Assets.m.EL_WorldStrength;
		};
	});

});
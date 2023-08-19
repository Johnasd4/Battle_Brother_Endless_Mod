local gt = getroottable();

::mods_registerMod("el_player_npc", 1, "el_player_npc");
::mods_queue(null, ">el_world", function ()
{

	::mods_hookExactClass("entity/tactical/actor", function(o){

		o.m.EL_RankLevel <- 0;

		local onSerialize = o.onSerialize;
		o.onSerialize = function ( _out )
		{
			onSerialize( _out );
			_out.writeI32(this.m.EL_RankLevel);
			//this.logInfo("this.EL_RankLevel : " + this.m.EL_RankLevel);
		}
		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function ( _in )
		{
			onDeserialize( _in );
			this.m.EL_RankLevel = _in.readI32();
			//this.logInfo("this.EL_RankLevel : " + this.m.EL_RankLevel);
		}


		local onTurnStart = o.onTurnStart;
		o.onTurnStart = function(){
			onTurnStart();
			if (!this.isAlive())
			{
				return;
			}
			this.logInfo("this.m.Fatigue 1: " + this.m.Fatigue);
			this.m.Fatigue -= this.Math.floor(this.m.CurrentProperties.Stamina / this.Const.EL_PlayerNPC.EL_ExtraFatigueRecovery.DivFactor + this.Const.EL_PlayerNPC.EL_ExtraFatigueRecovery.Offset);
			if(this.m.Fatigue < 0) {
				this.m.Fatigue = 0;
			}
			if(this.m.Fatigue > this.getFatigueMax()) {
				this.m.Fatigue = this.getFatigueMax();
			}
			this.logInfo("this.m.Fatigue 2: " + this.m.Fatigue);
			return;
		}

		o.EL_getRankLevel <- function ()
		{
			return this.m.EL_RankLevel;
		}
		o.EL_setRankLevel <- function (_EL_RankLevel)
		{
			this.m.EL_RankLevel = _EL_RankLevel;
		}
		o.EL_getCombatLevel <- function ()
		{
			return this.m.CurrentProperties.EL_CombatLevel;
		}

		local checkMorale = o.checkMorale;
		o.checkMorale = function(_change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false)
		{
			if (this.isAlive() && !this.isDying())
			{
				if (_change < 0)
				{
					if (this.m.MoraleState <= this.Const.EL_PlayerNPC.EL_RankToMoraleMin[this.m.EL_RankLevel])
					{
						return false;
					}
				}
			}
			return checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
		}

	});

});

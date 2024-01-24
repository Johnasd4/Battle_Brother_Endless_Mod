local gt = getroottable();

::mods_registerMod("el_retinue_follower", 1, "el_retinue_follower");
::mods_queue(null, "el_player_npc", function ()
{
	::mods_hookExactClass("retinue/followers/agent_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "Reveals available contracts and active situations in the tooltip of settlements no matter where you are",
                "合同刷新速度提高 100%"
            ];
		}
	});

	::mods_hookExactClass("retinue/followers/blacksmith_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "Repairs all armor, helmets, weapons and shields worn by your men even if they\'re broken or lost because your man died",
                "Increases repair speed by 100%"
            ];
		}

		local onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
            this.follower.onUpdate();

            if ("RepairSpeedMult" in this.World.Assets.m)
            {
                this.World.Assets.m.RepairSpeedMult *= 2.0;
            }

            if ("IsBlacksmithed" in this.World.Assets.m)
            {
                this.World.Assets.m.IsBlacksmithed = true;
            }
		}
	});

	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "显著提升遇到首领的机会",
                "为每个击杀的首领支付大量的克朗"
            ];
		}

		local onUpdate = o.onUpdate;
        o.onUpdate = function()
        {
        }

        local onUpdate = o.onUpdate;
        o.onChampionKilled = function( _champion )
        {
            local base_reward = 0;
            if(_champion.EL_getRankLevel() == 2) {
                base_reward = 5000;
            }
            if (this.Tactical.State.getStrategicProperties() == null || !this.Tactical.State.getStrategicProperties().IsArenaMode)
            {
                this.World.Assets.addMoney(this.Math.floor(base_reward * (1 + 0.08 * _champion.El_getLevel()) * this.World.Assets.EL_getHalfWorldDifficultFactor()));
            }
        }

	});

});

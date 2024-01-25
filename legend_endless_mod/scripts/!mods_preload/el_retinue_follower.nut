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

	::mods_hookExactClass("retinue/followers/brigand_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "让你能看到所有视野之外的商队"
            ];
		}
	});

	::mods_hookExactClass("retinue/followers/cartographer_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "为每个发现的地点奖励适量的克朗。 The further away from civilization, the more you\'re paid. Legendary locations pay double."
            ];
		}

		local onLocationDiscovered = o.onLocationDiscovered;
		o.onLocationDiscovered = function(_location)
		{
            local settlements = this.World.EntityManager.getSettlements();
            local dist = 9999;

            foreach( s in settlements )
            {
                local d = s.getTile().getDistanceTo(_location.getTile());

                if (d < dist)
                {
                    dist = d;
                }
            }

            local reward = this.Math.min(500, this.Math.max(200, 10 * dist));

            if (_location.isLocationType(this.Const.World.LocationType.Unique))
            {
                reward = reward * 2;
            }
            reward = this.Math.floor(reward * (1 + 0.08 * this.World.Assets.m.EL_WorldLevel) * this.World.Assets.EL_getHalfWorldDifficultFactor())
            this.World.Assets.addMoney(reward);
		}
	});

	::mods_hookExactClass("retinue/followers/drill_sergeant_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "低于世界等级的单位会获得更多的经验补偿",
                "高于世界等级的单位会受到更少的经验惩罚"
            ];
		}

		local onLocationDiscovered = o.onLocationDiscovered;
		o.onLocationDiscovered = function(_location)
		{
            local settlements = this.World.EntityManager.getSettlements();
            local dist = 9999;

            foreach( s in settlements )
            {
                local d = s.getTile().getDistanceTo(_location.getTile());

                if (d < dist)
                {
                    dist = d;
                }
            }

            local reward = this.Math.min(500, this.Math.max(200, 10 * dist));

            if (_location.isLocationType(this.Const.World.LocationType.Unique))
            {
                reward = reward * 2;
            }
            reward = this.Math.floor(reward * (1 + 0.08 * this.World.Assets.m.EL_WorldLevel) * this.World.Assets.EL_getHalfWorldDifficultFactor())
            this.World.Assets.addMoney(reward);
		}
	});

	::mods_hookExactClass("retinue/followers/lookout_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "Increases your sight radius by 100%",
                "Reveals extended information about footprints"
            ];
		}

		local onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
            if ("VisionRadiusMult" in this.World.Assets.m)
            {
                this.World.Assets.m.VisionRadiusMult *= 2.0;
            }

            if ("IsShowingExtendedFootprints" in this.World.Assets.m)
            {
                this.World.Assets.m.IsShowingExtendedFootprints = true;
            }
		}
	});

	::mods_hookExactClass("retinue/followers/minstrel_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "Makes you earn 50% more renown with every action",
                "Makes tavern rumors more likely to contain useful information"
            ];
		}

		local onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
            if ("BusinessReputationRate" in this.World.Assets.m)
            {
                this.World.Assets.m.BusinessReputationRate *= 1.5;
            }

            if ("IsNonFlavorRumorsOnly" in this.World.Assets.m)
            {
                this.World.Assets.m.IsNonFlavorRumorsOnly = true;
            }
		}
	});

	::mods_hookExactClass("retinue/followers/negotiator_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "Allows for more rounds of contract negotiations and greater payment with your potential employers before they abort, and with only a 10% chance on a hit to relations. Bad relations recover faster",
                "合同收入提高 50%"
            ];
		}

		local onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
            if ("BusinessReputationRate" in this.World.Assets.m)
            {
                this.World.Assets.m.BusinessReputationRate *= 1.5;
            }

            if ("IsNonFlavorRumorsOnly" in this.World.Assets.m)
            {
                this.World.Assets.m.IsNonFlavorRumorsOnly = true;
            }
		}
	});

	::mods_hookExactClass("retinue/followers/quartermaster_follower", function( o )
	{
		local create = o.create;
		o.create = function()
		{
            create();
            this.m.Effects = [
                "仓库容量、工具上限、弹药上限与医疗用品上限提升"
            ];
		}

		local onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
            if ("AmmoMaxAdditional" in this.World.Assets.m)
            {
                this.World.Assets.m.AmmoMaxAdditional = this.Math.floor(100 * (1 + 1.01 * this.World.Assets.m.EL_WorldLevel));
            }

            if ("MedicineMaxAdditional" in this.World.Assets.m)
            {
                this.World.Assets.m.MedicineMaxAdditional = this.Math.floor(100 * (1 + 1.01 * this.World.Assets.m.EL_WorldLevel));
            }

            if ("ArmorPartsMaxAdditional" in this.World.Assets.m)
            {
                this.World.Assets.m.ArmorPartsMaxAdditional = this.Math.floor(100 * (1 + 1.01 * this.World.Assets.m.EL_WorldLevel));
            }
		}
	});



});

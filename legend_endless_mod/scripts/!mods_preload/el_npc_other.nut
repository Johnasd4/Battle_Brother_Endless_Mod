local gt = getroottable();

::mods_registerMod("EL_NPCOther", 1, "EL_NPCOther");
::mods_queue(null, "el_npc", function ()
{
	::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function ( o )
	{
		o.onUpdate = function ()
		{
			this.World.Assets.m.ChampionChanceAdditional += 3;
		};
	});

	for(local i = 0; i < this.Const.EL_NPCOther.EL_BossLocation.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPCOther.EL_BossLocation[i], function ( o )
		{
			local create = o.create;
			o.create = function ()
			{
				create();
				this.m.EL_IsBossParty = true;
			};
		});
	}

	for(local i = 0; i < this.Const.EL_NPCOther.EL_getNameFunctionReplace.len(); ++i) {

		::mods_hookExactClass(this.Const.EL_NPCOther.EL_getNameFunctionReplace[i], function ( o )
		{
			o.getName = function ()
			{
				return this.actor.getName();
			};
		});
	}

	::mods_hookExactClass("entity/tactical/enemies/direwolf_high", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.Name = "Frenzied Direwolf";
		};
	});

	::mods_hookExactClass("entity/tactical/enemies/hyena_high", function ( o )
	{
		local create = o.create;
		o.create = function ()
		{
			create();
			this.m.Name = "Frenzied Hyena";
		};
	});

	::mods_hookExactClass("skills/racial/ghost_racial", function ( o )
	{
		o.m.EL_CurrentHitpoints <- 0;
		o.m.EL_IfHit <- false;

		o.onAdded <- function()
		{
			local actor = this.getContainer().getActor();
			actor.setIsAbleToDie(false);
		}

		.onDamageReceived <- function( _attacker, _damageHitpoints, _damageArmor )
		{
			local actor = this.getContainer().getActor();
			if(this.m.EL_IfHit == true) {
				--this.m.EL_CurrentHitpoints;
			}
			else {
				this.m.EL_CurrentHitpoints = actor.getHitpoints() - 1;
				this.m.EL_IfHit = true;
			}
			if(this.m.EL_CurrentHitpoints <= 0) {
				actor.setIsAbleToDie(true);
			}

		}

		o.onUpdate <- function( _properties )
		{
			if(this.m.EL_IfHit == true) {
				this.m.EL_IfHit = false;
				local actor = this.getContainer().getActor();
				actor.setHitpoints(this.m.EL_CurrentHitpoints);
			}
		}

	});


	::mods_hookExactClass("skills/actives/ghastly_touch", function ( o )
	{
		o.onUse = function( _user, _targetTile )
		{
			local ret = this.attackEntity(_user, _targetTile.getEntity());
			if(ret == true) {
				local target = _targetTile.getEntity();
				local difficulty = -_user.getBravery() +
								   this.Const.EL_NPCOther.EL_Ghost.GhastlyTouch.BaseOffset +
								   this.Const.EL_NPCOther.EL_Ghost.GhastlyTouch.RankFactor * (target.EL_getRankLevel() - _user.EL_getRankLevel()) +
								   this.Math.pow(this.Const.EL_Ghost.GhastlyTouch.Factor.CombatLevelFactor, this.Math.abs(target.EL_getCombatLevel() - _user.EL_getCombatLevel())) * (target.EL_getCombatLevel() - _user.EL_getCombatLevel());
				_targetTile.getEntity().checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
			}
			return ret;
		}
	});

	::mods_hookExactClass("skills/actives/horrific_scream", function ( o )
	{
		o.onUse = function( _user, _targetTile )
		{
			if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Horrific Scream");
			}
			local target = _targetTile.getEntity();
			local difficulty = -_user.getBravery() +
							   this.Const.EL_NPCOther.EL_Ghost.HrrificScream.BaseOffset +
							   this.Const.EL_NPCOther.EL_Ghost.HrrificScream.RankFactor * (target.EL_getRankLevel() - _user.EL_getRankLevel()) +
							   this.Math.pow(this.Const.EL_Ghost.HrrificScream.Factor.CombatLevelFactor, this.Math.abs(target.EL_getCombatLevel() - _user.EL_getCombatLevel())) * (target.EL_getCombatLevel() - _user.EL_getCombatLevel());
			_targetTile.getEntity().checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
			return true;
		}
	});

});

local gt = getroottable();

::mods_registerMod("el_skills_perks_ballance", 1, "el_skills_perks_ballance");
::mods_queue(null, "el_player_npc", function ()
{

	::mods_hookNewObject("skills/perks/perk_anticipation", function ( o )
	{

		o.getDescription = function()
		{
			return "By watching your opponent/\'s aim, you have more time to react.\n\nWhen being attacked with ranged weapons, gain [color=" + this.Const.UI.Color.PositiveValue + "]5 Ranged Defense[/color] as additional Ranged Defense per tile that the attacker is away, and always at least [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] to Ranged Defense.";
		}

		o.onBeingAttacked = function( _attacker, _skill, _properties )
		{
			local dist = _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile());
			_properties.RangedDefense += this.Math.max(10, this.Math.floor(dist * 5));
		}
	});

	::mods_hookNewObject("skills/perks/perk_battle_forged", function ( o )
	{

		o.getReductionPercentage = function()
		{
			local armor = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) + this.getContainer().getActor().getArmor(this.Const.BodyPart.Body);
			return this.Math.floor(100 - 100/(1 + armor * 0.05));
		}

	});

});

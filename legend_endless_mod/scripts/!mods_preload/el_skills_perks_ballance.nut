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

	::mods_hookNewObject("skills/perks/perk_colossus", function ( o )
	{

		o.getDescription = function()
		{
			return "Bring it on! Hitpoints are increased by [color=" + this.Const.UI.Color.PositiveValue + "]25[/color], which also reduces the chance to sustain debilitating injuries when being hit.";
		}


		o.onUpdate = function( _properties )
		{
			_properties.Hitpoints += 25;
		}

	});

	::mods_hookNewObject("skills/perks/perk_fortified_mind", function ( o )
	{

		o.getDescription <- function()
		{
			return "An iron will is not swayed from the true path easily. Resolve is increased by [color=" + this.Const.UI.Color.PositiveValue + "]15[/color].";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 15;
		}

	});

	::mods_hookNewObject("skills/perks/perk_horse_hippology", function ( o )
	{

		o.getDescription <- function()
		{
			return "Knowledge of horse physiology allows for better diet, exercise and care. Increases hitpoints by 25";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Hitpoints += 25;
		}

	});

	::mods_hookNewObject("skills/perks/perk_horse_impulsion", function ( o )
	{

		o.getDescription <- function()
		{
			return "Effective leverage of equestrian physiology relaxes the spinal column and allows the hindquarters to engage effectively. Increases Initiative by 30";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Initiative += 30;
		}

	});

	::mods_hookNewObject("skills/perks/perk_horse_leg_control", function ( o )
	{

		o.getDescription <- function()
		{
			return "it is not possible to hold the reins while firing a bow. Horse and rider must learn to communicate through the rider\'s legs. Increases ranged attack in battle by 25";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 25;
		}

	});

	::mods_hookNewObject("skills/perks/perk_horse_longeing", function ( o )
	{

		o.getDescription <- function()
		{
			return "Time spent working on a long rope helps build trust between horse and rider. Increases resolve by 15";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Bravery += 15;
		}

	});

	::mods_hookNewObject("skills/perks/perk_horse_tempi_change", function ( o )
	{

		o.getDescription <- function()
		{
			return "the most challenging form of lead change, a tempi change requires shifting back and forth between lead legs. This form of training can allow the horse to change lead leg according to the situation, useful when under fire. Increases ranged defense by 25";
		}

		o.onUpdate = function( _properties )
		{
			_properties.RangedSkill += 25;
		}

	});

	::mods_hookNewObject("skills/perks/perk_legend_alert", function ( o )
	{

		o.getDescription <- function()
		{
			return "Pay close attention at all times, surveying the surroundings and assessing every clue for an insight. Gain [color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Initiative.";
		}

		o.onUpdate = function( _properties )
		{
			_properties.Initiative += 30;
		}

	});

});

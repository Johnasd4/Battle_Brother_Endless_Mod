this.el_vampire_entry <- this.inherit("scripts/skills/el_entrys/el_weapon_entry", {
	m = {
        EL_VampireRateAddition = 0.0
    },
	function create()
	{
		this.el_weapon_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_Vampire.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Vampire rate + " + this.m.EL_VampireRateAddition + "%[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_VampireRateAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_Vampire.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_Vampire.RandomMinVampire[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_Vampire.RandomMaxVampire[this.getItem().m.EL_RankLevel];
		this.m.EL_VampireRateAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_Vampire.BaseVampire + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}
		local actor = this.m.Container.getActor();
		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}
        local vampire_number = this.Math.round(_damageInflictedHitpoints * this.m.EL_VampireRateAddition * 0.01);
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + vampire_number));
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_VampireRateAddition += this.m.EL_VampireRateAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_VampireRateAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_VampireRateAddition = _in.readF32();
	}
});
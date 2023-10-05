this.el_damage_mult_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_DamageMultAddition = 0.0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Weapon.EL_Entry.Factor.EL_DamageMult.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Attack damage + " + this.m.EL_DamageMultAddition + "%[/color]"
		};
		return result;
	}
	
	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_DamageMultAddition <= this.Const.EL_Weapon.EL_Entry.Factor.EL_DamageMult.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Weapon.EL_Entry.Factor.EL_DamageMult.RandomMinDamageMult[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Weapon.EL_Entry.Factor.EL_DamageMult.RandomMaxDamageMult[this.getItem().m.EL_RankLevel];
		this.m.EL_DamageMultAddition = this.Const.EL_Weapon.EL_Entry.Factor.EL_DamageMult.BaseDamageMult + this.Math.rand(randomMin, randomMax) * 0.01;
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.DamageTotalMult *= 1.0 + this.m.EL_DamageMultAddition * 0.01;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_DamageMultAddition += this.m.EL_DamageMultAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeF32(this.m.EL_DamageMultAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_DamageMultAddition = _in.readF32();
	}
});
this.el_engrgy_shield_entry <- this.inherit("scripts/skills/el_entrys/el_accessory_entry", {
	m = {
        EL_StackMax = 0,
        EL_Stack = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.ID;
		this.m.Icon = "ui/perks/omens_circle.png";
		this.m.IconMini = "mini_omens_circle";
		this.m.Overlay = "omens_circle";
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		if(this.m.EL_CurrentLevel != 1)
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Engrgy Shield: " + this.m.EL_Stack + "/" + this.Math.round(this.m.EL_CurrentLevel * this.m.EL_StackMax) + "(" + this.m.EL_StackMax + ")[/color]"
			};
		}
		else
		{
			return {
				id = _id,
				type = "text",
				text = "[color=" + colour + "]Engrgy Shield: " + this.m.EL_Stack + "/" + this.m.EL_StackMax + "[/color]"
			};
		}
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index <= this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_StackMax <= this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.RandomMinEngrgyShieldStack[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.RandomMaxEngrgyShieldStack[this.getItem().m.EL_RankLevel];
		this.m.EL_StackMax = this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.BaseEngrgyShieldStack + this.Math.rand(randomMin, randomMax);
	}

	function EL_strengthen()
	{
		this.m.EL_StackMax = this.Const.EL_Accessory.EL_Entry.EntryStrengthenMult * this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.ColourRange[this.Const.EL_Item.Type.Legendary];
	}

	function EL_onUpgradeRank()
	{
		if(EL_getEntryColour() != this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary])
		{
			this.m.EL_StackMax += this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.RandomMaxEngrgyShieldStack[this.Const.EL_Item.Type.Normal] / 2;
		}
	}

    function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
    {
        if(this.m.EL_Stack != 0) 
		{
            _properties.DamageReceivedTotalMult = 0;
            --this.m.EL_Stack;
        }
    }

	function onTurnStart()
	{
        this.m.EL_Stack += this.Math.max(1, this.Math.round(this.Math.round(this.m.EL_CurrentLevel * this.m.EL_StackMax) * this.Const.EL_Accessory.EL_Entry.Factor.EL_EngrgyShield.StackRecoverPersentPurTurn));
	}

	function onCombatStarted()
	{
        this.m.EL_Stack = 0;
	}

	function onCombatFinished()
	{
        this.m.EL_Stack = 0;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		++_EL_totalEntry.m.EL_EntryNum;
		_EL_totalEntry.m.EL_EngrgyShield += this.Math.round(this.m.EL_CurrentLevel * this.m.EL_StackMax);
	}

    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_StackMax);
	}

	function onDeserialize( _in )
	{
		this.m.EL_StackMax = _in.readI32();
	}
});


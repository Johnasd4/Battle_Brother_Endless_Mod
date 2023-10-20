this.el_proof_of_kingly_way_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.ID = "el_rarity_entry.proof_of_kingly_way";
		this.m.Name = "Proof of Kingly Way(Battle Standard)";
		this.m.Description = "Glory is still present, and the unity of all hearts shakes the enemy's courage.";//荣光尚在，万众一心震敌胆
		this.m.Icon = "el_entrys/el_proof_of_kingly_way_entry.png";
		//this.m.IconMini = "el_proof_of_kingly_way_entry_mini";
		this.m.Overlay = "el_proof_of_kingly_way_entry";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getTooltip()
	{
        local result = [
            {
				id = 1,
				type = "title",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Rare] + "]" + this.getName() + "[/color]"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]Increase the determination gain and reduction effect of the battle standard to " + this.Const.EL_Rarity_Entry.Factor.EL_ProofOfKinglyWay.BraveryMult * 100 + "%.[/color]"
			},
			{
				id = 4,
                type = "text",
                icon = "ui/icons/special.png",
				text = "[color=" + this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Special] + "]At the beginning of the turn, friendly morale within the range increases, while enemy morale decreases.[/color]"
			}
        ]
		if (!EL_isUsable())
		{
            result.push({
                id = 8,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]You need to equip Battle Standard to take effect.[/color]"
            });
        }
		return result;
	}

	function onTurnStart()
	{
        local actor = this.getContainer().getActor();
        local targets = this.Tactical.Entities.getAllInstances();
		local affect_distance = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).EL_getRange();
        foreach( tar in targets )
        {
            foreach( t in tar )
            {
                if(t != null && actor.getTile().getDistanceTo(t.getTile()) <= affect_distance) 
				{
					if(!t.isAlliedWith(actor))
					{
						if(t.getMoraleState() != this.Const.MoraleState.Ignore) {
							t.setMoraleState(this.Math.max(this.Const.MoraleState.Fleeing, t.getMoraleState() - 1));
						}
					}
					else
					{
						t.setMoraleState(this.Math.min(this.Const.MoraleState.Confident, t.getMoraleState() + 1));
					}
                }
            }
        }
	}

	function EL_isUsable()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && item.getID() == "weapon.player_banner")
		{
			return true;
		}
		return false;
	}
});


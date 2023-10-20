this.el_vehemence_of_the_sky_subsidiary_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {},
	function create()
	{
		this.m.ID = "el_rarity_entry.vehemence_of_the_sky_subsidiary";
	}

	function EL_onItemUpdate( _item )
	{
		local container = _item.getContainer();
		if(container == null)
		{
			for(local index = 0; index < _item.m.EL_EntryList.len(); ++index)
			{
				if(_item.m.EL_EntryList[index].getID() == "el_rarity_entry.vehemence_of_the_sky_subsidiary")
				{
					_item.m.EL_EntryList.remove(index);
					//this.logInfo("container NULL");
					return;
				}
			}
		}
		local actor = container.getActor();
		if(actor == null)
		{
			for(local index = 0; index < _item.m.EL_EntryList.len(); ++index)
			{
				if(_item.m.EL_EntryList[index].getID() == "el_rarity_entry.vehemence_of_the_sky_subsidiary")
				{
					_item.m.EL_EntryList.remove(index);
					//this.logInfo("actor NULL");
					return;
				}
			}
		}
		local skill = actor.getSkills().getSkillByID("el_rarity_entry.vehemence_of_the_sky");
		if(skill == null || !skill.EL_isUsable())
		{
			for(local index = 0; index < _item.m.EL_EntryList.len(); ++index)
			{
				if(_item.m.EL_EntryList[index].getID() == "el_rarity_entry.vehemence_of_the_sky_subsidiary")
				{
					_item.m.EL_EntryList.remove(index);
					//this.logInfo("ENTRY NULL");
					return;
				}
			}
		}
		
		local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local condition_max = 0; 
		if(helmet != null)
		{
			condition_max += helmet.getConditionMax();
		}
		if(armor != null)
		{
			condition_max += armor.getConditionMax();
		}
		//this.logInfo("condition_max" + condition_max);
        _item.m.RegularDamage += condition_max * this.Const.EL_Rarity_Entry.Factor.EL_VehemenceOfTheSky.ConvertArmorIntoDamagePercent;
		_item.m.RegularDamageMax += condition_max * this.Const.EL_Rarity_Entry.Factor.EL_VehemenceOfTheSky.ConvertArmorIntoDamagePercent;
	}
});
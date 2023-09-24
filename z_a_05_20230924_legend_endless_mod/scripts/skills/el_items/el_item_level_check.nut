this.el_item_level_check <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "items.level_check";
		this.m.Type = this.Const.SkillType.Item;
        this.m.Order = this.Const.SkillOrder.First;
	}

    function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function onUpdate( _properties )
	{
        local combatLevel = this.Math.floor(this.getContainer().getActor().EL_getCombatLevel());
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
        if (item != null)
        {
            if(combatLevel < item.m.EL_Level)
            { 
                item.EL_setCurrentLevel(combatLevel);
                //this.logInfo("角色ID：" + this.getContainer().getActor().getName());
                //this.logInfo("主手限制等级：" + combatLevel);
            }
        }
        item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
        if (item != null)
        {
            if(combatLevel < item.m.EL_Level)
            { 
                item.EL_setCurrentLevel(combatLevel);
                //this.logInfo("副手限制等级：" + combatLevel);
            }
        }
        item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        if (item != null)
        {
            if(combatLevel < item.m.EL_Level)
            { 
                item.EL_setCurrentLevel(combatLevel);
                //this.logInfo("护甲限制等级：" + combatLevel);
            }
        }
        item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
        if (item != null)
        {
            if(combatLevel < item.m.EL_Level)
            { 
                item.EL_setCurrentLevel(combatLevel);
                //this.logInfo("头盔限制等级：" + combatLevel);
            }
        }
        item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
        if (item != null)
        {
            if(combatLevel < item.m.EL_Level)
            { 
                item.EL_setCurrentLevel(combatLevel);
                //this.logInfo("饰品限制等级：" + combatLevel);
            }
        }
	}
});


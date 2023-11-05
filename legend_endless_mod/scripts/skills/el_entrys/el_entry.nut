this.el_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsSerialized = false;
		this.m.IsStacking = true;
	}

	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);

		this.EL_createAddition();
	}

	function EL_isEntryEffect()
	{
		return true;
	}

	function EL_createAddition()
	{
	}

	function EL_getEntryColour()
	{
	}

	function onSerialize( _out )
	{
	}

	function onDeserialize( _in )
	{
	}

	function onUpdate( _properties )
	{
	}

	function onAdded()
	{
		if(this.getContainer() != null && !("Skills" in this.getContainer()))
		{
			this.getContainer().add(this.new("scripts/skills/el_entrys/el_total_entry"));
		}
	}

	function EL_strengthen()
	{
	}

	function EL_onUpgradeRank()
	{
	}

	function EL_onNewDay( _item )
	{
	}

	function EL_onItemUpdate( _item )
	{
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
	}

	function getTooltip( _id )
	{
		return null;
	}
});
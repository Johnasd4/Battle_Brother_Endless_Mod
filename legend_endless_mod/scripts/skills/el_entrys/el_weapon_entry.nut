this.el_weapon_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsSerialized = false;
		this.m.IsStacking = false;
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
		if(this.getContainer().getActor().getFaction() == this.Const.Faction.Player)
		{
			this.m.Container.add(this.new("scripts/skills/el_entrys/el_total_entry"));
		}
	}

	function EL_onNewDay( _item )
	{
	}

	function EL_onItemUpdate( _item )
	{
	}

	function EL_refreshTotalEntry( __EL_totalEntry )
	{
	}

	function getTooltip( _id )
	{
	}
});
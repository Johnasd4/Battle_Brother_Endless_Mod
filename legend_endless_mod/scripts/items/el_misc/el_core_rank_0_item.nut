this.el_core_rank_0_item <- this.inherit("scripts/items/el_misc/el_core_item", {
	m = {},
	function create()
	{
		this.m.EL_RankLevel = 0;
		this.el_core_item.create();
	}

});


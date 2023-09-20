this.el_core_rank_1_item <- this.inherit("scripts/items/el_misc/el_core_item", {
	m = {},
	function create()
	{
		this.m.EL_RankLevel = 1;
		this.el_core_item.create();
	}

});


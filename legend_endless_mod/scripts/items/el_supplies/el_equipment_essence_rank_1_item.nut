this.el_equipment_essence_rank_1_item <- this.inherit("scripts/items/el_supplies/el_equipment_essence_item", {
	m = {},

	function create()
	{
		this.m.EL_RankLevel = 1;
		this.el_equipment_essence_item.create();
	}

});


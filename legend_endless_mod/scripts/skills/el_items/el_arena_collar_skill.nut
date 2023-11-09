this.el_arena_collar_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "el_items.arena_collar_skill";
		this.m.Name = "竞技场选手";
		this.m.Description = "被选中参加竞技场。";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.Icon = "el_skills/el_arena_collar_skill.png";
		this.m.Order = this.Const.SkillOrder.First;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		return ret;
	}

	function onNewDay()
	{
        this.getContainer().remove(this);
	}



});


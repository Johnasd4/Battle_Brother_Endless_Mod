this.el_npc_buff_stone_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "el_items.npc_buff_stone_skill";
		this.m.Name = "魔法石";
		this.m.Description = "通过魔法石获取力量。";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.Icon = "el_skills/el_npc_buff_stone.png";
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
		local skills = this.getContainer().getActor().getSkills().m.Skills;
		foreach(skill in skills) {
			if(skill.EL_isNPCBuff()) {
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/el_icons/magic_stone_rank_" + skill.EL_getRankLevel() + ".png",
					text = skill.getName()
				});
			}
		}
		return ret;
	}


});


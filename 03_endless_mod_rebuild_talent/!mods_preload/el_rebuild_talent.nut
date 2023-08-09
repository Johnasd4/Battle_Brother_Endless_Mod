local gt = getroottable();

::mods_registerMod("el_rebuild_talent", 1, "el_rebuild_talent");
::mods_queue(null, ">el_world_difficulty", function ()
{

	::mods_hookExactClass("entity/tactical/player", function(obj)
	{
		::mods_override(obj, "fillTalentValues", function ()
		{

			this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

			if (this.getBackground() != null && this.getBackground().isUntalented())
			{
				return;
			}

			for( local i = 0; i < this.Const.Attributes.COUNT; ++i )
			{
				if (this.m.Talents[i] == 0 && (this.getBackground() == null || this.getBackground().getExcludedTalents().find(i) == null))
				{
					local r = this.Math.rand(1, 100);

					if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[0])
					{
						this.m.Talents[i] = 0;
					}
					else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[1])
					{
						this.m.Talents[i] = 1;
					}
					else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[2])
					{
						this.m.Talents[i] = 2;
					}
					else
					{
						this.m.Talents[i] = 3;
					}

				}
			}
		});

	});

});

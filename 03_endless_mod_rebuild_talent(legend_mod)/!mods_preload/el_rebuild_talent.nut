local gt = getroottable();

::mods_registerMod("el_rebuild_talent", 1, "el_rebuild_talent");
::mods_queue(null, ">el_world_difficulty", function ()
{

	::mods_hookExactClass("entity/tactical/player", function(obj)
	{
		::mods_override(obj, "fillTalentValues", function ( _num, _force = false )
		{
			this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

			if (this.getBackground() != null && this.getBackground().isBackgroundType(this.Const.BackgroundType.Untalented) && !_force)
			{
				return;
			}

			local attributes = [];
			local weights = [];
			local totalWeight = 0;

			for( local i = 0; i < this.m.StarWeights.len(); i = i )
			{
				if (this.m.Talents[i] != 0)
				{
				}
				else if (this.getBackground() != null && this.getBackground().getExcludedTalents().find(i) != null)
				{
				}
				else
				{
					if (this.getFlags().has("PlayerZombie") && (i == this.Const.Attributes.Bravery || i == this.Const.Attributes.Fatigue || i == this.Const.Attributes.Initiative))
					{
						continue;
					}
					else if (this.getFlags().has("PlayerSkeleton") && (i == this.Const.Attributes.Bravery || i == this.Const.Attributes.Fatigue || i == this.Const.Attributes.Hitpoints))
					{
						continue;
					}

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

					attributes.push(i);
					weights.push(this.m.StarWeights[i]);
					totalWeight = totalWeight + this.m.StarWeights[i];
				}

				i = ++i;
			}

			for( local done = 0; done < _num; done = done )
			{
				local weight = this.Math.rand(1, totalWeight);
				local totalhere = 0;

				for( local i = 0; i < attributes.len(); i = i )
				{
					if (weight > totalhere && weight <= totalhere + weights[i])
					{
						local r = this.Math.rand(1, 100);
						local j = attributes[i];

						if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[1])
						{
							if(this.m.Talents[j] < 1){
								this.m.Talents[j] = 1;
							}
						}
						else if (r <= this.Const.EL_RebuildTalent.EL_TalentChance[2])
						{
							if(this.m.Talents[j] < 2){
								this.m.Talents[j] = 2;
							}
						}
						else
						{
							if(this.m.Talents[j] < 3){
								this.m.Talents[j] = 3;
							}
						}

						attributes.remove(i);
						totalWeight = totalWeight - weights[i];
						weights.remove(i);
						break;
					}
					else
					{
						totalhere = totalhere + weights[i];
					}

					i = ++i;
				}

				done = ++done;
			}

		});

	});

});

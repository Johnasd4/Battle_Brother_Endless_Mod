local gt = this.getroottable();

if (!("EL_Config" in gt.Const))
{
	gt.Const.EL_Config <- {};
}

gt.Const.EL_Config <- {

    EL_Attributes = {
        Hitpoints = 0,
        Bravery = 1,
        Fatigue = 2,
        Initiative = 3,
        MeleeSkill = 4,
        RangedSkill = 5,
        MeleeDefense = 6,
        RangedDefense = 7,
        COUNT = 8
    },

    EL_PerkTreeType = {
        Style = 0,
        Perfession = 1,
        Special = 2,
        Class = 3,
        Defense = 4,
        enemy = 5,
        magic = 6,
        Traits = 7,
        Weapon = 8,
        Count = 9
    },

    function EL_addInjurysToActor_P(_EL_actor, _EL_num, _EL_injuryTypeList, _EL_injuryThresholdMin = 0, _EL_injuryThresholdMax = 1) {
        local usable_injurys = [];
        foreach(injury_type in _EL_injuryTypeList) {
            foreach(injury in injury_type) {
                if(injury.Threshold >= _EL_injuryThresholdMin &&  injury.Threshold <= _EL_injuryThresholdMax) {
                    usable_injurys.push(injury);
                }
            }
        }
        local skills = _EL_actor.getSkills();
        while(_EL_num > 0 && usable_injurys.len() > 0) {
            local r = this.Math.rand(0, usable_injurys.len() - 1);
            if(!skills.hasSkill(usable_injurys[r].ID)) {
                skills.add(this.new("scripts/skills/" + usable_injurys[r].Script));
            }
            usable_injurys.remove(r);
        }
        return _EL_num;
    }

    function EL_addInjurysToActor(_EL_actor, _EL_num, _EL_injuryTypeList) {
        return EL_addInjurysToActor_P(_EL_actor, _EL_num, _EL_injuryTypeList);
    }
    function EL_addSlightInjurysToActor(_EL_actor, _EL_num, _EL_injuryTypeList) {
        return EL_addInjurysToActor_P(_EL_actor, _EL_num, _EL_injuryTypeList, 0, 0.4);
    }
    function EL_addSeriousInjurysToActor(_EL_actor, _EL_num, _EL_injuryTypeList) {
        return EL_addInjurysToActor_P(_EL_actor, _EL_num, _EL_injuryTypeList, 0.4, 1);
    }

    function EL_chanceTableCalculateAXB(_EL_info) {
        for(local range_index = 0, table_index = 0; range_index < _EL_info.Factor.Range.len(); ++range_index) {
            for(; table_index < _EL_info.Factor.Range[range_index]; ++table_index) {
                _EL_info.Table.push(table_index * _EL_info.Factor.Mult[range_index] + _EL_info.Factor.Offset[range_index])
            }
        }
    }

    function EL_chanceTableReadAXB(_EL_index, _EL_info) {
        if(_EL_index < _EL_info.Table.len()) {
            return _EL_info.Table[_EL_index];
        }
        else{
            local factor_last_index = _EL_info.Factor.Range.len();
            return _EL_index * _EL_info.Factor.Mult[factor_last_index] + _EL_info.Factor.Offset[factor_last_index];
        }
    }

};
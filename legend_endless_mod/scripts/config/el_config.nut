local gt = this.getroottable();

if (!("EL_Config" in gt.Const))
{
	gt.Const.EL_Config <- {};
}

gt.Const.EL_Config <- {

    Attributes = {
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


    function EL_chanceTableCalculateAXB(_EL_info) {
        for(local range_index = 0, table_index = 0; range_index < _EL_info.Factor.Range.len(); ++range_index) {
            for(; table_index < __EL_info.Factor.Range[range_index]; ++table_index) {
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
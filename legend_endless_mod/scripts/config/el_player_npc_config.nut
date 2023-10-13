local gt = this.getroottable();

if (!("EL_PlayerNPC" in gt.Const))
{
	gt.Const.EL_PlayerNPC <- {};
}

gt.Const.EL_PlayerNPC <- {
    EL_XPValue = {
        Offset = 300,
        Mult = 30,
    },

    EL_ShieldDamage = {
        Base = 1,
        MultPurCombatLevel = 0.04
    }

    EL_ExtraFatigueRecovery = {
        DivFactor = 20,
        Offset = -5,
    },

    EL_RankToMoraleMin = [
        0,
        0,
        1
    ]

    EL_CombatLevel = {
        HitChangeFactor = 1.04,
        DamageFactor = 1.04
    }

    EL_Morale = {
        HeadCount = {
            Factor1 = 2,
            Factor2 = 2,
            Factor3 = 2
        },
        Hit = {
            PersentPurCheck = 20,
            Factor1 = 10,
            Factor2 = 0.5,
            Factor3 = 2
        },
        Death = {
            BaseOffset = 0,
            RankFactor = 0,
            CombatLevelFactor = 1.04,
            DistanceFactor = 3
        },
        Move = {
            BaseOffset = 50,
            RankFactor = 0,
            CombatLevelFactor = 1.04,
        },
        Fleeing = {
            BaseOffset = 25,
            RankFactor = 0,
            CombatLevelFactor = 1.04,
            DistanceFactor = 3
        },

        Effect = {
            BraveryOffset = [-45, -30, -15, 0, 15, 0],
            InitiativeOffset = [-45, -30, -15, 0, 15, 0],
            MeleeSkillOffset = [-45, -30, -15, 0, 15, 0],
            RangedSkillOffset = [-45, -30, -15, 0, 15, 0],
            MeleeDefenseOffset = [-45, -30, -15, 0, 15, 0],
            RangedDefenseOffset = [-45, -30, -15, 0, 15, 0],
            FatigueOnSkillUseOffset = [6, 4, 2, 0, -2, 0],
            DamageDirectMult = [0.55, 0.70, 0.85, 1, 1.15, 1],
            DamageReceivedTotalMult = [1.45, 1.3, 1.15, 1, 0.85, 1],
        }
    }
};


gt.Const.CharacterProperties.EL_CombatLevel <- 0;
local onSerialize = gt.Const.CharacterProperties.onSerialize;
gt.Const.CharacterProperties.onSerialize = function ( _out )
{
    onSerialize( _out );
    _out.writeF32(this.EL_CombatLevel);
    _out.writeI16(this.ActionPoints);
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}
local onDeserialize = gt.Const.CharacterProperties.onDeserialize;
gt.Const.CharacterProperties.onDeserialize = function ( _in )
{
    onDeserialize( _in );
    this.EL_CombatLevel = _in.readF32();
    this.ActionPoints = _in.readI16();
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}

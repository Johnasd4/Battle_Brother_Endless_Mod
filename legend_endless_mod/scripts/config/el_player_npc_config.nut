local gt = this.getroottable();

if (!("EL_PlayerNPC" in gt.Const))
{
	gt.Const.EL_PlayerNPC <- {};
}

gt.Const.EL_PlayerNPC <- {

    EL_ExtraFatigueRecoveryDivFactor = 20,
    EL_ExtraFatigueRecoveryOffset = -3,

    EL_RankToMoraleMin = [
        0,
        1,
        2
    ]

};


gt.Const.CharacterProperties.EL_CombatLevel <- 0;
local onSerialize = gt.Const.CharacterProperties.onSerialize;
gt.Const.CharacterProperties.onSerialize = function ( _out )
{
    onSerialize( _out );
    _out.writeF32(this.EL_CombatLevel);
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}
local onDeserialize = gt.Const.CharacterProperties.onDeserialize;
gt.Const.CharacterProperties.onDeserialize = function ( _in )
{
    onDeserialize( _in );
    this.EL_CombatLevel = _in.readF32();
    //this.logInfo("this.EL_CombatLevel : " + this.EL_CombatLevel);
}

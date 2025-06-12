local gt = this.getroottable();

if (!("EL_GlobalFactor" in gt.Const))
{
	gt.Const.EL_GlobalFactor <- {};
}

gt.Const.EL_GlobalFactor <- {

    EL_PlayerAttributes = {
        HitpointsMult = 1.0,
        Bravery = 0,
        Fatigue = 0,
        Initiative = 0,
        MeleeSkill = 0,
        RangedSkill = 0,
        MeleeDefense = 0,
        RangedDefense = 0,
        InitiativeForTurnOrderAdditional = 0,
        Vision = 0,
        XPGainMult = 1.0,
        MovementAPCostAdditional = 0,
        MovementFatigueCostAdditional = 0,
        DamageReceivedArmorMult = 1.0,
        DamageReceivedDirectMult = 1.0,
        DamageReceivedRangedMult = 1.0,
        DamageReceivedMeleeMult = 1.0,
        DamageReceivedTotalMult = 1.0,
        MeleeDamageMult = 1.0,
        RangedDamageMult = 1.0,
        DamageArmorMult = 1.0,
        DamageDirectMult = 1.0,
        DamageTotalMult = 1.0,
        BodyArmorMult = 1.0,
        HeadArmorMult = 1.0
    },
    EL_NPCAttributes = {
        HitpointsMult = 1.0,
        Bravery = 0,
        Fatigue = 0,
        Initiative = 0,
        MeleeSkill = 0,
        RangedSkill = 0,
        MeleeDefense = 0,
        RangedDefense = 0,
        InitiativeForTurnOrderAdditional = 0,
        Vision = 0,
        XPMult = 1.0,
        MovementAPCostAdditional = 0,
        MovementFatigueCostAdditional = 0,
        DamageReceivedArmorMult = 1.0,
        DamageReceivedDirectMult = 1.0,
        DamageReceivedRangedMult = 1.0,
        DamageReceivedMeleeMult = 1.0,
        DamageReceivedTotalMult = 1.0,
        MeleeDamageMult = 1.0,
        RangedDamageMult = 1.0,
        DamageArmorMult = 1.0,
        DamageDirectMult = 1.0,
        DamageTotalMult = 1.0,
        BodyArmorMult = 1.0,
        HeadArmorMult = 1.0
    }

    function getClone()
    {
        return {
            EL_PlayerAttributes = clone gt.Const.EL_GlobalFactor.EL_PlayerAttributes,
            EL_NPCAttributes = clone gt.Const.EL_GlobalFactor.EL_NPCAttributes
        }
    }

	function onSerialize( _out )
	{
        //EL_PlayerAttributes
		_out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HitpointsMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.HitpointsMult);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Bravery - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.Bravery);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Fatigue - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.Fatigue);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Initiative - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.Initiative);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeSkill - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeSkill);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedSkill - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedSkill);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDefense - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeDefense);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDefense - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedDefense);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.InitiativeForTurnOrderAdditional - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.InitiativeForTurnOrderAdditional);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Vision - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.Vision);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.XPGainMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.XPGainMult);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MovementAPCostAdditional - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.MovementAPCostAdditional);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MovementFatigueCostAdditional - gt.Const.EL_GlobalFactor.EL_PlayerAttributes.MovementFatigueCostAdditional);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedArmorMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedDirectMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedDirectMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedRangedMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedRangedMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedMeleeMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedMeleeMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedTotalMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedTotalMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDamageMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.MeleeDamageMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDamageMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.RangedDamageMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageArmorMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageDirectMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageDirectMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageTotalMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.DamageTotalMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.BodyArmorMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.BodyArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HeadArmorMult / gt.Const.EL_GlobalFactor.EL_PlayerAttributes.HeadArmorMult);
        //EL_NPCAttributes
		_out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.HitpointsMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.HitpointsMult);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Bravery - gt.Const.EL_GlobalFactor.EL_NPCAttributes.Bravery);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Fatigue - gt.Const.EL_GlobalFactor.EL_NPCAttributes.Fatigue);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Initiative - gt.Const.EL_GlobalFactor.EL_NPCAttributes.Initiative);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeSkill - gt.Const.EL_GlobalFactor.EL_NPCAttributes.MeleeSkill);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedSkill - gt.Const.EL_GlobalFactor.EL_NPCAttributes.RangedSkill);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeDefense - gt.Const.EL_GlobalFactor.EL_NPCAttributes.MeleeDefense);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedDefense - gt.Const.EL_GlobalFactor.EL_NPCAttributes.RangedDefense);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.InitiativeForTurnOrderAdditional - gt.Const.EL_GlobalFactor.EL_NPCAttributes.InitiativeForTurnOrderAdditional);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Vision - gt.Const.EL_GlobalFactor.EL_NPCAttributes.Vision);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.XPMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.XPMult);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MovementAPCostAdditional - gt.Const.EL_GlobalFactor.EL_NPCAttributes.MovementAPCostAdditional);
		_out.writeI32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MovementFatigueCostAdditional - gt.Const.EL_GlobalFactor.EL_NPCAttributes.MovementFatigueCostAdditional);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedArmorMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedDirectMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedDirectMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedRangedMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedRangedMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedMeleeMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedMeleeMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedTotalMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedTotalMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeDamageMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.MeleeDamageMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedDamageMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.RangedDamageMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageArmorMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageDirectMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageDirectMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageTotalMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.DamageTotalMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.BodyArmorMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.BodyArmorMult);
        _out.writeF32(this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.HeadArmorMult / gt.Const.EL_GlobalFactor.EL_NPCAttributes.HeadArmorMult);
	}

	function onDeserialize( _in )
	{
        //EL_PlayerAttributes
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HitpointsMult *= _in.readF32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Bravery += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Fatigue += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Initiative += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeSkill += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedSkill += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDefense += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDefense += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.InitiativeForTurnOrderAdditional += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.Vision += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.XPGainMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MovementAPCostAdditional += _in.readI32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MovementFatigueCostAdditional += _in.readI32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedDirectMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedRangedMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedMeleeMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageReceivedTotalMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.MeleeDamageMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.RangedDamageMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageDirectMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.DamageTotalMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.BodyArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_PlayerAttributes.HeadArmorMult *= _in.readF32();
        //EL_NPCAttributes
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.HitpointsMult *= _in.readF32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Bravery += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Fatigue += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Initiative += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeSkill += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedSkill += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeDefense += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedDefense += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.InitiativeForTurnOrderAdditional += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.Vision += _in.readI32();
		this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.XPMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MovementAPCostAdditional += _in.readI32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MovementFatigueCostAdditional += _in.readI32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedDirectMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedRangedMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedMeleeMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageReceivedTotalMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.MeleeDamageMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.RangedDamageMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageDirectMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.DamageTotalMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.BodyArmorMult *= _in.readF32();
        this.World.Assets.m.EL_GlobalFactor.EL_NPCAttributes.HeadArmorMult *= _in.readF32();
	}

};
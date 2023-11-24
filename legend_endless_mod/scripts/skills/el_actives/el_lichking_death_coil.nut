el_lichking_death_coil <- this.inherit("scripts/skills/skill", {
	m = {
        EL_RankLevel = 0,
		EL_SoulEnergyCost = 0
	},
	function create()
	{
		this.m.ID = "el_actives.lichking_death_coil";
		this.m.Name = "死亡缠绕";
		this.m.Description = "对生者使用造成一次伤害，对亡灵使用则进行一次治疗。";
		this.m.Icon = "el_skills/death_coil.png";
		this.m.IconDisabled = "skills/missile_square_bw.png";
		this.m.Overlay = "missile_square";
		this.m.SoundOnUse = [
			"sounds/combat/stupefy_01.wav",
			"sounds/combat/stupefy_02.wav",
			"sounds/combat/stupefy_03.wav",
			"sounds/combat/stupefy_04.wav",
			"sounds/combat/stupefy_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/humans/0/human_fatigue_01.wav",
			"sounds/humans/0/human_fatigue_01.wav",
			"sounds/humans/0/human_fatigue_01.wav",
			"sounds/humans/0/human_fatigue_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTooCloseShown = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = this.Const.EL_LichKing.Weapon.DeathCoil.SkillActionPointCost;
		this.m.FatigueCost =  this.Const.EL_LichKing.Weapon.DeathCoil.SkillFatigueCost;
		this.m.MinRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 100;
		this.m.IsUsingHitchance = false;

		this.m.EL_SoulEnergyCost = this.Const.EL_LichKing.Weapon.DeathCoil.SoulEnergyCost[this.m.EL_RankLevel];
	}
    
	function isUsable()
	{
        return this.World.Assets.EL_getSoulEnergy() < this.m.EL_SoulEnergyCost ? false : this.skill.isUsable();
	}

	function getCostString()
	{
		return "[i]使用花费" + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " AP " + this.m.EL_SoulEnergyCost + "灵魂能量[/color][/b] 并增加" + (this.isAffordableBasedOnFatiguePreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getFatigueCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getFatigueCost()) + " Fatigue[/color][/b][/i]\n";
	}

	function getTooltip()
	{
		local p = this.m.Container.buildPropertiesForUse(this, null);
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
        local damage_regular = this.Math.floor(EL_getDamage() * p.DamageTotalMult * p.RangedDamageMult);
        local damage_direct = this.Math.floor(damage_regular * this.m.DirectDamageMult);
        local damage_armor = this.Math.floor(EL_getDamage() * p.DamageTotalMult * p.RangedDamageMult);

		ret.push({
            id = 4,
            type = "text",
            icon = "ui/icons/regular_damage.png",
            text = "对生命值造成 [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular + "[/color] 伤害，其中 [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct + "[/color] 可以忽视护甲"
        });
        ret.push({
            id = 5,
            type = "text",
            icon = "ui/icons/armor_damage.png",
            text = "对盔甲造成 [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor + "[/color] 伤害"
        });
		
        ret.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = "对亡灵单位释放将治疗等同于伤害数值" + this.Const.EL_LichKing.Weapon.DeathCoil.TreatmentMult * 100 + "%的状态"
        });
        if(EL_isInStrengthenForm())
        {
			ret.push({
				id = 7,
				type = "text",
			    icon = "ui/icons/special.png",
				text = "当前处于“黑暗强化”状态，每次使用消耗的灵魂能量增加为 [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSoulEnergyCostMult * 100 + "%[/color]，施法范围提升为  [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSkillRangeMaxMult * 100 + "%[/color]，伤害提升为 [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenDamageMult * 100 + "%。[/color]"
			});
        }
		return ret;
	}
    
	function EL_isInStrengthenForm()
	{
        return this.getContainer().hasSkill("el_effect.lichking_strengthen");
	}

	function onAfterUpdate( _properties )
	{
		this.m.EL_SoulEnergyCost = EL_isInStrengthenForm() ? this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSoulEnergyCostMult * this.Const.EL_LichKing.Weapon.DeathCoil.SoulEnergyCost[this.m.EL_RankLevel] : this.Const.EL_LichKing.Weapon.DeathCoil.SoulEnergyCost[this.m.EL_RankLevel];
		local range_item = this.Const.EL_LichKing.Weapon.DeathCoil.BaseSkillRangeMax + this.m.EL_RankLevel * this.Const.EL_LichKing.Weapon.DeathCoil.SkillRangeMaxRankFactor;
		local range_hitpoints = this.Const.EL_LichKing.Weapon.DeathCoil.BaseSkillRangeMax + this.Math.floor(this.getContainer().getActor().getHitpointsMax() / 100);
		this.m.MaxRange = EL_isInStrengthenForm() ? this.Math.min(range_item, range_hitpoints) * this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenSkillRangeMaxMult : this.Math.min(range_item, range_hitpoints);
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		local target = _targetTile.getEntity();
		local user = this.getContainer().getActor();

		if (target == null)
		{
			return false;
		}

		return true;
	}

    function EL_getDamage()
    {
        local result = this.Math.floor(this.Const.EL_LichKing.Weapon.DeathCoil.BaseSkillDamage + this.m.EL_RankLevel * this.Const.EL_LichKing.Weapon.DeathCoil.SkillDamageRankFactor) * (1 + this.getContainer().getActor().EL_getCombatLevel() * this.Const.EL_LichKing.Weapon.DeathCoil.SkillDamageLevelFactor);
        return EL_isInStrengthenForm() ? this.Const.EL_LichKing.Weapon.DeathCoil.StrengthenDamageMult * result : result;
    }

    function EL_getTreatmentNum()
    {
        return this.Const.EL_LichKing.Weapon.DeathCoil.TreatmentMult * EL_getDamage();
    }

    function EL_setRankLevel( _EL_rankLevel )
	{
        this.m.EL_RankLevel = _EL_rankLevel;
    }

    function EL_isUndead( _actor )
    {
		if(_actor.getSkills().hasSkill("el_trait.undead"))
		{
			return true;
		}
		foreach(valid_type in this.Const.EL_Weapon.EL_Entry.Factor.EL_SpecialAttackUndead.ValidEntity)
		{
			if(_actor.getType() == valid_type)
			{
				return true;
			}
		}
        return false;
    }
    
	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
        if(target == null)
        {
            return false;
        }
        this.World.Assets.EL_addSoulEnergy(-this.m.EL_SoulEnergyCost);
        if(EL_isUndead(target))
        {
            local treatment_num = EL_getTreatmentNum();
            local before_hitpoints = target.getHitpoints();
            target.setHitpoints(this.Math.min(target.getHitpointsMax(), before_hitpoints + treatment_num));
            treatment_num -= target.getHitpoints() - before_hitpoints;
            if(treatment_num > 0)
            {
                local body = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
                local head = target.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
				if(body == null && head == null)
				{
					return true;
				}
				if(body == null)
				{
					head.setArmor(this.Math.min(head.getArmorMax(), head.getArmor() + treatment_num));
					return true;
				}
				else if(head == null)
				{
					body.setArmor(this.Math.min(body.getArmorMax(), body.getArmor() + treatment_num));
					return true;
				}
                local body_conditon_percent = body == null ? 1 : body.getArmor() / (1.0 * body.getArmorMax());
                local head_conditon_percent = head.getArmor() / (1.0 * head.getArmorMax());
                local add_min_to_max_need = body_conditon_percent < head_conditon_percent ? head.getArmor() - body.getArmor() : body.getArmor() - head.getArmor();
                if(treatment_num > add_min_to_max_need)
                {
                    local final_percent = this.Math.min(1, (body.getArmor() + head.getArmor() + treatment_num) / (1.0 * (body.getArmorMax() + head.getArmorMax())));
                    body.setArmor(final_percent * body.getArmorMax());
                    head.setArmor(final_percent * head.getArmorMax());
                }
                else
                {
                    body_conditon_percent < head_conditon_percent ? body.setArmor(body.getArmor() + treatment_num) : head.setArmor(head.getArmor() + treatment_num);
                }
            }
            return true;
        }
        local hit_info = clone this.Const.Tactical.HitInfo;
        hit_info.DamageArmor = EL_getDamage();
        hit_info.DamageRegular = EL_getDamage() * this.m.DirectDamageMult;
        hit_info.DamageDirect = this.m.DirectDamageMult;
        hit_info.BodyPart = this.Const.BodyPart.Body;
        target.onDamageReceived(this.getContainer().getActor(), this, hit_info);
        return true;
	}
});
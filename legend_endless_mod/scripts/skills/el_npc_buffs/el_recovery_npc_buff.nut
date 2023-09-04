this.el_recovery_npc_buff <- this.inherit("scripts/skills/el_npc_buffs/el_npc_buff", {
	m = {
        EL_DefenseState = this.Const.EL_NPC.EL_NPCBuff.Evasion.RangeState
    },
	function create()
	{
		this.el_npc_buff.create();
		this.m.ID = "el_npc_buffs.recovery";
		this.m.Name = "Recovery";
		this.m.Description = "";
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
        local properties = actor.getCurrentProperties();

		local hitpoints_added = actor.getHitpoints();
        actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(actor.getHitpointsMax() * this.Const.EL_NPC.EL_NPCBuff.Recovery.HitpointsRecoveryRate[this.m.EL_RankLevel])));
		hitpoints_added = actor.getHitpoints() - hitpoints_added;
        if (!actor.isHiddenToPlayer() && hitpoints_added != 0)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + hitpoints_added + " points");
		}

        local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local body_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Body] * properties.ArmorMult[this.Const.BodyPart.Body]);
        if(body != null) {
            body.setArmor(this.Math.min(body.getArmorMax(), body.getArmor() + this.Math.round(body.getArmorMax() * this.Const.EL_NPC.EL_NPCBuff.Recovery.ArmorRecoveryRate[this.m.EL_RankLevel])));
		}
        else {
            properties.Armor[this.Const.BodyPart.Body] = this.Math.min(properties.ArmorMax[this.Const.BodyPart.Body], properties.Armor[this.Const.BodyPart.Body] + this.Math.round(properties.ArmorMax[this.Const.BodyPart.Body] * this.Const.EL_NPC.EL_NPCBuff.Recovery.ArmorRecoveryRate[this.m.EL_RankLevel]));
        }
        body_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Body] * properties.ArmorMult[this.Const.BodyPart.Body]) - body_armor_added;
        if (!actor.isHiddenToPlayer() && body_armor_added != 0)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " armor recoverd " + body_armor_added + " points");
		}

		local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
        local head_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Head] * properties.ArmorMult[this.Const.BodyPart.Head]);
        if(head != null) {
            head.setArmor(this.Math.min(head.getArmorMax(), head.getArmor() + this.Math.round(head.getArmorMax() * this.Const.EL_NPC.EL_NPCBuff.Recovery.ArmorRecoveryRate[this.m.EL_RankLevel])));
		}
        else {
            properties.Armor[this.Const.BodyPart.Head] = this.Math.min(properties.ArmorMax[this.Const.BodyPart.Head], properties.Armor[this.Const.BodyPart.Head] + this.Math.round(properties.ArmorMax[this.Const.BodyPart.Head] * this.Const.EL_NPC.EL_NPCBuff.Recovery.ArmorRecoveryRate[this.m.EL_RankLevel]));
        }
        head_armor_added = this.Math.round(properties.Armor[this.Const.BodyPart.Head] * properties.ArmorMult[this.Const.BodyPart.Head]) - head_armor_added;
        if (!actor.isHiddenToPlayer() && head_armor_added != 0)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " helmet recoverd " + head_armor_added + " points");
		}
	}

});


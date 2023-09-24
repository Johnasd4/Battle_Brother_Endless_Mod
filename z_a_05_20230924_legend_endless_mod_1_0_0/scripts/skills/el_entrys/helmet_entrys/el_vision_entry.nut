this.el_vision_entry <- this.inherit("scripts/skills/el_entrys/el_entry", {
	m = {
        EL_VisionAddition = 0
    },
	function create()
	{
		this.el_entry.create();
		this.m.ID = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.ID;
	}

	function getTooltip( _id )
	{
		local colour = this.EL_getEntryColour();
		local result = {
			id = _id,
			type = "text",
			text = "[color=" + colour + "]Vision + " + this.m.EL_VisionAddition + "[/color]"
		};
		return result;
	}

	function EL_getEntryColour()
	{
        for (local index = 0; index < this.Const.EL_Item.Type.Legendary; ++index)
        {
            if (this.m.EL_VisionAddition <= this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.ColourRange[index])
            {
                return this.Const.EL_Item.Colour[index];
            }
        }
		return this.Const.EL_Item.Colour[this.Const.EL_Item.Type.Legendary];
	}

	function EL_createAddition()
	{
		local randomMin = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.RandomMinVision[this.getItem().m.EL_RankLevel];
		local randomMax = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.RandomMaxVision[this.getItem().m.EL_RankLevel];
		this.m.EL_VisionAddition = this.Const.EL_Helmet.EL_Entry.Factor.EL_Vision.BaseVision + this.Math.rand(randomMin, randomMax);
	}

	function onUpdate( _properties )
	{
		this.el_entry.onUpdate(_properties);
		_properties.Vision += this.m.EL_VisionAddition;
	}

	function EL_refreshTotalEntry( _EL_totalEntry )
	{
		_EL_totalEntry.m.EL_VisionAddition += this.m.EL_VisionAddition;
	}
    
    function onSerialize( _out )
	{
		_out.writeI32(this.m.EL_VisionAddition);
	}

	function onDeserialize( _in )
	{
		this.m.EL_VisionAddition = _in.readI32();
	}
});
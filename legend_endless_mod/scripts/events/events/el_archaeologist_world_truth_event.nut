this.el_archaeologist_world_truth_event <- this.inherit("scripts/events/event", {
	m = {
        EL_Option = []
    },
	function create()
    {
        this.m.ID = "event.el_archaeologist_world_truth";
        this.m.Title = "世界真相";
        this.m.Cooldown = 0;
        this.m.IsSpecial = true;
    }

	function onUpdateScore()
	{
		this.m.Score = 0;
	}

	function onPrepare()
	{
        local screen = {
            ID = "screen",
            Text = "[img]gfx/ui/events/event_15.png[/img]你发觉了部分的世界真相！",
            Image = "",
            List = [],
            Characters = [],
            Options = [],
            function start( _event )
            {
            }
        }
        local day = this.World.getTime().Days;
        local factor = this.Math.min(5, 1 + day * 0.05)
        local good_factor = this.Const.EL_Archaeologist.DiffcultyFactor[this.World.Flags.get("ELArchaeologistDifficulty")].Good * factor;
        local bad_factor = -this.Const.EL_Archaeologist.DiffcultyFactor[this.World.Flags.get("ELArchaeologistDifficulty")].Bad * factor;
        this.m.EL_Option = [];
        for(local i = 0; i < 4; ++i) {
            local options = this.Const.EL_Archaeologist.WorldFactorChangeOption;
            local text = "真相" + (i + 1) + "：";
            local good_index = -1;
            local bad_index = -1;
            local option_good_factor = 0;
            local option_bad_factor = 0;
            if (good_factor > 0)
            {
                while(true) {
                    local r = this.Math.rand(0, options.len() - 1);
                    if (good_factor > options[r].MinFactor) {
                        good_index = r;
                        break;
                    }
                }
                option_good_factor = good_factor * options[good_index].Base;
                text = text + options[good_index].GetTooltip(option_good_factor);
            }
            if (bad_factor < 0)
            {
                while(true) {
                    local r = this.Math.rand(0, options.len() - 1);
                    if (-bad_factor > options[r].MinFactor && r != good_index) {
                        bad_index = r;
                        break;
                    }
                }
                if(good_index >= 0) {
                    text = text + "，"
                }
                option_bad_factor = bad_factor * options[bad_index].Base;
                text = text + options[bad_index].GetTooltip(option_bad_factor);
            }
            this.m.EL_Option.push({
                GoodIndex = good_index,
                GoodFactor = option_good_factor,
                GoodFunction = options[this.Math.max(0, good_index)].ChangeWorldFactor,
                BadIndex = bad_index,
                BadFactor = option_bad_factor,
                BadFunction = options[this.Math.max(0, bad_index)].ChangeWorldFactor,
                Text = text
            });
        }
        screen.Options.push({
            Text = this.m.EL_Option[0].Text,
            function getResult( _event )
            {
                local options = this.Const.EL_Archaeologist.WorldFactorChangeOption;
                if(_event.m.EL_Option[0].GoodIndex >= 0) {
                    _event.m.EL_Option[0].GoodFunction(_event.m.EL_Option[0].GoodFactor);
                }
                if(_event.m.EL_Option[0].BadIndex >= 0) {
                    _event.m.EL_Option[0].BadFunction(_event.m.EL_Option[0].BadFactor);
                }
                return 0;
            }
        });
        screen.Options.push({
            Text = this.m.EL_Option[1].Text,
            function getResult( _event )
            {
                local options = this.Const.EL_Archaeologist.WorldFactorChangeOption;
                if(_event.m.EL_Option[1].GoodIndex >= 0) {
                    _event.m.EL_Option[1].GoodFunction(_event.m.EL_Option[1].GoodFactor);
                }
                if(_event.m.EL_Option[1].BadIndex >= 0) {
                    _event.m.EL_Option[1].BadFunction(_event.m.EL_Option[1].BadFactor);
                }
                return 0;
            }
        });
        screen.Options.push({
            Text = this.m.EL_Option[2].Text,
            function getResult( _event )
            {
                local options = this.Const.EL_Archaeologist.WorldFactorChangeOption;
                if(_event.m.EL_Option[2].GoodIndex >= 0) {
                    _event.m.EL_Option[2].GoodFunction(_event.m.EL_Option[2].GoodFactor);
                }
                if(_event.m.EL_Option[2].BadIndex >= 0) {
                    _event.m.EL_Option[2].BadFunction(_event.m.EL_Option[2].BadFactor);
                }
                return 0;
            }
        });
        screen.Options.push({
            Text = this.m.EL_Option[3].Text,
            function getResult( _event )
            {
                local options = this.Const.EL_Archaeologist.WorldFactorChangeOption;
                if(_event.m.EL_Option[3].GoodIndex >= 0) {
                    _event.m.EL_Option[3].GoodFunction(_event.m.EL_Option[3].GoodFactor);
                }
                if(_event.m.EL_Option[3].BadIndex >= 0) {
                    _event.m.EL_Option[3].BadFunction(_event.m.EL_Option[3].BadFactor);
                }
                return 0;
            }
        });
        this.m.Screens.push(screen);
	}

	function onDetermineStartScreen()
	{
		return "screen";
	}

});


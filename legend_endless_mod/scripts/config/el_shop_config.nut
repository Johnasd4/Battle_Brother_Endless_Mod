local gt = this.getroottable();

if (!("EL_Shop" in gt.Const))
{
	gt.Const.EL_Shop <- {};
}

gt.Const.EL_Shop <- {
    EL_ShopLevelMax = 100,
    EL_ShopLevelInStoreMin = 10,
	EL_EssenceLevelFactor = 1.1,
	EL_ShopMaxNumitems = 2,
	EL_ShopMaxNum = 3,
	EL_ShopCoreMaxNum = 5,
	EL_ItemNumberLevelFactor = 0.01,
	EL_ItemRankUpOnceChance = {
		Factor = {
			Offset = [
				0,
				-30,
				-70,
				-120,
				-180,
				-250,
				-330,
				-420,
				280
			],
			Mult = [
				0,
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				0
			],
			Range = [
				30,
				40,
				50,
				60,
				70,
				80,
				90,
				100
			]
		}
		Table = []
		function EL_getChance(_EL_Index) {
			return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_ItemRankUpOnceChance);
		}
	},
	EL_ItemRankUpTwiceChance = {
		Factor = {
			Offset = [
				1000,
				1060,
				1130,
				1210,
				1300,
				900
			],
			Mult = [
				0,
				-1,
				-2,
				-3,
				-4,
				0
			],
			Range = [
				60,
				70,
				80,
				90,
				100
			]
		}
		Table = []
		function EL_getChance(_EL_Index) {
			return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_ItemRankUpTwiceChance);
		}
	},
	EL_CoreRank1Chance = {
        Factor = {
            Mult = [
                0,
                1,
                2,
                0
            ],
            Offset = [
                0,
                -10,
                -30,
                30
            ],
            Range = [
                10,
                20,
                30
            ],
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Player.EL_CoreRank1Chance);
        }
    },
    EL_CoreRank2Chance = {
        Factor = {
            Mult = [
                0,
                0.1,
                0.2,
                0.3,
                0.4,
                0
            ],
            Offset = [
                0,
                -2,
                -5,
                -9,
                -14,
                10,
            ],
            Range = [
                20,
                30,
                40,
                50,
                60
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Player.EL_CoreRank2Chance);
        }

    },
};

this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_ItemRankUpOnceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_ItemRankUpTwiceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_CoreRank1Chance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_CoreRank2Chance);
local gt = this.getroottable();

if (!("EL_Shop" in gt.Const))
{
	gt.Const.EL_Shop <- {};
}

gt.Const.EL_Shop <- {
    EL_ShopLevelMax = 50,
    EL_ShopLevelInStoreMax = 0,
    EL_ShopLevelInStoreMin = 10,
	//EL_EquipmentEssenceLevelFactor = 1.1,
	EL_ShopMaxNumitems = 2,
	EL_ShopMaxNum = 3,
	EL_FoodNumMult = 1.5,
	EL_ItemNumberLevelFactor = 0.01,
	EL_ItemRankUpOnceChance = {
		Factor = {
			Offset = [
				0,
				-6000,
				-15000,
				30000
			],
			Mult = [
				0,
				300,
				450,
				0
			],
			Range = [
				20,
				60,
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
				0,
				-2000,
				-5000,
				10000
			],
			Mult = [
				0,
				100,
				150,
				0
			],
			Range = [
				20,
				60,
				100
			]
		}
		Table = []
		function EL_getChance(_EL_Index) {
			return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_ItemRankUpTwiceChance);
		}
	},
	EL_Core = {
		EL_ShopMaxNum = 5,
		XPOffset = 200,
		XPMax = [
			190,
			150,
			100,
			100
		],
		XPMin = [
			10,
			0,
			0,
			0
		]
	},
	EL_PremiumCoreChance = {
        Factor = {
            Mult = [
                0,
                1000,
                0
            ],
            Offset = [
                0,
                0,
                50000
            ],
            Range = [
                0,
                50,
            ],
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_PremiumCoreChance);
        }
    },
    EL_FineCoreChance = {
        Factor = {
            Mult = [
                0,
                250,
				0
            ],
            Offset = [
                0,
                -2500,
				10000
            ],
            Range = [
                10,
                50,
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_FineCoreChance);
        }
    },
    EL_EpicCoreChance = {
        Factor = {
            Mult = [
                0,
                100,
				0
            ],
            Offset = [
                0,
                -2000,
				3000
            ],
            Range = [
                20,
				50
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_EpicCoreChance);
        }
    },
	EL_EquipmentEssence = {
		NumEachGroup = [
			1000,
			100,
			100,
			100,
			1
		],
		PriceEachOne = [
			1,
			50,
			200,
			1000,
			100000
		]
	},
	EL_PremiumEquipmentEssenceChance = {
        Factor = {
            Mult = [
                0,
                1000,
                0
            ],
            Offset = [
                0,
                0,
                50000
            ],
            Range = [
                0,
                50,
            ],
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_PremiumCoreChance);
        }
    },
    EL_FineEquipmentEssenceChance = {
        Factor = {
            Mult = [
                0,
                250,
				0
            ],
            Offset = [
                0,
                -2500,
				10000
            ],
            Range = [
                10,
				50
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_FineCoreChance);
        }
    },
    EL_EpicEquipmentEssenceChance = {
        Factor = {
            Mult = [
                0,
                100,
				0
            ],
            Offset = [
                0,
                -2000,
				3000
            ],
            Range = [
                20,
				50
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_EpicCoreChance);
        }
    },
    EL_LegendaryEquipmentEssenceChance = {
        Factor = {
            Mult = [
                0,
                10,
				0
            ],
            Offset = [
                0,
                0,
				500
            ],
            Range = [
                0,
				50
            ]
        },
        Table = []

        function EL_getChance(_EL_Index) {
            return this.Const.EL_Config.EL_chanceTableReadAXB(_EL_Index, this.Const.EL_Shop.EL_EpicCoreChance);
        }
    }
};

this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_ItemRankUpOnceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_ItemRankUpTwiceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_PremiumCoreChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_FineCoreChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_EpicCoreChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_PremiumEquipmentEssenceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_FineEquipmentEssenceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_EpicEquipmentEssenceChance);
this.Const.EL_Config.EL_chanceTableCalculateAXB(this.Const.EL_Shop.EL_LegendaryEquipmentEssenceChance);
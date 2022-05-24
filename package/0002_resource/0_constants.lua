local constants =
{
	id = "Resource" ,
	name = "矿产资源" ,
	raw =
	{
		ore =
		{
			type = SITypes.item.capsule ,
			list =
			{
				-- 岩心石
				stoneOpal = "蛋白石" ,
				stoneHard = "方刚石" ,
				stoneSlide = "绵滑石" ,
				stoneSea = "苍溟石" ,
				stoneGrass = "苔芜石" ,
				stoneArmor = "韧铠石" ,
				stoneShadow = "影山石" ,
				stoneBright = "灿光石" ,
				-- 变相石
				changeHeat = "荧焰石" , -- 对应力量
				changeDrown = "沉沦石" , -- 对应精神
				changeMeat = "血肉石" , -- 对应献祭
				changeWind = "浊风石" , -- 对应瘟疫
				changeGloomy = "断魄石" , -- 对应恐惧
				changeCold = "冰凌石" , -- 对应扭曲
				changeRed = "绯红石" , -- 对应侵蚀
				changeBlack = "黑晶石" , -- 对应虚空
				-- 夹层石
				waterClear = "清水石" , -- 天蓝色
				waterFire = "火苗石" , -- 橘红色
				waterTime = "悠远石" , -- 亮粉色
				waterQuiet = "宁寂石" , -- 蓝紫色
				waterBright = "凄辉石" -- 草绿色
			}
		} ,
		other =
		{
			type = SITypes.item.capsule ,
			list =
			{
				-- 矿山石
				stoneCore = "矿山石" ,
				stoneCoreTough = "韧性矿山石" ,
				stoneCoreHard = "刚性矿山石" ,
				stoneCorePowder = "矿山石的粉末" ,
				stoneCoreBubble = "多孔的矿山石" ,
				stoneCoreBrittle = "脆性矿山石" ,
				stoneCoreShake = "颤性矿山石" ,
				stoneCoreSplit = "碎裂的矿山石" ,
				stoneCoreMagic = "魔化矿山石" ,
				stoneCorePolluted = "被污染的矿山石的粉末" ,
				-- 矿石壳
				shellWhole = "矿石壳" ,
				shellHalf = "半矿石壳" ,
				shellSplit = "矿石壳屑" ,
				-- 矿石脉
				veinWhole = "矿石脉" ,
				veinHalf = "断裂的矿石脉" ,
				veinSplit = "矿石脉屑"
			}
		}
	}
}
return constants
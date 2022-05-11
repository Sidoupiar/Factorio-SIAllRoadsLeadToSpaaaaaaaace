local constants =
{
	id = "Garbage" ,
	name = "垃圾回收" ,
	categoryList =
	{
		[SITypes.category.fuel] =
		{
			garbage = "废料"
		} ,
		[SITypes.category.recipe] =
		{
			garbage = "燃烧废料"
		}
	} ,
	raw =
	{
		-- 固有物品
		item =
		{
			type = SITypes.item.capsule ,
			list =
			{
				fuelResult    = "燃烧灰烬" ,
				brokenMachine = "报废的机器" ,
				burntMachine  = "垃圾焚烧炉" ,
				ashBlower     = "吹灰机" ,
				ashMixer      = "调灰机" ,
				ashShower     = "喷灰机"
			}
		} ,
		-- 灰烬系列
		ash =
		{
			type = SITypes.item.capsule ,
			list =
			{
				ashFilter  = "滤网灰烬" ,
				ashFlue    = "烟道灰烬" ,
				ashCore    = "炉心灰烬" ,
				ashAttach  = "附着灰烬" ,
				ashWhite   = "苍白灰烬" ,
				ashGrey    = "焦色灰烬" ,
				ashLight   = "闪光灰烬" ,
				ashOre     = "矿物灰烬" ,
				ashDrop    = "沉积灰烬" ,
				ashBroken  = "破碎灰烬"
			}
		} ,
		-- 认证书系列
		book =
		{
			type = SITypes.item.capsule ,
			list =
			{
				bookLaunch = "太空垃圾认证书" ,
				bookBadge  = "闪耀徽章认证书" ,
				bookAsh    = "袅袅炊烟认证书" ,
				bookFog    = "有害雾气认证书" ,
				bookWinter = "火山冬天认证书" ,
				bookCloud  = "满天乌云认证书"
			}
		}
	}
}
return constants
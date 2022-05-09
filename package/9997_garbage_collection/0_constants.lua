local constants =
{
	id = "Garbage" ,
	name = "垃圾回收" ,
	categoryList =
	{
		[SITypes.category.recipe] =
		{
			garbage = "燃烧废料"
		} ,
		[SITypes.category.fuel] =
		{
			garbage = "废料"
		}
	} ,
	raw =
	{
		[SITypes.item.capsule] =
		{
			name = "item" ,
			list =
			{
				fuelResult = "燃烧灰烬" ,
				brokenMachine = "报废的机器" ,
				burntMachine = "垃圾焚烧炉" ,

				ashFilter = "滤网灰烬" ,
				ashWhite = "苍白灰烬" ,
				ashOre = "矿物灰烬" ,
				
				bookLaunch = "太空垃圾认证书" ,
				bookBadgeEP = "环保徽章认证书" ,
				bookWinter = "火山冬天认证书" ,
				bookAsh = "袅袅炊烟认证书"
			}
		}
	}
}
return constants
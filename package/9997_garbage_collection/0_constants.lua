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
				fuelGarbage = "燃烧灰烬" ,
				filterGarbage = "滤网灰烬" ,
				whiteGarbage = "苍白灰烬" ,
				oreGarbage = "矿物灰烬" ,
				launchBook = "太空垃圾认证书" ,
				epBadgeBook = "环保徽章认证书" ,
				winterBook = "火山冬天认证书" ,
				ashBook = "袅袅炊烟认证书" ,
				brokenMachine = "报废的机器" ,
				burntMachine = "垃圾焚烧炉"
			}
		}
	}
}
return constants
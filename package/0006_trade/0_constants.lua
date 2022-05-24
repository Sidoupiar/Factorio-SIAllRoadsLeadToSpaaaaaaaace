local constants =
{
	id = "Trade" ,
	name = "经济贸易" ,
	raw =
	{
		money =
		{
			type = SITypes.item.capsule ,
			list =
			{
				coin = "硬币" ,
				gold = "金币" ,
				balla = "贝拉" ,
				innew = "因纽" ,
				charp = "栗普"
			}
		} ,
		check =
		{
			type = SITypes.item.capsule ,
			list =
			{
				x1 = "1x兑换券"
			}
		}
	}
}
return constants
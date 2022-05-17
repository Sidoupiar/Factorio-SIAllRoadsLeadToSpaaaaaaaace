local constants =
{
	id = "OreProcessing" ,
	name = "矿石处理" ,
	raw =
	{
		-- 冶炼用品
		item =
		{
			type = SITypes.item.capsule ,
			list = {}
		} ,
		-- 熔融金属
		fluid =
		{
			type = SITypes.fluid ,
			list = {}
		} ,
		-- 中间产物
		intermediate =
		{
			type = SITypes.item.capsule ,
			list = {}
		}
	}
}
return constants
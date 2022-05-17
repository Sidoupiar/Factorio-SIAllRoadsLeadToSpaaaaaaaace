local constants =
{
	id = "MetalSmelting" ,
	name = "金属冶炼" ,
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
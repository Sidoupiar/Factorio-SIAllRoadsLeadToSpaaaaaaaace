local constants =
{
	id = "Core" ,
	name = "通用核心" ,
	categoryList =
	{
		[SITypes.category.ammo] =
		{
			peopleThrow = "手扔"
		}
	} ,
	raw =
	{
		[SITypes.group] =
		{
			name = "group" ,
			list =
			{
				material = "材料" ,
				mics = "杂项" ,
				other = "扩展"
			}
		} ,
		[SITypes.item.capsule] =
		{
			name = "item" ,
			list =
			{
				machineBadge = "设备徽章" ,
				roundBadge = "循环徽章" ,
				epBadge = "环保徽章"
			}
		}
	} ,
	-- 列表原本就有的值
	damage =
	{
		physical = "physical" ,
		impact = "impact" ,
		poison = "poison" ,
		explosion = "explosion" ,
		fire = "fire" ,
		laser = "laser" ,
		acid = "acid" ,
		electric = "electric"
	}
}
return constants
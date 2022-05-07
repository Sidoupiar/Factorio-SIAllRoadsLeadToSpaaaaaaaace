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
	damageType =
	{
		-- 物理伤害
		physicWater     = "湿润" ,
		physicDry       = "干燥" ,
		physicIce       = "冰冻" ,
		physicRadiation	= "辐射" ,
		physicCorrosion = "腐蚀" ,
		physicSound     = "声波" ,
		physicEnergy    = "能量" ,
		physicGravity   = "重力" ,
		-- 魔法伤害
		magicPower      = "力量" ,
		magicSpirit     = "精神" ,
		magicBlood      = "献祭" ,
		magicDisease    = "瘟疫" ,
		magicFear       = "恐惧" ,
		magicTwist      = "扭曲" ,
		magicCorrosion  = "侵蚀" ,
		magicVoid       = "虚空" ,
		-- 元素伤害
		elementCut      = "割元素" ,
		elementHeat     = "炎元素" ,
		elementGround   = "固元素" ,
		elementWater    = "流元素" ,
		elementWind     = "气元素" ,
		elementLife     = "命元素" ,
		elementSound    = "音元素" ,
		elementElectric = "电元素" ,
		elementLight    = "光元素" ,
		elementDary     = "影元素" ,
		elementEnergy   = "能元素" ,
		elementHeavy    = "质元素" ,
		elementFull     = "盈元素" ,
		elementVoid     = "虚元素" ,
		elementSkill    = "技元素"
	}
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
				materialBadge = "材料徽章" ,
				machineBadge = "设备徽章" ,
				roundBadge = "循环徽章" ,
				wildBadge = "野性徽章" ,
				tastyBadge = "美食徽章" ,
				epBadge = "环保徽章" ,
			}
		}
	} ,
	damage =
	{
		-- 列表原本就有的伤害类型
		physical  = "physical" ,
		impact    = "impact" ,
		poison    = "poison" ,
		explosion = "explosion" ,
		fire      = "fire" ,
		laser     = "laser" ,
		acid      = "acid" ,
		electric  = "electric"
	} ,
	AfterLoad = function()
		-- 给 damage 表里增加新创建的伤害类型
		if SIConstants_Core.damage and SIConstants_Core.damageType then
			for index , name in pairs( SIConstants_Core.damageType ) do
				SIConstants_Core.damage[index] = name
			end
		end
	end
}
return constants
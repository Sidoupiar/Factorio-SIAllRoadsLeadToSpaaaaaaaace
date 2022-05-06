local SINumbers =
{
	-- 按照一堆叠 100KG 进行大致衡量
	-- 生产类物资堆叠偏高 , 攻击类物资堆叠偏低
	-- 考虑到实用性 , 建筑类物资堆叠偏高 , 使用频率低的物资堆叠偏低
	-- 注意 : 一些特殊物品的堆叠数量不包含在内
	stackSize =
	{
		ore               = 999 ,   -- 开采出来的原矿
		powder            = 16000 , -- 粉末类物资
		materialTiny      = 4000 ,  -- 细小但是还不足以成为粉末的存在
		materialSmall     = 1600 ,  -- 碎块型物资
		materialNormal    = 400 ,   -- 通常物资
		materialBig       = 160 ,   -- 比较大块的物资
		materialHuge      = 40 ,    -- 很大块的物资
		component         = 128 ,   -- 元器件 , 比较精密的物资
		misc              = 16 ,    -- 杂项
		tool              = 24 ,    -- 工具 , 锤子扳手之类的
		module            = 12 ,    -- 插件
		fuel              = 48 ,    -- 燃料
		sciencePack       = 48 ,    -- 研究包
		container         = 16 ,    -- 这里指成箱的物资 , 打包的
		machine           = 16 ,    -- 生产设备 , 建筑物
		plant             = 32 ,    -- 植物 , 可以摆出来的那种

		turret            = 6 ,     -- 炮塔 , 攻击设备
		weapon            = 3 ,     -- 武器
		grenade           = 27 ,    -- 手雷
		landmine          = 9 ,     -- 地雷
		ammoLight         = 36 ,    -- 轻型弹夹 , 每个弹夹能射多少发另外定义
		ammoMedium        = 12 ,    -- 中型弹夹
		ammoHeavy         = 4 ,     -- 重型弹夹
		vehicle           = 1 ,     -- 载具
		equipment         = 1 ,     -- 模块
		wall              = 84 ,    -- 围墙

		floor             = 1500 ,  -- 地板
		decoration        = 300 ,   -- 装饰物
		badge             = 28956 , -- 徽章

		food              = 23 ,    -- 作为商品的料理 , 当然也可以用来吃
		soul              = 99 ,    -- 打败敌人掉落的灵魂
		spoils            = 18 ,    -- 战利品
		commemorativeCoin = 99 ,    -- 纪念币
		physicalMoney     = 500     -- 物品形式的货币 , 作为商品
	} ,
	ui =
	{
		lineMax = 10 ,
	} ,
	icon =
	{
		sizeNormal = 64 ,
		sizeGroup = 64 ,
		sizeTechnology = 128 ,
		pictureScale = 0.25 ,
		mipMaps = 4
	} ,
	
	defaultMiningTime = 1 ,
	defaultProductCount = 1 ,
	defaultMinableFluidCount = 1 ,

	graphicHrSizeScale = 2 ,
	graphicHrScaleDown = 0.5 ,
	moduleInfoIconScale = 0.4 ,
	equipmentPictureSize = 32 ,
	
	healthToMiningTime = 800 ,
	lightSizeMult = 2.4 ,

	graphicSetting_Default =
	{
		width = 32 ,
		height = 32 ,
		widthCount = 8
		heightCount = 8 ,
		animSpeed = 0.25
	} ,
	graphicSetting =
	{
		[SITypes.entity.projectile] =
		{
			width = 32 ,
			height = 32 ,
			widthCount = 8
			heightCount = 2 ,
			animSpeed = 0.25
		} ,
		[SITypes.entity.resource] =
		{
			width = 32 ,
			height = 32 ,
			widthCount = 8
			heightCount = 8 ,
			animSpeed = 0.25
		} ,
		[SITypes.entity.machine] =
		{
			width = 32 ,
			height = 32 ,
			widthCount = 8
			heightCount = 8 ,
			animSpeed = 64.0 / 60.0
		}
	}
}

local innerNumberList = table.deepcopy( SINumbers )

function SINumbers.RestoreDefault()
	for key , value in pairs( table.deepcopy( innerNumberList ) ) do
		SINumbers[key] = value
	end
end

return SINumbers
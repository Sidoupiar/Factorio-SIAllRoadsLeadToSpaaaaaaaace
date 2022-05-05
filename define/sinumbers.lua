local SINumbers =
{
	stackSize =
	{
		materialTiny = 500 ,
		materialSmall = 350 ,
		materialNormal = 200 ,
		materialBig = 100 ,
		materialHuge = 50 ,
		machine = 20 ,
		turret = 11 ,
		weapon = 4 ,
		grenade = 29 ,
		ammo = 99 ,
		misc = 15 ,
		tool = 25 ,
		vehicle = 1 ,
		sciencePack = 40 ,
		module = 10 ,
		equipment = 1 ,
		wall = 50 ,
		floor = 1000 ,
		decoration = 300 ,
		plant = 60 ,
		badge = 28956 ,
		spoils = 18 ,
		physicalMoney = 500 ,
		commemorativeCoin = 99 ,
		soul = 99
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
	}
	
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
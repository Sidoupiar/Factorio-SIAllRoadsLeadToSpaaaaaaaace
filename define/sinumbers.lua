local SINumbers =
{
	lineMax = 10 ,
	
	iconSize = 64 ,
	iconSizeGroup = 64 ,
	iconSizeTechnology = 128 ,
	mipMaps = 4 ,
	iconPictureScale = 0.25 ,
	
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
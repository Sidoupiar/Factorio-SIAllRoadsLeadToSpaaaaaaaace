SIConstants_Garbage.fuelSettings =
{

}

SIConstants_Garbage.rocketLaunchSettings =
{

}

function SIAPI.Garbage.AddFuelSetting( name , result , fuelValue , emissionsMultiplier )
	SIConstants_Garbage.fuelSettings[name] =
	{
		result = result ,
		fuelValue = fuelValue ,
		emissionsMultiplier = emissionsMultiplier ,
		pass = false
	}
end

function SIAPI.Garbage.AddRocketLaunchSetting( name , result )
	SIConstants_Garbage.rocketLaunchSettings[name] = result
end
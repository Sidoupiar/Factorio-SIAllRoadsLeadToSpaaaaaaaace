SIConstants_Garbage.fuelSettings =
{

}

SIConstants_Garbage.rocketSendSettings =
{

}

function SIAPI.Garbage.AddFuelSetting( name , result , fuelValue , emissionsMultiplier )
	SIConstants_Garbage.fuelSettings[name] =
	{
		result = result ,
		fuelValue = fuelValue ,
		emissionsMultiplier = emissionsMultiplier
	}
end

function SIAPI.Garbage.AddRocketSendSetting( name , result )
	SIConstants_Garbage.rocketSendSettings[name] = result
end
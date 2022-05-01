local fuelTypes = {}
local fuelCategory = SIConstants_Garbage.categoryList[SITypes.category.fuel].garbage

SIGen.TypeIndicator( SITypes.category.fuel , function( index , category )
	if category and category.name then table.insert( fuelTypes , category.name ) end
end )

SIGen.TypeIndicator( SITypes.item , function( index , item )
	if not item.burnt_result then
		local data = SIConstants_Garbage.fuelSettings[item.sourceName or item.name]
		if not data or not data.pass then
			item.fuel_category = fuelCategory
			item.fuel_acceleration_multiplier = 1.0
			item.fuel_emissions_multiplier = data and data.emissionsMultiplier or 1.0
			item.fuel_value = data and data.fuelValue or "1J"
			item.burnt_result = data and data.result or SIConstants_Garbage.item.fuelGarbage
		end
	end
	if not item.rocket_launch_product and not item.rocket_launch_products then
		local result = SIConstants_Garbage.rocketLaunchSettings[item.sourceName or item.name]
		if result then
			if SITools.IsTable( result ) then
				if result[1] and SITools.IsTable( result[1] ) then item.rocket_launch_products = result
				else item.rocket_launch_products = { result } end
			else item.rocket_launch_products = { { name = result , amount = 1 , probability = 1.0 , catalyst_amount = 1 } } end
		else item.rocket_launch_products = { { name = SIConstants_Garbage.item.launchGarbage , amount = 1 , probability = 1.0 , catalyst_amount = 1 } } end
	end
end )
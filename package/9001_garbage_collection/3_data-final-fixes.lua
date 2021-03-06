-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local fuelCategory = SIConstants_Garbage.categoryList[SITypes.category.fuel].garbage

-- ------------------------------------------------------------------------------------------------
-- -- 给焚烧炉添加多种燃料类别 --------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local fuelTypes = {}
SIGen.TypeIndicator( SITypes.category.fuel , function( type , category , index )
	if category and category.name then table.insert( fuelTypes , category.name ) end
end )
.LoadMachine( "垃圾焚烧炉" , nil , false , function( entity )
	entity.energy_source.fuel_categories = fuelTypes
end )

-- ------------------------------------------------------------------------------------------------
-- ----- 给物品添加燃料属性 -----------------------------------------------------------------------
-- ------- 和火箭发射产物 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.TypeIndicator( SITypes.item , function( type , item , index )
	if not item.fuel_value then
		local data = SIConstants_Garbage.settingsFuel[item.sourceName or item.name]
		if not data or not data.pass then
			item.fuel_category = fuelCategory
			item.fuel_acceleration_multiplier = 1.0
			item.fuel_emissions_multiplier = data and data.emissionsMultiplier or 1.0
			item.fuel_value = data and data.fuelValue or "1J"
			item.burnt_result = data and data.result or SIConstants_Garbage.item.fuelResult
		end
	end
	if not item.rocket_launch_product and not item.rocket_launch_products then
		local result = SIConstants_Garbage.settingsRocketLaunch[item.sourceName or item.name]
		if result then
			if SITools.IsTable( result ) then
				if result[1] and SITools.IsTable( result[1] ) then item.rocket_launch_products = result
				else item.rocket_launch_products = { result } end
			else item.rocket_launch_products = { SITools.ProductItemHide( result ) } end
		else item.rocket_launch_products = { SITools.ProductItemHide( SIConstants_Garbage.book.bookLaunch ) } end
	end
end )
-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not SIMods.base.loaded then return end

local function accumulator_picture( tint , repeat_count , other )
	local layers =
	{
		layers =
		{
			{
				filename = "__base__/graphics/entity/accumulator/accumulator.png" ,
				priority = "high" ,
				width = 66 ,
				height = 94 ,
				shift = util.by_pixel( 0 , -10 ) ,
				repeat_count = repeat_count ,
				tint = tint ,
				animation_speed = 0.5 ,
				hr_version =
				{
					filename = "__base__/graphics/entity/accumulator/hr-accumulator.png" ,
					priority = "high" , 
					width = 130 , 
					height = 189 , 
					shift = util.by_pixel( 0 , -11 ) ,
					repeat_count = repeat_count ,
					tint = tint ,
					animation_speed = 0.5 ,
					scale = 0.5
				}
			} ,
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png" ,
				priority = "high" ,
				width = 120 ,
				height = 54 ,
				shift = util.by_pixel( 28 , 6 ) ,
				repeat_count = repeat_count ,
				draw_as_shadow = true ,
				hr_version =
				{
					filename = "__base__/graphics/entity/accumulator/hr-accumulator-shadow.png" ,
					priority = "high" ,
					width = 234 ,
					height = 106 ,
					shift = util.by_pixel( 29 , 6 ) ,
					repeat_count = repeat_count ,
					draw_as_shadow = true ,
					scale = 0.5
				}
			}
		}
	}
	for index , layer in pairs( other or {} ) do table.insert( layers.layers , layer ) end
	return layers
end

local nameList =
{
	base     = { name = "基础" } ,
	normal   = { name = "普通" } ,
	improve  = { name = "改良" } ,
	advance  = { name = "进阶" } ,
	connect  = { name = "联合" } ,
	condens  = { name = "凝聚" } ,
	breach   = { name = "突破" } ,
	strength = { name = "强化" } ,
	transce  = { name = "超越" }
}
local solarData =
{
	flags = { SIFlags.entityFlags.placeableNeutral , SIFlags.entityFlags.playerCreation } ,
	minable = { mining_time = 0.1 } ,
	max_health = 200 ,
	corpse = "solar-panel-remnants" ,
	dying_explosion = "solar-panel-explosion" ,
	damaged_trigger_effect =
	{
		type = "create-entity" ,
		entity_name = "spark-explosion-higher" ,
		offset_deviation = { { -0.5 , -0.5 } , { 0.5 , 0.5 } } ,
		offsets = { { 0 , 1.5 } } ,
		damage_type_filters = "fire"
	} ,
	energy_source =
	{
		type = "electric" ,
		usage_priority = "solar"
	} ,
	picture =
	{
		layers =
		{
			{
				filename = "__base__/graphics/entity/solar-panel/solar-panel.png" ,
				priority = "high" ,
				width = 64 ,
				height = 64
			}
		}
	} ,
	overlay =
	{
		layers =
		{
			{
				filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow-overlay.png" ,
				priority = "high" ,
				width = 64 ,
				height = 64
			}
		}
	}
}
local accData =
{
	flags = { SIFlags.entityFlags.placeableNeutral , SIFlags.entityFlags.playerCreation } ,
	minable = { mining_time = 0.1 } ,
	max_health = 200 ,
	corpse = "accumulator-remnants" ,
	dying_explosion = "accumulator-explosion" ,
	damaged_trigger_effect =
	{
		type = "create-entity" ,
		entity_name = "spark-explosion-higher" ,
		offset_deviation = { { -0.5 , -0.5 } , { 0.5 , 0.5 } } ,
		offsets = { { 0 , 1.5 } } ,
		damage_type_filters = "fire"
	} ,
	energy_source =
	{
		type = "electric" ,
		usage_priority = "tertiary"
	} ,
	picture = accumulator_picture() ,
	water_reflection =
	{
		pictures =
		{
			filename = "__base__/graphics/entity/accumulator/accumulator-reflection.png" ,
			priority = "extra-high" ,
			width = 20 ,
			height = 24 ,
			shift = util.by_pixel( 0 , 50 ) ,
			variation_count = 1 ,
			scale = 5
		} ,
		rotate = false ,
		orientation_to_variation = false
	} ,
	charge_animation = accumulator_picture( SIColors.Color256( 256 , 256 , 256 , 256 ) , 24 ,
	{
		{
			filename = "__base__/graphics/entity/accumulator/accumulator-charge.png" ,
			priority = "high" ,
			width = 90 ,
			height = 100 ,
			line_length = 6 ,
			frame_count = 24 ,
			blend_mode = "additive" ,
			shift = util.by_pixel( 0 , -22 ) ,
			hr_version =
			{
				filename = "__base__/graphics/entity/accumulator/hr-accumulator-charge.png" ,
				priority = "high" ,
				width = 178 ,
				height = 206 ,
				line_length = 6 ,
				frame_count = 24 ,
				blend_mode = "additive" ,
				shift = util.by_pixel( 0 , -22 ) ,
				scale = 0.5
			}
		}
	} ) ,
	charge_cooldown = 30 ,
	charge_light = { intensity = 0.3 , size = 7 , color = SIColors.Color256( 255 , 255 , 255 ) } ,
	discharge_animation = accumulator_picture( SIColors.Color256( 256 , 256 , 256 , 256 ) , 24 ,
	{
		{
			filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png" ,
			priority = "high" ,
			width = 88 ,
			height = 104 ,
			line_length = 6 ,
			frame_count = 24 ,
			blend_mode = "additive" ,
			shift = util.by_pixel( -2 , -22 ) ,
			hr_version =
			{
				filename = "__base__/graphics/entity/accumulator/hr-accumulator-discharge.png" ,
				priority = "high" ,
				width = 170 ,
				height = 210 ,
				line_length = 6 ,
				frame_count = 24 ,
				blend_mode = "additive" ,
				shift = util.by_pixel( -1 , -23 ) ,
				scale = 0.5
			}
		}
	} ) ,
	discharge_cooldown = 60 ,
	discharge_light = { intensity = 0.7 , size = 7 , color = SIColors.Color256( 255 , 255 , 255 ) } ,
	working_sound =
	{
		sound =
		{
			filename = "__base__/sound/accumulator-working.ogg" ,
			volume = 0.4
		} ,
		idle_sound =
		{
			filename = "__base__/sound/accumulator-idle.ogg" ,
			volume = 0.35
		} ,
		max_sounds_per_type = 3 ,
		audible_distance_modifier = 0.5 ,
		fade_in_ticks = 4 ,
		fade_out_ticks = 20
	} ,
	circuit_wire_connection_point = circuit_connector_definitions["accumulator"].points ,
	circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites ,
	circuit_wire_max_distance = default_circuit_wire_max_distance ,
	default_output_signal = { type = "virtual" , name = "signal-A" }
}
local lastSolar = "solar-panel"
local lastAcc = "accumulator"
local solarList = {}
local accList = {}
local power = SIClass_PowerNumber.New( "60K" )

-- ------------------------------------------------------------------------------------------------
-- ------ 创建多阶太阳能板 ------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.Group( "energy" )
.ListIndicator( nameList , function( name , entityName , index )
	local solarName = entityName .. "型太阳能电池板"
	local accName = entityName .. "型蓄电器"
	power:Multiply( 2 )
	SIGen.NewSolar( solarName , solarData , true , function( entity )
		entity.production = power:Get( "W" )
	end )
	.SetSize( 2 )
	.NewItem( solarName , function( item )
		item.place_result = SIGen.LastDataName
	end )
	.SetStackSize( SINumbers.stackSize.machine )
	.AddTo_MiningResult( SIGen.LastDataName )
	.NewRecipe( solarName , function( recipe )
		recipe.ingredients =
		{
			SITools.ProductItem( lastSolar , 10 ) ,
			SITools.ProductItem( "steel-plate" , 5 ) ,
			SITools.ProductItem( "electronic-circuit" , 15 ) ,
			SITools.ProductItem( "copper-plate" , 15 )
		}
		recipe.results = { SITools.ProductItem( SIGen.LastDataName ) }
		recipe.main_product = SIGen.LastDataName
		lastSolar = SIGen.LastDataName
		table.insert( solarList , recipe.name )
	end )
	.NewAccumulator( accName , accData , true , function( entity )
		local subPower = power:Copy():Multiply( 6 )
		entity.energy_source.input_flow_limit = subPower:Get( "W" )
		entity.energy_source.output_flow_limit = subPower:Get( "W" )
		entity.energy_source.buffer_capacity = subPower:Multiply( 36 ):Get( "J" )
	end )
	.SetSize( 2 )
	.NewItem( accName , function( item )
		item.place_result = SIGen.LastDataName
	end )
	.NewRecipe( accName , function( recipe )
		recipe.ingredients =
		{
			SITools.ProductItem( lastAcc , 10 ) ,
			SITools.ProductItem( "iron-plate" , 2 ) ,
			SITools.ProductItem( "battery" , 5 )
		}
		recipe.results = { SITools.ProductItem( SIGen.LastDataName ) }
		recipe.main_product = SIGen.LastDataName
		lastAcc = SIGen.LastDataName
		table.insert( accList , recipe.name )
	end )
end )
.LoadTechnology( "solar-energy" )
.AddEffect_Recipes( solarList )
.LoadTechnology( "electric-energy-accumulators" )
.AddEffect_Recipes( accList )
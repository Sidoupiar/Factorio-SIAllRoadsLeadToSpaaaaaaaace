-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not SIMods.base.loaded then return end

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
	damaged_trigger_effect = hit_effects.entity() ,
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
	damaged_trigger_effect = hit_effects.entity() ,
	energy_source =
	{
		type = "electric" ,
		usage_priority = "tertiary"
	} ,
	picture = accumulator_picture() ,
	water_reflection = accumulator_reflection() ,
	charge_animation = accumulator_charge() ,
	charge_cooldown = 30 ,
	charge_light = { intensity = 0.3 , size = 7 , color = SIColors.Color256( 255 , 255 , 255 ) } ,
	discharge_animation = accumulator_discharge() ,
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
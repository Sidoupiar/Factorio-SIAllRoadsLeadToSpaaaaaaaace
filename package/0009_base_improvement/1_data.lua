-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not SIMods.base.loaded then return end

local nameList =
{
	connect = { name = "联合" }
}
local solarData =
{
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.1, result = "solar-panel"},
    max_health = 200,
    corpse = "solar-panel-remnants",
    dying_explosion = "solar-panel-explosion",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    energy_source =
    {
      type = "electric",
      usage_priority = "solar"
    },
    picture =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/solar-panel/solar-panel.png",
          priority = "high",
          width = 116,
          height = 112,
          shift = util.by_pixel(-3, 3),
          hr_version =
          {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel.png",
            priority = "high",
            width = 230,
            height = 224,
            shift = util.by_pixel(-3, 3.5),
            scale = 0.5
          }
        },
        {
          filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow.png",
          priority = "high",
          width = 112,
          height = 90,
          shift = util.by_pixel(10, 6),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow.png",
            priority = "high",
            width = 220,
            height = 180,
            shift = util.by_pixel(9.5, 6),
            draw_as_shadow = true,
            scale = 0.5
          }
        }
      }
    },
    overlay =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow-overlay.png",
          priority = "high",
          width = 108,
          height = 90,
          shift = util.by_pixel(11, 6),
          hr_version =
          {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow-overlay.png",
            priority = "high",
            width = 214,
            height = 180,
            shift = util.by_pixel(10.5, 6),
            scale = 0.5
          }
        }
      }
    },
    vehicle_impact_sound = sounds.generic_impact,
    production = "60kW"
}
local accData =
{
	type = "accumulator",
    name = "accumulator",
    icon = "__base__/graphics/icons/accumulator.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.1, result = "accumulator"},
    max_health = 150,
    corpse = "accumulator-remnants",
    dying_explosion = "accumulator-explosion",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1, -1}, {1, 1}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box = {{-1, -1.5}, {1, 1}},
    energy_source =
    {
      type = "electric",
      buffer_capacity = "5MJ",
      usage_priority = "tertiary",
      input_flow_limit = "300kW",
      output_flow_limit = "300kW"
    },
    picture = accumulator_picture(),
    charge_animation = accumulator_charge(),
    water_reflection = accumulator_reflection(),
    charge_cooldown = 30,
    charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
    discharge_animation = accumulator_discharge(),
    discharge_cooldown = 60,
    discharge_light = {intensity = 0.7, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/accumulator-working.ogg",
        volume = 0.4
      },
      idle_sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0.35
      },
      --persistent = true,
      max_sounds_per_type = 3,
      audible_distance_modifier = 0.5,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },

    circuit_wire_connection_point = circuit_connector_definitions["accumulator"].points,
    circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,

    default_output_signal = {type = "virtual", name = "signal-A"}
}
local lastSolar = "solar-panel"
local lastAcc = "accumulator"
local solarList = {}

-- ------------------------------------------------------------------------------------------------
-- ------ 创建多阶太阳能板 ------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.Group( "energy" )
.ListIndicator( nameList , function( name , entityName , index )
	local solarName = entityName .. "型太阳能电池板"
	local accName = entityName .. "型蓄电器"
	SIGen.NewSolar( solarName , solarData , true , function( entity )

	end )
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

	end )
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
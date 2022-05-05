-- ------------------------------------------------------------------------------------------------
-- ---------- 原型定义 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local ashThrowAction =
{
	acceleration = 0 ,
	action =
	{
		{
			type = "direct" ,
			action_delivery =
			{
				type = "instant" ,
				target_effects =
				{
					{
						type = "create-particle" ,
						particle_name = "stone-particle" ,
						repeat_count = 3 ,
						initial_height = 0.5 ,
						initial_vertical_speed = 0.05 ,
						initial_vertical_speed_deviation = 0.1 ,
						speed_from_center = 0.05 ,
						speed_from_center_deviation = 0.1 ,
						offset_deviation = { { -0.8985 , -0.5 } , { 0.8985 , 0.5 } }
					}
				}
			}
		} ,
		{
			type = "area" ,
			radius = 0.8 ,
			action_delivery =
			{
				type = "instant" ,
				target_effects =
				{
					SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
				}
			}
		}
	}
}
local bookThrowAction = util.deepcopy( ashThrowAction )
local blockThrowAction = util.deepcopy( ashThrowAction )
local machineThrowAction = util.deepcopy( ashThrowAction )
bookThrowAction.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 ) }
blockThrowAction.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 23.0 ) }
machineThrowAction.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 42.0 ) }
local ashThrowData
{
	radius_color = SIColors.Color256( 242 , 242 , 242 , 55 ) ,
	capsule_action =
	{
		type = "throw" ,
		uses_stack = true ,
		attack_parameters =
		{
			type = "projectile" ,
			range = 16.5 ,
			cooldown = 35 ,
			activation_type = "throw" ,
			ammo_type =
			{
				category = SIConstants_Core.categoryList[SITypes.category.ammo].peopleThrow ,
				target_type = "position" ,
				action =
				{
					{
						type = "direct" ,
						action_delivery =
						{
							type = "projectile" ,
							projectile = badgeName ,
							starting_speed = 0.25
						}
					} ,
					{
						type = "direct" ,
						action_delivery =
						{
							type = "instant" ,
							target_effects =
							{
								type = "play-sound" ,
								sound = SITools.SoundList_Base( "fight/throw-projectile" , 6 , 0.4 )
							}
						}
					}
				}
			}
		}
	}
}
local bookThrowData = util.deepcopy( ashThrowData )
local blockThrowData = util.deepcopy( ashThrowData )
local machineThrowData = util.deepcopy( ashThrowData )
SIGen.Group( SIConstants_Core.group )
.NewProjectile( "扔出去的灰烬" , ashThrowAction , true , function( projectile )
	ashThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewProjectile( "扔出去的认证书" , bookThrowAction , true , function( projectile )
	bookThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewProjectile( "扔出去的废料" , blockThrowAction , true , function( projectile )
	blockThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewProjectile( "扔出去的垃圾焚烧炉" , machineThrowAction , true , function( projectile )
	machineThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Garbage.item.fuelGarbage , ashThrowData , true ).SetStackSize( 4768 )
.NewCapsule( SIConstants_Garbage.item.filterGarbage , ashThrowData , true ).SetStackSize( 4399 )
.NewCapsule( SIConstants_Garbage.item.whiteGarbage , ashThrowData , true ).SetStackSize( 5553 )
.NewCapsule( SIConstants_Garbage.item.oreGarbage , ashThrowData , true ).SetStackSize( 6172 )
.NewCapsule( SIConstants_Garbage.item.launchBook , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.epBadgeBook , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.winterBook , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.ashBook , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.brokenMachine , blockThrowData , true ).SetStackSize( SINumbers.stackSize.misc )
.NewRecipe( "垃圾焚烧" , nil , false , function( recipe )
	recipe.enabled = true
	recipe.hidden = true
	recipe.hide_from_player_crafting = true
	recipe.allow_inserter_overload = false
	recipe.allow_decomposition = false
	recipe.allow_as_intermediate = false
	recipe.allow_intermediates = false
	recipe.always_show_made_in = false
	recipe.energy_required = 10
	recipe.category = SIConstants_Garbage.categoryList[SITypes.category.recipe].garbage
	recipe.ingredients = {}
	recipe.results =
	{
		{ type = "item" , name = SIConstants_Garbage.item.filterGarbage , amount = 1, catalyst_amount = 1 } ,
		{ type = "item" , name = SIConstants_Core.item.epBadge , amount = 1 , probability = 0.04 , catalyst_amount = 1 , show_details_in_recipe_tooltip = false }
	}
	recipe.main_product = SIConstants_Garbage.item.filterGarbage
end )
.NewAssemblingMachine( "垃圾焚烧炉" , nil ,false , function( entity )
	entity.minable =
	{
		mining_time = 2.5 ,
		results =
		{
			{ type = "item" , name = SIConstants_Core.item.roundBadge , amount = 1 , probability = 0.05 , catalyst_amount = 1 , show_details_in_recipe_tooltip = false } ,
			{ type = "item" , name = SIConstants_Garbage.item.burntMachine , amount = 1 , catalyst_amount = 1 , show_details_in_recipe_tooltip = false }
		}
	}
	entity.max_health = 400
	entity.dying_explosion = "big-explosion"
	entity.corpse = "big-remnants"
	entity.loot = { { item = SIConstants_Garbage.item.brokenMachine , probability = 1.0 , count_min = 1 , count_max = 3 } }
	entity.show_recipe_icon = false
	entity.crafting_categories = { SIConstants_Garbage.categoryList[SITypes.category.recipe].garbage }
	entity.fixed_recipe = SIGen.LastDataName
	entity.energy_usage = "850KW"
	entity.energy_source =
	{
		type = "burner" ,
		fuel_inventory_size = 20 ,
		burnt_inventory_size = 20 ,
		fuel_categories = { SIConstants_Garbage.categoryList[SITypes.category.fuel].garbage } ,
		effectivity = 0.23 ,
		smoke =
		{
			{
				name = "smoke" ,
				frequency = 5 ,
				starting_vertical_speed = 0.08 ,
				starting_frame_deviation = 60 ,
				position = { 0.0 , -0.8 } ,
				deviation = { 0.1 , 0.1 }
			}
		}
	}
end )
.SetSize( 3 )
.SetAnimation4Way()
.NewCapsule( SIConstants_Garbage.item.burntMachine , machineThrowData , true , function( item )
	item.place_result = SIGen.LastDataName
end )
.SetStackSize( SINumbers.stackSize.machine )
.NewRecipe( "组装垃圾焚烧炉" , nil , false , function( recipe )
	recipe.ingredients = {}
	recipe.results =
	{
		{ type = "item" , name = SIConstants_Garbage.item.burntMachine , amount = 1 , catalyst_amount = 1 } ,
		{ type = "item" , name = SIConstants_Core.item.machineBadge , amount = 1 , probability = 0.2 , catalyst_amount = 1 , show_details_in_recipe_tooltip = false }
	}
	recipe.main_product = SIConstants_Garbage.item.burntMachine
end )

-- ------------------------------------------------------------------------------------------------
-- ---------- 数据列表 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIConstants_Garbage.settingsFuel =
{
	[SIConstants_Garbage.item.fuelGarbage] = { pass = true } ,
	[SIConstants_Garbage.item.filterGarbage] = { result = SIConstants_Garbage.item.whiteGarbage } ,
	[SIConstants_Garbage.item.whiteGarbage] = { result = SIConstants_Garbage.item.oreGarbage } ,
	[SIConstants_Garbage.item.oreGarbage] = { pass = true }
}

SIConstants_Garbage.settingsRocketLaunch =
{
	[SIConstants_Core.item.epBadge] = SIConstants_Garbage.item.epBadgeBook ,
	[SIConstants_Garbage.item.fuelGarbage] = SIConstants_Garbage.item.ashBook ,
	[SIConstants_Garbage.item.whiteGarbage] = SIConstants_Garbage.item.winterBook ,
	[SIConstants_Garbage.item.oreGarbage] = SIConstants_Garbage.item.winterBook
}

function SIConstants_Garbage.api.AddFuelSetting( name , result , fuelValue , emissionsMultiplier )
	if result then
		SIConstants_Garbage.settingsFuel[name] =
		{
			result = result ,
			fuelValue = fuelValue ,
			emissionsMultiplier = emissionsMultiplier ,
			pass = false
		}
	else SIConstants_Garbage.settingsFuel[name] = { pass = true }
end

function SIConstants_Garbage.api.AddRocketLaunchSetting( name , result )
	SIConstants_Garbage.settingsRocketLaunch[name] = result
end
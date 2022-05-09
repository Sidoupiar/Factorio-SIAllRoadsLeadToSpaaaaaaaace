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
				target_effects = nil
			}
		}
	}
}
local bookThrowAction = util.deepcopy( ashThrowAction )
local blockThrowAction = util.deepcopy( ashThrowAction )
local machineThrowAction = util.deepcopy( ashThrowAction )
ashThrowAction.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 ) }
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
							projectile = nil ,
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
.NewCapsule( SIConstants_Garbage.item.fuelResult , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder )
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
	recipe.ingredients =
	{
		SITools.IngredientItem( "coal" , 10 )
	}
	recipe.results =
	{
		SITools.ProductItem( SIConstants_Garbage.item.ashFilter , 0.15 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashFlue , 0.09 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashCore , 0.04 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashAttach , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashWhite , 0.06 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashGrey , 0.06 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashLight , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashOre , 0.03 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashDrop , 0.03 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.item.ashBroken , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Core.item.badgeEP , 0.02 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.item.ashFilter
end )
.NewAssemblingMachine( "垃圾焚烧炉" , nil ,false , function( entity )
	entity.minable =
	{
		mining_time = 2.5 ,
		results =
		{
			SITools.ProductItemHide( SIConstants_Garbage.item.burntMachine ) ,
			SITools.ProductItemHide( SIConstants_Core.item.badgeRound , 0.05 , 1 )
		}
	}
	entity.max_health = 400
	entity.dying_explosion = "big-explosion"
	entity.corpse = "big-remnants"
	entity.loot = { SITools.Loot( SIConstants_Garbage.item.brokenMachine , 1.0 , 1 , 3 ) }
	entity.show_recipe_icon = false
	entity.crafting_categories = { SIConstants_Garbage.categoryList[SITypes.category.recipe].garbage }
	entity.fixed_recipe = SIGen.LastDataName
	entity.energy_usage = "450KW"
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
	recipe.ingredients =
	{}
	recipe.results =
	{
		SITools.ProductItem( SIConstants_Garbage.item.burntMachine , 1 ) ,
		SITools.ProductItemHide( SIConstants_Core.item.badgeMachine , 0.2 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.item.burntMachine
end )
-- 灰烬系列
.NewCapsule( SIConstants_Garbage.item.ashFilter , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-7311 )
.NewCapsule( SIConstants_Garbage.item.ashFlue , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6984 )
.NewCapsule( SIConstants_Garbage.item.ashCore , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6712 )
.NewCapsule( SIConstants_Garbage.item.ashAttach , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6559 )
.NewCapsule( SIConstants_Garbage.item.ashWhite , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6309 )
.NewCapsule( SIConstants_Garbage.item.ashGrey , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6117 )
.NewCapsule( SIConstants_Garbage.item.ashLight , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5944 )
.NewCapsule( SIConstants_Garbage.item.ashOre , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5738 )
.NewCapsule( SIConstants_Garbage.item.ashDrop , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5461 )
.NewCapsule( SIConstants_Garbage.item.ashBroken , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5327 )
-- 认证书系列
.NewCapsule( SIConstants_Garbage.item.bookLaunch , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.bookBadgeEP , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.bookAsh , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.bookFog , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.bookWinter , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.item.bookCloud , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )

-- ------------------------------------------------------------------------------------------------
-- ---------- 数据列表 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIConstants_Garbage.settingsFuel =
{
	[SIConstants_Garbage.item.fuelResult] = { pass = true } ,
	[SIConstants_Garbage.item.ashFilter] = { pass = true } ,
	[SIConstants_Garbage.item.ashFlue] = { pass = true } ,
	[SIConstants_Garbage.item.ashCore] = { pass = true } ,
	[SIConstants_Garbage.item.ashAttach] = { pass = true } ,
	[SIConstants_Garbage.item.ashWhite] = { pass = true } ,
	[SIConstants_Garbage.item.ashGrey] = { pass = true } ,
	[SIConstants_Garbage.item.ashLight] = { pass = true } ,
	[SIConstants_Garbage.item.ashOre] = { pass = true } ,
	[SIConstants_Garbage.item.ashDrop] = { pass = true } ,
	[SIConstants_Garbage.item.ashBroken] = { pass = true }
}

SIConstants_Garbage.settingsRocketLaunch =
{
	[SIConstants_Core.item.badgeEP] = SIConstants_Garbage.item.bookBadgeEP ,
	[SIConstants_Garbage.item.fuelResult] = SIConstants_Garbage.item.bookAsh ,
	[SIConstants_Garbage.item.ashFilter] = SIConstants_Garbage.item.bookFog ,
	[SIConstants_Garbage.item.ashFlue] = SIConstants_Garbage.item.bookFog ,
	[SIConstants_Garbage.item.ashCore] = SIConstants_Garbage.item.bookFog ,
	[SIConstants_Garbage.item.ashAttach] = SIConstants_Garbage.item.bookFog ,
	[SIConstants_Garbage.item.ashWhite] = SIConstants_Garbage.item.bookWinter ,
	[SIConstants_Garbage.item.ashGrey] = SIConstants_Garbage.item.bookWinter ,
	[SIConstants_Garbage.item.ashLight] = SIConstants_Garbage.item.bookWinter ,
	[SIConstants_Garbage.item.ashOre] = SIConstants_Garbage.item.bookCloud ,
	[SIConstants_Garbage.item.ashDrop] = SIConstants_Garbage.item.bookCloud ,
	[SIConstants_Garbage.item.ashBroken] = SIConstants_Garbage.item.bookCloud
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
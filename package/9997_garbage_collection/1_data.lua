-- ------------------------------------------------------------------------------------------------
-- --------- 默认值定义 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local commonThrowAction =
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

local commonThrowData
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

local resultThrowAction = util.deepcopy( commonThrowAction )
local blockThrowAction = util.deepcopy( commonThrowAction )
local machineThrowAction = util.deepcopy( commonThrowAction )
local ashThrowAction = util.deepcopy( commonThrowAction )
local bookThrowAction = util.deepcopy( commonThrowAction )

local resultThrowData = util.deepcopy( commonThrowData )
local blockThrowData = util.deepcopy( commonThrowData )
local machineThrowData = util.deepcopy( commonThrowData )
local ashThrowData = util.deepcopy( commonThrowData )
local bookThrowData = util.deepcopy( commonThrowData )

SIGen.Group( SIConstants_Core.group )

-- ------------------------------------------------------------------------------------------------
-- -------- 固有物品定义 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.NewProjectile( "扔出去的燃烧灰烬" , resultThrowAction , true , function( projectile )
	resultThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 ) }
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewProjectile( "扔出去的废料" , blockThrowAction , true , function( projectile )
	blockThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 23.0 ) }
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewProjectile( "扔出去的垃圾焚烧炉" , machineThrowAction , true , function( projectile )
	machineThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 42.0 ) }
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Garbage.item.fuelResult , resultThrowData , true ).SetStackSize( SINumbers.stackSize.powder )
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
		SITools.ProductItem( SIConstants_Garbage.ash.ashFilter , 0.15 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashFlue , 0.09 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashCore , 0.04 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashAttach , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashWhite , 0.06 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashGrey , 0.06 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashLight , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashOre , 0.03 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashDrop , 0.03 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Garbage.ash.ashBroken , 0.01 , 1 , 3 ) ,
		SITools.ProductItemHide( SIConstants_Core.badge.badgeEP , 0.02 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.ash.ashFilter
end )
.NewAssemblingMachine( "垃圾焚烧炉" , nil ,false , function( entity )
	entity.minable =
	{
		mining_time = 2.5 ,
		results =
		{
			SITools.ProductItemHide( SIConstants_Garbage.item.burntMachine ) ,
			SITools.ProductItemHide( SIConstants_Core.badge.badgeRound , 0.05 , 1 )
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
.NewRecipe( "组装垃圾焚烧炉-1" , nil , false , function( recipe )
	recipe.ingredients =
	{}
	recipe.results =
	{
		SITools.ProductItem( SIConstants_Garbage.item.burntMachine , 1 ) ,
		SITools.ProductItemHide( SIConstants_Core.badge.badgeMachine , 0.2 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.item.burntMachine
end )
.NewRecipe( "组装垃圾焚烧炉-2" , nil , false , function( recipe )
	recipe.ingredients =
	{}
	recipe.results =
	{
		SITools.ProductItem( SIConstants_Garbage.item.burntMachine , 1 ) ,
		SITools.ProductItemHide( SIConstants_Core.badge.badgeMachine , 0.2 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.item.burntMachine
end )
.NewRecipe( "组装垃圾焚烧炉-2" , nil , false , function( recipe )
	recipe.ingredients =
	{}
	recipe.results =
	{
		SITools.ProductItem( SIConstants_Garbage.item.burntMachine , 1 ) ,
		SITools.ProductItemHide( SIConstants_Core.badge.badgeMachine , 0.2 , 1 )
	}
	recipe.main_product = SIConstants_Garbage.item.burntMachine
end )

-- ------------------------------------------------------------------------------------------------
-- -------- 灰烬系列定义 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.NewProjectile( "扔出去的灰烬" , ashThrowAction , true , function( projectile )
	ashThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 ) }
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Garbage.ash.ashFilter , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-7311 )
.NewCapsule( SIConstants_Garbage.ash.ashFlue , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6984 )
.NewCapsule( SIConstants_Garbage.ash.ashCore , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6712 )
.NewCapsule( SIConstants_Garbage.ash.ashAttach , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6559 )
.NewCapsule( SIConstants_Garbage.ash.ashWhite , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6309 )
.NewCapsule( SIConstants_Garbage.ash.ashGrey , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-6117 )
.NewCapsule( SIConstants_Garbage.ash.ashLight , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5944 )
.NewCapsule( SIConstants_Garbage.ash.ashOre , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5738 )
.NewCapsule( SIConstants_Garbage.ash.ashDrop , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5461 )
.NewCapsule( SIConstants_Garbage.ash.ashBroken , ashThrowData , true ).SetStackSize( SINumbers.stackSize.powder-5327 )

-- ------------------------------------------------------------------------------------------------
-- ------- 认证书系列定义 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.NewProjectile( "扔出去的认证书" , bookThrowAction , true , function( projectile )
	bookThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 3.0 ) }
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Garbage.book.bookLaunch , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.book.bookBadge , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.book.bookAsh , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.book.bookFog , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.book.bookWinter , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )
.NewCapsule( SIConstants_Garbage.book.bookCloud , bookThrowData , true ).SetStackSize( SINumbers.stackSize.material )

-- ------------------------------------------------------------------------------------------------
-- ---------- 数据列表 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIConstants_Garbage.settingsFuel =
{
	[SIConstants_Garbage.item.fuelResult] = { pass = true } ,
	[SIConstants_Garbage.ash.ashFilter] = { pass = true } ,
	[SIConstants_Garbage.ash.ashFlue] = { pass = true } ,
	[SIConstants_Garbage.ash.ashCore] = { pass = true } ,
	[SIConstants_Garbage.ash.ashAttach] = { pass = true } ,
	[SIConstants_Garbage.ash.ashWhite] = { pass = true } ,
	[SIConstants_Garbage.ash.ashGrey] = { pass = true } ,
	[SIConstants_Garbage.ash.ashLight] = { pass = true } ,
	[SIConstants_Garbage.ash.ashOre] = { pass = true } ,
	[SIConstants_Garbage.ash.ashDrop] = { pass = true } ,
	[SIConstants_Garbage.ash.ashBroken] = { pass = true }
}

SIConstants_Garbage.settingsRocketLaunch =
{
	[SIConstants_Garbage.item.fuelResult] = SIConstants_Garbage.book.bookAsh ,
	[SIConstants_Garbage.ash.ashFilter] = SIConstants_Garbage.book.bookFog ,
	[SIConstants_Garbage.ash.ashFlue] = SIConstants_Garbage.book.bookFog ,
	[SIConstants_Garbage.ash.ashCore] = SIConstants_Garbage.book.bookFog ,
	[SIConstants_Garbage.ash.ashAttach] = SIConstants_Garbage.book.bookFog ,
	[SIConstants_Garbage.ash.ashWhite] = SIConstants_Garbage.book.bookWinter ,
	[SIConstants_Garbage.ash.ashGrey] = SIConstants_Garbage.book.bookWinter ,
	[SIConstants_Garbage.ash.ashLight] = SIConstants_Garbage.book.bookWinter ,
	[SIConstants_Garbage.ash.ashOre] = SIConstants_Garbage.book.bookCloud ,
	[SIConstants_Garbage.ash.ashDrop] = SIConstants_Garbage.book.bookCloud ,
	[SIConstants_Garbage.ash.ashBroken] = SIConstants_Garbage.book.bookCloud
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
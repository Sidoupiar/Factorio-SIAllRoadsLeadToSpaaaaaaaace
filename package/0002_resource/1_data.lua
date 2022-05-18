-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local normalOreData = {}
local shineOreData =
{
	effect_animation_period = 5 ,
	effect_animation_period_deviation = 1 ,
	effect_darkness_multiplier = 3.6 ,
	min_effect_alpha = 0.2 ,
	max_effect_alpha = 0.3
}
local stoneData =
{
	max_health = 511000 ,
	resistances =
	{
		SITools.Resistance( SIConstants_Core.damage.physical , 35 , 0.95 ) ,
		SITools.Resistance( SIConstants_Core.damage.impact , 55 , 0.78 ) ,
		SITools.Resistance( SIConstants_Core.damage.poison , 15 , 0.99 ) ,
		SITools.Resistance( SIConstants_Core.damage.explosion , 5 , 0.1 ) ,
		SITools.Resistance( SIConstants_Core.damage.fire , 200 , 0.99 ) ,
		SITools.Resistance( SIConstants_Core.damage.laser , 5 , 0.15 ) ,
		SITools.Resistance( SIConstants_Core.damage.acid , 12 , 0.88 ) ,
		SITools.Resistance( SIConstants_Core.damage.electric , 25 , 0.64 )
	}
}
local oreThrowAction =
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
local oreThrowData =
{
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

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建矿物 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.Group( SICConstants_Core.group.material , "矿物" )
-- 岩心石
.NewResource( "蛋白矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneOpal ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的蛋白石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneOpal , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "方刚矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneHard ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的方刚石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneHard , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "绵滑矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneSlide ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的绵滑石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneSlide , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "沧溟矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneSea ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的沧溟石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneSea , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "苔芜矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneGrass ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的苔芜石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneGrass , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "韧铠矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneArmor ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的韧铠石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneArmor , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "影山矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneShadow ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的影山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneShadow , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "灿光矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.stoneBright ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 0.08 , 1 , 5 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreSplit , 0.08 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的灿光石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.stoneBright , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
-- 变相石
.NewResource( "灼热矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeHeat ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的灼热石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeHeat , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "沉沦矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeDrown ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的沉沦石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeDrown , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "血肉矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeMeat ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的血肉石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeMeat , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "浊风矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeWind ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的浊风石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeWind , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "阴森矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeGloomy ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的阴森石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeGloomy , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "冰凌矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeCold ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的冰凌石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeCold , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "绯红矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeRed ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的绯红石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeRed , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "黑晶矿" , normalOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.changeBlack ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreMagic , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePolluted , 0.02 , 2 , 12 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的黑晶石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.changeBlack , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
-- 夹层石
.NewResource( "清水矿" , shineOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.waterClear ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellWhole , 0.004 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellHalf , 0.016 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellSplit , 0.08 , 1 , 6 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinWhole , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinHalf , 0.005 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinSplit , 0.03 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的清水石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.waterClear , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "火苗矿" , shineOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.waterFire ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellWhole , 0.004 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellHalf , 0.016 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellSplit , 0.08 , 1 , 6 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinWhole , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinHalf , 0.005 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinSplit , 0.03 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的火苗石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.waterFire , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "悠远矿" , shineOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.waterTime ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellWhole , 0.004 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellHalf , 0.016 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellSplit , 0.08 , 1 , 6 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinWhole , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinHalf , 0.005 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinSplit , 0.03 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的悠远石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.waterTime , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "宁寂矿" , shineOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.waterQuiet ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellWhole , 0.004 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellHalf , 0.016 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellSplit , 0.08 , 1 , 6 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinWhole , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinHalf , 0.005 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinSplit , 0.03 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的宁寂石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.waterQuiet , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )
.NewResource( "凄辉矿" , shineOreData , true , function( resource )
	resource.minable =
	{
		results =
		{
			SITools.ProductItem( SIConstants_Resource.ore.waterBright ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellWhole , 0.004 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellHalf , 0.016 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.shellSplit , 0.08 , 1 , 6 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinWhole , 0.001 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinHalf , 0.005 , 1 ) ,
			SITools.ProductItemHide( SIConstants_Resource.other.veinSplit , 0.03 , 1 , 5 )
		}
	}
	resource.category = ""
end )
.SetMapColor( SIColor.Color256( 127 , 127 , 127 ) )
.SetSize( 1 )
.SetStages()
.AutoMiningTime( 2 )
.SetAutoPlace
{
	order = "d" ,
	base_density = 0.9 ,
	base_spots_per_km2 = 1.25 ,
	random_spot_size_minimum = 2 ,
	random_spot_size_maximum = 4 ,
	regular_rq_factor_multiplier = 1 ,
	has_starting_area_placement = false
}
.NewProjectile( "扔出去的凄辉石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.ore.waterBright , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.ore )

-- ------------------------------------------------------------------------------------------------
-- --------- 创建矿山石 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.Group( SICConstants_Core.group.material , "矿山石" )
.NewProjectile( "扔出去的矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCore , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的韧性矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreTough , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的刚性矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreHard , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的矿山石的粉末" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCorePowder , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.powder )
.NewProjectile( "扔出去的多孔的矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreBubble , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的脆性矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreBrittle , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的颤性矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreShake , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的碎裂的矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreSplit , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.powder )
.NewProjectile( "扔出去的魔化矿山石" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCoreMagic , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialBig )
.NewProjectile( "扔出去的被污染的矿山石的粉末" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.stoneCorePolluted , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.powder )
.ListIndicator( { "rock-big" , "rock-huge" , "sand-rock-big" } , function( index , entityName , count )
	local subStoneData = util.deepcopy( stoneData )
	subStoneData.name = "矿山石-" .. index
	SIGen.CopySimpleEntity( entityName , subStoneData , true , function( entity )
		entity.minable =
		{
			mining_time = 33 ,
			result = nil ,
			count = nil ,
			results =
			{
				SITools.ProductItem( SIConstants_Resource.other.stoneCore , 1.0 , 1 , 5 ) ,
				SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreTough , 0.35 , 1 , 2 ) ,
				SITools.ProductItemHide( SIConstants_Resource.other.stoneCoreHard , 0.35 , 1 , 2 ) ,
				SITools.ProductItemHide( SIConstants_Resource.other.stoneCorePowder , 1.0 , 3 , 15 ) ,
			}
		}
		entity.loot =
		{
			SITools.Loot( SIConstants_Resource.other.stoneCoreBubble , 1.0 , 1 , 5 ) ,
			SITools.Loot( SIConstants_Resource.other.stoneCoreBrittle , 0.35 , 1 , 2 ) ,
			SITools.Loot( SIConstants_Resource.other.stoneCoreShake , 0.35 , 1 , 2 ) ,
			SITools.Loot( SIConstants_Resource.other.stoneCoreSplit , 1.0 , 3 , 15 )
		}
	end )
	.AddFlag{ SIFlags.entityFlags.notOnMap }
	.AddCollisionMask
	{
		SIFlags.collisionMasks.water ,
		SIFlags.collisionMasks.item ,
		SIFlags.collisionMasks.object ,
		SIFlags.collisionMasks.player ,
		SIFlags.collisionMasks.notCollidingWithItself
	}
end )

-- ------------------------------------------------------------------------------------------------
-- --------- 创建矿石壳 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.Group( SICConstants_Core.group.material , "矿石壳" )
.NewProjectile( "扔出去的矿石壳" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.shellWhole , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialNormal )
.NewProjectile( "扔出去的半矿石壳" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.shellHalf , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialNormal )
.NewProjectile( "扔出去的矿石壳屑" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.shellSplit , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialTiny )

-- ------------------------------------------------------------------------------------------------
-- --------- 创建矿石脉 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.Group( SICConstants_Core.group.material , "矿石脉" )
.NewProjectile( "扔出去的矿石脉" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.veinWhole , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialNormal )
.NewProjectile( "扔出去的断裂的矿石脉" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.veinHalf , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialNormal )
.NewProjectile( "扔出去的矿石脉屑" , util.deepcopy( oreThrowAction ) , true , function( projectile )
	oreThrowData.radius_color = SIColors.Color256( 242 , 242 , 242 , 55 )
	oreThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.action[2].action_delivery.target_effects =
	{
		SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 )
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.NewCapsule( SIConstants_Resource.other.veinSplit , util.deepcopy( oreThrowData ) , true ).SetStackSize( SINumber.stackSize.materialTiny )
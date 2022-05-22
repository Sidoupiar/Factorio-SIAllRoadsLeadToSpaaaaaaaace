-- ------------------------------------------------------------------------------------------------
-- --------- 创建默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for name , groupName in pairs( SIConstants_Core.group ) do SIGen.Group( groupName , "基础" ) end

local throwData =
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

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建分组 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.ListIndicator( SIConstants_Core.group , function( name , groupName , index )
	SIGen.Group( groupName , "基础" )
end )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建徽章 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.Group( SIConstants_Core.group.mics , "徽章" )
.NewProjectile( "扔出去的徽章" , function( projectile )
	throwData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
	projectile.acceleration = 0
	projectile.action =
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
					SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 3.0 )
				}
			}
		}
	}
end )
.SetSize( 1 )
.SetAnimation( 0.5 )
.ListIndicator( SIConstants_Core.item , function( name , itemName , index )
	SIGen.NewCapsule( itemName , throwData , true ).SetStackSize( SINumbers.stackSize.badge )
end )
-- ------------------------------------------------------------------------------------------------
-- --------- 定义默认值 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local moneyThrowAction =
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
local moneyThrowData
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
-- ---------- 创建货币 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.Group( SIConstants_Core.group.misc , "货币" )
for name , itemName in pairs( SIConstants_Trade.money ) do
	SIGen
	.NewProjectile( "投掷物-"..itemName , util.deepcopy( moneyThrowAction ) , true , function( projectile )
		moneyThrowData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = projectile.name
		projectile.action[2].action_delivery.target_effects = { SITools.Attack_EffectDamage( SIConstants_Core.damage.physical , 1.0 ) }
	end )
	.SetSize( 1 )
	.SetAnimation( 0.5 )
	.NewCapsule( itemName , util.deepcopy( moneyThrowData ) , true ).SetStackSize( SINumber.stackSize.physicalMoney )
end
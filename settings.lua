data:extend
{
	{
		type = "boolean-setting" ,
		setting_type = "startup" ,
		name = "SIALTS-showPatreon" ,
		localised_name = { "SISetting-name.SIALTS-showPatreon" } ,
		localised_description = { "SI-common.description" , "总体设置" , { "SISetting-description.SIALTS-showPatreon" } } ,
		default_value = true ,
		order = 1
	} ,
	{
		type = "boolean-setting" ,
		setting_type = "startup" ,
		name = "SIALTS-debug" ,
		localised_name = { "SISetting-name.SIALTS-debug" } ,
		localised_description = { "SI-common.description" , "总体设置" , { "SISetting-description.SIALTS-debug" } } ,
		default_value = false ,
		order = 2
	}
}

require( "utils" )
SIInit.AutoLoad( SIInit.StateDefine.Settings )
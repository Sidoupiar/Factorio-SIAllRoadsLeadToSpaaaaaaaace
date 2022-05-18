-- ------------------------------------------------------------------------------------------------
-- ---- 根据徽章列表添加产物 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.ListIndicator( SIConstants_Core.badge , function( name , itemName , index )
	SIConstants_Garbage.api.AddRocketLaunchSetting( SIConstants_Garbage.book.bookBadge )
end )
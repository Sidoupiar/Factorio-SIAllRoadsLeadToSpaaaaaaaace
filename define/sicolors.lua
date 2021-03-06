local SIColors =
{
	baseColor =
	{
		baseWhite = { r = 1.00 , g = 1.00 , b = 1.00 } , -- 纯白
		baseBlack = { r = 0.00 , g = 0.00 , b = 0.00 } , -- 纯黑
		
		yellow    = { r = 1.00 , g = 0.78 , b = 0.00 } , -- 黄
		white     = { r = 0.88 , g = 0.88 , b = 0.88 } , -- 白
		red       = { r = 0.82 , g = 0.00 , b = 0.00 } , -- 红
		green     = { r = 0.31 , g = 0.90 , b = 0.00 } , -- 绿
		clay      = { r = 0.12 , g = 0.88 , b = 0.78 } , -- 青
		blue      = { r = 0.12 , g = 0.27 , b = 0.86 } , -- 蓝
		pink      = { r = 0.94 , g = 0.35 , b = 0.67 } , -- 粉
		purple    = { r = 0.67 , g = 0.00 , b = 0.67 } , -- 紫
		orange    = { r = 0.94 , g = 0.55 , b = 0.00 } , -- 橙
		gray      = { r = 0.50 , g = 0.50 , b = 0.50 }   -- 灰
	} ,
	printColor =
	{
		white     = { r = 0.88 , g = 0.88 , b = 0.88 } , -- 白
		red       = { r = 1.00 , g = 0.40 , b = 0.40 } , -- 红
		green     = { r = 0.45 , g = 0.94 , b = 0.09 } , -- 绿
		blue      = { r = 0.28 , g = 0.64 , b = 0.96 } , -- 蓝
		yellow    = { r = 1.00 , g = 1.00 , b = 0.40 } , -- 黄
		orange    = { r = 1.00 , g = 0.70 , b = 0.40 }   -- 橙
	} ,
	damageBeamColor =
	{
		physical  = { r = 0.90 , g = 0.65 , b = 0.22 } ,
		impact    = { r = 0.50 , g = 0.50 , b = 0.50 } ,
		poison    = { r = 0.43 , g = 0.86 , b = 0.24 } ,
		explosion = { r = 0.90 , g = 0.06 , b = 0.65 } ,
		fire      = { r = 0.90 , g = 0.31 , b = 0.06 } ,
		laser     = { r = 0.92 , g = 0.16 , b = 0.16 } ,
		acid      = { r = 0.84 , g = 0.92 , b = 0.16 } ,
		electric  = { r = 0.06 , g = 0.41 , b = 0.90 } ,
		curse     = { r = 0.15 , g = 0.15 , b = 0.15 } ,
		other     = { r = 1.00 , g = 1.00 , b = 1.00 }
	} ,
	tintColor =
	{
		default   = { r = 0.30 , g = 0.30 , b = 0.30 , a = 0.30 }   -- 深灰
	} ,
	fontColor =
	{
		black     = { r = 1.00 , g = 1.00 , b = 1.00 }   -- 黑色
	} ,
	buttonColor =
	{
		default   = { r = 0.01 , g = 0.01 , b = 0.01 , a = 0.40 } , -- 默认颜色
		gray      = { r = 0.90 , g = 0.90 , b = 0.30 , a = 0.50 } , -- 灰色
		green     = { r = 0.35 , g = 1.00 , b = 0.35 , a = 0.50 } , -- 绿色
		red       = { r = 1.00 , g = 0.35 , b = 0.35 , a = 0.50 }   -- 红色
	} ,

	Color = function( r , g , b , a )
		local color = {}
		if r then color.r = r
		else color.r = 0.0 end
		if g then color.g = g
		else color.g = 0.0 end
		if b then color.b = b
		else color.b = 0.0 end
		if a then color.a = a
		else color.a = 1.0 end
		return color
	end ,
	Color256 = function( r , g , b , a )
		local color = {}
		if r then color.r = r / 256.0
		else color.r = 0.0 end
		if g then color.g = g / 256.0
		else color.g = 0.0 end
		if b then color.b = b / 256.0
		else color.b = 0.0 end
		if a then color.a = a / 256.0
		else color.a = 1.0 end
		return color
	end
}
return SIColors
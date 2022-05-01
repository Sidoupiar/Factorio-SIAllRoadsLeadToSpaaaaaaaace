local SITools =
{
	CopyData = function( curData , customData , needOverwrite )
		if not curData then curData = {} end
		if not customData or SITools.IsNotTable( customData ) then return curData end
		for key , value in pairs( customData ) do
			if curData[key] then
				if needOverwrite then curData[key] = value end
			else curData[key] = value end
		end
		return curData
	end ,

	IsTable = function( data )
		return type( data ) == "table"
	end ,
	IsNotTable = function( data )
		return type( data ) ~= "table"
	end ,
	IsString = function( data )
		return type( data ) == "string"
	end ,
	IsNotString = function( data )
		return type( data ) ~= "string"
	end ,
	IsNumber = function( data )
		return type( data ) == "number"
	end ,
	IsNotNumber = function( data )
		return type( data ) ~= "number"
	end
}

return SITools
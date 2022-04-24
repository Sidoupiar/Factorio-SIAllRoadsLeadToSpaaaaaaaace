local SITools =
{
	CopyData = function( curData , customData , needOverwrite )
		if not curData then curData = {} end
		if not customData or type( customData ) ~= "table" then return curData end
		for key , value in pairs( customData ) do
			if curData[key] then
				if needOverwrite then curData[key] = value end
			else curData[key] = value end
		end
		return curData
	end
}

return SITools
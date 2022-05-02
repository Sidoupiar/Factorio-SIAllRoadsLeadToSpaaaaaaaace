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

	NumberLength = function( number )
		number = math.abs( number )
		local length = 0
		while number > 0 do
			length = length + 1
			number = math.floor( number/10 )
		end
		return length
	end ,
	NumberToString = function( number , length )
		local str = "" .. number
		while str:len() < length do str = "0" .. str end
		return str
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
	end ,

	Attack_EffectDamage = function( damageType , amount )
		return
		{
			type = "damage" ,
			damage = { type = damageType , amount = amount }
		}
	end ,

	BoundBox = function( width , height )
		height = height or width
		halfWidth = width / 2.0
		halfHeight = height / 2.0
		return { { -halfWidth , -halfHeight } , { halfWidth , halfHeight } }
	end ,
	BoundBox_Collision = function( width , height )
		width = width * 0.95
		height = height and height * 0.95 or width
		halfWidth = width / 2.0
		halfHeight = height / 2.0
		return { { -halfWidth , -halfHeight } , { halfWidth , halfHeight } }
	end ,

	Sound = function( file , volume , minSpeed , maxSpeed )
		local sound = { filename = file , volume = volume or SISounds.baseVolume }
		if minSpeed then sound.min_speed = minSpeed end
		if maxSpeed then sound.max_speed = maxSpeed end
		return sound
	end ,
	Sounds = function( fileOrList , volume , minSpeed , maxSpeed )
		if SITools.IsTable( fileOrList ) then
			local sounds = {}
			for i , v in pairs( fileOrList ) do table.insert( sounds , SISounds.Sound( v , volume , minSpeed , maxSpeed ) ) end
			return sounds
		else return { SISounds.Sound( fileOrList , volume , minSpeed , maxSpeed ) } end
	end ,
	SoundList_Base = function( soundName , count , volume , startIndex )
		volume = volume or SISounds.baseVolume
		startIndex = startIndex or 1
		local length = count + startIndex - 1
		local countLength = SITools.NumberLength( length )
		local soundList = {}
		for i = startIndex , length , 1 do table.insert( soundList , SITools.Sound( "__base__/sound/"..soundName.."-"..SITools.NumberToString( i , countLength )..".ogg" , volume ) ) end
		return soundList
	end
}

return SITools
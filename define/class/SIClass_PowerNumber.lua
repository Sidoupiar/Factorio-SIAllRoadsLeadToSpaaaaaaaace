SIClass_PowerNumber =
{
	UnitList = { "" , "K" , "M" , "G" , "T" , "P" , "E" , "X" , "Y" }
}

function SIClass_PowerNumber.New( number )
	local last = number:sub( -1 ):upper()
	for index , unitName in pairs( SIClass_PowerNumber.UnitList ) do
		if last == unitName then
			local curNumber = math.abs( tonumber( number:sub( 1 , -2 ) ) or 0 )
			local tier = index
			if curNumber == 0 then tier = 1 end
			return setmetatable( { number = curNumber , tier = tier } , SIClass_PowerNumber )
		end
	end
	return setmetatable( { number = tonumber( number ) or 0 , tier = 1 } , SIClass_PowerNumber )
end

function SIClass_PowerNumber:Copy()
	return setmetatable( { number = self.numebr , tier = self.tier } , SIClass_PowerNumber )
end

function SIClass_PowerNumber:Multiply( number )
	self.number = self.number * math.abs( number )
	while self.number > 1000.0 and self.tier <= #SIClass_PowerNumber.UnitList do
		self.number = self.number / 1000.0
		self.tier = self.tier + 1
	end
	return self
end

function SIClass_PowerNumber:Divide( number )
	self.number = self.number / math.abs( number )
	while self.number < 1.0 and self.tier > 1 do
		self.number = self.number * 1000.0
		self.tier = self.tier - 1
	end
	return self
end

function SIClass_PowerNumber:Get( unit )
	return self.number .. SIClass_PowerNumber.UnitList[self.tier] .. ( unit and unit:upper() or "" )
end
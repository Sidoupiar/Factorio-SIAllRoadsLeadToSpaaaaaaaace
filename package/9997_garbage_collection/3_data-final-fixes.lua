local fuelTypes = {}

SIGen.TypeIndicator( SITypes.category.fuel , function( index , prototype )
	if prototype and prototype.name then table.insert( fuelTypes , prototype.name ) end
end )

for _ typeName in pairs( SITypes.item ) do
	SIGen.TypeIndicator( typeName , function( index , prototype )
		
	end )
end
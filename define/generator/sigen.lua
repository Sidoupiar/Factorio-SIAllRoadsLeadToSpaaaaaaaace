SIGen =
{
	AutoFillData = {}
}

local AutoFillSource =
{

}

local function PutParentAutoFillData( data , parentType )
	if AutoFillSource[parentType] then
		local parent = AutoFillSource[parentType]
		if parent.defaultValues then
			for key , value in pairs( parent.defaultValues ) do
				if not data.defaultValues[key] then data.defaultValues[key] = value end
			end
		end
		if parent.parent then PutParentAutoFillData( data , parent.parent ) end
	end
end

for type , data in pairs( AutoFillSource ) do
	if not data.defaultValues then data.defaultValues = {} end
	if data.parent then PutParentAutoFillData( data , data.parent ) end
	local newData =
	{
		defaultValues = data.defaultValues ,
		callBack = data.callBack
	}
	SIGen.AutoFillData[type] = util.deepcopy( newData )
	if data.types then
		for index , typeName in pairs( data.types ) do SIGen.AutoFillData[typeName] = util.deepcopy( newData ) end
	end
end
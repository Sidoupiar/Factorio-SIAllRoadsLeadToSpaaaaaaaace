SIGen =
{
	Data = nil
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local AutoFillData = {}
local GroupSettings = {}
local Raw = {}

local AutoFillSource =
{
	"item" =
	{
		icon_size = 32 ,
		icon_mipmap = 4
	}
}

for type , data in pairs( AutoFillSource ) do
	if not data.defaultValues then data.defaultValues = {} end
	if data.parent then
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
		PutParentAutoFillData( data , data.parent )
	end
	local newData =
	{
		defaultValues = data.defaultValues ,
		callBack = data.callBack
	}
	AutoFillData[type] = util.deepcopy( newData )
	if data.types then
		for index , typeName in pairs( data.types ) do AutoFillData[typeName] = util.deepcopy( newData ) end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 内部方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local function Init( type , name , customData , needOverwrite )
	local curData =
	{
		type = type ,
		name = name
	}
	SITools.CopyData( curData , customData , needOverwrite )
	return curData
end

local function Append( data )
	SIGen.Data = data
	local list = Raw[data.type]
	if not list then
		list = {}
		Raw[data.type] = list
	end
	list[data.name] = data
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 查询实体 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.FindData( type , name )
	local list = data.raw[type]
	local curData = nil
	if list then curData = list[name]
	if not curData then
		list = Raw[type]
		if list then curData = list[name] end
	end
	return curData
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 分组控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.Group( groupName , subGroupName )
	
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建实体 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.New( type , name , customData , needOverwrite )
	return Append( Init( type , name , customData , needOverwrite ) )
end

function SIGen.Load( type , name , customData , needOverwrite )
	local curData = SIGen.FindData( type , name )
	if not curData then e( "找不到类型为["..type.."] , 名称为["..name.."]的数据" ) end
	if curData.type ~= customData.type or curData.name ~= customData.name then Append( curData ) end
	SITools.CopyData( curData , customData , needOverwrite )
	return SIGen
end

function SIGen.Copy( type , name , customData , needOverwrite )
	local curData = SIGen.FindData( type , name )
	if curData then SITools.CopyData( curData , customData , needOverwrite )
	else curData = Init( type , name , customData , needOverwrite ) end
	return Append( util.deepcopy( curData ) )
end

for index , typeName in pairs( SITypes.all ) do
	local functionName = typeName:ToFunctionName()
	SIGen["New"..functionName] = function( name , customData , needOverwrite )
		return SIGen.New( typeName , name , customData , needOverwrite )
	end
	SIGen["Load"..functionName] = function( name , customData , needOverwrite )
		return SIGen.Load( typeName , name , customData , needOverwrite )
	end
	SIGen["Copy"..functionName] = function( name , customData , needOverwrite )
		return SIGen.Copy( typeName , name , customData , needOverwrite )
	end
end
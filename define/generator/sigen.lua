SIGen =
{
	Data = nil
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local GroupSettings =
{
	groupName = nil ,
	subGroupName = nil
}
local GenIndex = 100000
local AutoFillData = {}
local Raw = {}

-- ------------------------------------------------------------------------------------------------
-- ---------- 内部方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local function Init( type , name , customData , needOverwrite )
	if not GroupSettings.currentGroupData then
		e( "创建原型时必须先定义所在的分组" )
		return nil
	end
	GenIndex = GenIndex + 1
	local realName = SIInit.CurrentConstants.AutoName( name , type )
	local curData =
	{
		type = type ,
		name = realName ,
		localised_name = { "SI-name."..realName } ,
		localised_description = { "SI-description."..realName } ,
		icon = SIInit.CurrentConstants.GetPicturePath( name , type ) ,
		group = GroupSettings.groupName ,
		subgroup = GroupSettings.subGroupName ,
		order = SIInit.CurrentConstants.AutoOrder() ,
		sourceName = name ,
		fromSIGen = true ,
		indexSIGen = GenIndex
	}
	local autoFillData = AutoFillData[type]
	if autoFillData then
		if autoFillData.defaultValues then SITools.CopyData( curData , autoFillData.defaultValues , false ) end
		if autoFillData.callBack then autoFillData.callBack() end
	end
	SITools.CopyData( curData , customData , needOverwrite )
	return Append( curData )
end

local function Append( curData )
	SIGen.Data = curData
	local list = Raw[curData.type]
	if not list then
		list = {}
		Raw[curData.type] = list
	end
	list[curData.sourceName or curData.name] = curData
	return SIGen
end

local function Check()
	if not SIGen.Data then
		e( "必须先创建原型 , 之后才能修改属性" )
		return true
	end
	return false
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 查询实体 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.FindData( type , name )
	local curData = nil
	local list = data.raw[type]
	if list then
		curData = list[name]
		if curData then curData.fromSIGen = false end
	end
	if not curData then
		list = Raw[type]
		if list then
			curData = list[name]
			if curData then curData.fromSIGen = true end
		end
	end
	return curData
end

function SIGen.GetRaw()
	return Raw
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 分组控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.Group( groupName , subGroupName )
	local group = nil
	local subGroup = nil
	local list = data.raw[SITypes.group]
	if list then
		group = list[groupName]
		if not group then group = list[SICORE.AutoName( groupName , SITypes.group )] end
	end
	if group then
		list = data.raw[SITypes.subgroup]
		if list then
			subgroup = list[subGroupName]
			if not subGroup then subGroup = list[SIInit.CurrentConstants.AutoName( subGroupName , SITypes.subgroup )] end
		end
	end
	if not group then
		local name = SICORE.AutoName( groupName , SITypes.group )
		group =
		{
			type = SITypes.group ,
			name = name ,
			localised_name = { "item-group-name."..name } ,
			localised_description = { "item-group-description."..name }
			icon = SICORE.GetPicturePath( name , SITypes.group ) ,
			order = SICORE.AutoOrder()
		}
		data:extend{ group }
	end
	if not subGroup then
		subGroup =
		{
			type = SITypes.subgroup ,
			name = SIInit.CurrentConstants.AutoName( groupName , SITypes.subgroup ) ,
			group = group.name ,
			order = SIInit.CurrentConstants.AutoOrder()
		}
		data:extend{ subGroup }
	end
	GroupSettings.groupName = group.name
	GroupSettings.subGroupName = subGroup.name
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建实体 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.New( type , name , customData , needOverwrite )
	if not type or not name then
		e( "创建原型时 type 和 name 均不能为空 , 当前 type 为["..type.."] , name 为["..name.."]" )
		return SIGen
	end
	return Init( type , name , customData , needOverwrite )
end

function SIGen.Load( type , name , customData , needOverwrite )
	if not type or not name then
		e( "创建原型时 type 和 name 均不能为空 , 当前 type 为["..type.."] , name 为["..name.."]" )
		return SIGen
	end
	local curData = SIGen.FindData( type , name )
	if not curData then e( "找不到 type 为["..type.."] , name 为["..name.."]的原型" ) end
	SITools.CopyData( curData , customData , needOverwrite )
	if customData.type and type ~= customData.type or customData.name and name ~= customData.name then
		if curData.fromSIGen then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		if customData.name then customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type ) end
		Append( curData )
	end
	return SIGen
end

function SIGen.Copy( type , name , customData , needOverwrite )
	if not type or not name then
		e( "创建原型时 type 和 name 均不能为空 , 当前 type 为["..type.."] , name 为["..name.."]" )
		return SIGen
	end
	local curData = SIGen.FindData( type , name )
	if curData then
		if customData.name then customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type ) end
		return Append( SITools.CopyData( util.deepcopy( curData ) , util.deepcopy( customData ) , needOverwrite ) )
	else return Init( type , name , util.deepcopy( customData ) , needOverwrite ) end
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

-- ------------------------------------------------------------------------------------------------
-- ---------- 修改属性 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.SetCustomData( customData , needOverwrite )
	if Check() then return SIGen end
	local type = SIGen.Data.type
	local name = SIGen.Data.name
	if customData.name then customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or type ) end
	SITools.CopyData( SIGen.Data , customData , needOverwrite )
	if customData.type and type ~= customData.type or customData.name and name ~= customData.name then
		if SIGen.Data.fromSIGen then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		Append( SIGen.Data )
	end
	return SIGen
end

function SIGen.SetType( newType )
	if Check() then return SIGen end
	if not newType then return SIGen end
	local type = SIGen.Data.type
	if type ~= newType then
		local name = SIGen.Data.name
		if SIGen.Data.fromSIGen then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		SIGen.Data.type = newType
		SIGen.Data.name = SIInit.CurrentConstants.AutoName( SIInit.CurrentConstants.RemoveAutoName( name , type ) , newType )
		Append( SIGen.Data )
	end
	return SIGen
end

function SIGen.SetName( newName )
	if Check() then return SIGen end
	if not newName then return SIGen end
	local type = SIGen.Data.type
	local name = SIGen.Data.name
	newName = SIInit.CurrentConstants.AutoName( newName , type )
	if name ~= newName then
		if SIGen.Data.fromSIGen then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		SIGen.Data.name = newName
		Append( SIGen.Data )
	end
	return SIGen
end

function SIGen.ValueSet( key , value )
	if Check() then return SIGen end
	if key == "type" then return SIGen.SetType( value )
	else if key == "name" then return SIGen.SetName( value )
	else if key:find( "." ) then
		local curData = SIGen.Data
		local keys = key:Split( "." )
		local keyLength = #keys
		for index = 1 , keyLength , 1 do
			local curKey = keys[index]
			if index == keyLength then
				if curKey == "" then table.insert( curData , value )
				else curData[curKey] = value end
			else curData = curData[curKey] end
		end
	else SIGen.Data[key] = value end
	return SIGen
end

function SIGen.ValueRemove( key )
	if Check() then return SIGen end
	if key ~= "type" and key ~= "name" then
		if key:find( "." ) then
			local curData = SIGen.Data
			local keys = key:Split( "." )
			local keyLength = #keys
			for index = 1 , keyLength , 1 do
				local curKey = keys[index]
				if index == keyLength then
					local number = tonumber( curKey )
					if number then table.remove( curData , number )
					else if curKey == "" then table.remove( curData )
					else curData[curKey] = nil end
				else curData = curData[curKey] end
			end
		else SIGen.Data[key] = nil end
	end
	return SIGen
end

function SIGen.ListSet( key , value , index )
	if Check() then return SIGen end
	return SIGen.ValueSet( key.."."..( index and index or "" ) , value )
end

function SIGen.ListRemove( key , value , index )
	if Check() then return SIGen end
	return SIGen.ValueRemove( key.."."..( index and index or "" ) , value )
end

function SIGen.ListAdd( key , value , index )
	if Check() then return SIGen end
	if key ~= "type" and key ~= "name" then
		local curData = SIGen.Data
		if key:find( "." ) then
			local keys = key:Split( "." )
			local keyLength = #keys
			for index = 1 , keyLength , 1 do curData = curData[curKey] end
		end
		if index then table.insert( curData[key] , index , value )
		else table.insert( curData[key] , value ) end
	end
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 流程控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.Clean()
	SIGen.Data = nil
	GroupSettings =
	{
		groupName = nil ,
		subGroupName = nil
	}
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 自动填充 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local AutoFillSource =
{
	"item" =
	{
		defaultValues =
		{
			icon_size = SINumbers.iconSize ,
			icon_mipmaps = SINumbers.mipMaps
		}
	} ,
	"item2" =
	{
		types = SITypes.stackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = 100 ,
			stackable = true
		}
	} ,
	"item3" =
	{
		types = SITypes.unstackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = 1 ,
			stackable = false
		}
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
	if data.types then
		for index , typeName in pairs( data.types ) do AutoFillData[typeName] = util.deepcopy( newData ) end
	end
end

AutoFillSource = nil
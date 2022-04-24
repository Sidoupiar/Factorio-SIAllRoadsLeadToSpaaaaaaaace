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
local GenIndex = 100000

local AutoFillSource =
{
	"item" =
	{
		icon_size = 64 ,
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
	GenIndex = GenIndex + 1
	local curData =
	{
		type = type ,
		name = name ,
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
	list[curData.name] = curData
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 查询实体 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIGen.FindData( type , name )
	local list = data.raw[type]
	local curData = nil
	if list then
		curData = list[name]
		if curData then curData.fromSIGen = false end
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
	if curData then return Append( SITools.CopyData( util.deepcopy( curData ) , util.deepcopy( customData ) , needOverwrite ) )
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
	local type = SIGen.Data.type
	local name = SIGen.Data.name
	SITools.CopyData( SIGen.Data , customData , needOverwrite )
	if customData.type and type ~= customData.type or customData.name and name ~= customData.name then
		if SIGen.Data.fromSIGen then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		Append( SIGen.Data )
	end
	return SIGen
end

function SIGen.SetType( newType )
	if not newType then return SIGen end
	local type = SIGen.Data.type
	SIGen.Data.type = newType
	if type ~= newType then
		if SIGen.Data.fromSIGen then Raw[type][SIGen.Data.name] = nil
		else data.raw[type][SIGen.Data.name] = nil end
		Append( SIGen.Data )
	end
	return SIGen
end

function SIGen.SetName( newName )
	if not newName then return SIGen end
	local name = SIGen.Data.name
	SIGen.Data.name = newName
	if name ~= newName then
		if SIGen.Data.fromSIGen then Raw[SIGen.Data.type][name] = nil
		else data.raw[SIGen.Data.type][name] = nil end
		Append( SIGen.Data )
	end
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 流程控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
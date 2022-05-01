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
local CORE = nil

-- ------------------------------------------------------------------------------------------------
-- ---------- 内部方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local function Init( type , name , customData , needOverwrite , callback )
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
	return Append( curData , callback )
end

local function Append( curData , callback )
	SIGen.Data = curData
	local list = Raw[curData.type]
	if not list then
		list = {}
		Raw[curData.type] = list
	end
	list[curData.sourceName or curData.name] = curData
	if callback then callback( curData ) end
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
-- ---------- 查询遍历 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 通过原型类型和原型名称来查找原型
-- 使用 callback 来处理原型
-- ----------------------------------------
-- type = 原型类型
-- name = 原型名称 , 不含前缀
-- callback = 回调函数 , 查找完毕后会调用
-- ----------------------------------------
-- callback 参数 :
-- [1] = 找到的原型本体
-- ----------------------------------------
function SIGen.FindData( type , name , callback )
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
	if callback then callback( curData ) end
	return SIGen
end

-- ----------------------------------------
-- 通过原型类型来遍历这个类型下的所有原型
-- 使用 callback 来处理这些原型
-- 每找到一个原型就会调用一次 callback
-- ----------------------------------------
-- typeOrList = 原型类型 , 也可以是一个原型类型的列表
-- callback = 回调函数 , 每找到一个原型就会调用一次
-- ----------------------------------------
-- callback 参数 :
-- [1] = 当前是第几个原型
-- [2] = 找到的原型本体
-- ----------------------------------------
function SIGen.TypeIndicator( typeOrList , callback )
	if not callback then return SIGen end
	local prototypeList = {}
	for _ , typeName in pairs( SITools.IsTable( typeOrList ) and typeOrList or { typeOrList } ) do
		for _ , list in pairs{ data.raw[typeName] , Raw[typeName] } do
			if list then
				for name , prototype in pairs( list ) do
					if prototype then table.insert( prototypeList , prototype ) end
				end
			end
		end
	end
	for index , prototype in pairs( prototypeList ) do callback( index , prototype ) end
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 分组控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 设置分组和子分组
-- SIGen 中新创建的原型会默认使用这个分组来安排位置
-- 如果分组或子分组不存在则自动创建
-- 创建的分组会保存进 data.raw 中
-- ----------------------------------------
-- groupName = 分组名称
-- subGroupName = 子分组名称
-- ----------------------------------------
function SIGen.Group( groupName , subGroupName )
	if not CORE then
		e( "创建分组时必须添加管理核心 CoreConstants" )
		return nil
	end
	local group = nil
	local subGroup = nil
	local list = data.raw[SITypes.group]
	if list then
		group = list[groupName]
		if not group then group = list[CORE.AutoName( groupName , SITypes.group )] end
	end
	if group then
		list = data.raw[SITypes.subgroup]
		if list then
			subgroup = list[subGroupName]
			if not subGroup then subGroup = list[SIInit.CurrentConstants.AutoName( subGroupName , SITypes.subgroup )] end
		end
	end
	if not group then
		local name = CORE.AutoName( groupName , SITypes.group )
		group =
		{
			type = SITypes.group ,
			name = name ,
			localised_name = { "item-group-name."..name } ,
			localised_description = { "item-group-description."..name }
			icon = CORE.GetPicturePath( name , SITypes.group ) ,
			order = CORE.AutoOrder()
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

-- ----------------------------------------
-- 创建一个新的原型
-- 这个原型会被设置为当前编辑的原型
-- 创建的原型无法在 data.raw 中找到 , 需要通 SIGen.FindData 函数才能找到
-- ----------------------------------------
-- type = 原型类型
-- name = 原型名称 , 不含前缀
-- customData = 自定义数据表 , 可以包含任意字段 , 它们会被复制进创建的原型中
-- needOverride = 控制自定义数据表中的数据是否覆盖原型中已存在的值 , 包括默认值
-- callback = 回调函数 , 创建完毕时会调用 , 用处基本为语法糖
-- ----------------------------------------
-- callback 参数 :
-- [1] = 创建完毕的原型本体
-- ----------------------------------------
function SIGen.New( type , name , customData , needOverwrite , callback )
	if not type or not name then
		e( "创建原型时 type 和 name 均不能为空 , 当前 type 为["..type.."] , name 为["..name.."]" )
		return SIGen
	end
	return Init( type , name , customData , needOverwrite , callback )
end

-- ----------------------------------------
-- 从已有原型中加载一个原型 , 发生的修改会直接在原始原型上生效
-- 这个原型会被设置为当前编辑的原型
-- 若通过 customData 改了原型名称或原型类型 , 则会导致在原来的位置上无法找到原始原型
-- 改了原型名称或原型类型后 , 则该原型无法在 data.raw 中找到 , 需要通 SIGen.FindData 函数才能找到
-- ----------------------------------------
-- type = 原型类型
-- name = 原型名称 , 不含前缀
-- customData = 自定义数据表 , 可以包含任意字段 , 它们会被复制进创建的原型中
-- needOverride = 控制自定义数据表中的数据是否覆盖原型中已存在的值 , 包括默认值
-- callback = 回调函数 , 创建完毕时会调用 , 用处基本为语法糖
-- ----------------------------------------
-- callback 参数 :
-- [1] = 创建完毕的原型本体
-- ----------------------------------------
function SIGen.Load( type , name , customData , needOverwrite , callback )
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
		if customData.name then
			curData.sourceName = customData.name
			customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type )
		end
		curData.fromSIGen = true
		return Append( curData , callback )
	else
		if callback then callback( curData ) end
		return SIGen
	end
end

-- ----------------------------------------
-- 从已有原型中加载一个原型 , 复制原始原型的数据并创建为新的原型
-- 这个原型会被设置为当前编辑的原型
-- 任何对原型的修改不会影响原始原型
-- 创建的原型无法在 data.raw 中找到 , 需要通 SIGen.FindData 函数才能找到
-- ----------------------------------------
-- type = 原型类型
-- name = 原型名称 , 不含前缀
-- customData = 自定义数据表 , 可以包含任意字段 , 它们会被复制进创建的原型中
-- needOverride = 控制自定义数据表中的数据是否覆盖原型中已存在的值 , 包括默认值
-- callback = 回调函数 , 创建完毕时会调用 , 用处基本为语法糖
-- ----------------------------------------
-- callback 参数 :
-- [1] = 创建完毕的原型本体
-- ----------------------------------------
function SIGen.Copy( type , name , customData , needOverwrite , callback )
	if not type or not name then
		e( "创建原型时 type 和 name 均不能为空 , 当前 type 为["..type.."] , name 为["..name.."]" )
		return SIGen
	end
	local curData = SIGen.FindData( type , name )
	if curData then
		if customData.name then
			curData.sourceName = customData.name
			customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type )
		end
		curData.fromSIGen = true
		return Append( SITools.CopyData( util.deepcopy( curData ) , util.deepcopy( customData ) , needOverwrite ) , callback )
	else return Init( type , name , util.deepcopy( customData ) , needOverwrite , callback ) end
end

-- ----------------------------------------
-- 按类别创建/加载/复制原型
-- 这个原型会被设置为当前编辑的原型
-- 命名规则为 SITypes 的原型类型对应的键首字母大写+New/Load/Copy 前缀
-- 比如创建一个物品 , 物品原型类型在 SITypes 中的键为 item , 则函数为 NewItem
-- 创建的原型无法在 data.raw 中找到 , 需要通 SIGen.FindData 函数才能找到
-- ----------------------------------------
-- name = 原型名称 , 不含前缀
-- customData = 自定义数据表 , 可以包含任意字段 , 它们会被复制进创建的原型中
-- needOverride = 控制自定义数据表中的数据是否覆盖原型中已存在的值 , 包括默认值
-- callback = 回调函数 , 创建完毕时会调用 , 用处基本为语法糖
-- ----------------------------------------
-- callback 参数 :
-- [1] = 创建完毕的原型本体
-- ----------------------------------------
for index , typeName in pairs( SITypes.all ) do
	local functionName = typeName:ToFunctionName()
	SIGen["New"..functionName] = function( name , customData , needOverwrite , callback )
		return SIGen.New( typeName , name , customData , needOverwrite , callback )
	end
	SIGen["Load"..functionName] = function( name , customData , needOverwrite , callback )
		return SIGen.Load( typeName , name , customData , needOverwrite , callback )
	end
	SIGen["Copy"..functionName] = function( name , customData , needOverwrite , callback )
		return SIGen.Copy( typeName , name , customData , needOverwrite , callback )
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 修改属性 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 把自定义表中的键值对保存进当前编辑的原型中
-- ----------------------------------------
-- customData = 自定义数据表 , 可以包含任意字段 , 它们会被复制进创建的原型中
-- needOverride = 控制自定义数据表中的数据是否覆盖原型中已存在的值 , 包括默认值
-- ----------------------------------------
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

-- ----------------------------------------
-- 变更当前编辑的原型的原型类型
-- 若改了原型类型 , 则会导致在原来的位置上无法找到原型
-- ----------------------------------------
-- newType = 新的原型类型
-- ----------------------------------------
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

-- ----------------------------------------
-- 变更当前编辑的原型的原型名称
-- 若改了原型名称 , 则会导致在原来的位置上无法找到原型
-- ----------------------------------------
-- newName = 新的原型名称 , 不含前缀
-- ----------------------------------------
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

-- ----------------------------------------
-- 通过属性名称来变更当前编辑的原型中的属性
-- 多层表中的属性可以使用 . 来连接多个层级的属性名称 , 比如 icons.1.icon
-- 当要给列表结构添加元素时 , 可以把索引留空 , 比如 icons.
-- 使用多层属性名称时 , 需要确保属性名称是存在的 , 不然会报错
-- ----------------------------------------
-- key = 属性名称
-- value = 属性值
-- ----------------------------------------
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

-- ----------------------------------------
-- 移除当前编辑的原型中的属性
-- 多层表中的属性可以使用 . 来连接多个层级的属性名称 , 比如 icons.1.icon
-- 当移除列表结构的最后一个元素时 , 可以把索引留空 , 比如 icons.
-- 使用多层属性名称时 , 需要确保属性名称是存在的 , 不然会报错
-- ----------------------------------------
-- key = 属性名称
-- ----------------------------------------
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

-- ----------------------------------------
-- 通过属性名称来向当前编辑的原型中的属性内添加新的项目 , 仅限于列表结构
-- 多层表中的属性可以使用 . 来连接多个层级的属性名称 , 比如 icons.1.icon
-- 使用多层属性名称时 , 需要确保属性名称是存在的 , 不然会报错
-- ----------------------------------------
-- key = 属性名称
-- value = 属性值
-- index = 列表索引位置 , 添加至最后一位则留空
-- ----------------------------------------
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

-- ----------------------------------------
-- 通过属性名称来变更当前编辑的原型中的属性 , 仅限于列表结构
-- 多层表中的属性可以使用 . 来连接多个层级的属性名称 , 比如 icons.1.icon
-- 使用多层属性名称时 , 需要确保属性名称是存在的 , 不然会报错
-- ----------------------------------------
-- key = 属性名称
-- value = 属性值
-- index = 列表索引位置 , 添加至最后一位则留空
-- ----------------------------------------
function SIGen.ListSet( key , value , index )
	if Check() then return SIGen end
	return SIGen.ValueSet( key.."."..( index and index or "" ) , value )
end

-- ----------------------------------------
-- 移除当前编辑的原型中的属性 , 仅限于列表结构
-- 多层表中的属性可以使用 . 来连接多个层级的属性名称 , 比如 icons.1.icon
-- 使用多层属性名称时 , 需要确保属性名称是存在的 , 不然会报错
-- ----------------------------------------
-- key = 属性名称
-- index = 列表索引位置 , 最后一位则留空
-- ----------------------------------------
function SIGen.ListRemove( key , index )
	if Check() then return SIGen end
	return SIGen.ValueRemove( key.."."..( index and index or "" ) )
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 流程控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- 框架内部函数
function SIGen.SetCore( coreConstants )
	CORE = coreConstants
	return SIGen
end

-- 框架内部函数
function SIGen.Clean()
	CORE = nil
	SIGen.Data = nil
	GroupSettings =
	{
		groupName = nil ,
		subGroupName = nil
	}
	return SIGen
end

-- 框架内部函数
function SIGen.GetRaw()
	return Raw
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
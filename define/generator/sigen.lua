SIGen =
{
	LastDataName = nil ,
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
-- ---------- 内部函数 ----------------------------------------------------------------------------
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
		SIGenSourceName = name ,
		SIGenForm = true ,
		SIGenIndex = GenIndex
	}
	local autoFillData = AutoFillData[type]
	if autoFillData then
		if autoFillData.defaultValues then SITools.CopyData( curData , autoFillData.defaultValues , false ) end
		if autoFillData.callback then autoFillData.callback( curData ) end
	end
	SITools.CopyData( curData , customData , needOverwrite )
	return Append( curData , callback )
end

local function Append( curData , callback )
	SIGen.LastDataName = SIGen.Data.name
	SIGen.Data = curData
	local list = Raw[curData.type]
	if not list then
		list = {}
		Raw[curData.type] = list
	end
	list[curData.SIGenSourceName] = curData
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
		if curData then curData.SIGenForm = false end
	end
	if not curData then
		list = Raw[type]
		if list then
			curData = list[name]
			if curData then curData.SIGenForm = true end
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
		if curData.SIGenForm then Raw[type][name] = nil
		else data.raw[type][name] = nil end
		if customData.name then
			curData.SIGenSourceName = customData.name
			customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type )
		else curData.SIGenSourceName = curData.name end
		curData.SIGenForm = true
		return Append( curData , callback )
	else
		curData.SIGenSourceName = curData.name
		curData.SIGenForm = false
		SIGen.LastDataName = SIGen.Data.name
		SIGen.Data = curData
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
			curData.SIGenSourceName = customData.name
			customData.name = SIInit.CurrentConstants.AutoName( customData.name , customData.type or curData.type )
		else curData.SIGenSourceName = curData.name end
		curData.SIGenForm = true
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
-- -------- 修改通用属性 --------------------------------------------------------------------------
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
		if SIGen.Data.SIGenForm then Raw[type][name] = nil
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
		if SIGen.Data.SIGenForm then Raw[type][name] = nil
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
		if SIGen.Data.SIGenForm then Raw[type][name] = nil
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
-- -------- 修改具体属性 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 修改物品的堆叠数量
-- ----------------------------------------
-- stackSize = 堆叠数量
-- ----------------------------------------
function SIGen.SetStackSize( stackSize )
	if Check() then return SIGen end
	stackSize = stackSize or 1
	if stackSize > 1 then SIGen.Data.stackable = true
	else SIGen.Data.stackable = false end
	SIGen.Data.stack_size = stackSize
	return SIGen
end

-- ----------------------------------------
-- 根据给定的大小创建选择区域和碰撞区域
-- ----------------------------------------
-- width = 区域宽度
-- height = 区域高度 , 不填写是使用宽度的数值
-- ----------------------------------------
function SIGen.SetSize( width , height )
	if Check() then return SIGen end
	if not height then height = width end
	local size = SIGen.Data.SIGenSize or {}
	if size.width ~= width or size.height ~= height then
		SIGen.Data.selection_box = SITools.BoundBox( width , height )
		SIGen.Data.collision_box = SITools.BoundBox_Collision( width , height )
	end
	SIGen.Data.SIGenSize = { width = width , height = height }
	return SIGen
end

-- ----------------------------------------
-- 根据参数创建动画帧图结构 , 无方向
-- 这种模式下会附带一个影子属性 shadow
-- ----------------------------------------
-- scale = 缩放比例 , 原图比例为 1.0
-- shift = 偏移位置 , 默认 { 0.0 , 0.0 }
-- hasHr = 是否创建高清图部分 , 默认否
-- isGlow = 是否发光 , 默认不发光
-- ----------------------------------------
function SIGen.SetAnimation( scale , shift , hasHr , isGlow )
	if Check() then return SIGen end
	local size = SIGen.Data.SIGenSize or { width = 1 , height = 1 }
	local graphicSetting = SINumbers.graphicSettings[SIGen.Data.type] or SINumbers.graphicSetting_Default
	SIGen.Data.animation =
	{
		filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName , SIGen.Data.type ) ,
		width = size.width * graphicSetting.width ,
		height = size.height * graphicSetting.height ,
		scale = scale or 1.0 ,
		shift = shift and util.by_pixel( shift.x , shift.y ) or util.by_pixel( 0.0 , 0.0 ) ,
		priority = SIFlags.priorities.high ,
		line_length = graphicSetting.widthCount or 1 ,
		frame_count = graphicSetting.widthCount and graphicSetting.heightCount and graphicSetting.widthCount * graphicSetting.heightCount or 1 ,
		animation_speed = graphicSetting.animSpeed or nil ,
		draw_as_glow = isGlow and true or nil ,
		hr_version = hasHr and
		{
			filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-hr" , SIGen.Data.type ) ,
			width = size.width * graphicSetting.width * SINumbers.graphicHrSizeScale ,
			height = size.height * graphicSetting.height * SINumbers.graphicHrSizeScale ,
			scale = ( scale or 1.0 ) * SINumbers.graphicHrScaleDown ,
			shift = shift and util.by_pixel( shift.x*SINumbers.graphicHrSizeScale , shift.y*SINumbers.graphicHrSizeScale ) or util.by_pixel( 0.0 , 0.0 ) ,
			priority = SIFlags.priorities.high ,
			line_length = graphicSetting.widthCount or 1 ,
			frame_count = graphicSetting.widthCount and graphicSetting.heightCount and graphicSetting.widthCount * graphicSetting.heightCount or 1 ,
			animation_speed = graphicSetting.animSpeed or nil ,
			draw_as_glow = isGlow and true or nil
		} or nil
	}
	SIGen.Data.shadow = util.deepcopy( SIGen.Data.animation )
	SIGen.Data.shadow.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-shadow" , SIGen.Data.type )
	SIGen.Data.shadow.draw_as_glow = nil
	SIGen.Data.shadow.draw_as_shadow = true
	if hasHr then
		SIGen.Data.shadow.hr_version.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-shadow-hr" , SIGen.Data.type )
		SIGen.Data.shadow.hr_version.draw_as_glow = nil
		SIGen.Data.shadow.hr_version.draw_as_shadow = true
	end
	return SIGen
end

-- ----------------------------------------
-- 根据参数创建动画帧图结构 , 四个方向
-- 这种模式下没有影子属性
-- ----------------------------------------
-- scale = 缩放比例 , 原图比例为 1.0
-- shift = 偏移位置 , 默认 { 0.0 , 0.0 }
-- hasHr = 是否创建高清图部分 , 默认否
-- isGlow = 是否发光 , 默认不发光
-- ----------------------------------------
function SIGen.SetAnimation4Way( scale , shift , hasHr )
	if Check() then return SIGen end
	local size = SIGen.Data.SIGenSize or { width = 1 , height = 1 }
	local graphicSetting = SINumbers.graphicSettings[SIGen.Data.type] or SINumbers.graphicSetting_Default
	local horizontally = util.deepcopy( graphicSetting )
	horizontally.width = size.width * graphicSetting.width
	horizontally.height = size.height * graphicSetting.height
	local vertically = util.deepcopy( graphicSetting )
	vertically.width = horizontally.height
	vertically.height = horizontally.width
	SIGen.Data.animation
	{
		north = CreateLayer4Way( horizontally , scale , shift , hasHr , SIFlags.directions.north ) ,
		east = CreateLayer4Way( vertically , scale , shift , hasHr , SIFlags.directions.east ) ,
		south = CreateLayer4Way( horizontally , scale , shift , hasHr , SIFlags.directions.south ) ,
		west = CreateLayer4Way( vertically , scale , shift , hasHr , SIFlags.directions.west )
	}
	return SIGen
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
-- --------- 构建数据包 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local function CreateLayer4Way( size , scale , shift , hasHr , directionName )
	return
	{
		filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-"..direction , SIGen.Data.type ) ,
		width = size.width ,
		height = size.height ,
		scale = scale or 1.0 ,
		shift = shift and util.by_pixel( shift.x , shift.y ) or util.by_pixel( 0.0 , 0.0 ) ,
		priority = SIFlags.priorities.high ,
		line_length = size.widthCount or 1 ,
		frame_count = size.widthCount and size.heightCount and size.widthCount * size.heightCount or 1 ,
		animation_speed = graphicSetting.animSpeed or nil ,
		draw_as_glow = isGlow and true or nil ,
		hr_version = hasHr and
		{
			filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-"..direction.."-hr" , SIGen.Data.type ) ,
			width = size.width * SINumbers.graphicHrSizeScale ,
			height = size.height * SINumbers.graphicHrSizeScale ,
			scale = ( scale or 1.0 ) * SINumbers.graphicHrScaleDown ,
			shift = shift and util.by_pixel( shift.x*SINumbers.graphicHrSizeScale , shift.y*SINumbers.graphicHrSizeScale ) or util.by_pixel( 0.0 , 0.0 ) ,
			priority = SIFlags.priorities.high ,
			line_length = size.widthCount or 1 ,
			frame_count = size.widthCount and size.heightCount and size.widthCount * size.heightCount or 1 ,
			animation_speed = size.animSpeed or nil ,
			draw_as_glow = isGlow and true or nil
		} or nil
	}
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 自动填充 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local AutoFillSource =
{
	item =
	{
		defaultValues =
		{
			icon_size = SINumbers.iconSize ,
			icon_mipmaps = SINumbers.mipMaps
		} ,
		callback = function( data )
			data.icon = SIInit.CurrentConstants.GetPicturePath( data.SIGenSourceName.."-icon" , data.type )
		end
	} ,
	item2 =
	{
		types = SITypes.stackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = 100 ,
			stackable = true
		}
	} ,
	item3 =
	{
		types = SITypes.unstackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = 1 ,
			stackable = false
		}
	} ,
	recipe =
	{
		types = { SITypes.recipe } ,
		super = "item" ,
		defaultValues =
		{
			enabled = false , -- 默认启用
			hidden = false , -- 默认隐藏
			hide_from_stats = false , -- 从统计页隐藏
			hide_from_player_crafting = false , -- 从玩家背包隐藏
			allow_inserter_overload = true , -- 允许爪子给机器装更多的原料作为储备
			allow_decomposition = true , -- 允许计算配方的原料
			allow_as_intermediate = true , -- 允许作为手搓的中间配方
			allow_intermediates = true , -- 允许手搓时使用中间配方
			always_show_made_in = true , -- 总是显示那些机器可以制作它
			always_show_products = true , -- 总是显示产物
			show_amount_in_title = true , -- 在标题中显示数量
			unlock_results = true , -- 配方解锁时会同时解锁在选择器中选择产物的功能
			energy_required = 1.0 , -- 能量需求 , 机器能耗为 1
			overload_multiplier = 5.0 , -- 爪子给机器装更多的原料作为储备时的多装倍率
			requester_paste_multiplier = 50.0 -- 原料需求复制给物流箱子时的需求倍率
		}
	} ,
	entity =
	{
		super = "item" ,
		defaultValues =
		{
			allow_copy_paste = true ,
			selectable_in_game = true ,
			selection_priority = 50 ,
			remove_decoratives = "automatic" ,
			vehicle_impact_sound = SITools.SoundList_Base( "car-metal-impact" , 5 , 0.5 , 2 ) ,
			open_sound = SITools.Sounds( "__base__/sound/machine-open.ogg" , 0.5 ) ,
			close_sound = SITools.Sounds( "__base__/sound/machine-close.ogg" , 0.5 )
		}
	} ,
	healthEntity =
	{
		super = "entity" ,
		defaultValues =
		{
			alert_when_damaged = true ,
			hide_resistances = true ,
			create_ghost_on_death = true
		}
	}
	machine =
	{
		types = { SITypes.entity.machine , SITypes.entity.furnace } ,
		super = "healthEntity" ,
		defaultValues =
		{
			crafting_speed = 1.0 ,
			scale_entity_info_icon = false ,
			show_recipe_icon = true ,
			return_ingredients_on_change = true ,
			always_draw_idle_animation = false
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
				if not data.callback and parent.callback then data.callback = parent.callback end
				if parent.parent then PutParentAutoFillData( data , parent.parent ) end
			end
		end
		PutParentAutoFillData( data , data.parent )
	end
	local newData =
	{
		defaultValues = data.defaultValues ,
		callback = data.callback
	}
	if data.types then
		for index , typeName in pairs( data.types ) do AutoFillData[typeName] = util.deepcopy( newData ) end
	end
end

AutoFillSource = nil
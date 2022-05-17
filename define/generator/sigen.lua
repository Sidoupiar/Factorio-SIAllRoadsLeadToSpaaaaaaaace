-- ------------------------------------------------------------------------------------------------
-- ------------ 说明 ------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- [原型构建器]
-- 用来自动化构建 prototype 的结构
-- ----------------------------------------
-- [作用]
-- 通过统一入口来代替人工代码完成一些自动化编码工作
-- 通常是添加一些默认值 , 计算出一些比较难写的参数
-- 或者创建一些非常冗长复杂的表结构
-- 部分时候也是用变量代替的容易写错的静态值
-- ----------------------------------------

-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen =
{
	LastDataName = nil ,
	Data = nil
}

local GroupSettings =
{
	groupName = nil ,
	subGroupName = nil
}
local GenIndex = 1000000
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
		localised_description = { "SI-common.description" , SIInit.CurrentConstants.showName , { "SI-description."..realName:RemoveLastAndAfter( "_" ) } } ,
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
	if callback then
		local package = callback( curData )
		if SITools.IsTable( package ) then
			for k , v in pairs( package ) do curData[k] = v end
		end
	end
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
			localised_name = { "SIGroup-name."..name } ,
			localised_description = { "SIGroup-description."..name }
			icon = CORE.GetPicturePath( name , SITypes.group ) ,
			icon_size = SINumbers.icon.sizeGroup ,
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
-- name = 原型名称 , 不含前缀 , 末尾添加 _xxxx , 前面相同但是这部分不同的原型会使用相同的语言词条
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
-- 若无法找到原始原型 , 则适用 SIGen.New 的逻辑
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
-- CopyXXXX 中若无法找到原始原型 , 则适用 SIGen.NewXXXX 的逻辑
-- ----------------------------------------
-- name = 原型名称 , 不含前缀 , 当为 NewXXXX 时 , 末尾添加 _xxxx , 前面相同但是这部分不同的原型会使用相同的语言词条
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
	elseif key == "name" then return SIGen.SetName( value )
	elseif key:find( "." ) then
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
					elseif curKey == "" then table.remove( curData )
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
	stackSize = math.max( math.floor( stackSize or 1 ) , 1 )
	if stackSize > 1 then SIGen.Data.stackable = true
	else SIGen.Data.stackable = false end
	SIGen.Data.stack_size = stackSize
	return SIGen
end

-- ----------------------------------------
-- 设置实体在地图上的颜色
-- ----------------------------------------
-- color = 地图颜色
-- friendlyColor = 友方的地图颜色 , 默认地图颜色
-- enemyColor = 敌方的地图颜色 , 默认地图颜色
-- ----------------------------------------
function SIGen.SetMapColor( color , friendlyColor , enemyColor )
	if Check() then return SIGen end
	SIGen.Data.map_color = color
	SIGen.Data.friendly_map_color = friendlyColor or color
	SIGen.Data.enemy_map_color = enemyColor or color
	return SIGen
end

-- ----------------------------------------
-- 设置实体的自动放置规则
-- ----------------------------------------
-- settings = 自动放置设置
-- ----------------------------------------
-- settings 参数 :
-- ----------------------------------------
function SIGen.SetAutoPlace( settings )
	if Check() then return SIGen end
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
-- 需要先通过 SIGen.SetSize 来设置宽高 , 默认宽高均为 1
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
	size = { width = math.ceil( size.width ) , height = math.ceil( size.height ) }
	local graphicSetting = SINumbers.graphicSettings[SIGen.Data.type] or SINumbers.graphicSetting_Default
	SIGen.Data.animation =
	{
		filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName , SIGen.Data.type ) ,
		width = size.width * graphicSetting.width + graphicSetting.addenWidth ,
		height = size.height * graphicSetting.height + graphicSetting.addenHeight ,
		scale = scale or 1.0 ,
		shift = shift and util.by_pixel( shift.x , shift.y ) or util.by_pixel( 0.0 , 0.0 ) ,
		priority = SIFlags.priorities.high ,
		line_length = graphicSetting.widthCount or 1 ,
		frame_count = graphicSetting.frameCount or 1 ,
		animation_speed = graphicSetting.animSpeed or nil ,
		draw_as_glow = isGlow and true or nil
	}
	if hasHr then
		local hr = util.deepcopy( SIGen.Data.animation )
		hr.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-hr" , SIGen.Data.type )
		hr.width = hr.width * SINumbers.graphicHrSizeScale
		hr.height = hr.height * SINumbers.graphicHrSizeScale
		hr.scale = hr.scale * SINumbers.graphicHrScaleDown
		hr.shift = util.by_pixel( hr.shift.x*SINumbers.graphicHrSizeScale , hr.shift.y*SINumbers.graphicHrSizeScale )
		SIGen.Data.animation.hr_version = hr
	end
	local shadow = util.deepcopy( SIGen.Data.animation )
	shadow.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-shadow" , SIGen.Data.type )
	shadow.draw_as_glow = nil
	shadow.draw_as_shadow = true
	if hasHr then
		shadow.hr_version.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-shadow-hr" , SIGen.Data.type )
		shadow.hr_version.draw_as_glow = nil
		shadow.hr_version.draw_as_shadow = true
	end
	SIGen.Data.shadow = shadow
	return SIGen
end

-- ----------------------------------------
-- 根据参数创建动画帧图结构 , 四个方向
-- 需要先通过 SIGen.SetSize 来设置宽高 , 默认宽高均为 1
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
	size = { width = math.ceil( size.width ) , height = math.ceil( size.height ) }
	local graphicSetting = SINumbers.graphicSettings[SIGen.Data.type] or SINumbers.graphicSetting_Default
	local horizontally = util.deepcopy( graphicSetting )
	horizontally.width = size.width * graphicSetting.width + graphicSetting.addenWidth
	horizontally.height = size.height * graphicSetting.height + graphicSetting.addenHeight
	local vertically = util.deepcopy( graphicSetting )
	vertically.width = horizontally.height
	vertically.height = horizontally.width
	SIGen.Data.animation
	{
		north = CreateLayer4Way( horizontally , scale , shift , hasHr , SIFlags.directions.north , graphicSetting ) ,
		east = CreateLayer4Way( vertically , scale , shift , hasHr , SIFlags.directions.east , graphicSetting ) ,
		south = CreateLayer4Way( horizontally , scale , shift , hasHr , SIFlags.directions.south , graphicSetting ) ,
		west = CreateLayer4Way( vertically , scale , shift , hasHr , SIFlags.directions.west , graphicSetting )
	}
	return SIGen
end

-- ----------------------------------------
-- 根据参数创建动画阶段图结构 , 无方向
-- 需要先通过 SIGen.SetSize 来设置宽高 , 默认宽高均为 1
-- ----------------------------------------
-- scale = 缩放比例 , 原图比例为 1.0
-- shift = 偏移位置 , 默认 { 0.0 , 0.0 }
-- hasHr = 是否创建高清图部分 , 默认否
-- addGlow = 是否添加发光层 , 默认否
-- ----------------------------------------
function SIGen.SetStages( scale , shift , hasHr , addGlow )
	if Check() then return SIGen end
	local size = SIGen.Data.SIGenSize or { width = 1 , height = 1 }
	size = { width = math.ceil( size.width ) , height = math.ceil( size.height ) }
	local graphicSetting = SINumbers.graphicSettings[SIGen.Data.type] or SINumbers.graphicSetting_Default
	SIGen.Data.stages =
	{
		filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName , SIGen.Data.type ) ,
		width = size.width * graphicSetting.width + graphicSetting.addenWidth ,
		height = size.height * graphicSetting.height + graphicSetting.addenHeight ,
		scale = scale or 1.0 ,
		shift = shift and util.by_pixel( shift.x , shift.y ) or util.by_pixel( 0.0 , 0.0 ) ,
		priority = SIFlags.priorities.high ,
		frame_count = graphicSetting.frameCount or 1 ,
		variation_count = graphicSetting.variationCount or 1
	}
	if hasHr then
		local hr = util.deepcopy( SIGen.Data.stages )
		hr.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-hr" , SIGen.Data.type )
		hr.width = hr.width * SINumbers.graphicHrSizeScale
		hr.height = hr.height * SINumbers.graphicHrSizeScale
		hr.scale = hr.scale * SINumbers.graphicHrScaleDown
		hr.shift = util.by_pixel( hr.shift.x*SINumbers.graphicHrSizeScale , hr.shift.y*SINumbers.graphicHrSizeScale )
		SIGen.Data.stages.hr_version = hr
	end
	if addGlow then
		local effect = util.deepcopy( SIGen.Data.stages )
		effect.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-glow" , SIGen.Data.type )
		effect.blend_mode = SIFlags.blendModes.additive
		if hasHr then
			effect.hr_version.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-glow-hr" , SIGen.Data.type )
			effect.hr_version.blend_mode = SIFlags.blendModes.additive
		end
		SIGen.Data.stages_effect = effect
	end
	return SIGen
end

function SIGen.AddFlag( flags )
	if Check() then return SIGen end
	if not SIGen.Data.flags then SIGen.Data.flags = flags
	else
		for index , flag in pairs( flags ) do
			if not table.Has( SIGen.Data.flags , flag ) then table.insert( SIGen.Data.flags , flag ) end
		end
	end
	return SIGen
end

function SIGen.AddCollisionMask( masks )
	if Check() then return SIGen end
	if not SIGen.Data.collision_mask then SIGen.Data.collision_mask = masks
	else
		for index , mask in pairs( masks ) do
			if not table.Has( SIGen.Data.collision_mask , mask ) then table.insert( SIGen.Data.collision_mask , mask ) end
		end
	end
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 自动填充 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 根据实体的最大生命值 , 面积来确定到底需要挖多久才能挖下来
-- 需要先通过 SIGen.SetSize 来设置宽高 , 默认宽高均为 1
-- 需要实体已经设置好 minable 属性
-- 挖掘时间 = 最大生命值 / SINumber.healthToMiningTime * 面积 / SINumber.sizeToMiningTime * multiplier
-- 挖掘时间最少 0.1
-- ----------------------------------------
-- multiplier = 挖掘时间倍率 , 默认 1
-- ----------------------------------------
function SIGen.AutoMiningTime( multiplier )
	if Check() then return SIGen end
	if not SIGen.Data.minable then return SIGen end
	local size = SIGen.Data.SIGenSize or { width = 1 , height = 1 }
	multiplier = multiplier or 1
	local time = 1
	if SIGen.Data.max_health then time = SIGen.Data.max_health * size.width * size.height / SINumber.healthToMiningTime / SINumber.sizeToMiningTime * multiplier
	else time = size.width * size.height / SINumber.sizeToMiningTime * multiplier end
	SIGen.Data.minable.mining_time = math.max( time , 0.1 )
	return SIGen
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 流程控制 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- 框架内部函数
function SIGen.SetCore( coreConstants )
	CORE = coreConstants
	if CORE.autoFillSource then TransAutoFillData( AutoFillData , CORE.autoFillSource ) end
	return SIGen
end

-- 框架内部函数
function SIGen.ResetAutoFillData()
	AutoFillData = util.deepcopy( AutoFillSource )
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

local function CreateLayer4Way( size , scale , shift , hasHr , directionName , graphicSetting )
	local layer =
	{
		filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-"..direction , SIGen.Data.type ) ,
		width = size.width ,
		height = size.height ,
		scale = scale or 1.0 ,
		shift = shift and util.by_pixel( shift.x , shift.y ) or util.by_pixel( 0.0 , 0.0 ) ,
		priority = SIFlags.priorities.high ,
		line_length = graphicSetting.widthCount or 1 ,
		frame_count = graphicSetting.frameCount or 1 ,
		animation_speed = graphicSetting.animSpeed or nil
		{
			 ,
			width = size.width * SINumbers.graphicHrSizeScale ,
			height = size.height * SINumbers.graphicHrSizeScale ,
			scale = ( scale or 1.0 ) * SINumbers.graphicHrScaleDown ,
			shift = shift and util.by_pixel( shift.x*SINumbers.graphicHrSizeScale , shift.y*SINumbers.graphicHrSizeScale ) or util.by_pixel( 0.0 , 0.0 ) ,
			priority = SIFlags.priorities.high ,
			line_length = size.widthCount or 1 ,
			frame_count = size.widthCount and size.heightCount and size.widthCount * size.heightCount or 1 ,
			animation_speed = size.animSpeed or nil
		} or nil
	}
	if hasHr then
		local hr = util.deepcopy( layer )
		hr.filename = SIInit.CurrentConstants.GetPicturePath( SIGen.Data.SIGenSourceName.."-"..direction.."-hr" , SIGen.Data.type )
		hr.width = hr.width * SINumbers.graphicHrSizeScale
		hr.height = hr.height * SINumbers.graphicHrSizeScale
		hr.scale = hr.scale * SINumbers.graphicHrScaleDown
		hr.shift = util.by_pixel( hr.shift.x*SINumbers.graphicHrSizeScale , hr.shift.y*SINumbers.graphicHrSizeScale )
		layer.hr_version = hr
	end
	return layer
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
			icon_size = SINumbers.icon.sizeNormal , -- 图标大小
			icon_mipmaps = SINumbers.icon.mipMaps -- 图标层级
		} ,
		callback = function( data )
			data.icons = { SITools.Icon( SIInit.CurrentConstants.GetPicturePath( data.SIGenSourceName.."-icon" , data.type ) ) }
		end
	} ,
	item2 =
	{
		types = SITypes.stackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = SINumber.stackSize.materialNormal , -- 堆叠数量
			stackable = true -- 是否允许堆叠
		}
	} ,
	item3 =
	{
		types = SITypes.unstackableItem ,
		super = "item" ,
		defaultValues =
		{
			stack_size = SINumber.stackSize.cannotStack , -- 堆叠数量
			stackable = false -- 是否允许堆叠
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
			allow_copy_paste = true , -- 是否允许复制粘贴
			selectable_in_game = true , -- 是否可以被玩家选择
			selection_priority = 50 , -- 选择的权重
			remove_decoratives = "automatic" , -- 是否在建设时移除地面装饰
			vehicle_impact_sound = SITools.SoundList_Base( "car-metal-impact" , 5 , 0.5 , 2 ) , -- 撞击声音
			open_sound = SITools.Sounds( "__base__/sound/machine-open.ogg" , 0.5 ) , -- 打开的声音
			close_sound = SITools.Sounds( "__base__/sound/machine-close.ogg" , 0.5 ) -- 关闭的声音
		}
	} ,
	healthEntity =
	{
		super = "entity" ,
		defaultValues =
		{
			alert_when_damaged = true , -- 受伤时是否给玩家发出警报
			hide_resistances = false , -- 是否隐藏实体的抗性属性
			create_ghost_on_death = true -- 是否在被摧毁后在原地放置蓝图虚像
		}
	} ,
	resource =
	{
		types = { SITypes.entity.resource } ,
		super = "entity" ,
		defaultValues =
		{
			flags = -- 实体标识
			{
				SIFlags.entityFlags.placeableNeutral ,
				SIFlags.entityFlags.notOnMap ,
				SIFlags.entityFlags.hidden
			} ,
			tree_removal_probability = 0.1 , -- 移除树木的概率
			tree_removal_max_distance = 256 , -- 移除树木的范围
			stage_counts = { 3906250 , 781250 , 156250 , 31250 , 6250 , 1250 , 250 , 50 } , -- 图片阶段对应的数量
			walk_sound = SITools.SoundList_Base( "walking/resources/ore" , 10 , 0.7 ) -- 行走在上面的声音
		}
	} ,
	simpleEntity =
	{
		types = { SITypes.entity.simpleEntity } ,
		super = "healthEntity" ,
		defaultValues =
		{
			alert_when_damaged = false , -- 受伤时是否给玩家发出警报
			hide_resistances = true , -- 是否隐藏实体的抗性属性
			create_ghost_on_death = false -- 是否在被摧毁后在原地放置蓝图虚像
		}
	} ,
	machine =
	{
		types = { SITypes.entity.machine , SITypes.entity.furnace } ,
		super = "healthEntity" ,
		defaultValues =
		{
			crafting_speed = 1.0 , -- 组装速度
			scale_entity_info_icon = false , -- 是否缩放详情模式下的图标
			show_recipe_icon = true , -- 是否显示配方图标
			return_ingredients_on_change = false , -- 在修改配方时是否返还正在制作的配方的原料
			always_draw_idle_animation = false -- 是否总是运行动画 , 即使机器已经停工
		}
	}
}

local function TransAutoFillData( autoFillData , autoFillSource )
for type , data in pairs( autoFillSource ) do
	if not data.defaultValues then data.defaultValues = {} end
	if data.parent then
		local function PutParentAutoFillData( data , parentType )
			if autoFillSource[parentType] then
				local parent = autoFillSource[parentType]
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
		for index , typeName in pairs( data.types ) do
			local realData = autoFillData[typeName]
			local curData = util.deepcopy( newData )
			if realData then
				if not realData.defaultValues then realData.defaultValues = {} end
				for k , v in pairs( curData.defaultValues ) do realData.defaultValues[k] = v end
				realData.callback = curData.callback
			else realData = curData
		end
	end
end

TransAutoFillData( AutoFillData , AutoFillSource )
AutoFillSource = AutoFillData
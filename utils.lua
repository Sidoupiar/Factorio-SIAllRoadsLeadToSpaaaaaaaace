-- ------------------------------------------------------------------------------------------------
-- ---------- 添加引用 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not util then util = require( "__core__/lualib/util" ) end
SINumbers = require( "define/sinumbers" )
SIFlags = require( "define/siflags" )
SITypes = require( "define/sitypes" )
SIColors = require( "define/sicolors" )
SIMods = require( "define/simods" )
SITools = require( "define/sitools" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 定义数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local CoreName = "__SIAllRoadsLeadToRome__"
local packageList =
{
	"0_special" ,
	"1_environment" ,
	"2_resource" ,
	"3_plant" ,
	"4_living" ,
	"5_ruin" ,
	"6_trade" ,
	"9997_garbage_collection" ,
	"9998_detail_improvement" ,
	"9999_debug"
}

SIEvents = {}
for k , v in pairs( defines.events ) do SIEvents[k] = v end

SIOrderList = { "a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i" , "j" , "k" , "l" , "m" , "n" , "o" , "p" , "q" , "r" , "s" , "t" , "u" , "v" , "w" , "x" , "y" , "z" }
SIOrderListSize = #SIOrderList

-- ------------------------------------------------------------------------------------------------
-- ---------- 定义函数 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not date then date = {} end

date.ticksPerDay = SINumbers.ticksPerDay
date.ticksPerHalfDay = SINumbers.ticksPerHalfDay

function date.FormatDateByTick( tick )
	local d , t = math.modf( tick/date.ticksPerDay )
	local h , m = math.modf( t*24 )
	return ( "%u-%02u:%02u" ):format( d+1 , h , math.floor( m*60 ) )
end

function math.Range( num , min , max )
	return math.max( math.min( num , max ) , min )
end

function math.Cnum( num , min , max )
	return math.Range( math.floor( num ) , min , max )
end

function string:Split( separator )
	if separator == "" then return { self } end
	local pos = 0
	local list = {}
	for st , sp in function() return self:find( separator , pos , true ) end do
		table.insert( list , self:sub( pos , st-1 ) )
		pos = sp + 1
	end
	table.insert( list , self:sub( pos ) )
	return list
end

function string:UpperCaseFirst()
	return self:sub( 1 , 1 ):upper() .. self:sub( -self:len()+1 )
end

function string:StartsWith( str )
	return self:sub( 1 , str:len() ) == str
end

function string:EndsWith( str )
	return self:sub( -str:len() ) == str
end

function string:ToABlist()
	if self and self ~= "" then
		local list = self:Split( ";" )
		if #list > 0 then
			local item
			local items = {}
			for i , v in pairs( list ) do
				if v and v ~= "" then
					item = v:Split( "," )
					if item[1] ~= "" and item[2] ~= "" and tonumber( item[2] ) then
						item[2] = math.ceil( item[2] )
						items[item[1]] = item[2] < 1 and 1 or item[2]
					end
				end
			end
			return items
		else return {} end
	else return {} end
end

function string:Spos( pos )
	self = self or ""
	return self .. pos.x .. "," .. pos.y
end

function string:Level()
	return tonumber( self:sub( -1 ) )
end

function string:LastLevel()
	return self:sub( 1 , -2 ) .. ( self:Level() - 1 )
end

function string:NextLevel()
	return self:sub( 1 , -2 ) .. ( self:Level() + 1 )
end

function string:GetEnergyClass()
	local class = ""
	local value = self
	local pos , _ = value:find( "[a-zA-Z]" )
	if pos then
		class = value:sub( pos )
		value = value:sub( 1 , pos-1 )
	end
	return tonumber( value ) , class
end

function string:ToFunctionName()
	local functionName = ""
	for index , str in pairs( self:Split( "-" ) ) do
		functionName = functionName .. str:UpperCaseFirst()
	end
	return functionName
end

function table.Size( data )
	return table_size( data )
end

function table.HasKey( data , key )
	for k , v in pairs( data ) do
		if k == key then return true end
	end
	return false
end

function table.Has( data , value )
	for k , v in pairs( data ) do
		if v == value then return true end
	end
	return false
end

function table.GetWithName( data , name )
	for k , v in pairs( data ) do
		if type( v ) == "table" and v.name == name then return v end
	end
	return nil
end

function table.ShallowCopy( data )
	local new_data = {}
	for k , v in pairs( data ) do new_data[k] = v end
	return new_data
end

function table.TableToString( data , level )
	if type( data ) ~= "table" then e( "数据类型错误：无法对非 table 类型的数据进行转换" ) end
	level = level or 1
	local levelSpace = ""
	for i = 1 , level , 1 do levelSpace = levelSpace .. "    " end
	local size = 1
	local maxSize = table.Size( data )
	local s = level == 1 and "\n{" or "{"
	for k , v in pairs( data ) do
		s = s .. "\n" .. levelSpace .. ( type( k ) == "number" and "" or ( tostring( k ) .. " : " ) )
		local dataType = type( v )
		if dataType == "table" then s = s .. table.TableToString( v , level+1 )
		elseif dataType == "string" then s = s .. "\"" .. v .. "\""
		else s = s .. tostring( v ) end
		if size < maxSize then s = s .. " ," end
		size = size + 1
	end
	s = s .. "\n"
	for i = 1 , level-1 , 1 do s = s .. "    " end
	return s .. "}"
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 报错信息 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local mmess = error

function error( message )
	log( "[错误获取] SIAllRoadsLeadToRome_Code: "..message )
end

function e( message )
	local output = ""
	for i = 5 , 2 , -1 do
		local a = debug.getinfo( i , "S" )
		local b = debug.getinfo( i , "l" )
		local c = debug.getinfo( i , "n" )
		if a and a.source then output = output .. a.source:sub( 2 , -1 )
		else output = output .. "[unknown]" end
		if b and b.currentline then output = output .. ":" .. b.currentline
		else output = output .. ":-1" end
		if c and c.name then output = output .. ":" .. c.name .. "()"
		else output = output .. ":[filecode]" end
		output = output .. " :: "
	end
	mmess( "_____ :: "..output..message )
end

function ee( tableData )
	e( table.TableToString( tableData ) )
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 引用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local SINeedListData = {}

function need( name , notself )
	local source = debug.getinfo( 2 , "S" ).source
	if notself then
		for i = 3 , 10 , 1 do
			source = debug.getinfo( i , "S" )
			if source then
				source = source.source
				if not source:find( CoreName ) then break end
			else
				source = debug.getinfo( i-1 , "S" ).source
				break
			end
		end
	end
	local isBase = name:find( "__" )
	source = isBase and source:sub( source:find( "__" , 3 )+3 , -1 ) or source:sub( 2 , -1 )
	local path = SINeedListData[source]
	if not path then
		path = isBase and "" or source:match( "^.*/" ) or ""
		SINeedListData[source] = path
	end
	return require( path..name )
end

function needList( basePath , ... )
	local results = {}
	for i , path in pairs{ ... } do if path then results[path] = need( basePath.."."..path , true ) end end
	return results
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 输出信息 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SISettings =
{
	Startup = {} ,
	Runtime = {} ,
	PerPlayer = {}
}

SIInit =
{
	StateDefine =
	{
		Settings = 0 ,
		Data = 1 ,
		DataUpdates = 2 ,
		DataFinalFixes = 3 ,
		Control = 4
	} ,
	State = nil ,
	PackageName = nil ,
	OrderCode = 10000 ,
	CurrentConstants = {} ,
	ConstantsData = {} ,
	CoreName = CoreName ,
	AutoLoadDataList = {}
}

function SIInit.AutoLoad( stateCode )
	if not table.Has( SIInit.StateDefine , stateCode ) then
		e( "不存在的阶段 : "..stateCode )
		return
	end
	SIInit.State = stateCode
	for index , name in pairs( packageList ) do
		SIInit.packageName = name
		local registerData = need( "package."..name..".0_auto_load" , true )
		if not registerData or type( registerData ) ~= "table" then registerData = {} end
		for index = 1 , 4 , 1 do
			local fileList = registerData[index]
			if fileList and type( fileList ) == "string" then
				fileList = { fileList }
				registerData[index] = fileList
			end
			if not fileList or type( fileList ) ~= "table" or #fileList < 1 then
				fileList = {}
				if index == 1 then table.insert( fileList , "1_data" )
				else if index == 2 then table.insert( fileList , "2_data-updates" )
				else if index == 3 then table.insert( fileList , "3_data-final-fixes" )
				else if index == 4 then table.insert( fileList , "4_control" ) end
				registerData[index] = fileList
			end
		end
		SIInit.AutoLoadDataList[SIInit.packageName] = registerData
	end
	if SIInit.State == SIInit.StateDefine.Settings or SIInit.State == SIInit.StateDefine.Data or SIInit.State == SIInit.StateDefine.Control then
		if SIInit.State == SIInit.StateDefine.Data then need( "define.generator.sigen" , true )
		else if SIInit.State == SIInit.StateDefine.Control then
			need( "define.runtime.load" , true )
		end
		local constantsDataList = { CORE = need( "constants" , true ) }
		for name , data in pairs( SIInit.AutoLoadDataList ) do
			SIInit.packageName = name
			local constantsData = need( "package."..name..".0_constants" , true )
			if constantsData then constantsDataList[name] = constantsData end
		end
		for name , constantsData in pairs( constantsDataList ) do
			SIInit.packageName = name
			SIInit.OrderCode = SIInit.OrderCode + 1000
			local class = constantsData.name:upper()
			_G[class] = constantsData
			SIInit.ConstantsData[name] = constantsData
			SIInit.CurrentConstants = constantsData
			-- 添加基础数据
			local realName = constantsData.name:gsub( "_" , "-" ) .. "-"
			constantsData.class = class
			constantsData.realName = realName
			constantsData.orderCode = SIInit.OrderCode
			constantsData.orderName = SIInit.OrderCode .. "[" .. realName .. "o]-"
			-- 加载前回调
			if constantsData.BeforeLoad then constantsData.BeforeLoad() end
			if SIInit.State == SIInit.StateDefine.Settings then
				-- 创建设置
				if constantsData.settings then
					local settings = {}
					for settingName , settingValue in pairs( constantsData.settings ) do
						constantsData.orderCode = constantsData.orderCode + 1
						settingName = realName .. settingName:gsub( "_" , "-" )
						local settingItem =
						{
							type = settingValue[1] .. "-setting" ,
							setting_type = settingValue[2] ,
							name = settingName ,
							localised_name = settingValue[8] or nil ,
							localised_description = settingValue[9] or nil ,
							default_value = settingValue[3] ,
							allowed_values = settingValue[6] ,
							allow_blank = settingValue[7] or false ,
							order = constantsData.orderCode
						}
						if type == "int" or type == "double" then
							settingItem.minimum_value = settingValue[4]
							settingItem.maximum_value = settingValue[5]
						end
						table.insert( settings , settingItem )
					end
					if #settings > 0 then data:extend( settings ) end
				end
			else
				-- 创建设置引用
				if constantsData.settings then
					local startupList = {}
					local runtimeList = {}
					local perPlayerList = {}
					for settingName , settingValue in pairs( constantsData.settings ) do
						local key = realName .. settingName:gsub( "_" , "-" )
						if v[2] == "startup" then startupList[settingName] = function() return settings.startup[key].value end
						elseif v[2] == "runtime-global" then runtimeList[settingName] = function() return settings.global[key].value end
						elseif v[2] == "runtime-per-user" then perPlayerList[settingName] = function( playerOrIndex )
								if type( playerOrIndex ) == "number" or not playerOrIndex.is_player then playerOrIndex = game.players[playerOrIndex] end
								return playerOrIndex.mod_settings[key]
							end
						end
					end
					if constantsData.finalSettingDataList then
						for settingName , settingValue in pairs( constantsData.finalSettingDataList ) do
							if startupList[settingName] then startupList[settingName] = function() return settingValue end
							elseif runtimeList[settingName] then runtimeList[settingName] = function() return settingValue end
							elseif perPlayerList[settingName] then perPlayerList[settingName] = function() return settingValue end end
						end
					end
					SISettings.Startup[class] = startupList
					SISettings.Runtime[class] = runtimeList
					SISettings.PerPlayer[class] = perPlayerList
				end
				-- 计算资源文件路径
				if not constantsData.base then constantsData.base = SIInit.CoreName
				else constantsData.base = string.sub( constantsData.base , 1 , 2 ) == "__" and constantsData.base or SIInit.CoreName end
				if constantsData.pictureSource then
					constantsData.pictureSource = string.sub( constantsData.pictureSource , 1 , 2 ) == "__" and constantsData.pictureSource or SIInit.CoreName
					constantsData.picturePath = constantsData.pictureSource .. "/package/" .. name .. "/graphic/"
				else constantsData.picturePath = constantsData.base .. "/package/" .. name .. "/graphic/" end
				if constantsData.picturePaths then
					local newPicturePaths = {}
					for path , typeList in pairs( constantsData.picturePaths ) do
						path = string.sub( path , 1 , 2 ) == "__" and path or SIInit.CoreName
						table.insert( newPicturePaths , { path = path , typeList = typeList } )
					end
					constantsData.mainPicturePath = 0
					constantsData.picturePaths = newPicturePaths
				end
				if constantsData.soundSource then
					constantsData.soundSource = string.sub( constantsData.soundSource , 1 , 2 ) == "__" and constantsData.soundSource or SIInit.CoreName
					constantsData.soundPath = constantsData.soundSource .. "/package/" .. name .. "/sound/"
				else constantsData.soundPath = constantsData.base .. "/package/" .. name .. "/sound/" end
				-- 自动注册伤害类型和其他类型
				local prototypeList = {}
				if constantsData.damageType then
					for index , name in pairs( constantsData.damageType ) do table.insert( prototypeList , { type = SITypes.damageType , name = name } ) end
				end
				if constantsData.categoryList then
					for id , category in pairs( SITypes.category ) do
						if constantsData.categoryList[category] then
							for index , name in pairs( constantsData.categoryList[category] ) do table.insert( prototypeList , { type = category , name = name } ) end
						end
					end
				end
				if #prototypeList > 0 then data:extend( prototypeList ) end
				-- 添加函数
				constantsData.GetPicturePath = function( prototypeType )
					if not constantsData.picturePaths then return constantsData.picturePath end
					if constantsData.mainPicturePath > 0 then
						local dataPack = constantsData.picturePaths[constantsData.mainPicturePath]
						for code , type in pairs( dataPack.typeList ) do
							if type == prototypeType then return dataPack.path end
						end
					else
						for index , dataPack in pairs( constantsData.picturePaths ) do
							if index ~= constantsData.mainPicturePath then
								for code , type in pairs( dataPack.typeList ) do
									if type == prototypeType then return dataPack.path end
								end
							end
						end
					end
					return constantsData.picturePath
				end
				-- 根据当前状态挂载不同的函数
				if SIInit.State == SIInit.StateDefine.Data then
					constantsData.Extend = function( ... )
						data:extend{ ... }
					end
				end
			end
			-- 加载完毕回调
			if constantsData.AfterLoad then constantsData.AfterLoad() end
		end
	end
	for name , data in pairs( SIInit.AutoLoadDataList ) do
		SIInit.packageName = name
		SIInit.CurrentConstants = SIInit.ConstantsData[name]
		for index , fileName in pairs( data[SIInit.State] ) do
			need( "package."..name.."."..fileName , true )
		end
	end
end
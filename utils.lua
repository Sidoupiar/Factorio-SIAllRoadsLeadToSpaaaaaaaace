-- ------------------------------------------------------------------------------------------------
-- ---------- 添加引用 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not util then util = require( "__core__/lualib/util" ) end

SITools = require( "define/sitools" )
SIFlags = require( "define/siflags" )
SITypes = require( "define/sitypes" )
SINumbers = require( "define/sinumbers" )
SIColors = require( "define/sicolors" )
SIMods = require( "define/simods" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 定义数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local CoreBaseName = "SIAllRoadsLeadToSpaaaaaaace"
local CoreName = "__" .. CoreBaseName .. "__"
local packageList =
{
	"0000_core" ,
	"0001_environment" ,
	"0002_resource" ,
	"0003_plant" ,
	"0004_living" ,
	"0005_ruin" ,
	"0006_trade" ,
	"0007_mission" ,
	"0008_event" ,
	"0009_base_improvement" ,
	"0020_tool_item" ,
	"0030_technology" ,
	"0040_agriculture" ,
	"0100_ore_processing" ,
	"0101_metal_smelting" ,
	"0102_metal_forging" ,
	"9001_garbage_collection" ,
	"9998_detail_improvement" ,
	"9999_debug"
}
local classList =
{
	"SIClass_PowerNumber"
}

if defines and defines.events then
	SIEvents = {}
	for k , v in pairs( defines.events ) do SIEvents[k] = v end
end

SIOrderList = { "a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i" , "j" , "k" , "l" , "m" , "n" , "o" , "p" , "q" , "r" , "s" , "t" , "u" , "v" , "w" , "x" , "y" , "z" }
SIOrderListSize = #SIOrderList

-- ------------------------------------------------------------------------------------------------
-- ---------- 定义函数 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not date then date = {} end

date.ticksPerDay = 25000
date.ticksPerHalfDay = 12500

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
	if not separator or separator:len() < 1 then return { self } end
	local pos = 0
	local list = {}
	for st , sp in function() return self:find( separator , pos , true ) end do
		table.insert( list , self:sub( pos , st-1 ) )
		pos = sp + 1
	end
	table.insert( list , self:sub( pos ) )
	return list
end

function string:Concat( list , separator )
	local str = self and self .. separator or ""
	local index = 1
	for i , v in pairs( list ) do
		if index > 1 then str = str + separator end
		str = str + v
		index = index + 1
	end
	return str
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

function string:FindLast( str )
	if not str or str:len() < 1 then return nil end
	local length = str:len()
	for index = self:len()-length , 1 , -1 do
		local startPos , endPos = self:find( str , index , length )
		if startPos then return startPos , endPos end
	end
	return nil
end

function string:RemoveLastAndAfter( str )
	local startPos = self:FindLast( str )
	return startPos and self:sub( 1 , startPos ) or self
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
		if SITools.IsTable( v ) and v.name == name then return v end
	end
	return nil
end

function table.ShallowCopy( data )
	local new_data = {}
	for k , v in pairs( data ) do new_data[k] = v end
	return new_data
end

function table.TableToString( data , level )
	if SITools.IsNotTable( data ) then e( "数据类型错误：无法对非 table 类型的数据进行转换" ) end
	level = level or 1
	local levelSpace = ""
	for i = 1 , level , 1 do levelSpace = levelSpace .. "    " end
	local size = 1
	local maxSize = table.Size( data )
	local s = level == 1 and "\n{" or "{"
	for k , v in pairs( data ) do
		s = s .. "\n" .. levelSpace .. ( SITools.IsNumber( k ) and "" or ( tostring( k ) .. " : " ) )
		if SITools.IsTable( v ) then s = s .. table.TableToString( v , level+1 )
		elseif SITools.IsString( v ) then s = s .. "\"" .. v .. "\""
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
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- API 需要在 data-updates 和 data-final-fixes 中才能正常使用
SIAPI = {}

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
	OrderCode = 1000000 ,
	CurrentConstantsData = {} ,
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
		if not registerData or SITools.IsNotTable( registerData ) then registerData = {} end
		for code = 1 , 4 , 1 do
			local fileList = registerData[code]
			if fileList and SITools.IsString( fileList ) then fileList = { fileList } end
			if not fileList or SITools.IsNotTable( fileList ) or #fileList < 1 then
				fileList = {}
				if code == 1 then table.insert( fileList , "1_data" )
				elseif code == 2 then table.insert( fileList , "2_data-updates" )
				elseif code == 3 then table.insert( fileList , "3_data-final-fixes" )
				elseif code == 4 then table.insert( fileList , "4_control" ) end
			end
			registerData[code] = fileList
		end
		SIInit.AutoLoadDataList[SIInit.packageName] = registerData
	end
	if SIInit.State == SIInit.StateDefine.Data then
		for index , name in pairs( classList ) do need( "define.class."..name ) end
		need( "define.generator.sidatakeys" , true )
		need( "define.generator.sigen" , true )
	elseif SIInit.State == SIInit.StateDefine.Control then
		for index , name in pairs( classList ) do need( "define.class."..name ) end
		need( "define.runtime.sievent_bus" , true )
		need( "define.runtime.siglobal" , true )
	end
	if SIInit.State == SIInit.StateDefine.Settings or SIInit.State == SIInit.StateDefine.Data or SIInit.State == SIInit.StateDefine.Control then
		local constantsDataList = {}
		for name , data in pairs( SIInit.AutoLoadDataList ) do
			SIInit.packageName = name
			local constantsData = need( "package."..name..".0_constants" , true )
			if constantsData then constantsDataList[name] = constantsData end
		end
		for name , constantsData in pairs( constantsDataList ) do
			SIInit.packageName = name
			SIInit.OrderCode = SIInit.OrderCode + 1000
			local class = "SIConstants_" .. constantsData.id
			_G[class] = constantsData
			constantsData.api =
			{
				name = constantsData.id ,
				path = SIInit.packageName
			}
			SIAPI[constantsData.id] = constantsData.api
			SIInit.ConstantsList[name] = constantsData
			SIInit.CurrentConstants = constantsData
			-- 添加基础数据
			local realClass = "SI" .. constantsData.id:upper():gsub( "_" , "-" ) .. "-"
			constantsData.showName = constantsData.name:gsub( "_" , "-" )
			local realName = "SI" .. constantsData.showName .. "-"
			constantsData.class = class
			constantsData.realClass = realClass
			constantsData.realName = realName
			constantsData.orderIndex = 100000
			constantsData.orderCode = SIInit.OrderCode
			constantsData.orderName = "z" .. SIInit.OrderCode .. "[" .. realClass .. "o]-"
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
							localised_name = settingValue[8] or { "SISetting-name."..settingName } ,
							localised_description = settingValue[9] or { "SI-common.description" , constantsData.showName , { "SISetting-description."..settingName } } ,
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
						if settingValue[2] == "startup" then startupList[settingName] = function() return settings.startup[key].value end
						elseif settingValue[2] == "runtime-global" then runtimeList[settingName] = function() return settings.global[key].value end
						elseif settingValue[2] == "runtime-per-user" then perPlayerList[settingName] = function( playerOrIndex )
								if SITools.IsNumber( playerOrIndex ) or not playerOrIndex.is_player then playerOrIndex = game.players[playerOrIndex] end
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
				-- 添加函数
				constantsData.HasAutoName = function( sourceName , typeName )
					if typeName then typeName = SITypes.autoName[typeName] end
					if typeName then typeName = typeName .. "-"
					else typeName = "" end
					local prefix = constantsData.realName .. typeName
					return sourceName:StartsWith( prefix ) , prefix
				end
				constantsData.AutoName = function( sourceName , typeName )
					local result , prefix = constantsData.HasAutoName( sourceName , typeName )
					if result then return sourceName
					else return prefix .. sourceName end
				end
				constantsData.RemoveAutoName = function( sourceName , typeName )
					local result , prefix = constantsData.HasAutoName( sourceName , typeName )
					if result then return sourceName:sub( prefix:len() )
					else return sourceName end
				end
				constantsData.AutoOrder = function()
					constantsData.orderIndex = constantsData.orderIndex + 1
					return constantsData.orderName .. constantsData.orderIndex
				end
				constantsData.GetPicturePath = function( name , typeName )
					name = name .. ".png"
					if not constantsData.picturePaths then return constantsData.picturePath .. name end
					if constantsData.mainPicturePath > 0 then
						local dataPack = constantsData.picturePaths[constantsData.mainPicturePath]
						for code , type in pairs( dataPack.typeList ) do
							if type == typeName then return dataPack.path .. name end
						end
					else
						for index , dataPack in pairs( constantsData.picturePaths ) do
							if index ~= constantsData.mainPicturePath then
								for code , type in pairs( dataPack.typeList ) do
									if type == typeName then return dataPack.path .. name end
								end
							end
						end
					end
					return constantsData.picturePath .. name
				end
				-- 处理节点
				if constantsData.raw then
					local newRaw = {}
					-- 待定
					constantsData.raw = newRaw
				end
				-- 自动注册伤害类型和其他类型
				local prototypeList = {}
				if constantsData.damageType then
					for index , name in pairs( constantsData.damageType ) do
						name = constantsData.AutoName( name , SITypes.damageType )
						constantsData.damageType[index] = name
						table.insert( prototypeList , { type = SITypes.damageType , name = name } )
					end
				end
				if constantsData.categoryList then
					for id , category in pairs( SITypes.category ) do
						if constantsData.categoryList[category] then
							for index , name in pairs( constantsData.categoryList[category] ) do
								name = constantsData.AutoName( name , category )
								constantsData.categoryList[category][index] = name
								table.insert( prototypeList , { type = category , name = name } )
							end
						end
					end
				end
				-- 提前处理公开数据
				if constantsData.raw and SITools.IsTable( constantsData.raw ) then
					for name , list in pairs( constantsData.raw ) do
						if list.type and list.list then
							local rawCode = list.name or name
							local output = constantsData[rawCode]
							if not output then
								output = {}
								constantsData[rawCode] = output
							end
							local typeName = list.type
							for key , name in pairs( list.list ) do
								output[key] = constantsData.AutoName( name , typeName )
							end
						end
					end
					constantsData.raw = nil
				end
			end
			-- 加载完毕回调
			if constantsData.AfterLoad then constantsData.AfterLoad() end
		end
	end
	if SIGen then SIGen.SetCore( SIConstants_Core ) end
	for name , autoLoadData in pairs( SIInit.AutoLoadDataList ) do
		SIInit.packageName = name
		SIInit.CurrentConstants = SIInit.ConstantsList[name]
		for index , fileName in pairs( autoLoadData[SIInit.State] ) do
			need( "package."..name.."."..fileName , true )
		end
		if SIGen then SIGen.Clean() end
	end
	if SIGen then SIGen.ResetAutoFillData() end
	if SIInit.State == SIInit.StateDefine.DataFinalFixes then
		for type , list in pairs( SIGen.GetRaw() ) do
			if table.Size( list ) > 0 then data:extend( list ) end
		end
	end
	if SIInit.State == SIInit.StateDefine.Data then
		for constantsName , list in pairs( SIAPI ) do
			for name , func in pairs( list ) do SIPrint.Debug( "SIAPI."..constantsName.."."..name ) end
		end
	elseif SIInit.State == SIInit.StateDefine.Control and remote then
		for constantsName , list in pairs( SIAPI ) do
			local functionList = {}
			for name , func in pairs( list ) do
				functionList[name] = func
				SIPrint.Debug( "remote -> SIAPI_"..constantsName.."."..name )
			end
			if table.Size( functionList ) > 0 then remote.add_interface( "SIAPI_"..constantsName , functionList ) end
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 输出信息 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIPrint =
{
	IsPatreonEnabled = function()
		return settings.startup["SIALTS-showPatreon"].value
	end ,
	IsDebugEnabled = function()
		return settings.startup["SIALTS-debug"].value
	end ,
	Log = function( message )
		log( CoreBaseName.." : "..message )
	end ,
	Debug = function( message )
		if SIPrint.IsDebugEnabled() then
			log( CoreBaseName.." : "..message )
			if game then game.print( { "SI-common.debug" , message } , SIColors.printColor.blue ) end
		end
	end ,
	Print = function( message )
		if SIInit.State == SIInit.StateDefine.Control then
			if game then game.print( { "SI-common.message" , message } , SIColors.printColor.green )
			else SIPrint.Log( message ) end
		else SIPrint.Log( message ) end
	end ,
	Message = function( playerOrIndex , customMessage )
		if SIInit.State == SIInit.StateDefine.Control then
			if not playerOrIndex then playerOrIndex = game
			elseif SITools.IsNumber( playerOrIndex ) or not playerOrIndex.is_player then playerOrIndex = game.players[playerOrIndex] end
			playerOrIndex.print( { "SI-common.message" , customMessage } , SIColors.printColor.green )
		else SIPrint.Log( customMessage ) end
	end ,
	Warning = function( playerOrIndex , customMessage )
		if SIInit.State == SIInit.StateDefine.Control then
			if not playerOrIndex then playerOrIndex = game
			elseif SITools.IsNumber( playerOrIndex ) or not playerOrIndex.is_player then playerOrIndex = game.players[playerOrIndex] end
			playerOrIndex.print( { "SI-common.warning" , customMessage } , SIColors.printColor.orange )
		else SIPrint.Log( customMessage ) end
	end ,
	Alert = function( playerOrIndex , customMessage )
		if SIInit.State == SIInit.StateDefine.Control then
			if not playerOrIndex then playerOrIndex = game
			elseif SITools.IsNumber( playerOrIndex ) or not playerOrIndex.is_player then playerOrIndex = game.players[playerOrIndex] end
			playerOrIndex.print( { "SI-common.alert" , customMessage } , SIColors.printColor.red )
		else SIPrint.Log( customMessage ) end
	end ,
	Error = e ,
	ErrorExpand = ee
}
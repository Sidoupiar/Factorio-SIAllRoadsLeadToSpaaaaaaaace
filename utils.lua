-- ------------------------------------------------------------------------------------------------
-- ---------- 添加引用 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not util then util = require( "__core__/lualib/util" ) end
require( "define/sitypes" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 定义函数 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

table.TableToString( data , level )
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
		if dataType == "table" then s = s .. debug.TableToString( v , level+1 )
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
function e( msg )
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
	mmess( "_____ :: "..output..msg )
end

error = function( msg )
	log( "[错误获取] SIAllRoadsLeadToRome_Code: "..msg )
end

function ee( tableData )
	e( debug.TableToString( tableData ) )
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 引用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SINeedlist = {}

function need( name , notself )
	local source = debug.getinfo( 2 , "S" ).source
	if notself then
		for i = 3 , 10 , 1 do
			source = debug.getinfo( i , "S" )
			if source then
				source = source.source
				if not source:find( "__SIAllRoadsLeadToRome__" ) then break end
			else
				source = debug.getinfo( i-1 , "S" ).source
				break
			end
		end
	end
	local isBase = name:find( "__" )
	source = isBase and source:sub( source:find( "__" , 3 )+3 , -1 ) or source:sub( 2 , -1 )
	local path = SINeedlist[source]
	if not path then
		path = isBase and "" or source:match( "^.*/" ) or ""
		SINeedlist[source] = path
	end
	return require( path..name )
end

function needlist( basePath , ... )
	local results = {}
	for i , path in pairs{ ... } do if path then results[path] = need( basePath.."/"..path , true ) end end
	return results
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 输出信息 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local packageList =
{
	"1_resource"
}

SIUtils =
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
	AutoLoadDataList = {} ,
	AutoLoad = function()
		for index , name in pairs( packageList ) do
			SIUtils.packageName = name
			local registerData = need( "package/"..name.."/0_auto_load" )
			SIUtils.AutoLoadDataList[SIUtils.packageName] = registerData
		end
		for name , data in pairs( SIUtils.AutoLoadDataList ) do
			SIUtils.packageName = name
			if SIUtils.State == SIUtils.StateDefine.Settings or SIUtils.State == SIUtils.StateDefine.Data or SIUtils.State == SIUtils.StateDefine.Control then
				local constantsData = need( "package/"..name.."/1_constants" )
				SIUtils.Init( constantsData )
			end
			for index , fileName in pairs( data[SIUtils.State] ) do
				need( "package/"..name.."/"..fileName )
			end
		end
	end ,
	Init = function( constantsData )
		
	end
}
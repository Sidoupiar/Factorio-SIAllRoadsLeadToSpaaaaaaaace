-- ------------------------------------------------------------------------------------------------
-- ---------- 检查引用 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

if not SIEventBus then e( "模块使用[SIGlobal] : 必须启用 SIEventBus 之后才能使用 SIGlobal 模块" ) end

-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGlobal =
{
	functionId = "SIGlobalCreate" ,
	added = false ,
	tableList = {} ,
	initFunctionList = {}
}

-- ------------------------------------------------------------------------------------------------
-- -------- 基础存取方法 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 把数据保存进 global 表中
-- ----------------------------------------
-- name = 键
-- data = 值
-- ----------------------------------------
function SIGlobal.Set( name , data )
	global[name] = data
	return SIGlobal
end

-- ----------------------------------------
-- 从 global 表中取出数据
-- ----------------------------------------
-- name = 键
-- ----------------------------------------
function SIGlobal.Get( name )
	return global[name]
end

-- ------------------------------------------------------------------------------------------------
-- ------- 构造全局数据包 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ----------------------------------------
-- 根据 name 的值来创建全局表
-- 通过这个函数创建的表会在 global 中有索引
-- 即表的数据会随着存档一起保存
-- ----------------------------------------
-- name = 全局表的名称 , 不能为空
-- initFunction = 创建全局表时用来初始化表数据的回调函数
-- ----------------------------------------
function SIGlobal.Create( name , initFunction )
	_G[name] = {}
	table.insert( SIGlobal.tableList , name )
	SIGlobal.initFunctionList[name] = initFunction
	if not SIGlobal.added then
		SIGlobal.added = true
		SIEventBus.Init( SIGlobal.CreateOnInit , SIGlobal.functionId ).Load( SIGlobal.CreateOnLoad , SIGlobal.functionId )
	end
	return SIGlobal
end

-- ----------------------------------------
-- 由于在 migration 中 , 定义在 SIGlobal 中的表不会自动初始化
-- 因此需要手动调用这个函数来初始化它们
-- ----------------------------------------
function SIGlobal.CreateOnMigrations()
	for i , name in pairs( SIGlobal.tableList ) do
		local data = SIGlobal.Get( name )
		if not data then SIGlobal.InitData( name )
		else _G[name] = data end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 内部函数 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- 框架内部函数
function SIGlobal.CreateOnInit()
	for i , name in pairs( SIGlobal.tableList ) do
		if not SIGlobal.Get( name ) then SIGlobal.InitData( name ) end
	end
end

-- 框架内部函数
function SIGlobal.CreateOnLoad()
	for i , name in pairs( SIGlobal.tableList ) do _G[name] = SIGlobal.Get( name ) end
end

-- 框架内部函数
function SIGlobal.InitData( name )
	local data = {}
	if _G[name] and type( _G[name] ) == "table" then data = _G[name] end
	_G[name] = data
	SIGlobal.Set( name , data )
	if SIGlobal.initFunctionList[name] then SIGlobal.initFunctionList[name]( data ) end
end
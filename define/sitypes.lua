local SITypes =
{
	-- 原型类型
	group                   = "item-group" ,
	subgroup                = "item-subgroup" ,
	fluid                   = "fluid" ,
	tile                    = "tile" ,
	signal                  = "virtual-signal" ,
	recipe                  = "recipe" ,
	technology              = "technology" ,
	damageType              = "damage-type" ,
	equipmentGrid           = "equipment-grid" ,
	beam                    = "beam" ,
	decorative              = "optimized-decorative" ,
	input                   = "custom-input" ,
	ambientSound            = "ambient-sound" ,
	font                    = "font" ,
	controlAutoplace        = "autoplace-control" ,
	category =
	{
		ammo                = "ammo-category" ,
		equipment           = "equipment-category" ,
		fuel                = "fuel-category" ,
		module              = "module-category" ,
		recipe              = "recipe-category" ,
		resource            = "resource-category"
	} ,
	item =
	{
		item                = "item" ,
		itemEntity          = "item-with-entity-data" ,
		tool                = "tool" ,
		toolRepair          = "repair-tool" ,
		railPlanner         = "rail-planner" ,
		ammo                = "ammo" ,
		armor               = "armor" ,
		capsule             = "capsule" ,
		gun                 = "gun" ,
		module              = "module" ,
		blueprint           = "blueprint" ,
		blueprintBook       = "blueprint-book" ,
		redprint            = "deconstruction-item" ,
		selectionTool       = "selection-tool" ,
		itemTag             = "item-with-tags" ,
		itemLabel           = "item-with-label" ,
		itemInventory       = "item-with-inventory"
	} ,
	stackableItem =
	{
		item                = "item" ,
		itemEntity          = "item-with-entity-data" ,
		tool                = "tool" ,
		toolRepair          = "repair-tool" ,
		railPlanner         = "rail-planner" ,
		ammo                = "ammo" ,
		capsule             = "capsule" ,
		gun                 = "gun" ,
		module              = "module"
	} ,
	unstackableItem =
	{
		armor               = "armor" ,
		blueprint           = "blueprint" ,
		blueprintBook       = "blueprint-book" ,
		redprint            = "deconstruction-item" ,
		selectionTool       = "selection-tool" ,
		itemTag             = "item-with-tags" ,
		itemLabel           = "item-with-label" ,
		itemInventory       = "item-with-inventory"
	} ,
	iconableItem =
	{
		item                = "item" ,
		itemEntity          = "item-with-entity-data" ,
		tool                = "tool" ,
		ammo                = "ammo" ,
		armor               = "armor" ,
		capsule             = "capsule" ,
		gun                 = "gun" ,
		module              = "module" ,
		
		fluid               = "fluid"
	} ,
	entity =
	{
		fire                = "fire" ,
		sticker             = "sticker" ,
		projectile          = "projectile" ,
		particle            = "particle" ,
		cliff               = "cliff" ,
		resource            = "resource" ,           -- 矿物
		tree                = "tree" ,
		character           = "character" ,
		fish                = "fish" ,
		unit                = "unit" ,
		spawner             = "unit-spawner" ,
		corpse              = "corpse" ,
		corpseCharacter     = "character-corpse" ,
		boiler              = "boiler" ,             -- 锅炉
		generator           = "generator" ,          -- 发电机
		burnerGenerator     = "burner-generator" ,   -- 燃烧发电机
		solar               = "solar-panel" ,
		reactor             = "reactor" ,
		accumulator         = "accumulator" ,
		accumulatorInfinity = "electric-energy-interface" ,
		pump                = "pump" ,               -- 泵
		pumpOffshore        = "offshore-pump" ,
		mining              = "mining-drill" ,       -- 矿机
		furnace             = "furnace" ,            -- 熔炉
		machine             = "assembling-machine" , -- 组装机
		lab                 = "lab" ,
		beacon              = "beacon" ,
		market              = "market" ,
		rocketSilo          = "rocket-silo" ,
		rocketRocket        = "rocket-silo-rocket" ,
		rocketShadow        = "rocket-silo-rocket-shadow" ,
		belt                = "transport-belt" ,
		beltGround          = "underground-belt" ,
		beltLinked          = "linked-belt" ,
		beltLoader          = "loader" ,
		beltLoaderSmall     = "loader-1x1" ,
		beltSplitter        = "splitter" ,
		pipe                = "pipe" ,               -- 管道
		pipeGround          = "pipe-to-ground" ,
		pipeHeat            = "heat-pipe" ,
		railStraight        = "straight-rail" ,
		railCurved          = "curved-rail" ,
		railStop            = "train-stop" ,
		railSign            = "rail-signal" ,
		railChain           = "rail-chain-signal" ,
		inserter            = "inserter" ,
		container           = "container" ,
		containerLogic      = "logistic-container" ,
		containerLinked     = "linked-container" ,
		containerFluid      = "storage-tank" ,
		containerInfinity   = "infinity-container" ,
		pole                = "electric-pole" ,
		powerSwitch         = "power-switch" ,
		lamp                = "lamp" ,
		car                 = "car" ,
		spiderVehicle       = "spider-vehicle" ,
		wagonLocomotive     = "locomotive" ,
		wagonCargo          = "cargo-wagon" ,
		wagonFluid          = "fluid-wagon" ,
		wagonArtillery      = "artillery-wagon" ,
		robotConstruct      = "construction-robot" , -- 建设机器人
		robotLogistic       = "logistic-robot" ,     -- 物流机器人
		robotCombat         = "combat-robot" ,       -- 攻击机器人
		roboport            = "roboport" ,           -- 指令平台
		playerPort          = "player-port" ,
		radar               = "radar" ,
		wall                = "wall" ,
		gate                = "gate" ,
		turret              = "turret" ,
		turretAmmo          = "ammo-turret" ,
		turretElectric      = "electric-turret" ,
		turretArtillery     = "artillery-turret" ,
		landMine            = "land-mine" ,
		combArithmetic      = "arithmetic-combinator" ,
		combDecider         = "decider-combinator" ,
		combConstant        = "constant-combinator" ,
		speaker             = "programmable-speaker" ,
		simpleEntity        = "simple-entity" ,
		simpleForce         = "simple-entity-with-force" ,
		simpleOwner         = "simple-entity-with-owner" ,
		flyingText          = "flying-text" ,
		speechBubble        = "speech-bubble" ,
		ghostEntity         = "entity-ghost" ,
		ghostTile           = "tile-ghost" ,
		proxyDt             = "deconstructible-tile-proxy" ,
		proxyIr             = "item-request-proxy" ,
		highlight           = "highlight-box" ,
		flame               = "flame-thrower-explosion" ,
		arrow               = "arrow" ,
		flare               = "artillery-flare" ,
		smoke               = "trivial-smoke" ,
		stream              = "stream"
	} ,
	healthEntity =
	{
		tree                = "tree" ,
		player              = "player" ,
		fish                = "fish" ,
		unit                = "unit" ,
		spawner             = "unit-spawner" ,
		boiler              = "boiler" ,             -- 锅炉
		generator           = "generator" ,          -- 发电机
		burnerGenerator     = "burner-generator" ,   -- 燃烧发电机
		solar               = "solar-panel" ,
		reactor             = "reactor" ,
		accumulator         = "accumulator" ,
		accumulatorInfinity = "electric-energy-interface" ,
		pump                = "pump" ,               -- 泵
		pumpOffshore        = "offshore-pump" ,
		mining              = "mining-drill" ,       -- 矿机
		furnace             = "furnace" ,            -- 熔炉
		machine             = "assembling-machine" , -- 组装机
		lab                 = "lab" ,
		beacon              = "beacon" ,
		market              = "market" ,
		rocketSilo          = "rocket-silo" ,
		belt                = "transport-belt" ,
		beltGround          = "underground-belt" ,
		beltLinked          = "linked-belt" ,
		beltLoader          = "loader" ,
		beltLoaderSmall     = "loader-1x1" ,
		beltSplitter        = "splitter" ,
		pipe                = "pipe" ,
		pipeGround          = "pipe-to-ground" ,
		pipeHeat            = "heat-pipe" ,
		railStraight        = "straight-rail" ,
		railCurved          = "curved-rail" ,
		railStop            = "train-stop" ,
		railSign            = "rail-signal" ,
		railChain           = "rail-chain-signal" ,
		inserter            = "inserter" ,
		container           = "container" ,
		containerLogic      = "logistic-container" ,
		containerLinked     = "linked-container" ,
		containerFluid      = "storage-tank" ,
		containerInfinity   = "infinity-container" ,
		pole                = "electric-pole" ,
		powerSwitch         = "power-switch" ,
		lamp                = "lamp" ,
		car                 = "car" ,
		spiderVehicle       = "spider-vehicle" ,
		wagonLocomotive     = "locomotive" ,
		wagonCargo          = "cargo-wagon" ,
		wagonFluid          = "fluid-wagon" ,
		wagonArtillery      = "artillery-wagon" ,
		robotConstruct      = "construction-robot" ,
		robotLogistic       = "logistic-robot" ,
		robotCombat         = "combat-robot" ,
		roboport            = "roboport" ,
		playerPort          = "player-port" ,
		radar               = "radar" ,
		wall                = "wall" ,
		gate                = "gate" ,
		turret              = "turret" ,
		turretAmmo          = "ammo-turret" ,
		turretElectric      = "electric-turret" ,
		turretArtillery     = "artillery-turret" ,
		landMine            = "land-mine" ,
		combArithmetic      = "arithmetic-combinator" ,
		combDecider         = "decider-combinator" ,
		combConstant        = "constant-combinator" ,
		speaker             = "programmable-speaker"
	} ,
	machine =
	{
		pump                = "pump" ,               -- 泵
		furnace             = "furnace" ,            -- 熔炉
		machine             = "assembling-machine"   -- 组装机
	} ,
	freelocEntity =
	{
		boiler              = "boiler" ,             -- 锅炉
		generator           = "generator" ,          -- 发电机
		burnerGenerator     = "burner-generator" ,   -- 燃烧发电机
		solar               = "solar-panel" ,
		reactor             = "reactor" ,
		accumulator         = "accumulator" ,
		accumulatorInfinity = "electric-energy-interface" ,
		pump                = "pump" ,               -- 泵
		pumpOffshore        = "offshore-pump" ,
		mining              = "mining-drill" ,       -- 矿机
		furnace             = "furnace" ,            -- 熔炉
		machine             = "assembling-machine" , -- 组装机
		lab                 = "lab" ,
		beacon              = "beacon" ,
		market              = "market" ,
		rocketSilo          = "rocket-silo" ,
		belt                = "transport-belt" ,
		beltGround          = "underground-belt" ,
		beltLinked          = "linked-belt" ,
		beltLoader          = "loader" ,
		beltLoaderSmall     = "loader-1x1" ,
		beltSplitter        = "splitter" ,
		pipe                = "pipe" ,
		pipeGround          = "pipe-to-ground" ,
		pipeHeat            = "heat-pipe" ,
		railStraight        = "straight-rail" ,
		railCurved          = "curved-rail" ,
		railStop            = "train-stop" ,
		railSign            = "rail-signal" ,
		railChain           = "rail-chain-signal" ,
		inserter            = "inserter" ,
		container           = "container" ,
		containerLogic      = "logistic-container" ,
		containerLinked     = "linked-container" ,
		containerFluid      = "storage-tank" ,
		containerInfinity   = "infinity-container" ,
		pole                = "electric-pole" ,
		powerSwitch         = "power-switch" ,
		lamp                = "lamp" ,
		roboport            = "roboport" ,
		playerPort          = "player-port" ,
		radar               = "radar" ,
		wall                = "wall" ,
		gate                = "gate" ,
		turret              = "turret" ,
		turretAmmo          = "ammo-turret" ,
		turretElectric      = "electric-turret" ,
		turretArtillery     = "artillery-turret" ,
		combArithmetic      = "arithmetic-combinator" ,
		combDecider         = "decider-combinator" ,
		combConstant        = "constant-combinator" ,
		speaker             = "programmable-speaker"
	} ,
	containerEntity =
	{
		character           = "character" ,
		container           = "container" ,
		containerLogic      = "logistic-container" ,
		containerLinked     = "linked-container" ,
		car                 = "car" ,
		spiderVehicle       = "spider-vehicle" ,
		wagonCargo          = "cargo-wagon" ,
		wagonArtillery      = "artillery-wagon" ,
		turretAmmo          = "ammo-turret" ,
	} ,
	equipment =
	{
		base                = "equipment" , -- 此项不能使用
		night               = "night-vision-equipment" ,
		shield              = "energy-shield-equipment" ,
		battery             = "battery-equipment" ,
		solar               = "solar-panel-equipment" ,
		generatorEquip      = "generator-equipment" ,
		activeDefense       = "active-defense-equipment" ,
		movement            = "movement-bonus-equipment" ,
		roboport            = "roboport-equipment" ,
		beltImmunity        = "belt-immunity-equipment"
	} ,
	-- 其他类型
	equipmentShapeType =
	{
		full                = "full" ,
		manual              = "manual"
	} ,
	logisticMode =
	{
		passive             = "passive-provider" , -- 红箱
		storage             = "storage" ,          -- 黄箱
		buffer              = "buffer" ,           -- 绿箱
		requester           = "requester" ,        -- 蓝箱
		active              = "active-provider"    -- 紫箱
	} ,
	linkedMode =
	{
		all                 = "all" ,
		admin               = "admin" ,
		none                = "none"
	} ,
	energy =
	{
		electric            = "electric" ,
		burner              = "burner" ,
		heat                = "heat" ,
		fluid               = "fluid" ,
		void                = "void"
	} ,
	electricUsagePriority =
	{
		primaryInput        = "primary-input" ,
		primaryOutput       = "primary-output" ,
		secondaryInput      = "secondary-input" ,
		secondaryOutput     = "secondary-output" ,
		tertiary            = "tertiary" ,
		solar               = "solar" ,
		lamp                = "lamp"
	} ,
	fluidBoxProductionType =
	{
		none                = "None" ,
		input               = "input" ,
		output              = "output" ,
		inAndOut            = "input-output"
	} ,
	fluidBoxConnectionType =
	{
		input               = "input" ,
		output              = "output" ,
		inAndOut            = "input-output"
	} ,
	moduleEffect =
	{
		speed               = "speed" ,
		product             = "productivity" ,
		consumption         = "consumption" ,
		pollut              = "pollution"
	} ,
	rock =
	{
		small               = "rock-small" ,
		medium              = "rock-medium" ,
		big                 = "rock-big"
	} ,
	controlAutoplaceCategory =
	{
		resource            = "resource" ,
		terrain             = "terrain" ,
		enemy               = "enemy"
	} ,
	view =
	{
		frame               = "" ,
	} ,
	modifier =
	{
		unlockRecipe                            = "unlock-recipe" ,
		gunSpeed                                = "gun-speed" ,
		ammoDamage                              = "ammo-damage" ,
		turretAttack                            = "turret-attack" ,
		giveItem                                = "give-item" ,
		nothing                                 = "nothing" ,
		
		inserterStackSizeBonus                  = "inserter-stack-size-bonus" ,
		stackInserterCapacityBonus              = "stack-inserter-capacity-bonus" ,
		miningDrillProductivityBonus            = "mining-drill-productivity-bonus" ,
		trainBrakingForceBonus                  = "train-braking-force-bonus" ,
		artilleryRange                          = "artillery-range" ,
		
		laboratorySpeed                         = "laboratory-speed" ,
		laboratoryProductivity                  = "laboratory-productivity" ,
		
		maximumFollowingRobotsCount             = "maximum-following-robots-count" ,
		followerRobotLifetime                   = "follower-robot-lifetime" ,
		workerRobotSpeed                        = "worker-robot-speed" ,
		workerRobotStorage                      = "worker-robot-storage" ,
		workerRobotBattery                      = "worker-robot-battery" ,
		
		ghostTimeToLive                         = "ghost-time-to-live" ,
		deconstructionTimeToLive                = "deconstruction-time-to-live" ,
		
		characterHealthBonus                    = "character-health-bonus" ,
		characterInventorySlotsBonus            = "character-inventory-slots-bonus" ,
		characterCraftingSpeed                  = "character-crafting-speed" ,
		characterMiningSpeed                    = "character-mining-speed" ,
		characterRunningSpeed                   = "character-running-speed" ,
		characterBuildDistance                  = "character-build-distance" ,
		characterItemDropDistance               = "character-item-drop-distance" ,
		characterReachDistance                  = "character-reach-distance" ,
		characterResourceReachDistance          = "character-resource-reach-distance" ,
		characterItemPickupDistance             = "character-item-pickup-distance" ,
		characterLootPickupDistance             = "character-loot-pickup-distance" ,
		characterLogisticSlots                  = "character-logistic-slots" ,
		characterLogisticTrashSlots             = "character-logistic-trash-slots" ,
		characterLogisticRequests               = "character-logistic-requests" ,
		characterAdditionalMiningCategories     = "character-additional-mining-categories" ,
		autoCharacterLogisticTrashSlots         = "auto-character-logistic-trash-slots" ,
		
		zoomToWorldEnabled                      = "zoom-to-world-enabled" ,
		zoomToWorldGhostBuildingEnabled         = "zoom-to-world-ghost-building-enabled" ,
		zoomToWorldBlueprintEnabled             = "zoom-to-world-blueprint-enabled" ,
		zoomToWorldDeconstructionPlannerEnabled = "zoom-to-world-deconstruction-planner-enabled" ,
		zoomToWorldUpgradePlannerEnabled        = "zoom-to-world-upgrade-planner-enabled" ,
		zoomToWorldSelectionToolEnabled         = "zoom-to-world-selection-tool-enabled" ,
		
		maxFailedAttemptsPerTickPerConstructionQueue     = "max-failed-attempts-per-tick-per-construction-queue" ,
		maxSuccessfulAttemptsPerTickPerConstructionQueue = "max-successful-attempts-per-tick-per-construction-queue"
	} ,
	trackType =
	{
		earlyGame = "early-game" , -- 载入游戏
		menuTrack = "menu-track" , -- 主菜单
		mainTrack = "main-track" , -- 游戏阶段
		interlude = "interlude"    -- 插曲
	} ,
	productType =
	{
		material = "material" ,
		resource = "resource" ,
		unit     = "unit"
	} ,

	all = {} ,
	autoName = {} ,
	rawCode = {} ,
	entityBack = {}
}

for type , real in pairs
{
	fluid            = "流体" ,
	tile             = "地板" ,
	signal           = "信号" ,
	recipe           = "配方" ,
	technology       = "科技" ,
	damageType       = "伤害" ,
	equipmentGrid    = "区域" ,
	beam             = "激光" ,
	decorative       = "遮盖" ,
	input            = "按键" ,
	ambientSound     = "音乐" ,
	font             = "字体" ,
	controlAutoplace = "放置" ,
	category         = "类别" ,
	item             = "物品" ,
	entity           = "实体" ,
	equipment        = "模块"
} do
	if SITools.IsTable( SITypes[type] ) then
		for key , value in pairs( SITypes[type] ) do
			SITypes.all[key] = value
			SITypes.autoName[value] = real
			SITypes.rawCode[value] = type
		end
	else
		SITypes.all[type] = SITypes[type]
		SITypes.autoName[SITypes[type]] = real
		SITypes.rawCode[SITypes[type]] = type
	end
end

for name , typeName in pairs( SITypes.entity ) do SITypes.entityBack[typeName] = name end

return SITypes
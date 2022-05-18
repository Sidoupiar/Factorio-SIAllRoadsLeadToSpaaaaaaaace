local SIFlags =
{
	itemFlags =
	{
		notStackable = "not-stackable" ,
		hidden = "hidden"
	} ,
	entityFlags =
	{
		hidden               = "hidden" , -- 隐藏
		noGapFill            = "no-gap-fill-while-building" ,
		notOnMap             = "not-on-map" , -- 不在地图上显示
		notFlammable         = "not-flammable" , -- 不可燃烧
		notRotatable         = "not-rotatable" , -- 不可旋转
		notRepairable        = "not-repairable" , -- 不可维修
		notBlueprintable     = "not-blueprintable" , -- 不能使用蓝图圈选
		notDeconstructable   = "not-deconstructable" , -- 不能使用红图圈选
		placeableEnemy       = "placeable-enemy" , -- 自动放置-[敌对]阵营
		placeablePlayer      = "placeable-player" , -- 自动放置-[玩家]阵营
		placeableNeutral     = "placeable-neutral" , -- 自动放置-[自然]阵营
		placeableOffGrid     = "placeable-off-grid" , -- 放置时不需要对齐地图网格
		hideAltInfo          = "hide-alt-info" , -- 隐藏详细信息
		hideFromBonus        = "hide-from-bonus-gui" , -- 从加成统计面板中隐藏
		fastReplaceableBuild = "fast-replaceable-no-build-while-moving" ,
		fastReplaceableCross = "fast-replaceable-no-cross-type-while-moving" ,
		building8Way         = "building-direction-8-way" , -- 是否可以旋转 8 次 , 就像铁路那样
		breathsAir           = "breaths-air" , -- 是否呼吸空气
		playerCreation       = "player-creation" , -- 是否由玩家创建
		filterDirections     = "filter-directions"
	} ,
	directions =
	{
		north = "north" ,
		east  = "east" ,
		south = "south" ,
		west  = "west"
	} ,
	directionCodes =
	{
		north = "朝北" ,
		east  = "朝东" ,
		south = "朝南" ,
		west  = "朝西"
	} ,
	collisionMasks =
	{
		ground        = "ground-tile" ,
		water         = "water-tile" ,
		resource      = "resource-layer" ,
		doodad        = "doodad-layer" ,
		floor         = "floor-layer" ,
		item          = "item-layer" ,
		ghost         = "ghost-layer" ,
		object        = "object-layer" ,
		player        = "player-layer" ,
		train         = "train-layer" ,
		rail          = "rail-layer" ,
		transportBelt = "transport-belt-layer" ,
		_13           = "layer-13" ,
		_14           = "layer-14" ,
		_15           = "layer-15" ,
		_16           = "layer-16" ,
		_17           = "layer-17" ,
		_18           = "layer-18" ,
		_19           = "layer-19" ,
		_20           = "layer-20" ,
		_21           = "layer-21" ,
		_22           = "layer-22" ,
		_23           = "layer-23" ,
		_24           = "layer-24" ,
		_25           = "layer-25" ,
		_26           = "layer-26" ,
		_27           = "layer-27" ,
		_28           = "layer-28" ,
		_29           = "layer-29" ,
		_30           = "layer-30" ,
		_31           = "layer-31" ,
		_32           = "layer-32" ,
		_33           = "layer-33" ,
		_34           = "layer-34" ,
		_35           = "layer-35" ,
		_36           = "layer-36" ,
		_37           = "layer-37" ,
		_38           = "layer-38" ,
		_39           = "layer-39" ,
		_40           = "layer-40" ,
		_41           = "layer-41" ,
		_42           = "layer-42" ,
		_43           = "layer-43" ,
		_44           = "layer-44" ,
		_45           = "layer-45" ,
		_46           = "layer-46" ,
		_47           = "layer-47" ,
		_48           = "layer-48" ,
		_49           = "layer-49" ,
		_50           = "layer-50" ,
		_51           = "layer-51" ,
		_52           = "layer-52" ,
		_53           = "layer-53" ,
		_54           = "layer-54" ,
		_55           = "layer-55" ,
		
		notCollidingWithItself  = "not-colliding-with-itself" ,
		considerTileTransitions = "consider-tile-transitions" ,
		collidingWithTilesOnly  = "colliding-with-tiles-only"
		
	} ,
	sciencePack =
	{
		key   = "description.science-pack-remaining-amount-key" ,
		value = "description.science-pack-remaining-amount-value"
	} ,
	conditions =
	{
		AND = "and" ,
		OR  = "or" ,
		NOT = "not"
	} ,
	priorities =
	{
		noAtlas          = "no-atlas" ,
		veryLow          = "very-low" ,
		low              = "low" ,
		medium           = "medium" ,
		high             = "high" ,
		extraHigh        = "extra-high" ,
		extraHighNoScale = "extra-high-no-scale"
	} ,
	blendModes =
	{
		normal           = "normal" ,
		additive         = "additive" ,
		additiveSoft     = "additive-soft" ,
		multiplicative   = "multiplicative" ,
		overwrite        = "overwrite"
	} ,
	graphicFlags =
	{
		light            = "light"
	}
}
return SIFlags
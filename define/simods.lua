local newModList = {}

local modList = nil
if mods then modList = mods
elseif script and script.active_mods then modList = script.active_mods end

if modList then
	for name , versionString in pairs( modList ) do
		local loaded = true
		local version = tonumber( string.gsub( versionString , "." , "" ) )
		newModList[name] =
		{
			displayName = { "mod-name."..name } ,
			description = { "mod-description."..name } ,
			loaded = loaded ,
			version = version
		}
	end
end

return newModList
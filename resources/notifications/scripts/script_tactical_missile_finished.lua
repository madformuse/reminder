local modpath = "/mods/reminder"
local selectHelper = import(modpath..'/modules/selectHelper.lua')


function getDefaultConfig()
	return nil
end
local runtimeConfig = {
	text = "",
	subtext = "",
	icons = {[1] = {icon='land_up.dds', isModFile=false}},
	unitsToSelect = {},
	sound = false,
}
function getRuntimeConfig()
	return runtimeConfig
end


local missileCountStationary = 0


function init()
	local faction = selectHelper.getFaction()
	if faction == "UEF" then
		runtimeConfig.icons[2] = {icon='UEB2108_icon.dds', isModFile=false}
	elseif faction == "AEON" then
		runtimeConfig.icons[2] = {icon='UAB2108_icon.dds', isModFile=false}
	elseif faction == "CYBRAN" then
		runtimeConfig.icons[2] = {icon='URB2108_icon.dds', isModFile=false}
	else
		runtimeConfig.icons[2] = {icon='XSB2108_icon.dds', isModFile=false}
	end
end


function triggerNotification(savedConfig)
	local currentMissilesStationary = 0
	runtimeConfig.unitsToSelect = {}
	
	for _,u in selectHelper.getAllUnits() do
		if(u:IsInCategory("TACTICALMISSILEPLATFORM") )then
			if(u:IsInCategory("STRUCTURE") )then
				info = u:GetMissileInfo()
				currentMissilesStationary = currentMissilesStationary + info.tacticalSiloStorageCount

				if( info.tacticalSiloStorageCount > 0 ) then
					table.insert(runtimeConfig.unitsToSelect, u)
				end
			end
		end
	end
	
	local difStationary = currentMissilesStationary - missileCountStationary
	if(difStationary > 0) then
		missileCountStationary = currentMissilesStationary
		if table.getn(runtimeConfig.unitsToSelect) < 2 then
			runtimeConfig.text = "TML is ready"
		else
			runtimeConfig.text = "TMLs are ready"
		end
		if difStationary == 1 then
			runtimeConfig.subtext = "A tac missile is ready"
		else
			runtimeConfig.subtext = difStationary.." tac missiles are ready"
		end
		return true
	end
	missileCountStationary = currentMissilesStationary
		
	return false
end


function onRetriggerDelay()
end
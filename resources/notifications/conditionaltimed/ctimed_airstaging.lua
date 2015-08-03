local modpath = "/mods/reminder"
local selectHelper = import(modpath..'/modules/selectHelper.lua')

function getDefaultConfig()
	return {
		[1] = {
			name = "Starts at gametime (seconds):",
			value = 720,
			path = "triggerAtSeconds",
			slider = {
				minVal = 0,
				maxVal = 60,
				valMult = 30,
			}
		},
		[2] = {
			name = "Retriggers each seconds:",
			value = 120,
			path = "retriggerDelay",
			slider = {
				minVal = 0,
				maxVal = 20,
				valMult = 15,
			}
		},
		[3] = {
			name = "Will trigger more than just once",
			path = "canRetrigger",
			value = true,
		},
	}
end
local runtimeConfig = {
	text = "Air Staging",
	subtext = "Good to have",
	icons = {[1] = {icon='land_up.dds', isModFile=false}},
	unitsToSelect = {},
	sound = false,
}
function getRuntimeConfig()
	if not runtimeConfig.icons[2] then
		local faction = selectHelper.getFaction()
		if faction == "UEF" then
			runtimeConfig.icons[2] = {icon='UEB5202_icon.dds', isModFile=false}
		elseif faction == "AEON" then
			runtimeConfig.icons[2] = {icon='UAB5202_icon.dds', isModFile=false}
		elseif faction == "CYBRAN" then
			runtimeConfig.icons[2] = {icon='URB5202_icon.dds', isModFile=false}
		else
			runtimeConfig.icons[2] = {icon='XSB5202_icon.dds', isModFile=false}
		end
	end

	return runtimeConfig
end


function triggerNotification(savedConfig)
	for _,u in selectHelper.getAllUnits() do
		if(u:IsInCategory("AIRSTAGINGPLATFORM") and u:IsInCategory("STRUCTURE")) then
			return false
		end
	end
	return true
end
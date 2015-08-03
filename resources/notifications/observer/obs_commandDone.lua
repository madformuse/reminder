local modpath = "/mods/reminder"
local selectHelper = import(modpath..'/modules/selectHelper.lua')
local observerLayer = import(modpath.."/modules/notificationObserverLayer.lua")


function getDefaultConfig()
	return 	{}
end
local runtimeConfig = {
	text = "Command executed",
	subtext = "",
	icons = {},
	unitsToSelect = {},
	sound = false,
}
function getRuntimeConfig()
	return runtimeConfig
end


local checkedUnits = {}


function init()
	checkedUnits = {}

	local KeyMapper = import('/lua/keymap/keymapper.lua')
	KeyMapper.SetUserKeyAction('Notifications: Add command finished notification', {action = "UI_Lua import('"..modpath.."/resources/notifications/observer/obs_commandDone.lua').onAddCommand()", category = 'Mods', order = 1020,})

	observerLayer.addCommandIssuedFunction(function(command)
		if command.CommandType == "None" then
			return
		end

		if command.Clear or command.CommandType == "Stop" then
			for _, u in command.Units do
				checkedUnits[u:GetEntityId()] = nil
			end
		else
			for _, u in command.Units do
				if checkedUnits[u:GetEntityId()] then
					for _, l in checkedUnits[u:GetEntityId()].checkedList do
						l.followedTasks = l.followedTasks + 1
					end
				end
			end
		end
	end)
end


function triggerNotification(savedConfig)
	runtimeConfig.unitsToSelect = {}

	for id, u in checkedUnits do
		if u.unit:IsDead() then
			checkedUnits[id] = nil
		else
			local amount = table.getn(u.unit:GetCommandQueue())
			for i, l in u.checkedList do
				l.tasksLeft = amount - l.followedTasks

				LOG('left: '..l.tasksLeft..', total: '..amount)

				if l.tasksLeft <= 0 then
					u.checkedList[i] = nil
					table.insert(runtimeConfig.unitsToSelect, u.unit)
				end
			end
		end
	end

	local numSelected = table.getn(runtimeConfig.unitsToSelect)
	if numSelected > 0 then
		if numSelected > 1 then
			runtimeConfig.subtext = numSelected.." units executed their order"
		else
			runtimeConfig.subtext = "One unit executed its order"
		end

		local unitToPick = runtimeConfig.unitsToSelect[1]
		runtimeConfig.icons[2] = {
			icon= runtimeConfig.unitsToSelect[1]:GetBlueprint().BlueprintId..'_icon.dds',
			isModFile=false
		}
		return true
	end

	return false
end


----------------------------------------------


function onAddCommand()
	local curUnits = GetSelectedUnits() or {}
	for _, u in curUnits do
		if not checkedUnits[u:GetEntityId()] then
			checkedUnits[u:GetEntityId()] = {
				unit = u,
				checkedList = {}
			}
		end
		table.insert(checkedUnits[u:GetEntityId()].checkedList, {
			tasksLeft = table.getn(u:GetCommandQueue()),
			followedTasks = 0,
		})
	end
end
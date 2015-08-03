local reminder_modpath = "/mods/reminder"
local selectHelper = import(reminder_modpath..'/modules/selectHelper.lua')

local originalCreateUI = CreateUI 
local originalOnSelectionChanged = OnSelectionChanged


function OnSelectionChanged(oldSelection, newSelection, added, removed)
	if not selectHelper.IsAutoSelection() then
		originalOnSelectionChanged(oldSelection, newSelection, added, removed)
	end
end


function CreateUI(isReplay) 
	originalCreateUI(isReplay)
	if not isReplay then
		import(reminder_modpath..'/modules/notificationPrefs.lua').init()
		import(reminder_modpath..'/modules/notificationUi.lua').init()
		AddBeatFunction(selectHelper.UpdateAllUnits)
		ForkThread(import(reminder_modpath..'/modules/notificationMain.lua').init)
	end
end


local KeyMapper = import('/lua/keymap/keymapper.lua')
KeyMapper.SetUserKeyAction('Notifications: Leftclick Last Notification', {action = "UI_Lua import('"..reminder_modpath.."/modules/notificationMain.lua').leftclickLast()", category = 'Mods', order = 996,})
KeyMapper.SetUserKeyAction('Notifications: Rightclick Last Notification', {action = "UI_Lua import('"..reminder_modpath.."/modules/notificationMain.lua').rightclickLast()", category = 'Mods', order = 997,})
KeyMapper.SetUserKeyAction('Notifications: Leftclick Cycle Notifications', {action = "UI_Lua import('"..reminder_modpath.."/modules/notificationMain.lua').cycleNotificationsLeftclick()", category = 'Mods', order = 998,})
KeyMapper.SetUserKeyAction('Notifications: Rightclick Cycle Notifications', {action = "UI_Lua import('"..reminder_modpath.."/modules/notificationMain.lua').cycleNotificationsRightclick()", category = 'Mods', order = 999,})
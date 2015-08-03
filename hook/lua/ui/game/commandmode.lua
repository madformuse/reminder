local reminder_observerLayer = import("/mods/reminder/modules/notificationreminder_observerLayer.lua")
local oldOnCommandIssued = OnCommandIssued

function OnCommandIssued(command)
	oldOnCommandIssued(command)
	ForkThread(reminder_observerLayer.onOnCommandIssued, command)
end
local observerLayer = import("/mods/reminder/modules/notificationObserverLayer.lua")
local oldOnCommandIssued = OnCommandIssued

function OnCommandIssued(command)
	oldOnCommandIssued(command)
	ForkThread(observerLayer.onOnCommandIssued, command)
end
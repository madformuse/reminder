local oldSelection = nil
local isAutoSelection = false
local allUnits = {}
local lastFocusedArmy = 0


function SelectBegin()
	oldSelection = GetSelectedUnits() or {}
	isAutoSelection = true
end
function SelectEnd()
	SelectUnits(oldSelection)
	isAutoSelection = false
end


function getAllUnits()
	return allUnits
end


function AddSelection()
	for _, unit in (GetSelectedUnits() or {}) do
		allUnits[unit:GetEntityId()] = unit
	end
end


function UpdateAllUnits()
	if GetFocusArmy() != lastFocusedArmy then
		Reset()
		lastFocusedArmy = GetFocusArmy()
	end

	AddSelection()
	
	-- Add focused (building or assisting), remove dead
	for entityid, unit in allUnits do
		if unit:IsDead() then
			allUnits[entityid] = nil
		elseif unit:GetFocus() and not unit:GetFocus():IsDead() then
			allUnits[unit:GetFocus():GetEntityId()] = unit:GetFocus()
		end
	end
end


function getFaction()
    local focusarmy = GetFocusArmy()
    if focusarmy >= 1 then
		local factionId = GetArmiesTable().armiesTable[focusarmy].faction
        if(factionId == 0) then
			return "UEF"
		elseif(factionId == 1) then
			return "AEON"
		elseif(factionId == 2) then
			return "CYBRAN"
		elseif(factionId == 3) then
			return "SERAPHIM"
		else
			return "UNKNOWN FACTION"
		end
    end
	return "OBSERVER"
end


function getLowestTechUnitsInGroup(group)
	local cats = {[1] = "TECH1", [2] = "TECH2", [3] = "TECH3"}
	local lowestTechUnits = {}
	for _, c in cats do
		for _, u in group do
			if u:IsInCategory(c) then
				table.insert(lowestTechUnits, u)
			end
		end
		if table.getn(lowestTechUnits) > 0 then
			return lowestTechUnits
		end
	end
end


function Reset()
	local currentlySelected = GetSelectedUnits() or {}
	isAutoSelection = true
	UISelectionByCategory("ALLUNITS", false, false, false, false)
	AddSelection()
	SelectUnits(currentlySelected)
	isAutoSelection = false
end


function IsAutoSelection()
	return isAutoSelection
end
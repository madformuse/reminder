function getFilenameWithoutDir(filename)
	return string.gsub(filename, "[a-z]*/", "")
end


function countTableElements(t)
	local cur = 0
	for _,__ in t do
		cur = cur+1
	end
	return cur
end


function modulo(a, b)
	return a - math.floor(a/b)*b
end


function logTable(t, prefix)
	LOG(prefix.."{")
	if type(t) == 'table' then
		for i, v in t do
			if(type(v) == 'table') then
				LOG(prefix..i.." (table): {")
				logTable(v, prefix.."__")
			elseif(type(v) == 'boolean' or type(v) == 'bool') then
				if(v) then
					LOG(prefix..i..": true")
				else
					LOG(prefix..i..": false")
				end
			elseif(type(v) == 'userdata') then
				LOG(prefix..i..": <userdata value>")
			else
				LOG(prefix..i..": "..v)
			end
		end
	elseif(type(t) == 'boolean' or type(t) == 'bool') then
		if(t) then
			LOG("true")
		else
			LOG("false")
		end
	elseif(type(t) == 'userdata') then
		LOG("<userdata value>")
	else
		LOG(t)
	end
	LOG(prefix.."}")
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
		for _, u in group or {} do
			if u:IsInCategory(c) then
				table.insert(lowestTechUnits, u)
			end
		end
		if table.getn(lowestTechUnits) > 0 then
			return lowestTechUnits
		end
	end
	return group or {}
end
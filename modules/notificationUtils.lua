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
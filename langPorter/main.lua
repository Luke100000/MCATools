local json = require("libs/json")

function table.copy(first_table)
	local second_table = { }
	for k,v in pairs(first_table) do
		if type(v) == "table" then
			second_table[k] = table.copy(v)
		else
			second_table[k] = v
		end
	end
	return second_table
end

function table.merge(first_table, second_table)
	for k,v in pairs(second_table) do
		if type(v) == "table" then
			if not first_table[k] then first_table[k] = { } end
			table.merge(first_table[k], v)
		else
			first_table[k] = v
		end
	end
	return first_table
end

function count(t)
	local c = 0
	for _,_ in pairs(t) do
		c = c + 1
	end
	return c
end

--delete old exports
function recRem(p)
	for d,s in ipairs(love.filesystem.getDirectoryItems(p)) do
		if love.filesystem.getInfo(p .. "/" .. s, "directory") then
			recRem(p .. "/" .. s)
		else
			love.filesystem.remove(p .. "/" .. s)
		end
	end
end

recRem("output")

--load old source langs
local sourceLang = { }
for _,file in pairs(love.filesystem.getDirectoryItems("source")) do
	local t = json.decode(love.filesystem.read("source/" .. file))
	table.merge(sourceLang, t)
end

--the original target lang files
local targetLang = { }
local total = 0
local renames = { }
for _,target in pairs(love.filesystem.getDirectoryItems("target")) do
	local t = json.decode(love.filesystem.read("target/" .. target))
	
	--look for renamed keys
	for d,s in pairs(sourceLang) do
		for i,v in pairs(t) do
			if s == v and d ~= i then
				renames[i] = d
				print(d .. " has been renamed to " .. i)
			end
		end
	end
	
	targetLang[target] = t
	total = total + count(t)
end

--the old translations
love.filesystem.createDirectory("output")
for _,language in pairs(love.filesystem.getDirectoryItems("translations")) do
	--load old
	local old = { }
	for _,file in pairs(love.filesystem.getDirectoryItems("translations/" .. language)) do
		local t = json.decode(love.filesystem.read("translations/" .. language .. "/" .. file))
		table.merge(old, t)
	end
	
	--try to port into new files
	local found = 0
	love.filesystem.createDirectory("output/" .. language)
	for file,target in pairs(targetLang) do
		new = { }
		for i,v in pairs(target) do
			local key = renames[i] or i
			if old[key] and old[key] ~= v then
				new[i] = old[key]
				found = found + 1
			end
		end
		love.filesystem.write("output/" .. language .. "/" .. file, json.encode(new))
	end
	
	print(string.format("%s\t%d%% reused", language, found / total * 100))
end

love.system.openURL(love.filesystem.getSaveDirectory() .. "/output")

os.exit()
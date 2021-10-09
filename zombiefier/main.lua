love.graphics.setDefaultFilter("nearest")

--get a list of files
local paths
function add(p)
	for d,s in ipairs(love.filesystem.getDirectoryItems(p)) do
		local pa = p .. "/" .. s
		if love.filesystem.getInfo(pa, "directory") then
			add(pa)
		else
			table.insert(paths, pa)
		end
	end
end

paths = { }
add("clothing")
add("example")

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

recRem("export")

--load resources
local shaderTorn = love.graphics.newShader("shaders/torn.glsl")
local shaderMoss = love.graphics.newShader("shaders/moss.glsl")

local mask = love.graphics.newImage("res/mask.png")
local moss = love.graphics.newImage("res/moss.png")

moss:setWrap("repeat")

shaderTorn:send("mask", mask)
shaderMoss:send("mask", moss)

--converts a given image and returns a rendered canvas
function convert(img)
	local canvas = love.graphics.newCanvas(64, 64)
	
	love.graphics.push("all")
	love.graphics.setCanvas(canvas)
	
	--torn
	love.graphics.setShader(shaderTorn)
	love.graphics.draw(img)
	
	--mossy
	love.graphics.setShader(shaderMoss)
	shaderMoss:send("offset", {math.random(), math.random()})
	love.graphics.draw(img)
	
	love.graphics.pop()
	return canvas
end

--exports all skins
local results = { }
for d,s in ipairs(paths) do
	local img = love.graphics.newImage(s)
	local canvas = convert(img)
	table.insert(results, {canvas, img})
	love.filesystem.createDirectory(("export/" .. s):match("(.*[/\\])"))
	canvas:newImageData():encode("png", "export/" .. s)
end

--previews files
function love.draw()
	love.graphics.clear(0.75, 0.75, 0.75)
	
	local i = math.ceil(love.mouse.getX() / love.graphics.getWidth() * #results)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(paths[i] or "", 5, 5)
	love.graphics.printf("press space to open export directory", 0, 5, love.graphics.getWidth() - 5, "right")
	
	love.graphics.setColor(1, 1, 1)
	local r = results[i]
	if r then
		local w = love.graphics.getWidth() / 128
		love.graphics.draw(r[2], 0, 40, 0, w)
		love.graphics.draw(r[1], love.graphics.getWidth() / 2, 40, 0, w)
	end
end

function love.keypressed(key)
	if key == "space" then
		love.system.openURL(love.filesystem.getSaveDirectory() .. "/export")
	end
end
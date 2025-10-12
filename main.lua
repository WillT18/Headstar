print(_VERSION)

local g3d = require("g3d")
local galaxy = require("galaxy")

math.randomseed(os.time())

local points = {}
local stars = {}
local n = 3000
local tetraScale = 0.1

love.load = function()
	--th = g3d.newModel("tetrahedron.obj", "yellow.png", {0, 0, 0})

	local c = 0
	
	local x, y, z, s
	for _, p in ipairs(galaxy.generate.outerArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.sagittariusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.perseusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.centaurusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/green.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.orionArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/blue.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.sagdeg(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.bootdsg(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.lmc(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.smc(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.center(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.globular(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	for _, p in ipairs(galaxy.generate.disk(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
	
--[[
	for nm, f in pairs(galaxy.generate) do
		print(nm)
		for _, p in ipairs(f(n)) do
			table.insert(points, p)
		end
	end
	print(#points)
	galaxy.settle(points)
	for _, p in ipairs(points) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, nil, tetraScale)
		table.insert(stars, s)
	end
]]

	--local cameraP = galaxy.vector3.new(50, 20, 0)
	--local px, py, pz = galaxy.data.fromV3(cameraP)
	--local cameraLook = galaxy.vector3.new(0, 0, 0)
	--local vx, vy, vz = galaxy.data.fromV3(cameraLook)
	--g3d.camera.lookAt(px, py, pz, vx, vy, vz)
	print(#stars)
end
local angle = 0
local lastDt = 0
love.update = function(dt)
	g3d.camera.firstPersonMovement(dt)
	lastDt = dt
end

love.draw = function()
	--th:draw()
	for _, star in ipairs(stars) do
		star:draw()
	end
	love.graphics.print(math.floor(1 / lastDt * 1000) / 1000 .. " fps")
	local cv = galaxy.data.toV3(unpack(g3d.camera.position))
	love.graphics.print(string.format("%.3f, %.3f, %.3f", cv.x, cv.y, cv.z), 0, 30)
	love.graphics.print("wasd: move\nspace: up\nlshift: down\nesc: close", 900)
end

love.mousemoved = function(x, y, dx, dy)
	g3d.camera.firstPersonLook(dx,dy)
end

local dr = 0.5
love.keypressed = function(key)
	if (key == "escape") then
		love.event.quit()
	end
end


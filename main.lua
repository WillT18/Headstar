print(_VERSION)

local g3d = require("g3d")
local galaxy = require("galaxy")

math.randomseed(os.time())

local stars = {}
local n = 3000
local tetraScale = 0.1

local function rot()
	return {
		math.random() * 2 * math.pi,
		math.random() * 2 * math.pi,
		math.random() * 2 * math.pi
	}
end

love.load = function()
	local c = 0
	local x, y, z, s
	for _, p in ipairs(galaxy.generate.outerArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("outer", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.sagittariusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("sag", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.perseusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("per", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.centaurusArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/green.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("cent", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.orionArm(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/blue.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("orion", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.sagdeg(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("sagdeg", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.bootdsg(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("bootes", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.lmc(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("lmc", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.smc(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("smc", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.center(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("center", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.globular(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("globular", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.disk(n)) do
		x, y, z = galaxy.data.fromV3(p)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, rot(), tetraScale)
		table.insert(stars, s)
	end
	print("disk", #stars - c)
	c = #stars

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
	print(#sphere)
	galaxy.settle(stars)
	--th1 = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {0, 0, 40}, nil, 0.5)
	--th2 = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {0, 1, 40}, nil, 0.5)
end
local angle = 0
local lastDt = 0
love.update = function(dt)
	g3d.camera.firstPersonMovement(dt)
	lastDt = dt
end

love.draw = function()

	local cv = galaxy.data.toV3(unpack(g3d.camera.position))
	local d
	for i, star in ipairs(stars) do
		d = g3d.vectors.magnitude(g3d.vectors.subtract(
			star.translation[1],
			star.translation[2],
			star.translation[3],
			g3d.camera.position[1],
			g3d.camera.position[2],
			g3d.camera.position[3]
		))
		star:setScale(math.max(0.001, math.min(d / 500, 0.1)))
		star:draw()
	end
	love.graphics.print(math.floor(1 / lastDt * 1000) / 1000 .. " fps")
	love.graphics.print(string.format("%.3f, %.3f, %.3f", cv.x, cv.y, cv.z), 0, 30)
	love.graphics.print("wasd: move\nspace: up\nlshift: down\nesc: close", love.graphics.getWidth() - 100)
end

love.mousemoved = function(x, y, dx, dy)
	g3d.camera.firstPersonLook(dx,dy)
end

love.keypressed = function(key)
	if (key == "escape") then
		love.event.quit()
	end
end


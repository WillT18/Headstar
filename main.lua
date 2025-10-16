print(_VERSION)

g3d = require("g3d")
local galaxy = require("galaxy")
local jetcam = require("jetcam")

math.randomseed(os.time())

local v3s = {}
local stars = {}
local n = 1000
local tetraScale = 0.5
math.pi2 = math.pi * 2
local mapScale = 1
local maxDist = g3d.camera.farClip - 800 -- distance threshold where we pin a star to a set distance from the camera

local function rot()
	return {
		math.random() * math.pi2,
		math.random() * math.pi2,
		math.random() * math.pi2
	}
end

local ship

love.load = function()
	ship = g3d.newModel("assets/814.obj", nil, {galaxy.data.fromV3(galaxy.vector3.new(10, 10, 10))}, nil, 0.1)
	ship:setRotation(math.pi / 2, 0, 0)
	--ship.matrix:setViewMatrix({0, 0, 10}, {galaxy.data.fromV3(galaxy.data.lmcCF.p)}, {0, 0, 1})
	--ship:setScale(0.1)
	local c = 0
	local x, y, z, s
	for _, p in ipairs(galaxy.generate.outerArm(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("outer", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.sagittariusArm(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("sag", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.perseusArm(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("per", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.centaurusArm(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/green.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("cent", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.orionArm(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/blue.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("orion", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.sagdeg(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("sagdeg", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.bootdsg(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("bootes", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.lmc(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("lmc", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.smc(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("smc", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.center(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/violet.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("center", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.globular(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", "assets/yellow.png", {x, y, z}, rot())
		table.insert(stars, s)
	end
	print("globular", #stars - c)
	c = #stars
	for _, p in ipairs(galaxy.generate.disk(n)) do
		table.insert(v3s, p * mapScale)
		x, y, z = galaxy.data.fromV3(p * mapScale)
		s = g3d.newModel("assets/tetrahedron.obj", nil, {x, y, z}, rot())
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

	local cameraP = galaxy.data.bootesCF.p
	local cameraTarg = galaxy.data.diskCF.p
	--jetcam.move(galaxy.cframe.lookAt(cameraP, cameraTarg))
	print(#stars)
	galaxy.settle(stars)
end
local angle = 0
local lastDt = 0
love.update = function(dt)
	g3d.camera.firstPersonMovement(dt)
	--jetcam.update(dt)
	lastDt = dt
end

love.draw = function()
	love.graphics.setColor(0.356863, 0.364706, 0.411765)
	ship:draw()
	love.graphics.setColor(1, 1, 1)
	local cv = galaxy.data.toV3(unpack(g3d.camera.position))
	local d
	local m
	local windowSize = math.min(love.graphics.getDimensions()) / 2
	local windowDistance = windowSize / math.tan(g3d.camera.fov / 2)
	for i, star in ipairs(stars) do
		m = (v3s[i] - cv).magnitude
		if (m < maxDist) then
			--if (not star.inside) then
				star:setTranslation(galaxy.data.fromV3(v3s[i]))
				star.inside = true
				star.mesh:setTexture(star.texture)
			--end
		else
			--if (star.inside or star.inside == nil) then
				star:setTranslation(galaxy.data.fromV3(cv + (v3s[i] - cv).unit * maxDist))
				star.inside = false
				star.mesh:setTexture(nil)
			--end
		end
		d = g3d.vectors.magnitude(g3d.vectors.subtract(
			star.translation[1],
			star.translation[2],
			star.translation[3],
			g3d.camera.position[1],
			g3d.camera.position[2],
			g3d.camera.position[3]
		))
		star:setScale(d * tetraScale / windowDistance)
		star:setRotation(unpack(rot()))
		star:draw()
	end
	love.graphics.print(
		string.format(
[[%.3f fps
%.3f, %.3f, %.3f
%.3f from origin]],
			1/ lastDt,
			cv.x, cv.y, cv.z,
			cv.magnitude
		)
	)
	love.graphics.print(
[[wasd: move
space: up
lshift: down
esc: close]],
		love.graphics.getWidth() - 100
	)
end

love.mousemoved = function(x, y, dx, dy)
	g3d.camera.firstPersonLook(dx,dy)
end

love.keypressed = function(key)
	if (key == "escape") then
		love.event.quit()
	end
end


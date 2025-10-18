print(_VERSION)

g3d = require("g3d")
local galaxy = require("galaxy")
local jetcam = require("jetcam")

local Vector3 = galaxy.vector3
local CFrame = galaxy.cframe

math.randomseed(os.time())

local v3s = {}
local stars = {}
local n = 200
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

local ship, shipf, shipu
local shipCF
local shipR = 0.25 * math.pi

local mx, my, mz


love.load = function()
	ship = g3d.newModel("assets/marker_2.obj", "assets/white.png", {10, 10, 10}, nil, 0.1)
	shipCF = CFrame.new(10, 10, 10)--CFrame.new(Vector3.new(10, 10, 10), galaxy.data.bootesCF.p)
	--ship.matrix:transformFromView(eye, targ, upV, ship.scale)
	--ship.matrix:setTransformationMatrix(eye, {0, 0, 0}, ship.scale)
	ship.matrix = galaxy.data.fromCF(shipCF, ship.scale)
	print(shipCF)
	print(ship.matrix)
	mx = g3d.newModel("assets/tetrahedron.obj", "assets/red.png", nil, nil, 0.25)
	my = g3d.newModel("assets/tetrahedron.obj", "assets/green.png", nil, nil, 0.25)
	mz = g3d.newModel("assets/tetrahedron.obj", "assets/blue.png", nil, nil, 0.25)

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
local t = 0
love.update = function(dt)
	--t = t + dt
	g3d.camera.firstPersonMovement(dt)
	--jetcam.update(dt)
	if (t == 1) then
		shipCF = shipCF * CFrame.angles(dt * shipR, 0, 0)
	elseif (t == 2) then
		shipCF = shipCF * CFrame.angles(0, dt * shipR, 0)
	elseif (t == 3) then
		shipCF = shipCF * CFrame.angles(0, 0, dt * shipR)
	elseif (t == -1) then
		shipCF = CFrame.new(shipCF.p)
		t = 0
	end
	ship.matrix = galaxy.data.fromCF(shipCF, ship.scale)
	mx:setTranslation(galaxy.data.fromV3((shipCF * CFrame.new(2, 0, 0)).p))
	my:setTranslation(galaxy.data.fromV3((shipCF * CFrame.new(0, 2, 0)).p))
	mz:setTranslation(galaxy.data.fromV3((shipCF * CFrame.new(0, 0, 2)).p))
	lastDt = dt
end

love.draw = function()
	love.graphics.setColor(0.356863, 0.364706, 0.411765)
	ship:draw()
	mx:draw()
	my:draw()
	mz:draw()
	love.graphics.setColor(1, 1, 1)
	local cv = galaxy.data.toV3(unpack(g3d.camera.position))
	local d
	local m
	local windowSize = math.min(love.graphics.getDimensions()) / 2
	local windowDistance = windowSize / math.tan(g3d.camera.fov / 2)
	for i, star in ipairs(stars) do
		--m = v3s[i] - cv
		--star:setTranslation(galaxy.data.fromV3(cv + m.unit * 1))
		d = g3d.vectors.magnitude(g3d.vectors.subtract(
			star.translation[1],
			star.translation[2],
			star.translation[3],
			g3d.camera.position[1],
			g3d.camera.position[2],
			g3d.camera.position[3]
		))
		star:setScale(d * tetraScale / windowDistance)
		if (star.rtimer == nil or star.rtimer <= 0) then
			star:setRotation(unpack(rot()))
			star.rtimer = math.random(1, 10)
		else
			star.rtimer = star.rtimer - 1
		end
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
	elseif (key == "x") then
		t = 1
	elseif (key == "y") then
		t = 2
	elseif (key == "z") then
		t = 3
	elseif (key == "e") then
		t = 0
	elseif (key == "r") then
		t = -1
	end
end


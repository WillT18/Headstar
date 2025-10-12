local Vector3 = galaxy.vector3
local CFrame = galaxy.cframe
local data = galaxy.data
local arms = galaxy.arms

local function randomPointInEllipsoid(size, d)
	local theta = 2 * math.pi * math.random()
	-- latitude (arc cosine prevents stars from clustering around the north and south poles)
	local phi = math.acos((2 * math.random()) - 1)-- - math.pi / 2
	-- distance (square root prevents stars from clustering around the origin)
	-- d = 2: even distribution
	-- d < 2: stars concentrated around center
	-- d > 2: stars concentrated around surface
	local r = math.random() ^ (1 / d)

	return Vector3.new(
		r * math.sin(phi) * math.cos(theta),
		r * math.sin(phi) * math.sin(theta),
		r * math.cos(phi)
	) * size / 2
end

local function isPointInEllipsoid(size, p)
	local axis = size / 2
	return ((p.x / axis.x) ^ 2 + (p.y / axis.y) ^ 2 + (p.z / axis.z) ^ 2) <= 1
end

local module = {}

function module.outerArm(n)
	local results = {}
	local t, r, lv, w, theta, radius
	for i = 1, math.floor(n * data.outerarm) do
		t = math.random()
		r, lv, w = arms.outerArm(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random()) * w
		results[i] = (CFrame.lookAlong(r, lv) * CFrame.angles(0, 0, theta) * CFrame.new(0, radius * data.armWidth, 0)).p
	end
	return results
end

function module.sagittariusArm(n)
	local results = {}
	local t, r, lv, w, theta, radius
	for i = 1, math.floor(n * data.mainarm) do
		t = math.random()
		r, lv, w = arms.sagittariusArm(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random()) * w
		results[i] = (CFrame.lookAlong(r, lv) * CFrame.angles(0, 0, theta) * CFrame.new(0, radius * data.armWidth, 0)).p
	end
	return results
end

function module.perseusArm(n)
	local results = {}
	local t, r, lv, w, theta, radius
	for i = 1, math.floor(n * data.mainarm) do
		t = math.random()
		r, lv, w = arms.perseusArm(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random()) * w
		results[i] = (CFrame.lookAlong(r, lv) * CFrame.angles(0, 0, theta) * CFrame.new(0, radius * data.armWidth, 0)).p
	end
	return results
end

function module.centaurusArm(n)
	local results = {}
	local t, r, lv, w, theta, radius
	for i = 1, math.floor(n * data.mainarm) do
		t = math.random()
		r, lv, w = arms.centaurusArm(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random()) * w
		results[i] = (CFrame.lookAlong(r, lv) * CFrame.angles(0, 0, theta) * CFrame.new(0, radius * data.armWidth, 0)).p
	end
	return results
end

function module.orionArm(n)
	local results = {}
	local t, r, lv, w, theta, radius
	for i = 1, math.floor(n * data.minorarm) do
		t = math.random()
		r, lv, w = arms.orionArm(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random()) * w
		results[i] = (CFrame.lookAlong(r, lv) * CFrame.angles(0, 0, theta) * CFrame.new(0, radius * data.orionArmWidth, 0)).p
	end
	return results
end

function module.disk(n)
	local results = {}
	for i = 1, math.floor(n * data.disk) do
		results[i] = data.diskCF * randomPointInEllipsoid(data.diskSize, 3)
	end
	return results
end

function module.center(n)
	local results = {}
	local bn = math.floor(n * data.bar)
	for i = 1, bn do
		results[i] = data.longBarCF * randomPointInEllipsoid(data.longBarSize, 3)
	end
	local p
	for j = 1, math.floor(n * data.bulge) do
		--repeat
		p = randomPointInEllipsoid(data.centerBulgeSize, 2)
		--until (not isPointInEllipsoid(data.longBarSize, p))
		results[bn + j] = data.centerBulgeCF * p
	end
	return results
end

function module.globular(n)
	local results = {}
	local gclusterstarpool = math.floor(n * data.globular)
	local starsThisCluster
	while (gclusterstarpool > 0) do
		starsThisCluster = math.min(gclusterstarpool, math.floor(data.globular * n / data.numberOfClusters * (0.75 + math.random() * 0.5)))
		gclusterstarpool = gclusterstarpool - starsThisCluster

		local theta = 2 * math.pi * math.random()
		local phi = math.acos((math.random() * 0.5 + 0.5) * (-1) ^ math.random(1, 2))
		local d = math.random() ^ (1 / 5)

		local r = Vector3.new(
			d * math.sin(phi) * math.cos(theta),
			d * math.cos(phi),
			d * math.sin(phi) * math.sin(theta)
		) * data.haloSize / 2

		for i = 1, starsThisCluster do
			local theta2 = 2 * math.pi * math.random()
			local phi2 = math.acos((2 * math.random()) - 1)
			local d2 = math.random() ^ (1 / 1)

			local r2 = Vector3.new(
				d2 * math.sin(phi2) * math.cos(theta2),
				d2 * math.cos(phi2),
				d2 * math.sin(phi2) * math.sin(theta2)
			) * 2

			table.insert(results, r + r2)
		end
	end
	return results
end

function module.lmc(n)
	local results = {}
	local sn = math.floor(n * data.lmc * data.lmcSpiralDist)
	local t, r, lv, w, theta, radius, cr
	for i = 1, sn do
		t = math.random() * 2 - 1
		t = math.abs(t) ^ (4 / 1) * data.sign(t)
		r, lv, w = arms.lmcSpiral(t)
		theta = math.random() * 2 * math.pi
		radius = math.sqrt(math.random())
		cr = Vector3.new(radius * math.cos(theta), radius * math.sin(theta), 0)
		results[i] = (data.lmcCF * CFrame.lookAlong(r * data.lmcSize / 2, lv) * CFrame.new(cr * data.lmcAxis * w)).p
	end
	for j = 1, math.floor(n * data.lmc - sn) do
		results[sn + j] = data.lmcCF * randomPointInEllipsoid(data.lmcSize, 3)
	end
	return results
end

function module.smc(n)
	local results = {}
	for i = 1, math.floor(n * data.smc) do
		results[i] = data.smcCF * randomPointInEllipsoid(data.smcSize, 1)
	end
	return results
end

function module.sagdeg(n)
	local results = {}
	for i = 1, math.floor(n * data.sagdeg) do
		results[i] = data.sagdegCF * randomPointInEllipsoid(data.sagdegSize, 1)
	end
	return results
end

function module.bootdsg(n)
	local results = {}
	for i = 1, math.floor(n * data.bootdsg) do
		results[i] = data.bootesCF * randomPointInEllipsoid(data.bootesSize, 1)
	end
	return results
end

return module

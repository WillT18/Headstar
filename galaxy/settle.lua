local Vector3 = galaxy.vector3
--local g3d = require("g3d")

local limit = 0.001
local ec = 0.01
local dt = 0.01
local climit = 100000

--return function(stars)
local function old(stars)
	local minDist = 0
	local c = 0
	local velocity = {}
	local forceM, forceD
	while (minDist < limit) do
		minDist = math.huge
		for i, star1 in ipairs(stars) do
			for j, star2 in ipairs(stars) do
				if (i ~= j) then
					forceM = ec / ((star1 - star2).magnitude ^ 2)
					forceD = (star1 - star2).unit -- force exerted by star2 onto star1
					if (velocity[i] == nil) then
						velocity[i] = forceD * forceM
					else
						velocity[i] = velocity[i] + forceD * forceM
					end
					minDist = math.min(minDist, (star1 - star2).magnitude)
					c = c + 1
					if (c > climit) then
						c = 0
						--print(1)
						--love.timer.sleep(0.05)
					end
				end
			end
		end
		print(minDist)
		if (minDist >= limit) then
			break
		end
		for i, star1 in ipairs(stars) do
			star1 = star1 + velocity[i] * dt
			c = c + 1
			if (c > climit) then
				c = 0
				print(2)
				--love.timer.sleep(0.05)
			end
		end
		love.timer.sleep(0.05)
	end
	print(minDist)
end

return function(stars)
	local minDist = math.huge
	local maxDist = 0
	local dist
	local t0 = os.time()
	for i = 1, #stars do
		for j = i + 1, #stars do
			dist = g3d.vectors.magnitude(g3d.vectors.subtract(
				stars[i].translation[1],
				stars[i].translation[2],
				stars[i].translation[3],

				stars[j].translation[1],
				stars[j].translation[2],
				stars[j].translation[3]
			))
			--dist = (stars[i] - stars[j]).magnitude
			minDist = math.min(minDist, dist)
			maxDist = math.max(maxDist, dist)
		end
	end
	print(minDist)
	print(maxDist)
	print(os.time() - t0)
end

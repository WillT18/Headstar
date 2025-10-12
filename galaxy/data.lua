local Vector3 = galaxy.vector3
local CFrame = galaxy.cframe

-- shortcut for creating an orientation from degree angles
local function fromOrientation(x, y, z)
	return CFrame.fromEulerAnglesYXZ(math.rad(x), math.rad(y), math.rad(z))
end
-- because Lua 5.1 doesn't have math.sign
local function sign(n)
	if (n < 0) then
		return -1
	elseif (n > 0) then
		return 1
	else
		return 0
	end
end
-- convert a set of cordinates to a Vector3
local function toV3(x, y, z)
	return Vector3.new(y, z, x)
end
-- convert right handed Y-up Vector3 coordinates to the right handed Z-up coordinates that g3d uses
local function fromV3(v)
	return v.z, v.x, v.y
end

local module = {
	
	-- static functions
	fromOrientation = fromOrientation,
	sign = sign,
	toV3 = toV3,
	fromV3 = fromV3,

	-- region position and sizes
	diskCF = CFrame.new(),
	diskSize = Vector3.new(100, 8, 100),
	haloCF = CFrame.new(),
	haloSize = Vector3.new(80, 40, 80),
	longBarCF = fromOrientation(0, 60, 0),
	longBarSize = Vector3.new(4, 2, 16),
	shortBarCF = fromOrientation(0, 90, 0),
	shortBarSize = Vector3.new(4, 1, 10),
	centerBulgeCF = CFrame.new(),
	centerBulgeSize = Vector3.new(24, 16, 24),
	sagdegCF = fromOrientation(0, -20, 15) + Vector3.new(-31, -28, -13),
	sagdegSize = Vector3.new(4, 12, 8),
	bootesCF = fromOrientation(60, 0, -60) + Vector3.new(-50, 50, 100),
	bootesSize = Vector3.new(4, 8, 4),
	lmcCF = fromOrientation(45, -30, 30) + Vector3.new(66, -31, -14),
	lmcSize = Vector3.new(24, 8, 16),
	smcCF = fromOrientation(-25, 85, 50) + Vector3.new(58, -53, -56),
	smcSize = Vector3.new(8, 4, 16),

	-- other constants
	spiralRadius = 40,		-- how far the main spiral arms go out
	spiralRatio = 1.2,		-- spiral ratio for the long arms
	armWidth = 4,			-- max arm width
	orionArmWidth = 3,		-- max width for the orion arm
	armScale = 1,			-- default parameter bound (t = [0, 1])
	outerArmScale = 1.5,	-- higher bound for the outer arm (t = [0, 1.5])
	orionArmScale = 0.825,	-- to place the orion arm between the main arms
	orionStart = 0.6,		-- lower bound for the orion arm
	orionEnd = 0.9,			-- upper bound for the orion arm
	tangentDt = 0.001,		-- how far to go when calculating the tangent vector at a given position along a spiral arm
	lmcSpiralDist = 0.9,	-- % of stars in the LMC that are part of its spiral

	-- star distribution ratios
	mainarm = 0.14, -- x3
	outerarm = 0.16, -- x1
	minorarm = 0.04,
	bulge = 0.1,
	disk = 0,
	bar = 0.05,
	smc = 0.01,
	lmc = 0.05,
	sagdeg = 0.01,
	bootdsg = 0.005,
	globular = 0.05,
	numberOfClusters = math.random(20, 30)
}

module.longBarAxis = module.longBarSize.z / 2
module.shortBarAxis = module.shortBarSize.z / 2
module.orionAxis = (module.orionEnd - module.orionStart) / 2
module.lmcAxis = Vector3.new(module.lmcSize.x / 2, module.lmcSize.z, module.lmcSize.x)

local sum = module.mainarm * 3 + module.outerarm + module.minorarm + module.bulge + module.disk + module.bar + module.smc + module.lmc + module.sagdeg + module.bootdsg + module.globular
module.mainarm = module.mainarm / sum
module.outerarm = module.outerarm / sum
module.minorarm = module.minorarm / sum
module.bulge = module.bulge / sum
module.disk = module.disk / sum
module.bar = module.bar / sum
module.smc = module.smc / sum
module.lmc = module.lmc / sum
module.sagdeg = module.sagdeg / sum
module.bootdsg = module.bootdsg / sum
module.globular = module.globular / sum

return module

-- needed to put the arm code in a separate script because it's so long
local data = galaxy.data
local Vector3 = galaxy.vector3
local CFrame = galaxy.cframe

-- position along an arm at parameter 't', with origin and width depending on which arm it is
local function armPosition(t, origin, width, scale, isShort)
	local t1 = t * math.pi * 2 / (isShort and 1 or data.spiralRatio) * scale
	local r1 = t * data.spiralRadius * data.spiralRatio * scale
	return (origin * CFrame.angles(0, t1, 0) * CFrame.new(r1 * data.sign(width), 0, width)).p
end
-- direction an arm is pointing at t
local function armTangent(t, r, origin, width, scale, isShort)
	if (t == 0) then
		return origin.rightVector * data.sign(width)
	else
		local r0 = armPosition(math.max(0, t - data.tangentDt), origin, width, scale, isShort)
		return (r - r0).unit
	end
end
-- width of a galaxy arm at t
local function mainArmSize(t)
	local w = math.sqrt(t)
	local dr = math.sqrt(1 - t ^ 2)
	return w * dr
end
-- width for the norma/outer arm which stretches a little further
local function outerArmSize(t)
	local w = math.sqrt(t)
	--local dr = (t <= 0.5) and 1 or math.sqrt(0.25 - (t - 0.5) ^ 2) + 0.5
	local dr = (t <= 0.5) and 1 or math.sqrt(0.25 - (t - 0.5) ^ 2) * 2
	return w * dr
end

-- position along the orion arm
local function orionPosition(t)
	local t1 = t * math.pi * 2
	local r1 = t * data.spiralRadius * data.spiralRatio
	return (data.shortBarCF * CFrame.angles(0, t1, 0) * CFrame.new(r1 * data.orionArmScale, 0, data.shortBarAxis)).p
end
-- direction for the orion arm
local function orionTangent(t, r)
	if (t == 0) then
		return data.shortBarCF.rightVector
	else
		local r0 = orionPosition(math.max(0, t - data.tangentDt))
		return (r - r0).unit
	end
end
-- width of the orion arm
local function orionArmSize(t)
	if (t >= data.orionStart and t <= data.orionEnd) then
		return t ^ 3 / data.orionAxis * math.sqrt(data.orionAxis ^ 2 - (t - data.orionStart - data.orionAxis) ^ 2)
	else
		return 0
	end
end

-- position along the LMC spiral (t = (-1, 1))
local function lmcSpiralPosition(t)
	local th = t * math.pi * 0.5
	local r = math.abs(t) ^ (1 / 4) * data.sign(t)
	local x = r * math.cos(th)
	local z = r * math.sin(th) * data.sign(r)
	return Vector3.new(x, 0, z)
end
local function lmcTangent(t)
	return (lmcSpiralPosition(t - data.tangentDt) - lmcSpiralPosition(t + data.tangentDt)).unit
end
local function lmcArmSize(t)
	return math.cos(t * math.pi / 2) * 0.125
end

local module = {}

function module.lmcSpiral(t)
	local r = lmcSpiralPosition(t)
	local lv = lmcTangent(t)
	local w = lmcArmSize(t)
	return r, lv, w
end

function module.outerArm(t)
	-- position along arm at 't'
	local r = armPosition(t, data.longBarCF, data.longBarAxis, data.outerArmScale)
	-- tangent direction
	local lv = armTangent(t, r, data.longBarCF, data.longBarAxis, data.outerArmScale)
	-- diameter of the cross section
	local w = outerArmSize(t)
	return r, lv, w
end

function module.sagittariusArm(t)
	-- position along arm at 't'
	local r = armPosition(t, data.longBarCF, -data.longBarAxis, data.armScale)
	-- tangent direction
	local lv = armTangent(t, r, data.longBarCF, -data.longBarAxis, data.armScale)
	-- diameter of the cross section
	local w = mainArmSize(t)
	return r, lv, w
end

function module.perseusArm(t)
	-- position along arm at 't'
	local r = armPosition(t, data.shortBarCF, data.shortBarAxis, data.armScale, true)
	-- tangent direction
	local lv = armTangent(t, r, data.shortBarCF, data.shortBarAxis, data.armScale, true)
	-- diameter of the cross section
	local w = mainArmSize(t)
	return r, lv, w
end

function module.centaurusArm(t)
	-- position along arm at 't'
	local r = armPosition(t, data.shortBarCF, -data.shortBarAxis, data.armScale, true)
	-- tangent direction
	local lv = armTangent(t, r, data.shortBarCF, -data.shortBarAxis, data.armScale, true)
	-- diameter of the cross section
	local w = mainArmSize(t)
	return r, lv, w
end

function module.orionArm(t)
	local globalT = t * (data.orionEnd - data.orionStart) + data.orionStart
	-- position along arm at 't'
	local r = orionPosition(globalT)
	-- tangent direction
	local lv = orionTangent(globalT, r)
	-- diameter of the cross section
	local w = orionArmSize(globalT)
	return r, lv, w
end

return module

galaxy = {
	path = ...
}

galaxy.vector3 = require(galaxy.path .. "/vector3")
galaxy.cframe = require(galaxy.path .. "/cframe")
galaxy.data = require(galaxy.path .. "/data")
galaxy.arms = require(galaxy.path .. "/arms")
galaxy.generate = require(galaxy.path .. "/generate")
galaxy.settle = require(galaxy.path .. "/settle")

local galaxy = galaxy
_G.galaxy = nil
return galaxy

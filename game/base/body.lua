module("base.body", package.seeall)

require 'base.geom.vector'
require 'lux.object'
require 'lux.functional'

local _BODIES = {}

body = lux.object.new {
	pos = base.geom.vector(),
	bounds = base.geom.vector(),
	angle=0
}

function body:__call(pos, bounds, angle)
	local b = body.new {
		pos=pos or base.geom.vector()
		bounds=bounds or base.geom.vector(),
		angle=angle or 0
	}
	table.insert(_BODIES, b)
end

function body:lookat(direction)
	
end

function body.register(_body)
	table.insert(_BODIES, _body)
end
function body.remove(_body)
	local index = nil
	for i,v in ipairs(_BODIES) do
		if v==_body then index = i end
	end
	table.remove(_BODIES, index)
end


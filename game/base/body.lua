module("base", package.seeall)

require 'vector'
require 'lux.object'
require 'base.properties.visible'
require 'base.properties.moveable'

local bodies = {}

body = lux.object.new {
	position = vector:new{},
	size 	 = vector:new{},
	speed	 = vector:new{}
	pos = base.geom.vector:new{},
	bounds = base.geom.vector:new{},
	properties = {},
	angle = 0
}

body.__init = {}

function body.__init:__index( key )
	if key == 'x' then return self.position[1]
	elseif key == 'y' then return self.position[2]
	elseif key == 'width' then return self.size[1]
	elseif key == 'height' then return self.size[2]
	else return getmetatable(self)[key] end
function body:__call(pos, bounds, angle)
	local b = body:new {
		pos=pos or base.geom.vector:new{},
		bounds=bounds or base.geom.vector:new{},
		angle=angle or 0
	}
	table.insert(_BODIES, b)
	return b
end

function body.__init:__newindex( key, v )
	if key == 'x' then self.position[1] = v
	elseif key == 'y' then self.position[2] = v
	elseif key == 'widht' then self.size[1] = v
	elseif key == 'height' then self.size[2] = v
	else rawset(self,key,v) end
function body:look_at(direction)
	local d = direction - self.pos
	self.angle = math.atan2(d.y, d.x)
	return self.angle
end
function body:move_to(position)

function body.register(_body)
	table.insert(_BODIES, _body)

function body.register(_body)
	table.insert(_BODIES, _body)
function body:register()
	table.insert(bodies, self)
	return self
end

function body:draw()

end

function body:update(dt)

end

-- 'Static' functions below.

function register(_body)
	table.insert(_BODIES, _body)
end
function body.remove(_body)
	local index = nil
	for i,v in ipairs(_BODIES) do
		if v==_body then index = i end
	end
	table.remove(_BODIES, index)
function body.remove(_body)
	local index = nil
	for i,v in ipairs(_BODIES) do
		if v==_body then index = i end
	end
	table.remove(_BODIES, index)

function body.getAll()
	return bodies
function remove(_body)
	local index = nil
	for i,v in ipairs(_BODIES) do
		if v==_body then index = i end
	end
	table.remove(_BODIES, index)
end





function body:update( dt )
	self.position = self.position + self.speed * dt
end

function body:draw()
	-- abstract
end
function update(dt)
	for _,v in pairs(_BODIES) do
		v:update(dt)
	end
end
function draw()
	for _,v in pairs(_BODIES) do
		v:draw()
	end
end
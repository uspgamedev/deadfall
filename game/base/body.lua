module("base", package.seeall)

require 'vector'
require 'lux.object'

local bodies = {}

body = lux.object.new {
	position = vector:new{},
	target	 = nil,
	size 	 = vector:new{},
	speed	 = vector:new{},
	angle	 = 0
}

body.__init = {}

function body.__init:__index( key )
	if key == 'x' then return self.position[1]
	elseif key == 'y' then return self.position[2]
	elseif key == 'width' then return self.size[1]
	elseif key == 'height' then return self.size[2]
	else return getmetatable(self)[key] end
end

function body.__init:__newindex( key, v )
	if key == 'x' then self.position[1] = v
	elseif key == 'y' then self.position[2] = v
	elseif key == 'width' then self.size[1] = v
	elseif key == 'height' then self.size[2] = v
	else rawset(self,key,v) end
end

function body:look_at(direction)
	local dx = direction[1]-self.position[1]
	local dy = direction[2]-self.position[2]
	self.angle = math.atan2(dy, dx)
	return self.angle
end

function body:move_to(target)
	self:look_at(target)
	self.speed = vector:new{math.cos(self.angle)*200, math.sin(self.angle)*200}
	self.target = target
	print(self.speed)
end

function body:register()
	table.insert(bodies, self)
	return self
end

function body.getAll()
	return bodies
end

function body:update( dt )
	if not self.target then return end

	self.position:add(self.speed*dt)

	if self.target:dist(self.position)<=9 then self.target = nil end 
end

function body:draw()
	-- abstract
end
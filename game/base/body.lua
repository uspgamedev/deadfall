module("base", package.seeall)

require 'vector'
require 'lux.object'

local bodies = {}

body = lux.object.new {
	target	 = nil,
	angle	 = 0
}

body.__init = {
	position = vector:new{},
	 size 	 = vector:new{},
	speed	 = vector:new{}
}

function body.__init:__index( key )
	if key == 'x' then return self.position[1]
	elseif key == 'y' then return self.position[2]
	elseif key == 'centerX' then return (self.position[1] + self.size[1]/2)
	elseif key == 'centerY' then return (self.position[2] + self.size[2]/2)
	elseif key == 'Vx' then return self.speed[1]
	elseif key == 'Vy' then return self.speed[2]
	elseif key == 'width' then return self.size[1]
	elseif key == 'height' then return self.size[2]
	else return getmetatable(self)[key] end
end

function body.__init:__newindex( key, v )
	if key == 'x' then self.position[1] = v
	elseif key == 'y' then self.position[2] = v
	elseif key == 'centerX' then self.position[1] = v - self.size[1]/2
	elseif key == 'centerY' then self.position[2] = v - self.size[2]/2
	elseif key == 'Vx' then self.speed[1] = v
	elseif key == 'Vy' then self.speed[1] = v
	elseif key == 'width' then self.size[1] = v
	elseif key == 'height' then self.size[2] = v
	else rawset(self,key,v) end
end

function body:look_at(direction)
	local dx = direction.x - self.centerX
	local dy = direction.y - self.centerY
	self.angle = math.atan2(dy, dx)
	return self.angle
end

function body:move_to(target)
	self:look_at(target)
	--self.speed = vector:new{math.cos(self.angle)*200, math.sin(self.angle)*200}
	self.speed = (target - {self.centerX,self.centerY}):normalized() * 200
	self.target = target
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

	if self.target:distsqr(self.centerX,self.centerY)<=9 then self.target = nil end 
end

function body:draw()
	-- abstract
end

function body:is_inside( p )
	if p.x < self.x then return false end
	if p.y < self.y then return false end
	if p.x > self.x + self.width  then return false end
	if p.y > self.y + self.height then return false end
	return true
end
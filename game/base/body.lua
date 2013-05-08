module("base", package.seeall)

require 'vector'
require 'lux.functional'
require 'lux.object'
require 'base.queue'
require 'base.timer'

local bodies = {}

body = lux.object.new {
	angle	 = 0,
	mass	 = 10
}

body.__init = {
	targets  = base.queue:new{},
	target	 = nil,
	position = vector:new{},
	size 	 = vector:new{},
	speed	 = vector:new{},
	force	 = vector:new{},
	reactor	 = base.timer:new {
		dt 		= 0.250,
		repeats = true,
		running = false
	}
}

function body.__init:__index(key)
	if key == 'x' then return self.position[1]
	elseif key == 'y' then return self.position[2]
	elseif key == 'centerX' then return (self.position[1] + self.size[1]/2)
	elseif key == 'centerY' then return (self.position[2] + self.size[2]/2)
	elseif key == 'Vx' then return self.speed[1]
	elseif key == 'Vy' then return self.speed[2]
	elseif key == 'width' then return self.size[1]
	elseif key == 'height' then return self.size[2]
	elseif key == 'Fx' then return self.force[1]
	elseif key == 'Fy' then return self.force[2]
	else return getmetatable(self)[key] end
end

function body.__init:__newindex(key, v)
	if key == 'x' then self.position[1] = v
	elseif key == 'y' then self.position[2] = v
	elseif key == 'centerX' then self.position[1] = v - self.size[1]/2
	elseif key == 'centerY' then self.position[2] = v - self.size[2]/2
	elseif key == 'Vx' then self.speed[1] = v
	elseif key == 'Vy' then self.speed[1] = v
	elseif key == 'width' then self.size[1] = v
	elseif key == 'height' then self.size[2] = v
	elseif key == 'Fx' then self.force[1] = v
	elseif key == 'Fy' then self.force[2] = v
	else rawset(self,key,v) end
end

function body:look_at(x, y)
	if not y then
		return self:look_at(x:unpack())
	end
	
	local dx = x - self.centerX
	local dy = y - self.centerY
	self.angle = math.atan2(dy, dx)
	return self.angle
end

function body:add_move(target)

end

function body:move_to(target, multipath)
	if not multipath then
		self:look_at(target)
		self.speed = (target - {self.centerX,self.centerY}):normalized() * 200
		self.target = target
		if multipath==false then self.targets.clear() end
	else
		if not self.target then
			self:look_at(target)
			self.speed = (target - {self.centerX,self.centerY}):normalized() * 200
			self.target = target
		else
			self.targets.push(target)
		end
	end
end

function body:register()
	table.insert(bodies, self)
	return self
end

function body.getAll()
	return bodies
end

function body:update(dt)
	if not self.target then return end

	self.position:add(self.speed*dt)
	self.speed:add(self.force/self.mass)
	self.force:reset()

	for _,v in pairs(bodies) do
		if v~=self then
			if self:intersects(v) then
				self.speed:add((self.centerX-v.centerX), (self.centerY-v.centerY))
				if not self.reactor.running and self.target then
					if not self.reactor.event then
						self.reactor.event = function()
						if self.target then
							self:move_to(self.target)
						end
					end
					self.reactor.running = false
				end
				self.reactor:start()
				end
			end
		end
	end

	if self.target:distsqr(self.centerX,self.centerY)<=16 then 
		--if self.target[3] then self.look_at(self.target[3], self.target[4]) end
		self.target = self.targets.pop()
		if self.target then self:move_to(self.target) end
	end 
end

function body:draw()
	-- abstract
end

function body:is_inside(p, q)
	if q then
		if p < self.x then return false end
		if q < self.y then return false end
		if p > self.x + self.width  then return false end
		if q > self.y + self.height then return false end
		return true
	end	

	if p.x < self.x then return false end
	if p.y < self.y then return false end
	if p.x > self.x + self.width  then return false end
	if p.y > self.y + self.height then return false end
	return true
end

function body:intersects(b)
	local w, h = self.size:unpack()
	local x, y = self.position:unpack()
	local px, py = b.position:unpack()
	local pw, ph = b.size:unpack()
	return x<=px+pw and x+w>=px and 
		y<=py+ph and y+h>=py
end
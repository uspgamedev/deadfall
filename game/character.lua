require 'base.body'
require 'base.transform'

local colors = {
	{0, 255, 0},
	{0, 0, 255},
	{255, 0, 0}
}

character = base.body:new {
	mode = 'fill',
	team = 0,
	__type = "character"
}

function character:__init()
	if self.radius then
		self.size:set(2*self.radius,2*self.radius)
		self.radius = nil
	end

	self.targets  = base.queue:new{}
	self.reactor	 = base.timer:new {
		dt 		= 0.250,
		repeats = true,
		running = false
	}
end

function character:shoot( target )
	bullet:new{ 
		position = vector:new{self.centerX, self.centerY},
		target = target 
	}:register()
end

function character:move_to(target, multipath)
	if not multipath then
		self:look_at(target)
		self.speed = (target - {self.centerX,self.centerY}):normalize():mult(200)
		self.target = target
		if multipath==false then self.targets:clear() end
	else
		if not self.target then
			self:look_at(target)
			self.speed = (target - {self.centerX,self.centerY}):normalize():mult(200)
			self.target = target
		else
			self.targets:push(target)
		end
	end
end

function character:draw()
	love.graphics.setColor(colors[self.team+1])
	
	base.transform.rotate(self)
	love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end

function character:drawextra()
	if self.target then 
		love.graphics.setColor(255,0,0)
		love.graphics.circle('fill', self.target.x, self.target.y, 5)
	end

	local latX, latY = self.centerX, self.centerY
	local ltarg = self.target
	if ltarg then
		love.graphics.setColor(colors[self.team+1])
		love.graphics.line(latX, latY, ltarg[1], ltarg[2])
		latX, latY = ltarg[1], ltarg[2]
	end

	for i,v in ipairs(self.targets) do
		love.graphics.setColor(0, 0, 255)
		love.graphics.print(i, v[1], v[2])
		love.graphics.circle('fill', v[1], v[2], 3)
		love.graphics.setColor(colors[self.team+1])
		love.graphics.line(latX, latY, v[1], v[2])
		latX, latY = v[1], v[2]
	end
end

function character:update( dt )
	if not self.target then return end
	character:__super().update(self, dt)

	for _,v in pairs(base.body.getAll().character) do
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
		self.target = self.targets:pop()
		if self.target then self:move_to(self.target) end
	end 
end
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
	health = 100,
	__type = "character"
}

function character:__init()
	if self.radius then
		self.size:set(2*self.radius,2*self.radius)
		self.radius = nil
	end

	self.n = nchars
	nchars = nchars + 1

	self.targets  = base.queue:new{}
	self.reactor  = base.timer:new {
		dt 		= 0.250,
		repeats = true,
		running = false
	}
end

function character:shoot(target)
	if not self.burst then
		self.burst = base.timer:new{
			dt = 0.125,
			repeats = true,
			bullets = 0,
			s_target = target,
			event = function() 
				if self.burst.bullets > 3 then
					self.burst.bullets = 0
					self.burst:stop()
					self.burst:remove()
					return
				end

				bullet:new{
					owner = self,
					position = vector:new{self.centerX, self.centerY},
					target = self.burst.s_target:clone()
				}:register()
				self.burst.bullets = self.burst.bullets + 1
			end
		}
	elseif not self.burst.running then
		self.burst.s_target = target
		self.burst:restart()
		self.burst:register()
	end
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

	if self.derp then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle('fill', self.centerX, self.centerY, 5)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.n, self.x, self.y)
	if self.pushed then
		local str = self.pushed.__type=='character' and self.pushed.n or 'obst'
		love.graphics.print(str, self.x, self.y+10) 
	end
end

function character:die()
	--TODO: Death Sprite animation + corpse registering.
	self:unregister()
end

function character:update(dt)
	if self.health <= 0 then self:die() end

	if not self.target then
		if self.pushed then
			for _,v in pairs(base.body.getAll().character) do
				if v~=self then
					if self:intersects(v) then
						local vX, vY = (self.centerX-v.centerX), (self.centerY-v.centerY)
						self.derp = true
						if self.pushed~=v then v.temp_force:set(-vX, -vY):mult(40)
						elseif self.pushed.speed:equals(0, 0) then v.temp_force:set(-vX, -vY):mult(40) end
						v.pushed = self
					end
				end
			end
			if base.body.getAll().obstacle then
				for _,v in pairs(base.body.getAll().obstacle) do
					v:update(dt)
				end
			end
			character:__super().update(self, dt)
			self.speed:reset()
			self.pushed = nil
		end
		return 
	end

	character:__super().update(self, dt)

	local chars = base.body.getAll().character
	for _,v in pairs(chars) do
		if v~=self then
			if self:intersects(v) then
				local vX, vY = (self.centerX-v.centerX), (self.centerY-v.centerY)
				v.speed:reset()
				--self.speed:add(vX, vY)
				v.temp_force:set(-vX, -vY):mult(40)
				v.pushed = self
				if not self.reactor.running and self.target then
					if not self.reactor.event then
						print "YUP"
						self.reactor.event = function()
							if self.target then
								self:move_to(self.target)
							end
						end
						self.reactor.running = false
					end
					self.reactor:start()
					self.reactor:register()
				end
			end
		end
	end

	if self.target:distsqr(self.centerX,self.centerY)<=16 then 
		self.target = self.targets:pop()
		if self.target then self:move_to(self.target) end
	end 
end
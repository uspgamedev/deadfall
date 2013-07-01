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

function obstruct( c )
	local sx, sy = math.floor(c.x/mapper.s) + 1, math.floor(c.y/mapper.s) + 1
	sx = math.max(sx, 1)
	sy = math.max(sy, 1)
	local dx, dy = math.floor((c.x + c.width)/mapper.s) + 1, math.floor((c.y + c.height)/mapper.s) + 1
	dx = math.min(dx, mapperwidth)
	dy = math.min(dy, mapperheight)
	for i = sx, dx do
		for j = sy, dy do
			mapper[i][j].obstructs = true
		end
	end
end

function character:processPathfinding( target )
	mapperwidth = 40
	mapperheight = 40
	local s = math.max(self.width, self.height)
	local m = {s = s}
	for i = 1, mapperwidth do 
		m[i] = {} 
		for j = 1, mapperheight do
			m[i][j] = {i,j}
		end
	end
	mapper = m
	local dx, dy
	for _, c in pairs(base.body.getAll().character) do
		if c ~= self then 
			obstruct(c)
		end
	end
	for _, o in pairs(base.body.getAll().obstacle) do
		obstruct(o)
	end
	dx, dy = math.floor(self.centerX/s) + 1, math.floor(self.centerY/s) + 1
	self.currentTile = m[dx][dy]
	local tile = m[math.floor(target.x/s) + 1][math.floor(target.y/s) + 1]
	if tile == self.currentTile or tile.obstructs then return end
	moveto(self, tile)
	local path = {}
	while tile do
		table.insert(path, tile)
		tile = tile.parent
	end
	self.target = nil
	self.targets:clear()
	for i = #path-1, 1, -1 do
		self:move_to(vector:new{
			(path[i][1]-1)*s + s/2,
			(path[i][2]-1)*s + s/2
		}, true)
	end
end

function moveto(self, tile)
	local dx, dy = tile[1], tile[2]
	local open = {}
	local selftilebak = self.currentTile
	local ctile = self.currentTile
	local pathfound = false
	ctile.G = 0
	count = 0
	repeat
		for i = -1, 1 do
			for j = -1, 1 do
				if (i~=0 or j~=0) and ctile[1] + i > 0 and ctile[1] + i <= mapperwidth and ctile[2] + j > 0 and ctile[2] + j <= mapperheight then
					local t = mapper[ctile[1] + i][ctile[2] + j]
					if t == tile then 
						t.parent = ctile
						pathfound = true 
					end

					if t.obstructs then 
						open[t] = false
					end

					if not pathfound and open[t] ~= false then
						if open[t] == true then
							local newG = ctile.G + ((i*j) == 0 and 10 or 14)
							if newG < t.G then
								t.G = newG
								t.parent = ctile
							end
						else
							open[t] = true
							t.parent = ctile
							t.G = ctile.G + ((i*j) == 0 and 10 or 14)
							t.H = (math.abs(ctile[1] + i - dx) + math.abs(ctile[2] + j - dy)) * 10
							t.F = t.G + t. H
							if t.H == 0 then pathfound = true end
						end
					end
				end
			end
		end
		open[ctile] = false
		ctile = nil
		local minF = 100000
		for k, isOpen in pairs(open) do
			if isOpen then
				if k.F < minF then
					minF  = k.F
					ctile = k
				end
			end
		end
		count = count + 1
	until ctile == nil or pathfound
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

	base.body.update(self, dt)

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

	if self.target:distsqr(self.centerX,self.centerY)<=25 then 
		self.target = self.targets:pop()
		if self.target then self:move_to(self.target) end
	end 
end
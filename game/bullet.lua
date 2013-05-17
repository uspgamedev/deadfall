require 'base.body'
require 'camera'
require 'base.timer'

local BASE_DAM = 60
local BASE_SPREAD = 200

bullet = base.body:new {
	owner = nil,
	__type = "bullet"
}

local screenbounds = {
	position = camera.getPosition(),
	size  = camera.getSize()
}

function bullet:__init()
	local rand = math.random
	local spread = rand(0, BASE_SPREAD)
	self.speed = (self.target - self.position):normalize():mult(500):
		add(rand()>0.5 and spread or -spread)
end

function bullet:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle('fill', self.x, self.y, 4)
end

function bullet:update( dt )
	bullet:__super().update(self, dt)

	local bodies = base.body.getAll().character
	for _,v in pairs(bodies) do
		if v~=self.owner then
			if self:intersects(v) then 
				v.health = v.health - BASE_DAM
				self:unregister()
				return
			end
		end
	end

	if not self:intersects(screenbounds) then self:unregister() end
end
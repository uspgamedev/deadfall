require 'base.body'
require 'camera'

bullet = base.body:new {
	__type = "bullet"
}

local screenbounds = {
	position = camera.getPosition(),
	size  = camera.getSize()
}

function bullet:__init()
	self.speed = (self.target - self.position):normalize():mult(500)
end

function bullet:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle('fill', self.x, self.y, 4)
end

function bullet:update( dt )
	bullet:__super().update(self, dt)
	if not self:intersects(screenbounds) then self:unregister() end
end
require 'base.body'

bullet = base.body:new {
	__type = "bullet"
}

function bullet:__init()
	self.speed = (self.target - self.position):normalize():mult(500)
end

function bullet:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle('fill', self.x, self.y, 4)
end
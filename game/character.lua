require 'base.body'

character = base.body:new {
	mode	= 'fill'
}

function character:__init()
	if self.radius then
		self.size:set(2*self.radius,2*self.radius)
		self.radius = nil
	end
end

function character:draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle(self.mode, self.centerX, self.centerY, self.width/2)
	if self.target then 
		love.graphics.setColor(255,0,0)
		love.graphics.circle('fill', self.target.x, self.target.y, 5)
	end
end
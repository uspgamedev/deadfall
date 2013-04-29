require 'base.body'

character = base.body:new {
	mode	= 'fill'
}

function character:draw()
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle( self.mode, self.x, self.y, self.radius or self.width)
	love.graphics.setColor(r, g, b)
end
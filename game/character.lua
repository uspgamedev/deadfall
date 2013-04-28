require 'base.body'

character = base.body:new {
	mode	= 'fill'
}

function character:draw()
	love.graphics.circle( self.mode, self.x, self.y, self.radius or self.width)
end
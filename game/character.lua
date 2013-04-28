require 'base.body'

character = base.body:new {
	mode	= 'fill'
}

function character:draw()
	love.graphics.circle( self.mode, self.position[1], self.position[2], self.radius or self.size[1])
end
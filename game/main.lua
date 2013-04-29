require 'vector'
require 'character'
require 'base.body'
require 'selector'

local bodies

function love.load()
	bodies = base.body.getAll()

	character:new { 
		radius = 30,
		position = vector:new{100,400},
		speed = vector:new{15,-30}
	}:register()

end

function love.mousepressed(x, y, button)
	selector.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
	selector.mousereleased(x, y, button)
end

function love.draw()
	for i,b in ipairs(bodies) do
		b:draw()
	end
	selector.draw()
end

function love.update( dt )
	for i,b in ipairs(bodies) do
		b:update(dt)
	end
	selector.update(dt)
end
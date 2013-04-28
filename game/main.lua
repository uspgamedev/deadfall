require 'vector'
require 'character'
require 'base.body'

local bodies

function love.load()
	bodies = base.body.getAll()
	local c = character:new { 
		radius = 40,
		position = vector:new{100,400},
		speed = vector:new{15,-30}
	}:register()
end

function love.draw()
	for i,b in ipairs(bodies) do
		b:draw()
	end
end

function love.update( dt )
	for i,b in ipairs(bodies) do
		b:update(dt)
	end
end
require 'lux.object'
require 'base.geom.vector'
require 'base.body'
require 'base.properties.moveable'
require 'base.properties.visible'
require 'lux.functional'

function love.load()

end

function love.mousepressed(x, y, button)

end

function love.draw()

end

function love.update(dt)

end
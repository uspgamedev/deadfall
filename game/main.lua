require 'vector'
require 'character'
require 'base.body'
require 'selector'

local bodies

function love.load()
	bodies = base.body.getAll()

	local c = character:new { 
		radius = 30,
		position = vector:new{100,400}
	}:register()
	
	character:new {
		radius = 25,
		position = vector:new{600, 500}
	}:register()

	character:new {
		radius = 50,
		position = vector:new{400, 100}
	}:register()

end

function love.mousepressed(x, y, button)
	selector.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
	selector.mousereleased(x, y, button)
end

function love.draw()
	for _,b in ipairs(bodies) do
		b:draw()
	end
	selector.draw()
end

function love.update(dt)
	if love.keyboard.isDown('lalt') and love.keyboard.isDown('f4') then os.exit(0) end

	for _,b in pairs(bodies) do
		b:update(dt)
	end

	selector.update(dt)
end
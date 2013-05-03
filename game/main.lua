require 'vector'
require 'character'
require 'base.body'
require 'base.timer'
require 'selector'
require 'camera'

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

	character:new {
		radius = 50,
		position = vector:new{200, 100}
	}:register()

	character:new {
		radius = 50,
		position = vector:new{300, 300}
	}:register()

	base.timer:new {
		dt = 2.50,
		repeats = false,
		event = function() c:move_to(vector:new{400, 300}) end
	}
end

function love.mousepressed(x, y, button)
	selector.mousepressed(x, y, button)
	camera.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
	selector.mousereleased(x, y, button)
	camera.mousereleased(x, y, button)
end

function love.draw()
	camera.set()

	for _,b in ipairs(bodies) do
		b:draw()
	end
	selector.draw()

	camera.unset()
end

function love.update(dt)
	for _,b in pairs(bodies) do
		b:update(dt)
	end
	
	base.timer.update(dt)

	selector.update(dt)
end

function love.keypressed()
	if love.keyboard.isDown('lalt') and love.keyboard.isDown('f4') then love.event.push('quit') end	
end
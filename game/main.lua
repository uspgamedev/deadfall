require 'vector'
require 'character'
require 'bullet'
require 'obstacle'
require 'base.body'
require 'base.timer'
require 'selector'
require 'camera'

bodies = 0

function love.load()
	bodies = base.body.getAll()

	local c = character:new { 
		radius = 30,
		position = vector:new{100,400}
	}:register()
	
	character:new {
		radius = 25,
		position = vector:new{600, 500},
		team = 1
	}:register()

	character:new {
		radius = 50,
		position = vector:new{400, 100},
		team = 1
	}:register()

	character:new {
		radius = 50,
		position = vector:new{200, 100},
		team = 2
	}:register()

	character:new {
		radius = 50,
		position = vector:new{300, 300},
		team = 2
	}:register()

	base.timer:new {
		dt = 2.50,
		repeats = false,
		event = function() c:move_to(vector:new{400, 300}) end
	}

	obstacle:new {
		position = vector:new{-50, 0},
		size = vector:new{1000, 50}
	}:register()
	obstacle:new {
		position = vector:new{-50, 0},
		size = vector:new{50, 800}
	}:register()
	obstacle:new {
		position = vector:new{950, 0},
		size = vector:new{50, 800}
	}:register()
	obstacle:new {
		position = vector:new{-50, 800},
		size = vector:new{1050, 50}
	}:register()
end

function love.draw()
	camera.set()

	for b in base.body.iterate() do
		love.graphics.push()
		b:draw()
		love.graphics.pop()
		if b.drawextra then b:drawextra() end
	end

	selector.draw()

	camera.unset()
	
	-- Debug Interface --

	local nBodies = 0
	for _,v in pairs(bodies) do
		nBodies = nBodies + #v
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Cam Translation: "..tostring(camera.getPosition()), 5, 0)
	love.graphics.print("Cam Zoom Scale: "..tostring(camera.getScale()), 5, 15)
	love.graphics.print("Mouse Position: "..tostring(camera.getMousePosition()), 5, 30)
	love.graphics.print("Number of Bodies: "..nBodies, 5, 45)
end

updateFollowers = { base.timer, selector, camera }

function love.update(dt)
	for b in base.body.iterate() do
		b:update(dt)
	end
	
	for _,v in ipairs(updateFollowers) do
		v.update(dt)
	end
end

keyboardFollowers = { camera }

function love.keypressed(key, code)
	if love.keyboard.isDown('lalt') and love.keyboard.isDown('f4') then love.event.push('quit') end

	for _,v in ipairs(keyboardFollowers) do
		v.keypressed(key, code)
	end
end

function love.keyreleased(key)
	for _,v in ipairs(keyboardFollowers) do
		v.keyreleased(key)
	end
end

mouseFollowers = { selector, camera }

function love.mousepressed(x, y, button)
	for _,v in ipairs(mouseFollowers) do
		v.mousepressed(x,y,button)
	end
end

function love.mousereleased(x, y, button)
	for _,v in ipairs(mouseFollowers) do
		v.mousereleased(x,y,button)
	end
end
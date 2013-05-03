module('camera', package.seeall)

require 'vector'
require 'lux.object'

local mousePos = vector:new{love.mouse.getPosition()}
local position = vector:new{}
local scale	   = vector:new{1, 1}
local angle	   = 0

local base_vel 	 = 500
local speed = vector:new{}
local base_angle = math.pi/96
local base_zoom	 = .02

local middle_button	= false

local SCREEN_WIDTH 	= love.graphics.getWidth()
local SCREEN_HEIGHT = love.graphics.getHeight()

function set()
	love.graphics.push()
	love.graphics.translate(-position[1], -position[2])
	love.graphics.scale(1/scale[1], 1/scale[2])	

	--love.graphics.translate(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	--love.graphics.rotate(angle)
	--love.graphics.translate(-SCREEN_WIDTH/2, -SCREEN_HEIGHT/2)
end

unset = love.graphics.pop

function mousepressed(x, y, button)
	if button=='m' then middle_button=true end

	if not middle_button then
		if button=='wu' then zoom_in(base_zoom)
		elseif button=='wd' then zoom_out(base_zoom) end
	else
		if button=='wd' or button=='wu' then
			--TODO: make rotate work with other stuff
			---rotate(button=='wu' and base_angle or -base_angle)
		end
	end
end

function mousereleased(x, y, button)
	if button=='m' then middle_button=false end
end

function keypressed(key)
	speed:add(
		(key == 'left' and -base_vel or 0) + (key == 'right' and base_vel or 0),
		(key == 'up'   and -base_vel or 0) + (key == 'down'  and base_vel or 0)
	)

	if love.keyboard.isDown('lctrl') and 
			(love.keyboard.isDown('kp0') or love.keyboard.isDown('0')) then
		scale:set(1, 1)
		angle=0 
	end
end

function keyreleased(key)
	speed:sub(
		(key == 'left' and -base_vel or 0) + (key == 'right' and base_vel or 0),
		(key == 'up'   and -base_vel or 0) + (key == 'down'  and base_vel or 0)
	)
end

function update(dt)
	if not speed:equals(0,0) then
		translate(speed*dt)
	end
end

function translate(x, y)
	position:add(x, y)
end

function setTranslation(x, y) 
	position:set(x, y)
end

function rotate(theta)
	angle = angle + theta
end

function zoom_in(rate)
	if scale[1] + rate <= 0 or scale[2] + rate <= 0 then return end
	scale:sub(rate, rate)
end
function zoom_out(rate)
	zoom_in(-rate)
end

function getScale() return scale:clone() end

function getTranslation() return position:clone() end

-- fixes a point, altering the vector. Don't send vectors that you don't want to change!
function fixPoint(p) 
	return p:mult(scale):add(position)
end

function getMousePosition()
	return fixPoint(mousePos:set(love.mouse.getPosition()))
end

function getMouseX() return love.mouse.getX() * scale[1] + position[1] end
function getMouseY() return love.mouse.getY() * scale[2] + position[2] end
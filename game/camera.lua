module('camera', package.seeall)

require 'vector'
require 'lux.object'

local position = vector:new{}
local scale	   = vector:new{1, 1}
local angle	   = 0

local base_vel 	 = 10
local base_angle = math.pi/96
local base_zoom	 = 2

local mouse_pos 	= vector:new{love.mouse.getPosition()}
local middle_button	= false

local SCREEN_WIDTH 	= love.graphics.getWidth()
local SCREEN_HEIGHT = love.graphics.getHeight()

function set()
	love.graphics.push()
	love.graphics.translate(-position[1], -position[2])
	love.graphics.scale(1/scale[1], 1/scale[2])	

	love.graphics.translate(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	love.graphics.rotate(angle)
	love.graphics.translate(-SCREEN_WIDTH/2, -SCREEN_HEIGHT/2)
	
	local vx, vy = 
		love.keyboard.isDown('right') and base_vel or love.keyboard.isDown('left') and -base_vel or 0,
		love.keyboard.isDown('down') and base_vel or love.keyboard.isDown('up') and -base_vel or 0

	translate(vx, vy)

	if love.keyboard.isDown('lctrl') then
		if love.keyboard.isDown('kp0') then scale:set(1, 1) end
		if love.keyboard.isDown('kp5') then angle=0 end
	end
end

function mousepressed(x, y, button)
	if button=='m' then middle_button=true end

	if not middle_button then
		if button=='wu' then zoom_in(base_zoom)
		elseif button=='wd' then zoom_out(base_zoom) end
	else
		if button=='wd' or button=='wu' then
			--TODO: make rotate work with other stuff
			--rotate(button=='wu' and base_angle or -base_angle)
		end
	end
end

function mousereleased(x, y, button)
	if button=='m' then middle_button=false end
end

unset = love.graphics.pop

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
	rate = rate/100
	if scale[1]+rate<=0 or scale[2]+rate<=0 then return end
	scale:sub(rate, rate)
end
function zoom_out(rate)
	zoom_in(-rate)
end

function getScale() return scale:clone() end

function getTranslation() return position:clone() end
function getPosition() 
	return mouse_pos:set(love.mouse.getX()+position[1], 
		love.mouse.getY()+position[2]):mult(scale):clone()
end
function getX() return love.mouse.getX()+position[1] end
function getY() return love.mouse.getY()+position[2] end
module("selector", package.seeall)

require 'vector'
require 'base.body'
require 'lux.object'

local selected = {}

local position  = nil
local size 	 	= vector:new{}
local color	 	= {0, 55, 200, 150}
local marker 	= nil

function draw()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(unpack(color))
	
	if position then
		love.graphics.rectangle('fill', position[1], position[2], size[1], size[2])
	end
	if marker then
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle('fill', marker.x, marker.y, 5, 50)
		love.graphics.setColor(unpack(color))
	end

	for _,v in pairs(selected) do
		love.graphics.rectangle('line', v.position.x-v.radius-4, v.position.y-v.radius-4, 
			2*v.radius+8, 2*v.radius+8)
	end

	love.graphics.setColor(r, g, b, a)
end

function mousepressed(x, y, button)
	if button=='l' then
		clear()
		position=vector:new{x, y}
	elseif button=='r' then
		marker = vector:new{x, y}
		for _,v in pairs(selected) do
			v:move_to(marker)
		end
	end
end
function mousereleased(x, y, button)
	if not position then return end
	if button=='l' then
		local bodies = base.body.getAll()
		local centerX, centerY

		local topX, topY, bottomX, bottomY

		if position.x > position.x+size.x then
			topX = position.x
			bottomX = position.x + size.x
		else
			topX = position.x + size.x
			bottomX = position.x
		end if position.y > position.y+size.y then
			topY = position.y
			bottomY = position.y + size.y
		else
			topY = position.y + size.y
			bottomY = position.y
		end

		for _,v in pairs(bodies) do
			centerX = v.position.x + v.size.x/2
			centerY = v.position.y + v.size.y/2

			if centerX>=bottomX and centerX<=topX then
				if centerY>=bottomY and centerY<=topY then
					register(v)
				end
			end
		end
		position=nil
	end
end

function update(dt)
	if marker then
		for _,v in pairs(selected) do
			if not v.target then marker = nil end
		end
	end

	if not position then return end
	size:set(love.mouse.getX()-position[1], love.mouse.getY()-position[2])
end

function register(body)
	table.insert(selected, body)
end
function remove(body)
	local index
	for i,v in pairs(selected) do
		if v==body then index=i end
	end
	table.remove(selected, index)
end
function clear()
	for k in pairs(selected) do
		selected[k] = nil
	end
end
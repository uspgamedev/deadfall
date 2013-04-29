module("selector", package.seeall)

require 'vector'
require 'base.body'
require 'lux.object'

local selected = {}

local clickposition  = nil -- rename this variable
local size 	 		 = vector:new{}
local outerrectcolor = {0, 55, 200, 230}
local innerrectcolor = {0, 55, 200,  60}
local linecolor		 = outerrectcolor

function draw()
	if clickposition then
		love.graphics.setColor(innerrectcolor)
		love.graphics.rectangle('fill', clickposition[1], clickposition[2], size[1], size[2])
		love.graphics.setColor(outerrectcolor)
		love.graphics.rectangle('line', clickposition[1], clickposition[2], size[1], size[2])
	end

	love.graphics.setColor(linecolor)
	for _,v in pairs(selected) do
		love.graphics.rectangle('line', v.x - 4, v.y - 4, v.width + 8, v.height + 8)
	end
end

function mousepressed(x, y, button)
	local pos = vector:new{x, y}
	if button == 'l' then
		clear()
		clickposition = pos
	elseif button == 'r' and #selected>0 then
		for _,v in pairs(selected) do
			v:move_to(pos)
		end
	end
end

function mousereleased(x, y, button)
	if not clickposition then return end
	if button=='l' then
		local bodies = base.body.getAll()
		
		if size.x < 5 and size.y < 5 then
			for _,b in ipairs(bodies) do
				if b:ispointinside(clickposition) then
					register(b)
				end
			end
		else 
			local topX, topY, bottomX, bottomY = 
				size.x > 0 and clickposition.x + size.x or clickposition.x,
				size.y > 0 and clickposition.y + size.y or clickposition.y,
				size.x < 0 and clickposition.x + size.x or clickposition.x,
				size.y < 0 and clickposition.y + size.y or clickposition.y

			local centerX, centerY
			for _,b in ipairs(bodies) do
				centerX = b.centerX
				centerY = b.centerY

				if centerX>=bottomX and centerX<=topX then
					if centerY>=bottomY and centerY<=topY then
						register(b)
					end
				end
			end
		end
		clickposition=nil
	end
end

function update(dt)
	if not clickposition then return end
	size:set(love.mouse.getX()-clickposition[1], love.mouse.getY()-clickposition[2])
end

function register(body)
	table.insert(selected, body)
end

function remove(body)
	local index
	for i,v in pairs(selected) do
		if v==body then index=i break end
	end
	table.remove(selected, index)
end

function clear()
	for k in pairs(selected) do
		selected[k] = nil
	end
end
module("selector", package.seeall)

require 'vector'
require 'base.body'
require 'lux.object'
require 'camera'

local selected = {}

local click_pos  	= nil
local size 	 		= vector:new{}
local outer_color 	= {0, 55, 200, 230}
local inner_color 	= {0, 55, 200,  60}
local line_color	= outer_color

function draw()
	if click_pos then
		love.graphics.setColor(inner_color)
		love.graphics.rectangle('fill', click_pos[1], click_pos[2], size[1], size[2])
		love.graphics.setColor(outer_color)
		love.graphics.rectangle('line', click_pos[1], click_pos[2], size[1], size[2])
	end

	love.graphics.setColor(line_color)
	for _,v in pairs(selected) do
		love.graphics.rectangle('line', v.x - 4, v.y - 4, v.width + 8, v.height + 8)
	end
end

function mousepressed(x, y, button)
	local pos = camera.getPosition()
	if button == 'l' then
		click_pos = pos
		if not love.keyboard.isDown('lshift') then clear() end
	elseif button == 'r' and #selected>0 then
		for _,v in pairs(selected) do
			v:move_to(pos)
		end
	end
end

function mousereleased(x, y, button)
	if not click_pos then return end
	if button=='l' then
		local bodies = base.body.getAll()

		if size.x < 5 and size.y < 5 then
			for _,b in ipairs(bodies) do
				if b:is_inside(click_pos) then
					action = contains(b) and remove or register
					action(b)
				end
			end
		else 
			local topX, topY, bottomX, bottomY = 
				size.x > 0 and click_pos.x + size.x or click_pos.x,
				size.y > 0 and click_pos.y + size.y or click_pos.y,
				size.x < 0 and click_pos.x + size.x or click_pos.x,
				size.y < 0 and click_pos.y + size.y or click_pos.y

			local centerX, centerY
			for _,b in ipairs(bodies) do
				centerX = b.centerX
				centerY = b.centerY

				if centerX>=bottomX and centerX<=topX then
					if centerY>=bottomY and centerY<=topY then
						action = contains(b) and remove or register
						action(b)
					end
				end
			end
		end
		click_pos=nil
	end
end

function update(dt)
	if not click_pos then return end
	size:set(camera.getPosition():sub(click_pos))
end

function register(body)
	if not contains(body) then
		table.insert(selected, body)
	end
end

function contains(body)
	for _,v in pairs(selected) do
		if v==body then return true end
	end
	return false
end

function remove(body)
	for i,v in pairs(selected) do
		if v==body then
			table.remove(selected, i)
			return 
		end
	end
end

function clear()
	for k in pairs(selected) do
		selected[k] = nil
	end
end
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
	for v in pairs(selected) do
		love.graphics.rectangle('line', v.x - 4, v.y - 4, v.width + 8, v.height + 8)
	end
end

function mousepressed(x, y, button)
	local pos = camera.getMousePosition()
	local lshift = love.keyboard.isDown('lshift')
	if button == 'l' then
		click_pos = pos
		if not lshift then clear() end
	elseif button == 'r' then
		if love.keyboard.isDown('lctrl') then
			for b in pairs(selected) do
				b:shoot(pos)
			end
		else
			local dx, dy, grt, len = 0, 0, 0, 0
			for v in pairs(selected) do grt = math.max(grt,v.width) len = len + 1 end
			dx = -(grt+20)*math.floor(len/2)
			for v in pairs(selected) do
				v:move_to(pos+{dx, dy}, lshift)
				dx = dx + grt + 20
			end
		end
	end
end

function mousereleased(x, y, button)
	if not click_pos then return end
	if button=='l' then
		click_pos=nil
	end
end

function update(dt)
	if not click_pos then return end
	size:set(camera.getMousePosition():sub(click_pos))
	local bodies = base.body.getAll()
	local lshift = love.keyboard.isDown('lshift')
	if size.x < 5 and size.y < 5 then
		for _,b in ipairs(bodies) do
			if b:is_inside(click_pos) then
				if b.team==0 and lshift then return end
				restrict(b, 0)
			end
		end
	else 
		local sx, sy = size:unpack()
		local px, py = click_pos:unpack()

		local topX, topY, bottomX, bottomY = 
			sx > 0 and px + sx or px,
			sy > 0 and py + sy or py,
			sx < 0 and px + sx or px,
			sy < 0 and py + sy or py

		local centerX, centerY
		for i,b in ipairs(bodies) do
			centerX = b.centerX
			centerY = b.centerY

			if centerX>=bottomX and centerX<=topX then
				if centerY>=bottomY and centerY<=topY then
					restrict(b, 0)
				elseif not lshift then b.passed = nil remove(b) end
			elseif not lshift then b.passed = nil remove(b) end
		end
	end
end

function restrict(b, team)
	if not b.passed then register(b) end
	if b.team == team then
		for k,_ in pairs(selected) do
			if k.team ~= team then k.passed = true remove(k) end
		end
	end
end

function length(t)
	local i=0
	for _ in pairs(t) do i = i + 1 end
	return i
end

function contains(body)
	return selected[body] ~= nil
end

function register(body)
	selected[body] = true
end

function remove(body)
	selected[body] = nil
end

function clear()
	local bodies = base.body.getAll()
	for k in pairs(selected) do
		selected[k] = nil
	end
	for _,k in ipairs(bodies) do k.passed = nil end
end
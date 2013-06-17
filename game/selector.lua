module("selector", package.seeall)

require 'vector'
require 'base.body'
require 'base.timer'
require 'lux.object'
require 'camera'
require 'base.transform'

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
	local vPos, vSize
	for v in pairs(selected) do
		vPos, vSize = v.position, v.size
		love.graphics.push();
		base.transform.rotate(v)
		love.graphics.rectangle('line', vPos[1] - 4, vPos[2] - 4, vSize[1] + 8, vSize[2] + 8)
		love.graphics.pop();
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
				--for i=1, 5 do
					b:shoot(pos)
				--end
			end
		else
			local dx, dy, grt, len = 0, 0, 0, 0
			for v in pairs(selected) do grt = math.max(grt,v.width) len = len + 1 end
			dx = -(grt+20)*math.floor(len/2)
			for v in pairs(selected) do
				v:processPathfinding(pos+{dx, dy}, lshift)
				dx = dx + grt + 20
			end
		end
	end
	if button == 'm' then 
		for v in pairs(selected) do
			v.position:set(pos:clone())
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
	if love.keyboard.isDown('lctrl') then
		local mousepos = camera.getMousePosition()
		for v in pairs(selected) do
			v:look_at(mousepos)
		end
	end
	
	if not click_pos then return end
	size:set(camera.getMousePosition():sub(click_pos))

	local lshift = love.keyboard.isDown('lshift')
	if size.x < 5 and size.y < 5 then
		for _,b in ipairs(bodies.character) do
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
		for i,b in ipairs(bodies.character) do
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
	for k in pairs(selected) do
		selected[k] = nil
	end
	for _,k in ipairs(bodies.character) do k.passed = nil end
end
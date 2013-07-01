module("map", package.seeall)

require 'lux.object'
require 'room'

local current_map = nil

map = lux.object.new {
	rooms = {},
	__type = "map"
}

function map:__init()
	if not self.position then self.position = vector:new{} end
	if not self.size then self.size = vector:new{} end

	self.bounds = {
		obstacle:new {
			position = vector:new{self.position[1], self.position[2]},
			size = vector:new{self.size[1], 5}
		},
		obstacle:new {
			position = vector:new{self.position[1]+self.size[1], self.position[2]},
			size = vector:new{5, self.size[2]}
		},
		obstacle:new {
			position = vector:new{self.position[1], self.position[2]+self.size[2]},
			size = vector:new{self.size[1], 5}
		},
		obstacle:new {
			position = vector:new{self.position[1], self.position[2]},
			size = vector:new{5, self.size[2]}
		}
	}
end

function map:inside(pos)
	local x, y = pos[1], pos[2]
	if x>self.position[1] and x<self.position[1]+self.size[1] then
		if y>self.position[2] and y<self.position[2]+self.size[2] then
			return true
		end
	end
	return false
end

function map:update(dt)
	for _,v in pairs(self.bounds) do self.bounds:update() end
end

function map:draw()
	love.graphics.setColor(25, 25, 25)
	love.graphics.rectangle('fill', self.position[1], self.position[2], self.size[1], self.size[2])

	for _,v in pairs(self.bounds) do v:draw() end
end

function map:register()
	for _,v in pairs(self.bounds) do v:register() end
	return self
end

function map:remove()
	for _,v in pairs(self.bounds) do v:remove() end
end

function getMap() return current_map end
function setMap(m) 
	if current_map then current_map:remove() end
	current_map = m:register() 
end
function newMap(pos, s) return map:new{position=pos, size=s} end
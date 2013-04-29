module("base", package.seeall)

require 'vector'
require 'lux.object'

local bodies = {}

body = lux.object.new {
	position = vector:new{},
	size 	 = vector:new{},
	speed	 = vector:new{}
}

body.__init = {}

function body.__init:__index( key )
	if key == 'x' then return self.position[1]
	elseif key == 'y' then return self.position[2]
	elseif key == 'width' then return self.size[1]
	elseif key == 'height' then return self.size[2]
	else return getmetatable(self)[key] end
end

function body.__init:__newindex( key, v )
	if key == 'x' then self.position[1] = v
	elseif key == 'y' then self.position[2] = v
	elseif key == 'width' then self.size[1] = v
	elseif key == 'height' then self.size[2] = v
	else rawset(self,key,v) end
end

function body:register()
	table.insert(bodies, self)
	return self
end

function body.getAll()
	return bodies
end

function body:update( dt )
	self.position = self.position + self.speed * dt
end

function body:draw()
	-- abstract
end
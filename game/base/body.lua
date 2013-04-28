module("base", package.seeall)

require 'vector'
require 'lux.object'

local bodies = {}

body = lux.object.new {
	position = vector:new{},
	size 	 = vector:new{},
	speed	 = vector:new{}
}

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
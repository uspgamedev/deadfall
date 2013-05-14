module("base", package.seeall)

require 'lux.object'
require 'lux.functional'

sprite = lux.object.new {
	sheet 		 = nil,
	maxframe		 = 1,
	flipped		 = false,
	dt				 = nil,
	currentFrame = 0
}

function sprite:__init()
	self.timer = timer:new {
		dt = self.dt,
		starts = self.starts,
		event = lux.functional.bindleft(self.nextFrame,self)
	}

	self.width = self.sheet:getWidth() / self.maxframe
	self.quad = love.graphics.newQuad(0, 0, self.width, self.sheet:getHeight(), self.sheet:getWidth(), self.sheet:getHeight())
	if self.flipped then self.quad:flip(true) end
end

function sprite:nextFrame()
	self.currentFrame = (self.currentFrame + 1) % self.maxframe
	self.quad:setViewport(self.currentFrame * self.width, 0, self.width, 
		self.width*self.maxframe)
	if self.flipped then self.quad:flip(true) end
end

function sprite:stop()
     self.timer:stop()
     self.currentFrame = 0
     self.quad:setViewport(0, 0, self.width, self.width * self.maxframe)
 end
 
 function sprite:start()
     self.timer:start()
     self.quad:flip(self.flipped)
 end
 
 function sprite:setflip(flip)
     self.quad:flip(flip == not self.flipped)
     self.flipped = flip
 end

 function sprite:draw(x,y)
     love.graphics.drawq(self.sheet, self.quad, x or self.x, y or self.y)
 end
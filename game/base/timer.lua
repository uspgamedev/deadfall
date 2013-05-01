module('base', package.seeall)

require 'lux.object'
require 'lux.functional'

local timers = {}

timer = lux.object.new {
	time 	= 0,
	dt 		= nil,
	format	= nil,
	event	= nil
}

timer.formats = {
	ms 	 	= 0.001,
	secs 	= 1,
	mins 	= 60,
	hours	= 360
}

-- Initializes the timer with the corresponding format.
function timer:__init()
	self.dt = self.dt*self.format
end

-- Resets timer to the given delta time.
function timer:set(dt, format, time, action)
	self:reset()
	self.time = time or self.time
	self.dt = dt*format
	self.format = format or self.formats.s
	self.event = action or self.event
end

-- Resets the timer to head time.
function timer:reset()
	self.time = 0
end

-- Resets the timer and starts the timer.
function timer:restart()
	self:reset()
	self:start()
end

-- Starts the timer from its current state by registering to table.
function timer:start()
	self:register()
end

-- Pauses the timer.
function timer:pause()
	self:remove()
end

-- Pauses and resets the timer.
function timer:stop()
	self:pause()
	self:reset()
end

function timer:intern_update(dt)
	self.time = self.time + dt
	if self.time >= self.dt then
		self:stop()
		self.event()
	end
end

function timer.contains(tm)
	for _,v in pairs(timers) do
		if v==tm then return true end
	end
	return false
end
function timer:register()
	if not self.contains(self) then
		table.insert(timers, self)
	end
end
function timer:remove()
	for i,v in pairs(timers) do
		if v==self then table.remove(timers, i) end
	end
end

function timer.update(dt)
	for _,v in pairs(timers) do
		v:intern_update(dt)
	end
end
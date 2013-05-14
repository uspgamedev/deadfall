module('base', package.seeall)

require 'lux.object'

local timers = {}

timer = lux.object.new {
	time 		= 0,
	dt 		= 1,
	format	= 1,
	running  = true,
	repeats  = true,
	event		= nil
}

timer.formats = {
	ms 	= 0.001,
	secs 	= 1,
	mins 	= 60,
	hours	= 3600
}

-- Initializes the timer with the corresponding format.
function timer:__init()
	self.dt = self.dt*self.format
	self:register()
end

-- Resets timer to the given delta time.
function timer:set(dt, format, time, action)
	self.time = time or 0
	self.dt = dt*format
	self.format = format or self.format
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
	self.running = true
end

-- Pauses the timer.
function timer:pause()
	self.running = false
end

-- Pauses and resets the timer.
function timer:stop()
	self:pause()
	self:reset()
end

function timer:intern_update(dt)
	if not self.running then return end
	self.time = self.time + dt
	if self.time >= self.dt then
		self.time = self.time - self.dt
		if self.event then self.event() end
		if not self.repeats then 
			self:stop()
			self:remove()
		end
	end
end

function timer:register()
	timers[self] = true
end
function timer:remove()
	timers[self] = nil
end

function timer.update(dt)
	for timer in pairs(timers) do
		timer:intern_update(dt)
	end
end
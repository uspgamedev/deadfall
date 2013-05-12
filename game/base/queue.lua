module('base', package.seeall)

require 'lux.object'

-- Queue: FIFO - First-In-First-Out
queue = lux.object.new {}

-- Adds the element given to the last position in the queue.
function queue:push(e)
	self[#self + 1] = e
end

-- Removes and returns the first position in the queue.
function queue:pop()
	return table.remove(self, 1)
end

-- Returns whether the queue is empty or not.
function queue:empty()
	return #self == 0
end

-- Clears the whole queue.
function queue:clear()
	for k in ipairs(self) do
		self[k] = nil
	end
end
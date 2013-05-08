module('base', package.seeall)

require 'lux.functional'
require 'lux.object'

-- Queue: FIFO - First-In-First-Out
queue = lux.object.new {}

function queue:__init()
	-- Adds the element given to the last position in the queue.
	self.push = lux.functional.bindfirst(table.insert, self)

	-- Removes and returns the first position in the queue.
	self.pop  = lux.functional.bindfirst(table.remove, self, 1)

	-- Returns the queue's size.
	self.size = lux.functional.bindfirst(function(_table) return #_table end, self)

	-- Returns whether the queue is empty or not.
	self.empty = lux.functional.bindfirst(function(_table) return _table.size()==0 end, self)

	-- Clears the whole queue.
	self.clear = lux.functional.bindfirst(function(_table) 
			for i,v in ipairs(_table) do _table[i] = nil end end, self)
end
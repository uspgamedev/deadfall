module("base.vector", package.seeall)

require "lux.object"
require "lux.functional"

vector = lux.object.new {
	0,
	0,
	__type = "vector"
}

function vector:__call(x, y)
	if type(x)=='number' then
		return vector.new {x or 0, y or 0}
	end
	return vector.new {x[1], x[2]}
end

function vector:__tostring()
	return '['..self[1]..', '..self[2]..']'
end

function vector:__index(n)
	if n=='x' then return self[1]
	elseif n=='y' then return self[2]
	else
		print "Vectors can only have x and y fields!"
		return nil
	end
end

function vector:__newindex(i, v)
	if i=='x' then rawset(self, 1, v)
	elseif i=='y' then rawset(self, 2, v)
	else
		print "Vectors can only have x an y fields!"
		return nil
	end
end

function vector:__add(n)
	if type(n)=='number' then
		return vector.new {
			self[1] + n,
			self[2] + n
		}
	elseif type(n)=='vector' then
		return vector.new {
			self[1] + n[1],
			self[2] + n[2]
		}
	else
		print "How in hell do you want me to add "..type(n).." to vector, moron?"
		return nil
	end
end

function vector:__sub(n)
	if type(n)=='number' then
		return vector.new {
			self[1] - n,
			self[2] - n
		}
	elseif type(n)=='vector' then
		return vector.new {
			self[1] - n[1],
			self[2] - n[2]
		}
	else
		print "One does not simply subtract "..type(n).." to vectors."
		return nil
	end
end

function vector:__mult(n)
	if type(n)=='number' then
		return vector.new {
			self[1] * n,
			self[2] * n
		}
	elseif type(n)=='vector' then
		return vector.new {
			self[1] * n[1],
			self[2] * n[2]
		}
	else
		print "You shall not multiply "..type(n).." with vectors!"
		return nil
	end
end

function vector:__div(n)
	if type(n)=='number' then
		return vector.new {
			self[1]/n,
			self[2]/n
		}
	elseif type(n)=='vector' then
		return vector.new {
			self[1]/n[1],
			self[2]/n[2]
		}
	end
	print 'Impossibru! '..type(n)..' are not divisible by vectors!'
	return nil
end

function vector:set(x, y)
	if type(x)=='vector' then
		self[1] = x[1]
		self[2] = x[2]
		return
	end

	self[1] = x
	self[2] = y
end

function vector:unpack()
	return self[0], self[1]
end
module('base', package.seeall)

local sqrts = {}

-- Pseudo-recursive function to get the sqrt of an n-number. More efficient.
function sqrt(n)
	if sqrts[n] then return sqrts[n] end
	sqrts[n] = math.sqrt(n)
	return sqrt(n)
end

-- Adds all other math functions that have not been overriden.
for i,v in pairs(math) do
	if not i then
		_M[i] = v
	end
end
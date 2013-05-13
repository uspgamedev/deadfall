module('base.transform', package.seeall)

--[[
	Rotates a body according to the given (x, y) anchor.

	Receives a body, an anchor point, a function in which to operate,
	and the function's passing arguments.

	The anchor point is, by definition, the coordinate where the rotation's
	origin takes place.

	If the anchor point is not passed, x_anchor is then assumed to
	be the argument draw, in which case the remaining arguments are
	its parameters.
	In this case, the anchor point is presumed to be the center of
	the body's bounds. Since Love2D's coordinate system counts from
	the absolute origin, we have that the center anchor point is:
		anchor = position+size/2, where all three variables are vectors
	
	Else, if the anchor point is in fact given, we calculate the
	anchor point relative to the body's position. This is due to
	the fact that if we were to use absolute-origin rotation we 
	could just use love.graphics.rotate directly.

	Before we can continue, we 'push' a new transformation stack
	element into the graphics' list. This way we don't have to
	manually revert everything.

	The relative-origin is then translated to the anchor point,
	which sets the point in which the body will be rotated. Once
	it's set, we rotate it body.angle radians. We then manually
	revert the origin's location (to avoid incorrect draw positioning)
	and effectively draw the shape/image with its corresponding
	parameters.

	Finally, we pop the last element from the graphics' stack, 
	reverting changes from love.graphics.
]]
function rotate(body, x_anchor, y_anchor, draw, ...)
	local trans, rotate = love.graphics.translate, love.graphics.rotate
	local draws = draw
	local args = nil
	local pos = body.position
	if type(x_anchor)=='function' then
		local size = body.size
		draws = x_anchor
		args = {y_anchor, draw, ...}
		x_anchor, y_anchor = pos[1]+size[1]/2, pos[2]+size[2]/2
	else 
		x_anchor = x_anchor + pos[1]
		y_anchor = y_anchor + pos[2]
	end
	if not args then args=... end

	love.graphics.push()

	trans(x_anchor, y_anchor)
	rotate(body.angle)
	trans(-x_anchor, -y_anchor)
	draws(unpack(args))

	love.graphics.pop()
end
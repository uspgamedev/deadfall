module('base.transform', package.seeall)

--[[
	Rotates a body according to the given (x, y) anchor.

	Receives a body and an anchor point.

	The anchor point is, by definition, the coordinate where the rotation's
	origin takes place.

	If the anchor point is not passed,it is presumed to be the center of
	the body's bounds.
	
	We calculate the anchor point relative to the body's position.
	This is due to	the fact that if we were to use absolute-origin 
	rotation we could just use love.graphics.rotate directly.

	The relative-origin is then translated to the anchor point,
	which sets the point in which the body will be rotated. Once
	it's set, we rotate it body.angle radians. We then manually
	revert the origin's location (to avoid incorrect draw positioning).
]]
function rotate(body, x_anchor, y_anchor)
	local trans, rotate = love.graphics.translate, love.graphics.rotate
	x_anchor = (x_anchor or body.width/2)  + body.x
	y_anchor = (y_anchor or body.height/2) + body.y

	trans(x_anchor, y_anchor)
	rotate(body.angle)
	trans(-x_anchor, -y_anchor)
end
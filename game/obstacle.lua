require 'base.body'

obstacle = base.body:new {
	__type = "obstacle"
}

function obstacle:update(dt)
	obstacle:__super().update(self, dt)

	local chars = base.body.getAll().character
	for _,v in pairs(chars) do
		if self:intersects(v) then
			local vX, vY = (self.centerX-v.centerX), (self.centerY-v.centerY)
			v.force:set(-vX, -vY):mult(40)
			v.pushed = true
			if not v.reactor.running and v.target then
				if not v.reactor.event then
					v.reactor.event = function()
						if v.target then
							v:move_to(v.target)
						end
					end
					v.reactor.running = false
				end
				v.reactor:start()
			end
		end
	end

	local bullets = base.body.getAll().bullet
	if bullets then
		for _,v in pairs(bullets) do
			if self:intersects(v) then
				v.speed:mult(-1, 1)
			end
		end
	end
end

function obstacle:draw()
	love.graphics.setColor(125, 125, 125)
	love.graphics.rectangle('fill', self.position[1], self.position[2], self.size[1], self.size[2])
end
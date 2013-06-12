require 'base.body'

obstacle = base.body:new {
	__type = "obstacle"
}

function obstacle:update(dt)
	obstacle:__super().update(self, dt)

	local chars = base.body.getAll().character
	for _,v in pairs(chars) do
		if self:intersects(v) then
			local vX, vY 
				
			if self.size[1] > self.size[2] then
				vX, vY = 0, self.centerY-v.centerY
			else
				vX, vY = self.centerX-v.centerX, 0
			end

			v.temp_force:set(-vX, -vY):mult(40)
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
				local dx, dy = math.abs(v.speed[1]), math.abs(v.speed[2])
				if self.y + self.height > v.y then dy = -dy end
				if self.x + self.width > v.x then dx = -dx end
				--[[local theta = math.pi/4 - math.atan2(v.Vy, v.Vx)

				local mx, my = math.cos(theta)*v.Vx, math.sin(theta)*v.Vy
				v.speed:mult(mx>0 and 1 or -1, my>0 and 1 or -1)]]
				v.speed:set(dx, dy)
			end
		end
	end
end

function obstacle:draw()
	love.graphics.setColor(125, 125, 125)
	love.graphics.rectangle('fill', self.position[1], self.position[2], self.size[1], self.size[2])
end
require 'base.body'
require 'base.timer'

gun = base.body:new {
	ammo = 0,
	owner = nil,
	mode = 'fill'
}

function gun:__init()
	self.position = vector:new{}
	self.reactor  = base.timer:new {
		dt 		= 0.250,
		repeats = true,
		running = false
	}
	self.size = vector:new {40, 5}

	self.floatY = 10
end

function gun:drop()
	self.owner = nil
end

function gun:draw()
	love.graphics.setColor(175, 175, 175)

	base.transform.rotate(self, 0, 0)
	love.graphics.rectangle(self.mode, self.position[1], self.position[2], 
		self.size[1], self.size[2])
end

function gun:shoot(target)
	self:look_at(target)

	if not self.burst then
		self.burst = base.timer:new{
			dt = 0.125,
			repeats = true,
			bullets = 0,
			s_target = target,
			event = function()
				if self.burst.bullets > 3 then
					self.burst.bullets = 0
					self.burst:stop()
					self.burst:remove()
					return
				end

				bullet:new{
					owner = self.owner,
					position = vector:new{
						self.position[1] + math.cos(self.angle)*self.size[1], 
						self.position[2] + math.sin(self.angle)*self.size[2]},
					target = self.burst.s_target:clone()
				}:register()
				self.burst.bullets = self.burst.bullets + 1
			end
		}
	elseif not self.burst.running then
		self.burst.s_target = target
		self.burst:restart()
		self.burst:register()
	end
end

function gun:update(dt)
	if not self.owner then
		local diff = dt
		self.angle = 0

		if self.floatY > 5 then
			diff = -dt
			self.floatY = 0
		elseif self.floatY < -5 then
			diff = dt
			self.floatY = 0
		end
		self.floatY = self.floatY + diff
		self.position:add(0, self.floatY)
	else
		self.position:set(self.owner.position[1]+self.owner.size[1]/2,
			self.owner.position[2]+self.owner.size[2]/2)
	end
end
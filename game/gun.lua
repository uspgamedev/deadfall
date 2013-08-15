require 'base.body'
require 'base.timer'

gun = base.body:new {
	ammo = 0,
	dropped = false
}

function gun:__init()

end

function gun:draw()
	love.graphics.setColor(175, 175, 175)

	base.transform.rotate(self)
	love.graphics.rectangle(self.mode, self.position[1], self.position[2], 
		self.size[1], self.size[2])
end

function gun:shoot()

end

function gun:update(dt)

end
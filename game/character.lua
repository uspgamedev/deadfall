require 'base.body'

local colors = {
	{0, 255, 0},
	{0, 0, 255},
	{255, 0, 0}
}

character = base.body:new {
	mode = 'fill',
	team = 0
}

function character:__init()
	if self.radius then
		self.size:set(2*self.radius,2*self.radius)
		self.radius = nil
	end
end

function character:draw()
	local teamColor = colors[self.team+1]
	love.graphics.setColor(unpack(teamColor))

	love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)

	if self.target then 
		love.graphics.setColor(255,0,0)
		love.graphics.circle('fill', self.target.x, self.target.y, 5)
	end

	local latX, latY = self.centerX, self.centerY
	local ltarg = self.target
	if ltarg then
		love.graphics.setColor(unpack(teamColor))
		love.graphics.line(latX, latY, ltarg[1], ltarg[2])
		latX, latY = ltarg[1], ltarg[2]
	end

	for i,v in ipairs(self.targets) do
		love.graphics.setColor(0, 0, 255)
		love.graphics.print(i, v[1], v[2])
		love.graphics.circle('fill', v[1], v[2], 3)
		love.graphics.setColor(unpack(teamColor))
		love.graphics.line(latX, latY, v[1], v[2])
		latX, latY = v[1], v[2]
	end
end
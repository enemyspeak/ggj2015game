local Cloud = class('Cloud')

Cloud.static.CENTERX = love.graphics.getWidth()/2
Cloud.static.CENTERY = love.graphics.getHeight()/2

Cloud.static.TILES = lg.newImage("res/skytiles.png")
Cloud.static.QUADS = 	{
						[1] = love.graphics.newQuad(0, 0, 155, 120, Cloud.TILES:getDimensions()),
						[2] = love.graphics.newQuad(155, 0, 170, 130, Cloud.TILES:getDimensions()),
						[3] = love.graphics.newQuad(320, 0, 210, 130, Cloud.TILES:getDimensions()),
						[4] = love.graphics.newQuad(530, 0, 184, 130, Cloud.TILES:getDimensions()),
						[5] = love.graphics.newQuad(710, 0, 180, 130, Cloud.TILES:getDimensions())
						}



-- 	OLD MAN YELLS AT CLOUD

function Cloud:initialize(attributes)
	self.offsetX = attributes.offsetX or 0
	self.offsetY = attributes.offsetY or 0

	self.x = attributes.x or 0
	self.y = attributes.y or 0
	self.gridX = attributes.gx or 0
	self.gridY = attributes.gy or 0

	self.width = attributes.width or 64
	self.height = attributes.height or 64

	self.n = attributes.n or math.random(1,5)

	self.finish = false

	self.time = 0
	self.speed = 10
	self.scaleX = math.random(0,10)
	self.scaleY = math.random(0,10)
end

function Cloud:getN()
	return self.n
end

function Cloud:getPosition()
	return self.x,self.y
end

function Cloud:getKill()
	return self.finish
end

function Cloud:setN(value)
	if value then
		self.n = value
	else
		self.n = 15
	end
end

function Cloud:update(dt)
	-- nothing to see here.
	self.x = self.x + self.speed*dt
	if self.y > lg.getWidth() + 200 then
		self.finish = true
	end
end

function Cloud:draw()
	lg.setColor(255,255,255)
	local quad = Cloud.QUADS[self.n]
	lg.draw(Cloud.TILES,quad,self.x,self.y,0,1,1)
end

return Cloud

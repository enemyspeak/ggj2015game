local ArtObject = class('ArtObject')

ArtObject.static.CENTERX = love.graphics.getWidth()/2
ArtObject.static.CENTERY = love.graphics.getHeight()/2

ArtObject.static.TILES = lg.newImage("res/fleur.png")
ArtObject.static.QUADS = 	{
						[1] = love.graphics.newQuad(145, 0, 310-145, 150, ArtObject.TILES:getDimensions()),
						[2] = love.graphics.newQuad(310, 0, 440-310, 150, ArtObject.TILES:getDimensions()),
						[3] = love.graphics.newQuad(440, 0, 595-440, 150, ArtObject.TILES:getDimensions()),
						[4] = love.graphics.newQuad(760, 0, 895-760, 150, ArtObject.TILES:getDimensions()),
						[5] = love.graphics.newQuad(640, 0, 725-640, 150, ArtObject.TILES:getDimensions()),
						[6] = love.graphics.newQuad(0, 0, 145, 150, ArtObject.TILES:getDimensions()),
						[7] = love.graphics.newQuad(895, 0, 1050-895, 150, ArtObject.TILES:getDimensions())
						}

function ArtObject:initialize(attributes)
	self.offsetX = attributes.offsetX or 0
	self.offsetY = attributes.offsetY or 0

	self.x = attributes.x or 0
	self.y = attributes.y or 0
	self.gridX = attributes.gx or 0
	self.gridY = attributes.gy or 0

	self.flip = math.floor(math.random(0,1)) + 1

	self.bn = attributes.bn or 1

	self.width = attributes.width or 64
	self.height = attributes.height or 64

	self.n = attributes.n or math.random(1,7)

	self.time = 0
	self.scaleX = math.random(0,10)
	self.scaleY = math.random(0,10)
end

function ArtObject:getN()
	return self.n
end

function ArtObject:setHeight(value,distance)
	if value == 1 then
		self.playerHeight = distance
	elseif value == 2 then
		self.enemyHeight = distance
	end
end

function ArtObject:getHeight(value)
	if value == 1 then
		return self.playerHeight
	elseif value == 2 then
		return self.enemyHeight
	end
end

function ArtObject:getPosition()
	return self.x,self.y
end

function ArtObject:setN(value)
	if value then
		self.n = value
	else
		self.n = 15
	end
end

function ArtObject:update(dt)
	-- nothing to see here.

	self.scaleX = self.scaleX + dt*2
	self.scaleY = self.scaleY + dt*2
end

function ArtObject:draw()
	lg.setColor(255,255,255,255)
	local sx = 0.5--(math.sin(self.scaleX) + 1)
	local sy = 0.5--(math.sin(self.scaleY) + 1)
	quad = ArtObject.QUADS[self.n]
	lg.draw(ArtObject.TILES,quad,self.x*self.width,self.y*self.height,0,sx,sy)

--	lg.print(self.n,(self.x-1)*64,(self.y-1)*64)
end

return ArtObject

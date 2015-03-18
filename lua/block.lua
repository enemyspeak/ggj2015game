local Block = class('Block')

Block.static.CENTERX = love.graphics.getWidth()/2
Block.static.CENTERY = love.graphics.getHeight()/2

Block.static.TILES = lg.newImage("res/tiles.png")
Block.static.BACKTILES = lg.newImage("res/backtiles.png")
Block.static.QUADS = 	{
						[0] = love.graphics.newQuad(0, 0, 64, 64, Block.TILES:getDimensions()),
						[1] = love.graphics.newQuad(64, 0, 64, 64, Block.TILES:getDimensions()),
						[2] = love.graphics.newQuad(64*2, 0, 64, 64, Block.TILES:getDimensions()),
						[3] = love.graphics.newQuad(64*3, 0, 64, 64, Block.TILES:getDimensions()),
						[4] = love.graphics.newQuad(64*4, 0, 64, 64, Block.TILES:getDimensions()),
						[5] = love.graphics.newQuad(64*5, 0, 64, 64, Block.TILES:getDimensions()),
						[6] = love.graphics.newQuad(64*6, 0, 64, 64, Block.TILES:getDimensions()),
						[7] = love.graphics.newQuad(64*7, 0, 64, 64, Block.TILES:getDimensions()),
						[8] = love.graphics.newQuad(64*8, 0, 64, 64, Block.TILES:getDimensions()),
						[9] = love.graphics.newQuad(64*9, 0, 64, 64, Block.TILES:getDimensions()),
						[10] = love.graphics.newQuad(64*10, 0, 64, 64, Block.TILES:getDimensions()),
						[11] = love.graphics.newQuad(64*11, 0, 64, 64, Block.TILES:getDimensions()),
						[12] = love.graphics.newQuad(64*12, 0, 64, 64, Block.TILES:getDimensions()),
						[13] = love.graphics.newQuad(64*13, 0, 64, 64, Block.TILES:getDimensions()),
						[14] = love.graphics.newQuad(64*14, 0, 64, 64, Block.TILES:getDimensions()),
						[15] = love.graphics.newQuad(64*15, 0, 64, 64, Block.TILES:getDimensions())
						}

function Block:initialize(attributes)
	self.offsetX = attributes.offsetX or 0
	self.offsetY = attributes.offsetY or 0

	self.x = attributes.x or 0
	self.y = attributes.y or 0
	self.gridX = attributes.gx or 0
	self.gridY = attributes.gy or 0
	self.background = attributes.background or false
	self.flip = math.floor(math.random(0,1)) + 1

	self.width = attributes.width or 64
	self.height = attributes.height or 64

	self.n = attributes.n or 15
		
	self.scaleX = math.random(0,math.pi)
	self.scaleY = math.random(0,math.pi)
end

function Block:getN()
	return self.n
end

function Block:setHeight(value,distance)
	if value == 1 then
		self.playerHeight = distance
	elseif value == 2 then
		self.enemyHeight = distance
	end
end

function Block:getHeight(value)
	if value == 1 then
		return self.playerHeight
	elseif value == 2 then
		return self.enemyHeight
	end
end

function Block:getPosition()
	return self.x,self.y
end

function Block:setN(value)
	if value then
		self.n = value
	else
		self.n = 15
	end
end

function Block:update(dt)
	-- nothing to see here.
	self.scaleX = self.scaleX + dt
	self.scaleY = self.scaleY + dt
	if self.scaleX > math.pi then self.scaleX = 0 end
	if self.scaleY > math.pi then self.scaleY = 0 end
end

function Block:draw()
	lg.setColor(255,255,255)
	
	if self.n == 16 then else
		local quad = Block.QUADS[self.n]
		lg.setColor(255,255,255,255)
		if self.background then
			lg.draw(Block.BACKTILES,quad,self.offsetX + self.x*self.width-self.width,self.offsetY + self.y*self.height-self.height,0,1,1,0,0)
		else	
			if self.n == 5 and self.flip == 2 then
				lg.draw(Block.TILES,quad,
				self.offsetX + self.x*self.width,
				self.offsetY + self.y*self.height-self.height,0,-1,1,0,0)
			else
				lg.draw(Block.TILES,quad,self.offsetX + self.x*self.width-self.width,self.offsetY + self.y*self.height-self.height,0,1,1,0,0)
			end
		end

		if self.background then else
		--	lg.rectangle("line",self.offsetX + self.x*self.width-self.width,self.offsetY + self.y*self.height-self.height,self.width,self.height)
		--	lg.print(self.n,(self.x-1)*64,(self.y-1)*64)
		end
	end
end

return Block

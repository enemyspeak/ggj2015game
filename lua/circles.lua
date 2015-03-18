		
local Circle = class('Circle')

Circle.static.CIRCLE = lg.newImage('res/circle.png')

function Circle:initialize(attributes)
	local attributes = attributes or {}
	self.x = attributes.x or Circle.CENTERX + Circle.SAFEZONE
	self.y = attributes.y or Circle.CENTERY + Circle.SAFEZONE
	self.scale = math.random(0.2,1)
	self.finished = false
	self.direction = math.random(0,1)
	self.speed = attributes.speed or math.random(35,65)
	self.size = 3
	self.type = math.random(1,2)
	self.time = 0
	self.color = 	{
					r = 255,
					g = 128,
					b = 128
					}
end

function Circle:setPos(xpos,ypos)
	self.x = xpos
	self.y = ypos
end

function Circle:update(dt)	
	self.time = self.time + dt*2
	
	local factor = 40
	self.offsetX = math.sin(self.time)*factor
	self.offsetY = math.cos(self.time)*factor
	self.sizeWobble = math.sin(self.time)/4
end

function Circle:getFinished()
	return self.finished
end

function Circle:setKill(value)
	self.finished = value
end

function Circle:getPos()
	return self.x, self.y, self.z
end

function Circle:draw()
	lg.setColor(self.color.r,self.color.g,self.color.b,255)
	lg.draw(Circle.CIRCLE,self.x,self.y,0,self.size,self.size,64,64)
	lg.draw(Circle.CIRCLE,self.x+self.offsetX,self.y+self.offsetY,0,self.size,self.size,64,64)
	lg.draw(Circle.CIRCLE,self.x,self.y,0,self.size+self.sizeWobble,self.size,64,64)
end

return Circle

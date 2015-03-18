		
local Particle = class('Particle')

Particle.static.SAFEZONE = 64		 --this is a class variable
Particle.static.KILLZONE = 610

Particle.static.COLOR1 = {1,0,1}		
Particle.static.COLOR2 = {8,38,53}	
Particle.static.COLOR3 = {6,24,39}	
				 
Particle.static.CENTERX = love.graphics.getWidth()/2
Particle.static.CENTERY = love.graphics.getHeight()/2

Particle.static.ATLAS = lg.newImage('res/sparkles.png')

Particle.static.QUADS = {
						[1] = love.graphics.newQuad(0, 0, 16, 16, Particle.ATLAS:getDimensions()),
						[2] = love.graphics.newQuad(16, 0, 16, 16, Particle.ATLAS:getDimensions()),
						[3] = love.graphics.newQuad(16*2, 0, 16, 16, Particle.ATLAS:getDimensions()),
						[4] = love.graphics.newQuad(16*2, 0, 16, 16, Particle.ATLAS:getDimensions()),
						}


function Particle:initialize(attributes)
	local attributes = attributes or {}
	self.x = attributes.x or Particle.CENTERX + Particle.SAFEZONE
	self.y = attributes.y or Particle.CENTERY + Particle.SAFEZONE
	self.scale = attributes.scale or math.random(0.2,1)
	self.direction = attributes.direction or math.random(0,1)
	self.speed = attributes.speed or math.random(15,65)
	self.switch = attributes.switch or 0
	self.finished = false
	self.step = math.random(1.0,2.0)
	self.type = math.random(0,1)
	self.n = math.random(1,4)
	self.time = 0
end

function Particle:setPos(xpos,ypos)
	self.x = xpos
	self.y = ypos
end

function Particle:update(dt)	
	self.time = self.time + dt
	if self.switch == 1 then
		if self.direction > 0.5 then
			self.x = self.x + (self.speed - math.sin(2*self.step*self.time+3) )* dt
		else
			self.x = self.x - (self.speed - math.sin(2*self.step*self.time+3) )* dt
		end
			self.y = self.y + (math.sin(self.step*self.time))/2
	else
		if self.direction > 0.5 then
			self.x = self.x + math.sin(self.step*self.time)
		else
			self.x = self.x - math.sin(self.step*self.time)
		end
		self.y = self.y + (self.speed - math.sin(2*self.step*self.time+3) )* dt

		if value then else			
			cull = Particle.KILLZONE
			if self.y  > cull then
				self.finished = true
			end
		end
	end
end

function Particle:isOnScreen()
	self.onScreen = false
	if self.x < Particle.CENTERX+4 and self.x > -Particle.CENTERX-4 then
		if self.y < Particle.CENTERY+4 and self.y > -Particle.CENTERY-4 then
			self.onScreen = true
		end
	end
	return self.onScreen
end

function Particle:getKill()
	return self.finished
end

function Particle:setKill(value)
	self.finished = value
end

function Particle:getDistance(x,y)
	if x == nil or y == nil then 
		return (self.x)^2+(self.y)^2
	else
		return (self.x-x)^2+(self.y-y)^2
	end
end

function Particle:getPos()
	return self.x, self.y, self.z
end

function Particle:draw()
	local quad = Particle.QUADS[self.n]
	love.graphics.setColor(255,255,255,255)	
	lg.draw(Particle.ATLAS,quad,self.x,self.y, math.sin(self.step*self.time)/2)
end

return Particle

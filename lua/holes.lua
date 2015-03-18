		
local Hole = class('Hole')

Hole.static.SAFEZONE = 64		 --this is a class variable
Hole.static.KILLZONE = 256

Hole.static.COLOR1 = {1,0,1}		
Hole.static.COLOR2 = {8,38,53}	
Hole.static.COLOR3 = {6,24,39}	
				 
Hole.static.CENTERX = IRESX/2
Hole.static.CENTERY = IRESY/2

Hole.static.KILLZONE = Hole.CENTERX*3


function Hole:initialize(attributes)
	local attributes = attributes or {}
	self.x = attributes.x or Hole.CENTERX + Hole.SAFEZONE
	self.y = attributes.y or Hole.CENTERY + Hole.SAFEZONE
	self.scale = attributes.scale or math.random(1,10)
	self.finished = false
	self.speed = attributes.speed or math.random(5,25)
	self.type = 1
end

function Hole:setPos(xpos,ypos)
	self.x = xpos
	self.y = ypos
end

function Hole:update(dt)	
	local cull = (Hole.CENTERX + Hole.KILLZONE)
	if self.x < -cull or self.x  > cull then
		self.finished = true
	end
	cull = (Hole.CENTERY + Hole.KILLZONE)
	if self.y < -cull or self.y  > cull then
		self.finished = true
	end
end

function Hole:isOnScreen()

end

function Hole:getKill()
	return self.finished
end

function Hole:setKill(value)
	self.finished = value
end

function Hole:getDistance(x,y)

end

function Hole:getPos()
	
end

function Hole:getState(xpos,ypos, value) 

end

function Hole:draw()
	
end

return Hole

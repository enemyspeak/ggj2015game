
local Player = class('Player')

Player.static.GRAVITY = 200
Player.static.MAXYSPEED = 1200
Player.static.BLOCKWIDTH = 64
Player.static.BLOCKHEIGHT = 64

Player.static.PLAYERONE = lg.newImage('res/playerone.png')
Player.static.PLAYERTWO = lg.newImage('res/playertwo.png')

Player.static.POSITIONS = 	{
							[1] = {x = 520,y = 528 },
							[2] = {x = 780,y = 528 }
							}

function Player:initialize(attributes)
	attributes = attributes or {}
	--self.x = attributes.x or 1
	--self.y = attributes.y or 1
	
	self.position = attributes.position or 1

	self.x = Player.POSITIONS[self.position].x
	self.y = Player.POSITIONS[self.position].y 

	self.width = 48
	self.height = 48

	self.state = 0
	self.animationCounter = 1
	self.animationSpeed = 0.5
	self.animationTimer = math.random(5,20)/10

	self.room = attributes.room or 1
	self.playerNum = attributes.playerNum or 1

	self.r = 0
	self.rtween = true

	self.normalAcceleration = 200
	self.dragActive = 0.9
	self.dragPassive = 0.7
	self.maxSpeed = 275 --800
	self.maxSpeed_sq = self.maxSpeed * self.maxSpeed

	self.jumpTime = 0.1
	self.maxJump = 0.1
	self.jumpHeight = 64*28 --64*3 -- 64 is a tile

	self.xVel = 0
	self.yVel = 0

	self.input = {}

	self.isTransitioning = false

	self.collisions = {}

	self.collisions[1] = attributes.collision or
					{
					lx = -lg.getWidth()/2,
					rx = lg.getWidth()/2,
					ly = -lg.getHeight()/2,
					ry = lg.getHeight()/2
					}
	self.collisions[2] = attributes.collision or
					{
					lx = -lg.getWidth()/2,
					rx = lg.getWidth()/2,
					ly = -lg.getHeight()/2,
					ry = lg.getHeight()/2
					}
	self.fancyCollisions = 	{
							top = false,
							right = false,
							bottom = false,
							left = false
							}
end

function Player:getPosition()
	return self.x,self.y
end

function Player:setPosition(x,y)
	self.x = x
	self.y = y
end	

function Player:setTransitioning(v,dir)
	self.isTransitioning = v
	local t = 0.4
	if self.isTransitioning then
		if dir == 3 then
			flux.to(self,t,{y = 80}):ease("quadinout")
		end
		if dir == 1 then
			flux.to(self,t,{y = 520}):ease("quadinout")
		end
		if self.playerNum == 1 then
			if dir == 2 then
				flux.to(self,t,{x = 70}):ease("quadinout")
			end
			if dir == 4 then
				flux.to(self,t,{x = 540}):ease("quadinout")
			end
		else
			if dir == 2 then
				flux.to(self,t,{x = 640+70}):ease("quadinout")
			end
			if dir == 4 then
				flux.to(self,t,{x = 640+540}):ease("quadinout")
			end
		end
	end
end

function Player:getTransitioning()
	return self.isTransitioning
end

function Player:updateMovement( dt )
	local function magnitude_2d(x, y)
		return math.sqrt(x*x + y*y)
	end

	local function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	local function magnitude_2d_sq(x, y)
		return x*x + y*y
	end

	local function normalize_2d(x, y)
		local mag = magnitude_2d(x, y)
		if mag == 0 then return {0,0} end
		return {x/mag, y/mag}
	end

	local tempXAccel = 0
	local tempYAccel = 0
	
	if (self.input.left and (not self.input.right)) then 
		tempXAccel = -1
	elseif (self.input.right and (not self.input.left)) then 
		tempXAccel = 1 
	end

	local tempNormAccel = normalize_2d(tempXAccel,tempYAccel)
	tempXAccel = tempNormAccel[1]*self.normalAcceleration

	local tempXVel = self.xVel
	local tempYVel = 0
	local curSpeed = magnitude_2d(self.xVel,0)
	
	if ((self.normalAcceleration + curSpeed) > self.maxSpeed) then
		local accelMagnitude = self.maxSpeed - curSpeed
		if (accelMagnitude < 0) then accelMagnitude = 0 end

		tempXAccel = tempNormAccel[1]*accelMagnitude
		--tempYAccel = tempNormAccel[2]*accelMagnitude
	end

	tempXVel = tempXVel + tempXAccel
	--tempYVel = tempYVel + tempYAccel

	local temp_vel = magnitude_2d_sq(tempXVel, 0)

	if(math.abs(temp_vel) > self.maxSpeed_sq) then
		tempXVel = self.xVel
	--	tempYVel = self.yVel
	end

	local temp_drag = self.dragPassive

	if (self.input.x_has_input or self.input.y_has_input) then
		temp_drag = self.dragActive
	end

	self.xVel = tempXVel * temp_drag

	if self.jumpTime > 0 and (self.input.up and (not self.input.down)) then	-- jump!
		self.jumpTime = self.jumpTime - dt
		self.yVel = self.yVel - self.jumpHeight * dt
	end

	if self.fancyCollisions.top then
		self.jumpTime = 0
		self.yVel = 100
	end
		
	self.y = self.y + self.yVel*dt
	self.yVel = self.yVel + Player.GRAVITY * dt
	
	if self.yVel > Player.MAXYSPEED then
		self.yVel = Player.MAXYSPEED
	end
	
	if self.fancyCollisions.bottom then
		self.jumpTime = self.maxJump
		self.yVel = 0
	end

end

function Player:getWidth()
	return self.width
end

function Player:getHeight()
	return self.height
end

function Player:setCollision(v,c)
	self.collisions[v] = c
end

function Player:move(dt)
	self.x = self.x + self.xVel*dt
	self.y = self.y + self.yVel*dt
	self.r = self.r + math.rad(self.xVel/50)
	if self.r > math.rad(360) then self.r = 0 end
	if self.r < -math.rad(180) then self.r = -self.r end

	self.rtween = flux.to(self,0.25,{r = 0}):ease("quadin")
end

function Player:drawCollision()
	--[[
	lg.setColor(0,255,255)
	lg.line(self.x-self.collisions[1].lx+self.width/2,self.y+self.height/2,self.x+self.width/2,self.y+self.height/2)
	lg.line(self.collisions[1].rx+self.x+self.width/2,self.y+self.height/2,self.x+self.width/2,self.y+self.height/2)
	lg.line(self.x+self.width/2,self.y-self.collisions[1].ly+self.height/2,self.x+self.width/2,self.y+self.height/2)
	lg.line(self.x+self.width/2,self.collisions[1].ry+self.y+self.height/2,self.x+self.width/2,self.y+self.height/2)
	
	
	lg.setColor(255,0,255)
	lg.line(self.x-self.collisions[2].lx-self.width/2,self.y-self.height/2,self.x-self.width/2,self.y-self.height/2)
	lg.line(self.collisions[2].rx+self.x-self.width/2,self.y-self.height/2,self.x-self.width/2,self.y-self.height/2)
	lg.line(self.x-self.width/2,self.y-self.collisions[2].ly-self.height/2,self.x-self.width/2,self.y-self.height/2)
	lg.line(self.x-self.width/2,self.collisions[2].ry+self.y-self.height/2,self.x-self.width/2,self.y-self.height/2)
	]]

	lg.setColor(0,0,0)
	lg.rectangle("fill",self.x+35,self.y-65,150,55)
	lg.setColor(0,255,255)
	lg.print("self.yVel: "..self.yVel, self.x+40,self.y-60)
	lg.print("bottom: "..tostring(self.fancyCollisions.bottom), self.x+40,self.y-40)
	lg.print("top: "..tostring(self.fancyCollisions.top), self.x+40,self.y-30)
end

function Player:drawDebug()
	lg.setColor(0,0,0)
	lg.rectangle("fill",self.x-5,self.y-105,150,45)
	lg.setColor(255,255,255)
	lg.print( math.floor(self.x/16).." ".. math.floor(self.y/16), self.x-5,self.y-100)
	lg.print( "yYel: "..self.yVel, self.x-5,self.y-90)
	lg.print( "xYel: "..self.xVel, self.x-5,self.y-80)
end

function Player:updateState()
	if (self.input.left and (not self.input.right)) then 
		self.state = 4 -- left
	elseif (self.input.right and (not self.input.left)) then 
		self.state = 2 -- right
	else
		self.state = 0 -- standing
	end

	if math.abs(self.yVel) < 100 then else
		self.state = 3
	end
end

function Player:updateAnimation(dt)
	
	self.animationTimer = self.animationTimer + dt

--[[
	if self.animationTimer > self.animationSpeed then
		self.animationTimer = 0
		self.animationCounter = self.animationCounter + 1
	end
	]]
end

function Player:setLeftCollision(v)
	self.fancyCollisions.left = v
end

function Player:setRightCollision(v)
	self.fancyCollisions.right = v
end

function Player:setTopCollision(v)
	self.fancyCollisions.top = v
end

function Player:setBottomCollision(v)
	self.fancyCollisions.bottom = v
end

function Player:update(dt)
	self:updateMovement(dt)
	--self:updateCollision()
	self:move(dt)
	self:updateState()
	self:updateAnimation(dt)
	self:setBottomCollision(false)
	self:setTopCollision(false)
end

function Player:draw()
--	self:drawCollision()
	--self:drawDebug()
	--[[
	local sy = 1 + math.abs(math.sin(self.animationTimer)/10)
	local sx = 1 + math.abs(math.cos(self.animationTimer)/10)
	if self.fancyCollisions.bottom then sx = sx + 0.1 end
	if self.fancyCollisions.bottom then sy = sy - 0.15 end
	if self.fancyCollisions.right then sx = sx - 0.15 end
	if self.fancyCollisions.right then sy = sy + 0.1 end
]]
	lg.setColor(179,179,179,255)
	lg.setLineStyle("smooth")
	lg.circle("fill",self.x,self.y,self.width/2+5)
	lg.setColor(255,255,255,255)
	--lg.print(self.r,self.x+20,self.y+20)
	if self.playerNum == 1 then
		lg.draw(Player.PLAYERONE,self.x,self.y,self.r,sx,sy,24,24)
	else
		lg.draw(Player.PLAYERTWO,self.x,self.y,self.r,sx,sy,24,24)
	end
	--lg.rectangle("line",self.x-38/2,self.y-38/2,38,38)
end

function Player:keypressed(key)
	local function op_xor(a, b)
		return ((a or b) and (not (a and b)))
	end

	self.input.x_has_input = false
	self.input.y_has_input = false

	self.input.left = false
	self.input.right = false
	self.input.up = false
	self.input.down = false

	if self.playerNum == 1 then
		self.input.left = love.keyboard.isDown("a")
		self.input.right = love.keyboard.isDown("d")
		self.input.up = love.keyboard.isDown("w")
		self.input.down = love.keyboard.isDown("s")

		if p1joystick == nil then else
			local deadzone = 0.2
	
			self.input.up = self.input.up or p1joystick:isGamepadDown("dpup") or p1joystick:isGamepadDown("a")
			if p1joystick:getGamepadAxis("leftx") < 0.1 + deadzone then
				self.input.left = true
			end
			self.input.left = self.input.left or p1joystick:isGamepadDown("dpleft")
			if p1joystick:getGamepadAxis("leftx") > 0.1 - deadzone then
				self.input.right = true
			end
			
			self.input.right = self.input.right or p1joystick:isGamepadDown("dpright")
			self.input.down = self.input.down or p1joystick:isGamepadDown("dpdown")
		end
	end

	if self.playerNum == 2 then
		self.input.left = love.keyboard.isDown("j")
		self.input.right = love.keyboard.isDown("l")
		self.input.up = love.keyboard.isDown("i")
		self.input.down = love.keyboard.isDown("k")

		if p2joystick == nil then else
			local deadzone = 0.2
	
			self.input.up = self.input.up or p2joystick:isGamepadDown("dpup") or p2joystick:isGamepadDown("a")
			if p2joystick:getGamepadAxis("leftx") < 0.1 + deadzone then
				self.input.left = true
			end
			self.input.left = self.input.left or p2joystick:isGamepadDown("dpleft")
			if p2joystick:getGamepadAxis("leftx") > 0.1 - deadzone then
				self.input.right = true
			end
			
			self.input.right = self.input.right or p2joystick:isGamepadDown("dpright")
			self.input.down = self.input.down or p2joystick:isGamepadDown("dpdown")
		end
	end

	self.input.x_has_input = op_xor(self.input.right, self.input.left)
	self.input.y_has_input = op_xor(self.input.up, self.input.down)
end

return Player

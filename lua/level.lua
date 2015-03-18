
local Level = class('level')

Level.static.Block = require('lua.block')
Level.static.ArtObject = require('lua.artobject')
Level.static.Button = require('lua.button')

Level.static.BLOCKWIDTH = 64
Level.static.BLOCKHEIGHT = 64
Level.static.TWEENTIME = 0.5
Level.static.MAXART = 10

Level.static.POSITIONS = 	{
							[1] = {x = 0, y = 0},
							[2] = {x = 640, y = 0}
							}

Level.static.LEVELS = 	{
						[0] = require 'levels.0',
						[1] = require 'levels.1',
						[2] = require 'levels.2',
						[3] = require 'levels.3',
						[4] = require 'levels.4',
						[5] = require 'levels.5',
						[6] = require 'levels.6',
						[7] = require 'levels.7',
						[8] = require 'levels.8',
						[9] = require 'levels.9',
						[10] = require 'levels.10',
						[11] = require 'levels.11',
						[12] = require 'levels.12',
						[13] = require 'levels.13',
						[14] = require 'levels.14',
						[15] = require 'levels.15',
						[16] = require 'levels.16',
						[17] = require 'levels.17',
						[18] = require 'levels.18',
						[19] = require 'levels.19',
						[20] = require 'levels.20',
						[21] = require 'levels.21',
						[22] = require 'levels.22',
						[23] = require 'levels.23',
						[24] = require 'levels.24',
						[25] = require 'levels.25',
						[50] = require 'levels.50',
						}

function Level:initialize(attributes)
	attributes = attributes or {}

	self.position = attributes.position or 1

	self.n = attributes.n or 1
	
	self.x = Level.POSITIONS[self.position].x
	self.y = Level.POSITIONS[self.position].y
	self.tween = 	{
					x = 0,
					y = 0
					}

	self.scroll = attributes.scroll or 0
	local tweenin = 0
	if self.scroll == 3 then 
		self.tween.y = 610
	elseif self.scroll == 4 then
		self.tween.x = -640
	elseif self.scroll == 1 then
		self.tween.y = -610
	elseif self.scroll == 2 then
		self.tween.x = 640
	else
		self.tween.y = 0
		--tweenin = 1
	end

	self.buttonsPushed = attributes.buttonsPushed or false

	flux.to(self.tween,Level.TWEENTIME+tweenin,{x = 0, y = 0}):ease("quadinout")

	self.grid = {}
	self.art = {}
	self.buttons = {}

	self.settings = {}

	self.finshed = false

	self.width = attributes.width or 10
	self.height = attributes.height or 10

	self.world = bump.newWorld(Level.BLOCKHEIGHT)

	self.playerone = {}
	self.playertwo = {}

	self:createGrid()
end

function Level:createGrid()
	local maxCarves = 48

	for i = 1, self.width do
		self.grid[i] = {}
		for k = 1, self.height do
			self.grid[i][k] = Level.Block:new({offsetX = self.x, offsetY = self.y, x = i, y = k, width = Level.BLOCKWIDTH, height = Level.BLOCKHEIGHT})	
		end
	end

	local chunk = Level.LEVELS[self.n]
	self.settings = chunk.settings
	
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			if chunk[j][i] == 0 then
				self.grid[i][j]:setN(16)
			elseif chunk[j][i] == 2 then -- level transitions
				self.grid[i][j]:setN(16)
			elseif chunk[j][i] == 3 then -- locked door
				self.grid[i][j]:setN(16)
			elseif chunk[j][i] == 4 then -- button
				self.grid[i][j]:setN(16)
				self.buttons[#self.buttons+1] = Level.Button:new({x = i,y =j, pushed = self.buttonsPushed}) -- push the buttons
			
				self.button = {
								isButton = true,
								type = "cross",
								x = i,
								y = j,
								w = 32,
								h = 5
								}

				self.world:add(self.button,self.x+(i-1)*64+32,(j)*64+2,48,10)
			
			elseif chunk[j][i] == 6 then
				self.grid[i][j]:setN(16)				
				local hidden_tile = { 	-- this is a metaphor for women in the tech indutry ok its deep
								x = i,
								y = j,
								w = 64,
								h = 64
								}

				self.world:add(hidden_tile,self.x+(i-1)*64+16,(j-1)*64+16,64,64)
			end
		end
	end
	self:updateGridTilemapping()

	for i = 1, Level.MAXART do
		local temp = true
		while temp do
			local x = math.random(1,self.width)
			local y = math.random(1,self.height)
			local n = self.grid[x][y]:getN()
			if self.position == 2 then
				x = x + 10
			end
			if n == 0 or (n == 14 or n == 10) or (n == 8 or n == 2) then
				local v = math.random(1,4)
				self.art[#self.art+1] = Level.ArtObject:new({x = x,n = v,offsetX = self.x,y = y-2,offsetY = self.y})
				temp = false
			else
				local v = math.random(5,7)
				self.art[#self.art+1] = Level.ArtObject:new({x = x,n = v,offsetX = self.x,y = y-1,offsetY = self.y})
				temp = false
			end
		end
	end

	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			if self.grid[i][j]:getN() == 16 then else
				local ground_tile = {
									x = i,
									y = j,
									w = 64,
									h = 64
									}

				self.world:add(ground_tile,self.x+(i-1)*64+16,(j-1)*64+16,64,64)
			end
		end
	end
end

function Level:addPlayer(n,x,y)
	if n == 1 then
		self.playerone = 	{
							x = x,
							y = y,
							w = 32,
							h = 32
							}
		self.world:add(self.playerone,x,y,38,38)
	else
		self.playertwo = 	{
							x = x,
							y = y,
							w = 32,
							h = 32
							}
		self.world:add(self.playertwo,x,y,38,38)
	end
end

function Level:updatePlayer(n,goalX,goalY)
	local actualX, actualY, cols, len 

	if n == 1 then
		actualX, actualY, cols, len = self.world:move(self.playerone, goalX, goalY)
	else
		actualX, actualY, cols, len = self.world:move(self.playertwo, goalX, goalY)
	end
 	for i=1,len do
 	   if cols[i].other == self.button then
 	   		self.buttonsPushed = true
 	   		for j,k in ipairs(self.buttons) do
 	   			self.buttons[j]:setPushed(true)
 	   		end
 	   end
 	end
	return actualX,actualY
end


function Level:checkGrid(x,y) -- checks if x,y are empty space
	local gx = math.floor(x/16)
	local gy = math.floor(y/16)

	if self.grid[gx][gy]:getN() == 16 then
		return true
	end

	return 0
end

function Level:createCollision(px,py)
	local x = px
	if self.position == 2 then
		x = px - Level.POSITIONS[2].x
	end

	local gx = math.floor(x/Level.BLOCKWIDTH)+1
	local gy = math.floor(py/Level.BLOCKHEIGHT)+1
	
	local leftx = Level.BLOCKWIDTH
	local rightx = (self.width-1)*Level.BLOCKWIDTH
	local lefty = Level.BLOCKHEIGHT
	local righty = (self.height-1)*Level.BLOCKHEIGHT
	
	if (gy <= self.height or gy >= 1) then
		if (gx <= self.width or gx >= 1) then
			for i = gy,self.height-gy do
				if gx >= self.width then break end
				
				if self.grid[gx][i]:getN() == 16 then else
					righty = (i-1) * Level.BLOCKHEIGHT
					break
				end
			end
						
			for i = gx, (self.width-gx) do
				if gy >= self.height then break end

				if self.grid[i][gy]:getN() == 16 then else
					rightx = (i-1) * Level.BLOCKHEIGHT
					break
				end
			end			

			local temp = true
			local index = gy
			while temp do
				--if gy >= self.height then break end
				if self.grid[index][gy]:getN() == 16 then else
					leftx = (index) * Level.BLOCKHEIGHT
				end

				index = index - 1
				if index < 1 then 
					temp = false
				end
			end


			temp = true
			index = gx			
			while temp do
				if gx >= self.width then break end

				if self.grid[gx][index]:getN() == 16 then else
					lefty = (index) * Level.BLOCKHEIGHT
				end

				index = index - 1
				if index < 1 then 
					temp = false
				end
			end
			
			return 	{
				lx = px-leftx,
				rx = rightx-px,
				ly = py-lefty,
				ry = righty-py
				}
		end
	end
end

function Level:check(x, y, w, h, func)
	local x1, y1, x2, y2, i, j
	-- find region coordinates to check in:
	x1 = math.floor(x / self.width)
	y1 = math.floor(y / self.height)
	x2 = math.floor((x + w - Level.justabit) / self.width)
	y2 = math.floor((y + h - Level.justabit) / self.height)
	for j = y1, y2 do for i = x1, x2 do
		local d = self.grid[j] -- find row
		if (d ~= nil) then
			d = d[i] -- find cell
			if d == 1 then
			--if (func(d)) then return true end -- test cell
				return true
			end
		end
	end end
	return false
end

function Level:scrollLevel(d)
	local finish = function()
		self.finished = true
	end

	local temp = 1

	if d == 1 then
		temp = self.settings.up 
		flux.to(self.tween,Level.TWEENTIME,{y = 610}):ease("quadinout"):oncomplete(finish)
	elseif d == 2 then
		temp = self.settings.right
		flux.to(self.tween,Level.TWEENTIME,{x = -640}):ease("quadinout"):oncomplete(finish)
	elseif d == 3 then
		temp = self.settings.down
		flux.to(self.tween,Level.TWEENTIME,{y = -610}):ease("quadinout"):oncomplete(finish)
	elseif d == 4 then
		temp = self.settings.left
		flux.to(self.tween,Level.TWEENTIME,{x = 640}):ease("quadinout"):oncomplete(finish)
	end

	return temp
end

function Level:updateGridTilemapping()
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			local value = 0

			if self.grid[i][j]:getN() == 16 then else
				if j+1 < self.height+1 then
					if self.grid[i][j+1]:getN() == 16 then else
						value = value + 4
					end
				else
					value = value + 4
				end
				if j-1 > 0 then
					if self.grid[i][j-1]:getN() == 16 then else
						value = value + 1
					end
				else
					value = value + 1	
				end
				if i+1 < self.width+1 then 
					if self.grid[i+1][j]:getN() == 16 then else
						value = value + 2
					end
				else
					value = value + 2
				end
				if i-1 > 0 then
					if self.grid[i-1][j]:getN() == 16 then else
						value = value + 8
					end
				else
					value = value + 8
				end

				self.grid[i][j]:setN(value)
			end
		end
	end
end

function Level:getFinished()
	return self.finished
end

function Level:drawGrid()
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			self.grid[i][j]:draw()
		end
	end
end









---

function Level:update(dt,x,y)
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			self.grid[i][j]:update(dt)
		end
	end
	for i,v in ipairs(self.art) do
		self.art[i]:update(dt)
	end
	for i,v in ipairs(self.buttons) do
		self.buttons[i]:update(dt,x,y)
	end
end

function Level:draw()
	lg.push()
	lg.translate(self.tween.x,self.tween.y)
		for i,v in ipairs(self.buttons) do
			self.buttons[i]:draw(dt)
		end
		self:drawGrid()
		for i,v in ipairs(self.art) do
			self.art[i]:draw()
		end
	lg.pop()
	lg.print(self.n,self.x+20,self.y)
end

return Level

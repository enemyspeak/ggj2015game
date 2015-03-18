
local Background = class('Background')

Background.static.Block = require('lua.block')
Background.static.ArtObject = require('lua.artobject')

Background.static.BLOCKWIDTH = 64
Background.static.BLOCKHEIGHT = 64
Background.static.TWEENTIME = 0.5
Background.static.MAXART = 5

Background.static.POSITIONS = 	{
							[1] = {x = 0, y = 0},
							[2] = {x = 640, y = 0}
							}

function Background:initialize(attributes)
	attributes = attributes or {}

	self.position = attributes.position or 1

	self.x = Background.POSITIONS[self.position].x
	self.y = Background.POSITIONS[self.position].y
	self.tween = 	{
					x = 0,
					y = 0
					}

	self.parallax = {
					x = 0,
					y = 0
					}

	self.scroll = attributes.scroll or 0

	self.finished = false

	if self.scroll == 3 then 
		self.tween.y = 610
	elseif self.scroll == 4 then
		self.tween.x = -640
	elseif self.scroll == 1 then
		self.tween.y = -610
	elseif self.scroll == 2 then
		self.tween.x = 640
	end

	flux.to(self.tween,Background.TWEENTIME,{x = 0, y = 0}):ease("quadinout")

	self.grid = {}
	self.art = {}

	self.finshed = false

	self.width = attributes.width or 10
	self.height = attributes.height or 10

	self:createGrid()
end

function Background:createGrid()
	local maxCarves = 7

	for i = 1, self.width do
		self.grid[i] = {}
		for k = 1, self.height do
			self.grid[i][k] = Background.Block:new({background = true, offsetX = self.x, offsetY = self.y, x = i, n =1, y = k, width = Background.BLOCKWIDTH, height = Background.BLOCKHEIGHT})	
		end
	end

	for i=1, maxCarves do
		local w = math.random(2,6)
		local h = math.random(2,6)
		local x = math.random(1,self.width)
		local y = math.random(1,self.height)

		for i = x, x+w do
			if i > self.width or i < 1 then break end
			for k = y, y+h do
				if k > self.height or k < 1 then break end
				self.grid[i][k]:setN(16)
			end
		end
	end

	local maxPlatforms = 4
	for i=1, maxPlatforms do
		local w = math.random(3,6)
		local x = math.random(1,self.width)
		local y = math.random(1,self.height)

		for i = x, x+w do
			if i > self.width or i < 1 then break end
			self.grid[i][y]:setN(1)
		end
	end

	self:updateGridTilemapping()
end

function Background:updateGridTilemapping()
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

function Background:getFinished()
	return self.finished
end

function Background:setPlayerPosition(x,y)
	self.parallax.x = 0+x*0.025
	--self.parallax.y = 0+y*0.025
end

function Background:scrollLevel(d)
	local finish = function()
		self.finished = true
	end
	if d == 1 then
		flux.to(self.tween,Background.TWEENTIME,{y = 610}):ease("quadinout"):oncomplete(finish)
	elseif d == 2 then
		flux.to(self.tween,Background.TWEENTIME,{x = -640}):ease("quadinout"):oncomplete(finish)
	elseif d == 3 then
		flux.to(self.tween,Background.TWEENTIME,{y = -610}):ease("quadinout"):oncomplete(finish)
	elseif d == 4 then
		flux.to(self.tween,Background.TWEENTIME,{x = 640}):ease("quadinout"):oncomplete(finish)
	end
end

function Background:drawGrid()
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			self.grid[i][j]:draw()
		end
	end
end









---

function Background:update(dt)
	for i,v in ipairs(self.grid) do
		for j,k in ipairs(self.grid[i]) do
			self.grid[i][j]:update(dt)
		end
	end
	for i,v in ipairs(self.art) do
		self.art[i]:update(dt)
	end
end

function Background:draw()
	lg.push()
	lg.translate(self.tween.x+self.parallax.x,self.tween.y+self.parallax.y)

		self:drawGrid()
		for i,v in ipairs(self.art) do
			self.art[i]:draw()
		end
	lg.pop()
end

return Background

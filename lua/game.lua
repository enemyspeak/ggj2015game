
local Game = Gamestate:addState('Game')

local Player =  require 'lua.player'
local Level = require 'lua.level'
local Cloud = require 'lua.clouds'
local Particle = require 'lua.particles'
local Background = require 'lua.background'

local moon = lg.newImage('res/moon.png')
local stars = lg.newImage('res/stars.png')
local glowcloud1 = lg.newImage('res/glowcloud1.png')
local glowcloud2 = lg.newImage('res/glowcloud2.png')

local MAXCLOUDS = 10
local MAXPARTICLES = 25

local starsX,starsY,starsR
local moonX,moonY,moonR

local canvas1 = lg.newCanvas(640,720)
local canvas2 = lg.newCanvas(640,720)

local score
local levels = {}
local levelNext = {}
local players = {}
local input = {}
local clouds = {}
local particles = {}
local backgrounds = {}

local particlesBuffer = 0
local cloudsBuffer = 0

local isSplit

local function updatePlayers(dt)
	for i,v in ipairs(players) do
		if players[i]:getTransitioning() then else
			players[i]:update(dt)

			local w = players[i]:getWidth()
			local h = players[i]:getHeight()
			local px,py = players[i]:getPosition()

			local leftx,rightx
			local temp = false

			if i == 1 then
				leftx = 10
				rightx = 630
			elseif i == 2 then
				leftx = 650
				rightx = 1270
			end

			if px < leftx then 
				scrollLevel(i,4)
				players[i]:setTransitioning(true,4)
				temp = true
			elseif px > rightx then 
				scrollLevel(i,2)
				players[i]:setTransitioning(true,2)
				temp = true
			end
			if py < 10 then 
				scrollLevel(i,1)
				players[i]:setTransitioning(true,1)
				temp = true
			elseif py > 610 then
				scrollLevel(i,3)
				temp = true
				players[i]:setTransitioning(true,3)
			end

			if temp then 
			else
				local x,y = levels[i]:updatePlayer(i,px,py)
			
				if py > y then
					players[i]:setBottomCollision(true)
				end
				if py < y then
					players[i]:setTopCollision(true)
				end
				players[i]:setPosition(x,y)
			end
		end
		--if py > y then else
		--	players[i]:setTopCollision(true)
		--end
		--if px == x then else
		--	players[i]:setRightCollision(true)
		--end
--[[	-- fuck you
		local n = 1
		if px > lg.getWidth()/2 then
			n = 2
		end

		local x = px+15
		local y = py-15	
		if x < 1 then x = 1 end
		if y < 1 then y = 1 end
		local collision = levels[n]:createCollision(x,y)
		players[i]:setCollision(1,collision)
		
		local x = px-15
		local y = py-14
		if x < 1 then x = 1 end
		if y < 1 then y = 1 end

		local collision = levels[n]:createCollision(x,y)
		players[i]:setCollision(2,collision)
]]
	end
end

local function drawDebug( ... )
	--fuck you fuck you fuck
	for i,v in ipairs(players) do
		lg.setColor(255,255,255)
	local px,py = players[i]:getPosition()
	local gx = math.floor(px/Level.BLOCKWIDTH)+1
	local gy = math.floor(py/Level.BLOCKHEIGHT)+1
	lg.print(gx..", "..gy,30,100+30*i)
	end
end

local function drawPlayers()
	for i,v in ipairs(players) do
		if i == 1 then
			lg.setCanvas(canvas1)
		else
			lg.push()
			lg.setCanvas(canvas2)
			lg.translate(-640,0)
		end

		players[i]:draw()
		
		if i == 2 then 
			lg.pop()
		end
		players[i]:keypressed(key)
	end
end

local function drawMouse()
	lg.setColor(255,255,255,128)
	local mx,my = love.mouse.getPosition()
	lg.print(mx..", "..my,10,200)
	lg.print(math.floor(mx/16)..", "..math.floor(my/16),10,100)
	lg.rectangle("fill",math.floor(mx/16)*16,math.floor(my/16)*16,16,16)
end

local function updateLevels(dt)
	for i,v in ipairs(levels) do
		local x,y = players[i]:getPosition()
		levels[i]:update(dt,x,y)
		if levels[i]:getFinished() then
			levels[i] = levelNext[i]
			players[i]:setTransitioning(false)
			levels[i]:addPlayer(i,x,y)
			break
		end
	end
end

local function updateBackground(dt)
	for i,v in ipairs(backgrounds) do
		backgrounds[i]:update(dt)
		local x,y
		if backgrounds[i].position == 1 then
			x,y = players[1]:getPosition()
		else
			x,y = players[2]:getPosition()
		end
		backgrounds[i]:setPlayerPosition(x,y)
		if backgrounds[i]:getFinished() == true then
			table.remove(backgrounds,i)
			break
		end
	end
	for i,v in ipairs(clouds) do
		clouds[i]:update(dt)
		if clouds[i]:getKill() == true then
			table.remove(clouds,i)
			break
		end
	end

	local interval = 8
	local rate = 1

	if cloudsBuffer > interval then
		cloudsBuffer = 0
		local CENTERY = lg.getHeight()/2
		local CENTERX = lg.getWidth()/2
		local y = math.random(0,lg.getHeight())
		local x = -200
		clouds[#clouds + 1] = Cloud:new({x = x, y = y}) 
	end
	
	cloudsBuffer = cloudsBuffer + rate*dt
end

local function drawBackground( ... )
	lg.setColor(39,69,95)
	lg.rectangle("fill",0,0,lg.getWidth(),lg.getHeight())
	
	lg.setColor(255,255,255)
	lg.draw(stars,starsX,starsY,starsY,1,1,256,256)
	lg.draw(moon,moonX,moonY,moonR,1,1,256,256)

	lg.draw(glowcloud1,glowcloudX,glowcloudY,0,1,1,256,256)
	lg.draw(glowcloud2,glowcloudX2,glowcloudY2,0,1,1,256,256)

	for i,v in ipairs(clouds) do
		clouds[i]:draw()
	end

	for i,v in ipairs(backgrounds) do
		lg.push()
		if backgrounds[i].position == 1 then
			lg.setCanvas(canvas1)
		end
		if backgrounds[i].position == 2 then
			lg.translate(-640,0)
			lg.setCanvas(canvas2)
		end
		
		backgrounds[i]:draw()
		lg.pop()
		lg.setCanvas()
	end
end

local function drawLevels()
	local n1 = false
	local n2 = false

	if levelNext[1] ~= nil then
		n1 = true
	end
	if levelNext[2] ~= nil then
		n2 = true
	end


	lg.setCanvas(canvas1)
		levels[1]:draw()
		if n1 then
			levelNext[1]:draw()
		end
	lg.setCanvas(canvas2)
	lg.push()
	lg.translate(-640,0)
		levels[2]:draw()
		if n2 then
			levelNext[2]:draw()
		end
	lg.pop()
	lg.setCanvas()
end

local function drawParticles()
	for i,v in ipairs(particles) do
		particles[i]:draw()
	end
end

local function updateParticles(dt)
	for i,v in ipairs(particles) do
		particles[i]:update(dt)
		if particles[i]:getKill() == true then
			table.remove(particles,i)
--			i = i - 1 -- probably not needed, I don't know
		end
	end

	local interval = 0.75
	local rate = 1

	if particlesBuffer > interval then
		particlesBuffer = 0
		local CENTERY = lg.getHeight()/2
		local CENTERX = lg.getWidth()/2
		local y = -CENTERY - Particle.SAFEZONE
		local x = math.random(0,lg.getWidth())
		particles[#particles + 1] = Particle:new({x = x, y = y}) 
	end
	
	particlesBuffer = particlesBuffer + rate*dt
end

function scrollLevel(i,dir)
	local r = levels[i]:scrollLevel(dir)
	for j,k in ipairs(backgrounds) do
		if backgrounds[j].position == i then
			backgrounds[j]:scrollLevel(dir)		
		end
	end

	levelNext[i] = Level:new({n =r, width = 10, height = 10,position = i,scroll = dir})
	backgrounds[#backgrounds+1] = Background:new({position = i,scroll = dir})
end

local function debugCollision()
	local mx,my = love.mouse.getPosition()
	players[2]:setPosition(mx,my)
end

local function drawHUD( ... )
	lg.setColor(0,0,0)
	if isSplit then
		lg.rectangle("fill",lg.getWidth()/2-(10/2),0,10,720)	
	end
	
	lg.rectangle("fill",0,640,lg.getWidth(),720-640)
	lg.setColor(255,255,255)
end









--------------

function Game:enteredState()
	local numPlayers = 2
	score = 0
	isSplit = true
	levels = {}
	players = {}
	clouds = {}
	backgrounds = {}
	particles = {}
	particlesBuffer = 0
	cloudsBuffer = 0

	starsX = math.random(1,lg.getWidth())
	starsY = math.random(1,lg.getHeight())
	starsR = math.rad(math.random(0,360))

	moonX = math.random(1,lg.getWidth())
	moonY = math.random(1,lg.getHeight()/3)
	moonR = math.rad(math.random(0,360))

	glowcloudX = math.random(100,lg.getWidth()-100)
	glowcloudY = math.random(100,lg.getHeight()-100)
	glowcloudX2 = math.random(100,lg.getWidth()-100)
	glowcloudY2 = math.random(100,lg.getHeight()-100)

	for i = 1,MAXCLOUDS do
		clouds[#clouds+1] = Cloud:new({x=math.random(0,lg.getWidth()),y= math.random(0,lg.getHeight())})
	end

	for i = 1,MAXPARTICLES do
		particles[#particles+1] = Particle:new({x=math.random(0,lg.getWidth()),y= math.random(0,lg.getHeight())})
	end

	local px = 100
	local py = 300			
	for i = 1, numPlayers do
		players[i] = Player:new({position = i, x = px,y = py,playerNum = i, room = 1})
		local n = 13
		if i == 2 then
			n = 1
		end
		levels[i] = Level:new({position = i,n = n, width = 10, height = 10, scroll = 5})
		local x, y = players[i]:getPosition()
		levels[i]:addPlayer(i,x,y)
		backgrounds[#backgrounds+1] = Background:new({position = i})
	end
end

function Game:exitedState()
    --hs:add("a", gameScore)
end

function Game:update(dt)
	--debugCollision()
	updateBackground(dt)
	updateParticles(dt)
	updatePlayers(dt)
	updateLevels(dt)
end

function Game:draw()
	canvas1:clear()
	canvas2:clear()

	drawBackground()

	drawParticles()
	drawPlayers()

	drawLevels()

		lg.draw(canvas1,0,0)
		lg.draw(canvas2,640,0)

	drawHUD()

	--drawMouse()
	--drawDebug()
end

function Game:keypressed(key, unicode)
	if key == 'n' then 
		Game:enteredState()
	end
--[[
	if key == 'w' then
		scrollLevel(1)
	elseif key == 'a' then
		scrollLevel(4)
	elseif key == 'd' then
		scrollLevel(2)
	elseif key == 's' then
		scrollLevel(3)
	end
	--]]
end

function Game:joystickpressed(joystick, button)

end

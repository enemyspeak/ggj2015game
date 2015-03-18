local Editor = Gamestate:addState('Editor')

local Circle = require 'lua.circles'

require 'lib.Tserial'

local WIDTH = lg.getWidth()
local HEIGHT = lg.getHeight()
local CENTERX = WIDTH/2
local CENTERY = HEIGHT/2

local debug_text = {}

local function debug(input, indent)
	if (input == nil) then
		input = "--------"
	end

	if (indent == nil) then
		indent = 0
	end

	local temp_string = tostring(input)

	for i = 1, indent, 1 do
		temp_string = "   " .. temp_string
	end

	table.insert(debug_text, temp_string);
end









--------

function Editor:enteredState()
	WIDTH = lg.getWidth()
	HEIGHT = lg.getHeight()
	CENTERX = WIDTH/2
	CENTERY = HEIGHT/2	

	local l = {
	[1] = {0,0,0,0,0,0,0,0,0,0},
	[2] = {0,0,0,0,0,0,0,0,0,0},
	[3] = {0,0,0,0,0,0,0,0,0,0},
	[4] = {0,0,0,0,0,1,0,0,0,0},
	[5] = {0,0,1,1,1,1,0,0,0,0},
	[6] = {0,0,0,0,0,0,0,0,0,0},
	[7] = {0,0,0,0,0,1,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0,0,0},
	[9] = {0,0,0,0,0,0,0,0,0,0},
	[10] = {0,0,0,0,0,0,0,0,0,0}
	}

	level = Tserial.pack(l, true, true)
	love.filesystem.write("testLevel.lua",level,all)
end

function Editor:update(dt)
end

function Editor:draw()
end

function Editor:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	else
	end
end

function Editor:keyreleased(key)
end

function Editor:mousepressed(x, y, button)
end

function Editor:mousereleased(x, y, button)
end

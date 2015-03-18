local Intro = Gamestate:addState('Intro')

local Circle = require 'lua.circles'

local WIDTH = lg.getWidth()
local HEIGHT = lg.getHeight()
local CENTERX = WIDTH/2
local CENTERY = HEIGHT/2

local bgcolor = 	{
					r = 252,
					g = 227,
					b = 185
					}
local Metaball = lg.newShader [[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
		{
		vec4 pixel = Texel(texture, texture_coords);
		pixel.r = floor(pixel.r+0.5);
		pixel.g = floor(pixel.g+0.25);
		pixel.b = floor(pixel.b+0.25);
		return vec4(pixel.r, pixel.g, pixel.b, 1.0);
		}
	]]
local Canv = lg.newCanvas(1280,720)

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

function Intro:enteredState()
	WIDTH = lg.getWidth()
	HEIGHT = lg.getHeight()
	CENTERX = WIDTH/2
	CENTERY = HEIGHT/2	

	circle = Circle:new({x=0,y=0})
end

function Intro:update(dt)
	circle:update(dt)
end

function Intro:draw()
	love.graphics.push()
	love.graphics.translate(CENTERX,CENTERY)
		lg.setColor(bgcolor.r,bgcolor.g,bgcolor.b,255)
		lg.rectangle("fill",-CENTERX,-CENTERY,WIDTH,HEIGHT)

		Canv:clear(0,0,0,0)
		lg.setCanvas(Canv)
			lg.setBlendMode("additive")
			circle:draw()
		lg.setCanvas()
		lg.setBlendMode("alpha")
		--lg.setShader(Metaball)
			lg.setColor(255,255,255,255)
			lg.draw(Canv,-CENTERX,-CENTERY)
		lg.setShader()

	love.graphics.pop()
end

function Intro:keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	else
	end
end

function Intro:keyreleased(key)
end

function Intro:mousepressed(x, y, button)
end

function Intro:mousereleased(x, y, button)
end

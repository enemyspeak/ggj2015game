local Button = class('Button')

Button.static.CENTERX = love.graphics.getWidth()/2
Button.static.CENTERY = love.graphics.getHeight()/2

Button.static.BAE = lg.newImage("res/buttonrim.png")
Button.static.PUSH = lg.newImage("res/buttonpush.png")

function Button:initialize(attributes)
	self.offsetX = attributes.offsetX or 0
	self.offsetY = attributes.offsetY or 0

	self.x = attributes.x or 0
	self.y = attributes.y or 0

	self.gridX = attributes.gx or 0
	self.gridY = attributes.gy or 0

	self.width = attributes.width or 64
	self.height = attributes.height or 64

	self.n = attributes.n or false
	self.pushed = false
	self.pushAnimate = 16
end

function Button:getPushed()
	return self.pushed
end

function Button:getPosition()
	return self.x,self.y
end

function Button:setPushed(value)
	if self.pushed then else
		flux.to(self,0.15,{pushAnimate = 8}):ease("quadin")
	end

	self.pushed = true
end

function Button:update(dt,x,y)

	--self:setN(true)
end

function Button:draw()
	lg.setColor(255,255,255)
	local offset = 5
	lg.draw(Button.PUSH,self.x*64-32,self.y*64-offset,0,1,1,32,self.pushAnimate)

	lg.draw(Button.BAE,self.x*64-32,self.y*64-offset,0,1,1,32,16)
end

return Button

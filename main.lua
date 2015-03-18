
function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end
    if love.event then love.event.pump() end
    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0

    while true do
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then 
                    if not love.quit or not love.quit() then
                        if love.audio then love.audio.stop() end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end
        if love.update then love.update(dt) end 
        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end
        if love.timer then love.timer.sleep(0.001) end
    end
end

function love.load()
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))   
    for i=1, 4 do math.random() end

    lg = love.graphics
    HASFOCUS = true

    love.graphics.setDefaultFilter("linear","linear")
    love.graphics.setPointStyle("smooth")
    love.graphics.setLineStyle("smooth")
    love.graphics.setPointSize(1)
    love.graphics.setLineWidth(1)
    love.mouse.setVisible(true)

					require 'lib.middleclass'
    Stateful =      require 'lib.stateful.stateful'
    flux =          require 'lib.flux'
    lume =          require "lib.lume"
    bump =          require 'lib.bump'
                    require 'lib.ellipse'
    Postshader =    require 'lib.postshader'
    postshader = Postshader()

    require 'lua.gamestate'
    require 'lua.game'
    require 'lua.intro'
    --require 'lua.editor'

    gamestate = Gamestate:new()
    gamestate:gotoState("Game")
end

function love.update(dt)
    local fps = love.timer.getFPS()
    love.window.setTitle(fps)

    if HASFOCUS then
        flux.update(dt)
        gamestate:update(dt)
    end
end

function love.joystickadded(joystick)
    if p1joystick == nil then
        p1joystick = joystick
    else
        p2joystick = joystick
    end
end

function love.draw()
    gamestate:draw()
end

function love.focus(f)
    HASFOCUS = f
end

function love.resize( w, h )
    gamestate:resize(w,h)
end

function love.joystickadded(joystick)
    p1joystick = joystick
end

function love.joystickpressed(joystick, button)
    gamestate:joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
    gamestate:joystickreleased(joystick, button)
end

function love.keypressed(key, unicode)
    if key == "3" then
        local s = love.graphics.newScreenshot()
        s:encode("game8"..os.time()..".png")
    elseif key == 'escape' then
		love.event.push('quit')
    end

    gamestate:keypressed(key, unicode)
end

function love.keyreleased(key)
    gamestate:keyreleased(key)
end

function love.mousepressed(x, y, button)
    gamestate:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    gamestate:mousereleased(x, y, button)
end

function love.quit()
    gamestate:quit()
end

--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

require("Dependencies")

local VIRTUAL_WIDTH <const> = 350
local VIRTUAL_HEIGHT <const> = 512

local level <const> = Level:new {
    width=VIRTUAL_WIDTH,
    height=VIRTUAL_HEIGHT,
}

function robin.start()
    robin.window.setTitle("RobinBird")
    robin.window.setSize(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function robin.update(dt)
    level:update(dt)
end

function robin.onKeyDown(e)
    if e:keycode() == "return" or e:keycode() == "space" then
        level:onInteraction()
    end
end

function robin.onMouseDown(e)
    if e:button() == "left" then
        level:onInteraction()
    end
end

function robin.onTouchDown(e)
    level:onInteraction()
end

function robin.draw()
    robin.graphics.clear(255, 255, 255)
    level:draw()
end

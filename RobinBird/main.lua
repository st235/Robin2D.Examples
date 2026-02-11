--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

require("Dependencies")

local VIRTUAL_WIDTH <const> = 350
local VIRTUAL_HEIGHT <const> = 512

local DESKTOP_WINDOW_WIDTH <const> = 700
local DESKTOP_WINDOW_HEIGHT <const> = 1024

local display <const> = VirtualDisplay:new{
    virtualWidth=VIRTUAL_WIDTH,
    virtualHeight=VIRTUAL_HEIGHT,
    windowWidth=VIRTUAL_WIDTH,
    windowHeight=VIRTUAL_HEIGHT,
}

local level <const> = Level:new {
    width=VIRTUAL_WIDTH,
    height=VIRTUAL_HEIGHT,
}

function robin.start()
    robin.window.setTitle("RobinBird")
    robin.window.setResizable(true)

    if robin.os == "macos" then
        robin.window.setSize(DESKTOP_WINDOW_WIDTH, DESKTOP_WINDOW_HEIGHT)
    end

    -- robin.onWindowResized is not triggers upon calling
    -- robin.window.setSize or when robin is initialised via
    -- robin.start lifecycle function.
    -- We still need to adjust virtual screen size, therefore
    -- we call onWindowResized with the current window dimensions.
    local w, h <const> = robin.window.getSize()
    robin.onWindowResized(w, h)
end

function robin.onWindowResized(w, h)
    display:onWindowResized(w, h)
end

function robin.update(dt)
    level:update(dt)
end

function robin.onKeyDown(e)
    local keycode <const> = e:keycode()

    if keycode == "return" or keycode == "space" then
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
    display:draw(function()
        robin.graphics.clear(0, 0, 0)
        level:draw()
    end)
end

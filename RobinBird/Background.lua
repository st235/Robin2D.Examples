--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

local _SCROLL_SPEED <const> = -24

Background = {}
Background.__index = Background

function Background:new(params)
    local o = {}
    setmetatable(o, self)

    o._position = 0
    o._width = params.width
    o._height = params.height
    o._textureScale = math.max(1, o._height / gTextures["background"]:height())

    o._scrollDistance = gTextures["background"]:width() * o._textureScale

    return o
end

function Background:update(dt)
    self._position = self._position + _SCROLL_SPEED * dt
    if self._position < -self._scrollDistance then
        self._position = 0
    end
end

function Background:draw()
    robin.graphics.draw(gTextures["background"], math.floor(self._position), 0, 0, self._textureScale, self._textureScale)
    robin.graphics.draw(gTextures["background"], math.floor(self._position + self._scrollDistance), 0, 0, self._textureScale, self._textureScale)
end

return Background

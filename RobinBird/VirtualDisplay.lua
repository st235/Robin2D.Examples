--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

VirtualDisplay = {}
VirtualDisplay.__index = VirtualDisplay

function VirtualDisplay:new(params)
    local o = {}
    setmetatable(o, self)

    assert(params.virtualWidth > 0 and params.virtualHeight > 0)

    o._virtualWidth = params.virtualWidth
    o._virtualHeight = params.virtualHeight

    o._texture = robin.graphics.newTexture(o._virtualWidth, o._virtualHeight)

    assert(params.windowWidth > 0 and params.windowHeight > 0)

    o._windowWidth = params.windowWidth
    o._windowHeight = params.windowHeight

    o:_getSizeThatFits()

    return o
end

function VirtualDisplay:_getSizeThatFits()
    self._scale = math.min(self._windowWidth / self._virtualWidth, self._windowHeight / self._virtualHeight)
end

function VirtualDisplay:onWindowResized(newWidth, newHeight)
    self._windowWidth = newWidth
    self._windowHeight = newHeight
    self:_getSizeThatFits()
end

function VirtualDisplay:draw(onVirtualDisplayDraw)
    local newWidth <const> = self._virtualWidth * self._scale
    local newHeight <const> = self._virtualHeight * self._scale

    robin.graphics.drawInto(self._texture, onVirtualDisplayDraw)

    robin.graphics.clear(0, 0, 0)
    robin.graphics.draw(self._texture,
        math.floor((self._windowWidth - newWidth) / 2),
        math.floor((self._windowHeight - newHeight) / 2),
        0, self._scale, self._scale)
end

return VirtualDisplay

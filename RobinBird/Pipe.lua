--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

local _TEXTURE_COLLIDER_VPADDING = 2
local _TEXTURE_COLLIDER_HPADDING = 4

Pipe = {}
Pipe.__index = Pipe

function Pipe:new(params)
    local o = {}
    setmetatable(o, self)

    local referenceWidth = gTextures["pipe-top"]:width()

    o._width = math.max(params.width, referenceWidth)
    o._height = math.max(params.height, gTextures["pipe-top"]:height())
    o._scale = o._width / referenceWidth

    o._isFlipped = params.isFlipped or false
    o._x = params.x or 0
    o._y = params.y or 0

    o._collider = Collider:new()
    local horizontalPadding <const> = _TEXTURE_COLLIDER_HPADDING * o._scale
    local verticalPadding <const> = _TEXTURE_COLLIDER_VPADDING * o._scale
    o._collider:resize(o._width - horizontalPadding * 2, o._height - verticalPadding)
    o:_updateCollider()

    return o
end

function Pipe:_updateCollider()
    local horizontalPadding <const> = _TEXTURE_COLLIDER_HPADDING * self._scale
    local verticalPadding <const> = _TEXTURE_COLLIDER_VPADDING * self._scale

    local verticalOffset = verticalPadding
    if self._isFlipped then
        verticalOffset = 0
    end

    -- Includes both leading and trailing paddings, and a top padding.
    self._collider:reposition(self._x + horizontalPadding, self._y + verticalOffset)
end

function Pipe:collides(collider)
    return self._collider:collides(collider)
end

function Pipe:toTheLeftOf(collider)
    return self._collider:toTheLeftOf(collider)
end

function Pipe:_getSegmentRotation()
    if self._isFlipped then
        return 180
    end

    return 0
end

function Pipe:translate(dx, dy)
    self._x = self._x + dx
    self._y = self._y + dy
    self:_updateCollider()
end

function Pipe:setPosition(x, y)
    self._x = x
    self._y = y
    self:_updateCollider()
end

function Pipe:draw()
    local topSegmentHeight <const> = gTextures["pipe-top"]:height() * self._scale
    -- Rotated pipe segment posses exactly the same dimensions.
    local pipeMiddleHeight <const> = gTextures["pipe-middle"]:height() * self._scale

    local startY = self._y
    if self._isFlipped then
        startY = self._y + self._height - topSegmentHeight
    end

    robin.graphics.draw(gTextures["pipe-top"], math.floor(self._x), math.floor(startY),
        self:_getSegmentRotation(), self._scale, self._scale)

    local currentY = startY
    if self._isFlipped then
        -- Upside-down Pipe.
        while currentY >= 0 do
            currentY = currentY - pipeMiddleHeight
            robin.graphics.draw(gTextures["pipe-middle-rotated"],
                math.floor(self._x), math.floor(currentY),
                0, self._scale, self._scale)
        end
    else
        -- Regular Pipe.
        currentY = currentY + topSegmentHeight
        while currentY < self._y + self._height do
            robin.graphics.draw(gTextures["pipe-middle"],
                math.floor(self._x), math.floor(currentY),
                0, self._scale, self._scale)
            currentY = currentY + pipeMiddleHeight
        end
    end

    self._collider:draw()
end

return Pipe

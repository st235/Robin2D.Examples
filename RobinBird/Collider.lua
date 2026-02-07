--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

-- Axis Alligned Bounding Boxes collider.
Collider = {}
Collider.__index = Collider

local _DEBUG_DISPLAY_COLLIDERS <const> = false

function Collider:new()
    local o = {}
    setmetatable(o, self)

    o._x = 0
    o._y = 0
    o._width = 0
    o._height = 0
    o._texture = nil

    return o
end

function Collider:reposition(x, y)
    self._x = x
    self._y = y
end

function Collider:resize(width, height)
    assert(width > 0 and height > 0)

    self._width = width
    self._height = height

    if _DEBUG_DISPLAY_COLLIDERS then
        self._texture = robin.graphics.newRect(math.floor(self._width), math.floor(self._height),
            { math.random(0, 255), math.random(0, 255), math.random(0, 255) })
    end
end

--[[
    Collision example:
        s1            f1
                s2            f2

    No collision example:
        s1            f1
                          s2            f2
]]
function Collider:collides(that)
    assert(self._width > 0 and self._height > 0 and
        that._width > 0 and that._height > 0)

    local horizontalCollision <const> = math.max(self._x, that._x) <
        math.min(self._x + self._width, that._x + that._width)
    local verticalCollision <const> = math.max(self._y, that._y) <
        math.min(self._y + self._height, that._y + that._height)
    return horizontalCollision and verticalCollision
end

function Collider:toTheLeftOf(that)
    assert(self._width > 0 and self._height > 0 and
        that._width > 0 and that._height > 0)
    return (self._x + self._width) <= that._x
end

function Collider:draw()
    -- Depends on _DEBUG_DISPLAY_COLLIDERS property.
    if self._texture == nil then
        return
    end

    robin.graphics.draw(self._texture, math.floor(self._x), math.floor(self._y))
end

return Collider

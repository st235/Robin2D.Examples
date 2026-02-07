--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

PipePair = {}
PipePair.__index = PipePair

function PipePair:new(params)
    local o = {}
    setmetatable(o, self)

    o._width = params.width
    o._height = params.height
    o._pipes = {}

    return o
end

function PipePair:setGapPosition(centerX, centerY, height)
    assert(self._height > height)

    local topPipeHeight <const> = (centerY - height / 2)
    local bottomPipeHeight <const> = self._height - (centerY + height / 2)

    self._pipes = {
        -- Top Pipe.
        Pipe:new{
            width=self._width,
            height=topPipeHeight,
            isFlipped=true,
            x=centerX - self._width / 2,
            y=0,
        },
        -- Bottom Pipe.
        Pipe:new{
            width=self._width,
            height=bottomPipeHeight,
            isFlipped=false,
            x=centerX - self._width / 2,
            y=centerY + height / 2,
        },
    }
end

function PipePair:scroll(dx)
    for _, pipe in pairs(self._pipes) do
        pipe:translate(dx, 0)
    end
end

function PipePair:collides(collider)
    for _, pipe in pairs(self._pipes) do
        if pipe:collides(collider) then
            return true
        end
    end
    return false
end

function PipePair:toTheLeftOf(collider)
    for _, pipe in pairs(self._pipes) do
        if not pipe:toTheLeftOf(collider) then
            return false
        end
    end
    return true
end

function PipePair:draw()
    for _, pipe in pairs(self._pipes) do
        pipe:draw()
    end
end

return PipePair

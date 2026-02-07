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
    o._gapHeight = params.gapHeight

    assert(o._height > o._gapHeight)

    local pipeHeight <const> = math.floor((o._height - o._gapHeight) / 2)
    o._pipes = {
        -- Top Pipe.
        Pipe:new{
            width=o._width,
            height=pipeHeight,
            isFlipped=true,
        },
        -- Bottom Pipe.
        Pipe:new{
            width=o._width,
            height=pipeHeight,
            isFlipped=false,
        },
    }

    return o
end

function PipePair:setCenterPosition(centerX, centerY)
    self._pipes[1]:setPosition(centerX - self._width / 2, centerY - self._height / 2)
    self._pipes[2]:setPosition(centerX - self._width / 2, centerY + self._gapHeight / 2)
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

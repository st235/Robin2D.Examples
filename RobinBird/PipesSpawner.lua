--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

local _DEFAULT_PIPE_WIDTH <const> = 70
local _DEFAULT_PIPES_SPEED <const> = -20
local _DEFAULT_PIPES_ACCELERATION <const> = -2

PipesSpawner = {}
PipesSpawner.__index = PipesSpawner

function PipesSpawner:new(params)
    local o = {}
    setmetatable(o, self)

    o._scrolledSoFar = 0
    o._scrollSpawnThreshold = 0

    o._width = params.width
    o._height = params.height
    o._onPass = params.onPass

    o._pairsToTheLeft = {}
    o._pairsToTheRight = {}
    o._pairsSpeed = _DEFAULT_PIPES_SPEED

    o._collider = Collider:new()
    o._collider:resize(o._width + _DEFAULT_PIPE_WIDTH, o._height)

    return o
end

function PipesSpawner:_getNextSpawnThreshold()
    return math.random(_DEFAULT_PIPE_WIDTH * 3, _DEFAULT_PIPE_WIDTH * 4)
end

function PipesSpawner:_getGapHeight()
    return math.random(80, 200)
end

function PipesSpawner:collides(collider)
    for _, pair in pairs(self._pairsToTheRight) do
        if pair:collides(collider) then
            return true
        end
    end

    if not self._collider:collides(collider) then
        return true
    end

    return false
end

function PipesSpawner:_spawn()
    if self._scrolledSoFar < self._scrollSpawnThreshold then
        return
    end

    self._scrolledSoFar = 0
    self._scrollSpawnThreshold = self:_getNextSpawnThreshold()

    local pair <const> = PipePair:new{
        width=_DEFAULT_PIPE_WIDTH,
        height=self._height,
        gapHeight=self:_getGapHeight(),
    }

    pair:setCenterPosition(self._width + _DEFAULT_PIPE_WIDTH / 2, self._height / 2)

    table.insert(self._pairsToTheRight, pair)
end

function PipesSpawner:update(dt, robinCollider)
    local scrolledDistanced = self._pairsSpeed * dt
    self._scrolledSoFar = self._scrolledSoFar + math.abs(scrolledDistanced)
    self:_spawn()

    local newPairsToTheLeft = {}
    local newPairsToTheRight = {}

    self._pairsSpeed = self._pairsSpeed + _DEFAULT_PIPES_ACCELERATION * dt
    for _, pair in pairs(self._pairsToTheLeft) do
        pair:scroll(scrolledDistanced)

        if pair:collides(self._collider) then
            table.insert(newPairsToTheLeft, pair)
        end
    end

    for _, pair in pairs(self._pairsToTheRight) do
        pair:scroll(scrolledDistanced)

        if pair:toTheLeftOf(robinCollider) then
            table.insert(newPairsToTheLeft, pair)
            self._onPass()
        else
            table.insert(newPairsToTheRight, pair)
        end
    end

    self._pairsToTheLeft = newPairsToTheLeft
    self._pairsToTheRight = newPairsToTheRight
end

function PipesSpawner:draw()
    self._collider:draw()

    for _, pair in pairs(self._pairsToTheLeft) do
        pair:draw()
    end

    for _, pair in pairs(self._pairsToTheRight) do
        pair:draw()
    end
end

return PipesSpawner

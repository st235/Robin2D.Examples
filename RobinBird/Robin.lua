--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

local _DEFAULT_SCALE <const> = 3.5
local _DEFAULT_VERTICAL_SPEED <const> = 15.0
local _DEFAULT_VERTICAL_ACCELERATION <const> = 220.0
local _DEFAULT_JUMP_DURATION <const> = 0.3

local _DEFAULT_STATE_IDLING = "idling"
local _DEFAULT_STATE_FALLING = "falling"
local _DEFAULT_STATE_FLYING = "flying"
local _DEFAULT_STATE_JUMPING = "jumping"

local Robin = {}
Robin.__index = Robin

function Robin:new(params)
    local o = {}
    setmetatable(o, self)

    -- The object is 19 by 16 pixels large.
    o._textureWidth = 19
    o._textureHeight = 16

    o._scale = params.scale or _DEFAULT_SCALE
    o._width = o._textureWidth * o._scale
    o._height = o._textureHeight * o._scale
    o._x = 0
    o._y = 0
    o._speed = _DEFAULT_VERTICAL_SPEED

    o._state = _DEFAULT_STATE_IDLING

    o._collider = Collider:new()
    o._collider:resize(o._width - 4 * o._scale, o._height - 5 * o._scale)
    o:_repositionCollider()

    return o
end

function Robin:getCollider()
    return self._collider
end

function Robin:_repositionCollider()
    self._collider:reposition(self._x + 2 * self._scale, self._y + 5 * self._scale)
end

function Robin:_getFrame()
    if self._state == _DEFAULT_STATE_FLYING then
        return 1
    end

    return 2
end

function Robin:_getRotation()
    if self._state == _DEFAULT_STATE_FALLING then
        return 15
    elseif self._state == _DEFAULT_STATE_JUMPING then
        return -15
    end

    return 0
end

function Robin:setCenterPosition(centerX, centerY)
    self._x = centerX - self._width / 2
    self._y = centerY - self._height / 2
    self:_repositionCollider()
end

function Robin:jump()
    if self._state == _DEFAULT_STATE_FLYING then
        return
    end

    self._speed = -100
    self._state = _DEFAULT_STATE_FLYING
    self._flyingTimer = _DEFAULT_JUMP_DURATION
end

function Robin:update(dt)
    self._y = self._y + dt * self._speed
    self._speed = self._speed + dt * _DEFAULT_VERTICAL_ACCELERATION

    if self._state == _DEFAULT_STATE_FLYING then
        self._flyingTimer = self._flyingTimer - dt
        if self._flyingTimer <= 0 then
            self._state = _DEFAULT_STATE_JUMPING
        end
    end

    if self._speed > 0 and self._state ~= _DEFAULT_STATE_FALLING then
        self._state = _DEFAULT_STATE_FALLING
    end

    self:_repositionCollider()
end

function Robin:draw()
    self._collider:draw()

    robin.graphics.draw(gTextures["robin"], gFrames["robin"][self:_getFrame()],
        math.floor(self._x), math.floor(self._y), self:_getRotation(),
        self._scale, self._scale)
end

-- Return the class instance.
return Robin

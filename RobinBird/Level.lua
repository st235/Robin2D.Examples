--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

local _STATE_NEWGAME <const> = 0
local _STATE_GAME <const> = 1
local _STATE_GAMEOVER <const> = 2

Level = {}
Level.__index = Level

function Level:new(params)
    local o = {}
    setmetatable(o, self)

    o._x = params.x or 0
    o._y = params.y or 0
    o._width = params.width
    o._height = params.height

    o._messages = {
        ["title"] = robin.graphics.newText(gFonts["large"], "RobinBird", { 255, 255, 255 }),
        ["game-over"] = robin.graphics.newText(gFonts["large"], "Game Over", { 255, 255, 255 }),
        ["score"] = robin.graphics.newText(gFonts["xxxlarge"], "0", { 255, 255, 255 }),
    }

    -- Reset level to the new game state.
    o:_reset()

    return o
end

function Level:_reset()
    self._score = 0
    self._messages["score"] = robin.graphics.newText(gFonts["xxxlarge"], "0", { 255, 255, 255 })
    self._state = _STATE_NEWGAME
    self._background = Background:new{
        width=self._width,
        height=self._height,
    }
    self._pipesSpawner = PipesSpawner:new{
        width=self._width,
        height=self._height,
        onPass=function() self:_onChangeScore() end
    }
    self._robin = Robin:new{}
    self._robin:setCenterPosition(self._width / 2, self._height / 2)
end

function Level:_onChangeScore()
    self._score = self._score + 1
    self._messages["score"] = robin.graphics.newText(gFonts["xxxlarge"], tostring(self._score), { 255, 255, 255 })
    gSounds["coin"]:play()
end

function Level:onInteraction()
    if self._state == _STATE_NEWGAME then
        self._state = _STATE_GAME
        gSounds["bloop"]:play()
        return
    end

    if self._state == _STATE_GAMEOVER then
        self:_reset()
        gSounds["bloop"]:play()
        return
    end

    self._robin:jump()
end

function Level:_drawTextWithShadow(texture, atCenterX, atCenterY)
    local width <const> = texture:width()
    local height <const> = texture:height()

    local firstShadowOffset = 4
    local secondShadowOffset = 8

    robin.graphics.setColor(210, 56, 5)

    robin.graphics.draw(texture,
        math.floor(atCenterX - width / 2) + 2,
        math.floor(atCenterY - height / 2) + secondShadowOffset)

    robin.graphics.setColor(238, 91, 10)

    robin.graphics.draw(texture,
        math.floor(atCenterX - width / 2) + 1,
        math.floor(atCenterY - height / 2) + firstShadowOffset)

    robin.graphics.setColor(11, 11, 11)

    robin.graphics.draw(texture,
        math.floor(atCenterX - width / 2),
        math.floor(atCenterY - height / 2))

    robin.graphics.setColor(255, 255, 255)
end

function Level:update(dt)
    if self._state ~= _STATE_GAME then
        return
    end

    self._background:update(dt)
    self._robin:update(dt)
    self._pipesSpawner:update(dt, self._robin:getCollider())

    if self._pipesSpawner:collides(self._robin:getCollider()) then
        self._state = _STATE_GAMEOVER
        gSounds["kick"]:play()
    end
end

function Level:draw()
    self._background:draw()

    self._pipesSpawner:draw()
    self._robin:draw()

    if self._state == _STATE_NEWGAME then
        self:_drawTextWithShadow(self._messages["title"],
            self._x + self._width / 2, self._y + self._height / 2)
    end

    if self._state == _STATE_GAMEOVER then
        self:_drawTextWithShadow(self._messages["game-over"],
            self._x + self._width / 2, self._y + self._height / 2)
    end

    if self._state == _STATE_GAME then
        self:_drawTextWithShadow(self._messages["score"],
            self._x + self._width / 2, self._y + 100)
    end
end

return Level

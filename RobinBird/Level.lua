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
        ["title"] = robin.graphics.newText(gFonts["large"], "RobinBird", { 0, 0, 0 }),
        ["game-over"] = robin.graphics.newText(gFonts["large"], "Game Over", { 0, 0, 0 }),
        ["score"] = robin.graphics.newText(gFonts["xxxlarge"], "0", { 0, 0, 0 }),
    }

    -- Reset level to the new game state.
    o:_reset()

    return o
end

function Level:_reset()
    self._score = 0
    self._messages["score"] = robin.graphics.newText(gFonts["xxxlarge"], "0", { 0, 0, 0 })
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
    self._messages["score"] = robin.graphics.newText(gFonts["xxxlarge"], tostring(self._score), { 0, 0, 0 })
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
        robin.graphics.draw(self._messages["title"],
            math.floor(self._x + (self._width - self._messages["title"]:width()) / 2),
            math.floor(self._y + (self._height - self._messages["title"]:height()) / 2))
    end

    if self._state == _STATE_GAMEOVER then
        robin.graphics.draw(self._messages["game-over"],
            math.floor(self._x + (self._width - self._messages["game-over"]:width()) / 2),
            math.floor(self._y + (self._height - self._messages["game-over"]:height()) / 2))
    end

    if self._state == _STATE_GAME then
        robin.graphics.draw(self._messages["score"],
            math.floor(self._x + (self._width - self._messages["score"]:width()) / 2),
            math.floor(self._y + 50))
    end
end

return Level

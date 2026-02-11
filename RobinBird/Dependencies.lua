--[[
    Copyright © Robin2D, Alex Dadukin,
    Licensed under the Robin2D Non-Commercial No-Derivatives License (RB-NC-ND 1.0)
]]

-- Entities.
Collider = require("Collider")
Background = require("Background")
Robin = require("Robin")
Pipe = require("Pipe")
PipePair = require("PipePair")
PipesSpawner = require("PipesSpawner")
Level = require("Level")
VirtualDisplay = require("VirtualDisplay")

gTextures = {
    ["background"] = robin.graphics.loadTexture("background.jpeg"),
    ["robin"] = robin.graphics.loadTexture("robin-atlas.png"),
    ["pipe-top"] = robin.graphics.loadTexture("pipe-top.png"),
    ["pipe-middle"] = robin.graphics.loadTexture("pipe-middle.png"),
    ["pipe-middle-rotated"] = robin.graphics.loadTexture("pipe-middle-rotated.png"),
}

gFrames = {
    ["robin"] = {
        robin.graphics.newQuad(0, 0, 19, 16),
        robin.graphics.newQuad(19, 0, 19, 16),
    },
}

gFonts = {
    ["medium"] = robin.graphics.newFont("leapfont-bold.ttf", 32),
    ["large"] = robin.graphics.newFont("leapfont-bold.ttf", 52),
    ["xxxlarge"] = robin.graphics.newFont("leapfont-bold.ttf", 96),
}

gSounds = {
    ["coin"] = robin.audio.newEffect("coin.mp3"),
    ["flap"] = robin.audio.newEffect("flap.mp3"),
    ["bloop"] = robin.audio.newEffect("bloop.mp3"),
    ["kick"] = robin.audio.newEffect("kick.mp3"),
}

-- Global volume for the effects:
-- values below should not be altered.
gSounds["coin"]:setVolume(30)
gSounds["flap"]:setVolume(10)
gSounds["bloop"]:setVolume(15)
gSounds["kick"]:setVolume(20)

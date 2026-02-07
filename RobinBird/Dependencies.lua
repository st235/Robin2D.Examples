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
    ["medium"] = robin.graphics.newFont("PixExtrusion.ttf", 32),
    ["large"] = robin.graphics.newFont("PixExtrusion.ttf", 42),
}

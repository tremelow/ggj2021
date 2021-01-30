debug = true

class = require("lib/middleclass/middleclass")
Stateful = require("lib/stateful/stateful")
json = require("lib/json")

require "game"

local game

function love.load(arg)
  -- Extra libraries
  Object = require(".src.Classic")
  Camera = require(".src.Camera")
  Talkies = require(".src.Talkies")
  
  -- Window dimensions
  WINDOW_HEIGHT = love.graphics.getHeight()
  WINDOW_WIDTH = love.graphics.getWidth()
  
  game = Game:new()
end

function love.update(dt)
  game:update(dt)
end

function love.draw(dt)
  game:draw()
end


function love.keypressed(key, code)
  game:keypressed(key, code)
end

function love.mousepressed(x, y, button, isTouch)
  game:mousepressed(x, y, button, isTouch)
end
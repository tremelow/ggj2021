debug = true

class = require("lib/middleclass/middleclass")
Stateful = require("lib/stateful/stateful")

require "game"

local game

function love.load(arg)
  game = Game:new()
  
  -- Window dimensions
  WINDOW_HEIGHT = love.graphics.getHeight()
  WINDOW_WIDTH = love.graphics.getWidth()
  
  -- Extra libraries
  Object = require(".src.Classic")
  Camera = require(".src.Camera")
  Talkies = require(".src.Talkies")
  
  -- Background Image
  background = love.graphics.newImage("assets/foot.jpg")
  FIELD_SIZE = background:getWidth()
  
  -- Initialize Camera, left-right scrolling
  camera = Camera()
  camera:setFollowStyle('PLATFORMER')
  camera:setDeadzone(0, - 200, 0, 200)
  camera:setBounds(0, WINDOW_HEIGHT * 3/5, FIELD_SIZE, WINDOW_HEIGHT * 2/5)
  
  -- Load Characters
  require(".src.Character")
  require(".src.Player")
  require(".src.PNJ")
  
  -- Init Players and three PNJs
  Hero = Player(0,0)
  PNJs = {PNJ(200,200, "Robeeeert"),
  PNJ(400,300, "Giseeeeeele"),
  PNJ(600,300, "Eeeeeetienne")}
  
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
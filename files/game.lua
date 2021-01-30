-- [tutorial](https://aalvarez.me/posts/an-introduction-to-game-states-in-love2d/)

Game = class("Game"):include(Stateful)
Interact = class("Interact"):include(Stateful)

local interact

require "states/menu"
require "states/pause"

require "dialog"

require "states/minigames/soccer"
require "states/minigames/jeudessin"




function Interact:initialize()
end

function Interact:update(dt)
  -- Update Camera
  camera:update(dt)
  camera:follow(Hero.x, Hero.y)
  
  -- Move Hero
  Hero:update(dt)
  
  -- Identify if PNJ close to player
  for i, v in ipairs(PNJs) do
    v:update(dt, Hero)
  end
end

function Interact:draw()
end

function Interact:keypressed(key, code)
  if key == "space" then
    for i, kid in ipairs(PNJs) do
      if kid:isCharacterClose(Hero) then
        self:pushState("Dialog", kid)
      end
    end
  end
end


function Game:initialize()
  self:gotoState("Menu")
  interact = Interact:new()
end

function Game:exit()
end

function Game:update(dt)
  interact:update(dt)
end

function Game:draw()
  camera:attach()
  -- DRAW GAME HERE

  -- Draw background image
  love.graphics.draw(background, 0, 0, 0, 1, WINDOW_HEIGHT/background:getHeight())

  -- Draw NPCs
  for i, v in ipairs(PNJs) do
    v:draw()
  end

  -- Draw Hero last
  Hero:draw()

  camera:detach()
  --camera:draw() --

  interact:draw()
end


function Game:keypressed(key, code)
  if key == 'p' or key == 'escape' then
    self:pushState("Pause") -- the topmost state has priority
  end

  interact:keypressed(key, code)
end

function Game:mousepressed(x, y, button, isTouch)
end

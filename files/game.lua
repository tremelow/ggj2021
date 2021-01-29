-- [tutorial](https://aalvarez.me/posts/an-introduction-to-game-states-in-love2d/)

Game = class("Game"):include(Stateful)

require "states/menu"
-- require "states/intro"
require "states/pause"
require "states/minigames/soccer"

inDialog = false -- TODO: add Dialog state

function Game:initialize()
  self:gotoState("Menu")
end

function Game:exit()
end

function Game:update(dt)
  -- Update Camera
  camera:update(dt)
  camera:follow(Hero.x, Hero.y)
  
  -- Move Hero
  if not inDialog then
    Hero:update(dt)
  end
  
  -- Identify if PNJ close to player
  for i, v in ipairs(PNJs) do
    v:update(dt, Hero)
  end
  
  -- Talkies
  Talkies.update(dt)
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
  
  Talkies.draw()
end


function Game:keypressed(key, code)
  if key == 'p' or key == 'escape' then
    self:pushState("Pause") -- the topmost state has priority
  end

  if not inDialog and key == "space" then
    inDialog = true
    for i, kid in ipairs(PNJs) do
      if kid:isCharacterClose(Hero) then
        Talkies.say(
          kid.name,
          {"Bonjour Morpion !", "Comment tu vas ?", "Ça te dit de jouer au foot ?"},
          {
            options = {
              {"Yes", function(dialog) self:pushState("Soccer") end },
              {"No", function(dialog) end}},
            oncomplete= function(dialog) inDialog = false end
          }
        )
      end
    end
  elseif inDialog and key == "space" then Talkies.onAction()
  elseif inDialog and key == "up" then Talkies.prevOption()
  elseif inDialog and key == "down" then Talkies.nextOption()
  end
end

function Game:mousepressed(x, y, button, isTouch)
end
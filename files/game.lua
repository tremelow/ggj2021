-- [tutorial](https://aalvarez.me/posts/an-introduction-to-game-states-in-love2d/)

Game = class("Game"):include(Stateful)

require "states/menu"
require "states/prologue"
require "states/pause"

require "dialog"

require "src/utils/animation"

require "states/minigames/soccer"
require "states/minigames/jeudessin"
require "states/minigames/billes"
require "states/minigames/shifumi"
require "states/minigames/punch"



function Game:initialize()

  self:gotoState("Menu")

  -- Background Image
  background = love.graphics.newImage("assets/foot.jpg")
  FIELD_SIZE = background:getWidth()
  tente = love.graphics.newImage("assets/img/world/tente.png")
  tableau = love.graphics.newImage("assets/img/world/tableau.png")

  -- Initialize Camera, left-right scrolling
  camera = Camera()
  camera:setFollowStyle('PLATFORMER')
  camera:setDeadzone(0, - 200, 0, 200)
  camera:setBounds(0, WINDOW_HEIGHT * 3/5, FIELD_SIZE, WINDOW_HEIGHT * 2/5)

  -- Load Characters
  require(".src.Character")
  require(".src.Player")
  require(".src.PNJ")

  -- Init Players and PNJs
  Hero = Player(0,0)

  PNJs = {}
  local content = ""
  for line in love.filesystem.lines("assets/txt/pnjs.json") do
    content = content .. line
  end
  local pnjData = json.decode(content)
  
  for id, kid in pairs(pnjData) do
    PNJs[id] = PNJ(kid)
  end
  
  content = ""
  for line in love.filesystem.lines("assets/txt/dialogs.json") do
    content = content .. line
  end
  dialogs = json.decode(content)
end

function Game:exit()
end

function Game:update(dt)
  -- Update Camera
  camera:update(dt)
  camera:follow(Hero.x, Hero.y)

  -- Move Hero
  Hero:update(dt)

  -- Identify if PNJ close to player
  for i, v in pairs(PNJs) do
    v:update(dt, Hero)
  end
end

function Game:draw()
  camera:attach()
  -- DRAW GAME HERE

  -- Draw background image
  love.graphics.draw(background, 0, 0, 0, 1, WINDOW_HEIGHT/background:getHeight())
  love.graphics.draw(tente, 700,230)
  love.graphics.draw(tableau, 90, 280)

  local hero_drawn = false
  -- Draw NPCs
  for i, v in pairs(PNJs) do
	if (Hero.y<v.y and math.abs((Hero.x-v.x))<50) then
		if not hero_drawn then
			Hero:draw()
			hero_drawn = true
		end
		v:draw()
	else
		v:draw()
	end
  end

  -- Draw Hero last
  if not hero_drawn then
    Hero:draw()
  end
  
  camera:detach()
  --camera:draw() --

  -- interact:draw()
  Talkies.draw()
end


function Game:keypressed(key, code)
  if key == 'p' or key == 'escape' then
    self:pushState("Pause") -- the topmost state has priority
  end

  if key == "space" then
    for i, kid in pairs(PNJs) do
      if kid:isCharacterClose(Hero) then
        -- TODO: choose flag depending on advancement
        self:pushState("Dialog", i, "pres_minigame")
      end
    end
  end
end

function Game:mousepressed(x, y, button, isTouch)
end

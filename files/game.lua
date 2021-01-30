-- [tutorial](https://aalvarez.me/posts/an-introduction-to-game-states-in-love2d/)

Game = class("Game"):include(Stateful)
Interact = class("Interact"):include(Stateful)

local interact

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


function Interact:initialize(game)
  self.game = game
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
  interact = Interact:new(self)

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
  for index, kid in ipairs(pnjData) do
    table.insert(PNJs, PNJ(kid))
  end
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
  love.graphics.draw(tente, 700,230)
  love.graphics.draw(tableau, 90, 280)

  local hero_drawn = false
  -- Draw NPCs
  for i, v in ipairs(PNJs) do
	if (Hero.y<v.y) then
		if not hero_drawn then
			Hero:draw()
		end
		v:draw()
		hero_drawn = true
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

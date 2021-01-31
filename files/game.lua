-- [tutorial](https://aalvarez.me/posts/an-introduction-to-game-states-in-love2d/)

Game = class("Game"):include(Stateful)

require "states/menu"
require "states/prologue"
require "states/epilogue"
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
  background = love.graphics.newImage("assets/img/world/fond.png")
  FIELD_SIZE = background:getWidth()
  
  background_elems = {love.graphics.newImage("assets/img/world/stand.png"), love.graphics.newImage("assets/img/world/tente.png"), 
  love.graphics.newImage("assets/img/world/tableau.png"), love.graphics.newImage("assets/img/world/fanions.png"),
  love.graphics.newImage("assets/img/world/fanions.png"), love.graphics.newImage("assets/img/world/fanions.png"),
  love.graphics.newImage("assets/img/world/ballons.png"), love.graphics.newImage("assets/img/world/ballons.png"),
	love.graphics.newImage("assets/img/world/cage.png"), love.graphics.newImage("assets/img/world/punchingball.png")
	}
  background_elems_pos = {{1200, 100}, {700,250},{2000, 400},{100, 150}, {700, 150}, {2200, 130}, {950,120}, {1300, 500}, {0, 350},{1600, 150}}
  
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
  Names = {theo = "Théodule"}
  DialogSprite = {theo = love.graphics.newImage("assets/img/talkies/theodule.png")}

  PNJs = {}
  local content = ""
  for line in love.filesystem.lines("assets/txt/pnjs.json") do
    content = content .. line
  end
  
  pnjData = json.decode(content)
  
  for id, kid in pairs(pnjData) do
    Names[id] = kid.name
    local talky = "assets/img/talkies/" .. id .. ".png"
    if love.filesystem.getInfo(talky) then
      DialogSprite[id] = love.graphics.newImage(talky)
    else
      DialogSprite[id] = love.graphics.newImage("assets/img/talkies/papyrus.png")
    end
    PNJs[id] = PNJ(kid)
  end

  Hero:resetAdvancement(pnjData)
  
  content = ""
  for line in love.filesystem.lines("assets/txt/dialogs.json") do
    content = content .. line
  end
  dialogs = json.decode(content)

--music
  overworldMusic = love.audio.newSource("assets/audio/overworld.mp3", "stream")
  overworldMusic:setLooping(true)
  overworldMusic:setVolume(0.2)
  minigameMusic = love.audio.newSource("assets/audio/minigame.mp3", "stream")
  minigameMusic:setLooping(true)
  minigameMusic:setVolume(0.8)
  prologueMusic = love.audio.newSource("assets/audio/prologue.mp3", "stream")
  prologueMusic:setVolume(0.5)
  epilogueMusic = love.audio.newSource("assets/audio/epilogue.mp3", "stream")
  epilogueMusic:setVolume(0.5)
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
  --love.graphics.draw(tente, 700,230)
  --love.graphics.draw(tableau, 2000, 400)
  --love.graphics.draw(cage, 50, 280)
  --love.graphics.draw(punchingball, 1600, 150)

  local hero_drawn = false
  for idx, elem in pairs(background_elems) do
    if (Hero.y<background_elems_pos[idx][2] and math.abs((Hero.x-(background_elems_pos[idx][1]+50)))<100) then
		if not hero_drawn then
			Hero:draw()
			hero_drawn = true
		end
		love.graphics.draw(elem, background_elems_pos[idx][1], background_elems_pos[idx][2])
	else
		love.graphics.draw(elem, background_elems_pos[idx][1], background_elems_pos[idx][2])
	end
  end
  
  
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
        if Hero.hasSpoken[i] then
          self:pushState("Dialog", i, Hero.advancement[i])
        else 
          Hero.hasSpoken[i] = true
          self:pushState("Dialog", i, 'first')
        end
      end
    end
  end
end

function Game:mousepressed(x, y, button, isTouch)
end

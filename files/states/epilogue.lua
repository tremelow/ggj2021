local Epilogue = Game:addState("Epilogue")

require "../src/json"
require "math"

local epilogue_counter = 1
local frame_counter = 0
local epilogue_text = {}
local epilogue_images = {}
local assets_idx = {}

function Epilogue:enteredState()
  epilogue_images = {love.graphics.newImage("assets/img/epilogue/epilogue_1.png"), love.graphics.newImage("assets/img/epilogue/epilogue_2.png"),
  love.graphics.newImage("assets/img/epilogue/epilogue_3.png"), love.graphics.newImage("assets/img/epilogue/epilogue_4.png"),
  love.graphics.newImage("assets/img/epilogue/epilogue_5.png"), love.graphics.newImage("assets/img/epilogue/epilogue_6.png")}
  assets_idx = {1, 3, 5, 5, 5, 5}

  local content = ""
  for line in love.filesystem.lines("assets/txt/epilogue.json") do
    content = content .. line
  end
  epilogue_text = json.decode(content)

  --music
  --epilogueMusic:play()
  --currentMusic = epilogueMusic
end

function Epilogue:update(dt)
	frame_counter = (frame_counter+1)%12
end

function Epilogue:draw()
  love.graphics.setBackgroundColor(0,0,0)
  if frame_counter < 6 then
    love.graphics.draw(epilogue_images[assets_idx[epilogue_counter]], 0, 0)
  else
    love.graphics.draw(epilogue_images[assets_idx[epilogue_counter]+1], 0, 0)
  end
  
  love.graphics.setColor(255,255,255)

  local wTitle = math.floor(WINDOW_WIDTH/2)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(8*WINDOW_HEIGHT/9)
  local title = epilogue_text[epilogue_counter]
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")

end

function Epilogue:keypressed(key, code)
  if key == 'space' then
    epilogue_counter = epilogue_counter+1
  elseif key == 'p' then
    self:pushState("Pause")
  end
  if epilogue_counter >= 7 then
    --epilogueMusic:stop()
    self:gotoState("Menu")
	-- on veut quitter le jeu, pas y retourner
  end
end
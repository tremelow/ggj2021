local Prologue = Game:addState("Prologue")

require "../src/json"
require "math"

local prologue_counter = 1
local frame_counter = 0

function Prologue:enteredState()
  prologue_images = {love.graphics.newImage("assets/img/prologue/theodule_1.png"), love.graphics.newImage("assets/img/prologue/theodule_2.png"),
  love.graphics.newImage("assets/img/prologue/emilie_1.png"), love.graphics.newImage("assets/img/prologue/emilie_2.png"), 
  love.graphics.newImage("assets/img/prologue/telescope_1.png"), love.graphics.newImage("assets/img/prologue/telescope_2.png"),
  love.graphics.newImage("assets/img/prologue/star1_1.png"), love.graphics.newImage("assets/img/prologue/star1_2.png"),
  love.graphics.newImage("assets/img/prologue/star2_1.png"), love.graphics.newImage("assets/img/prologue/star2_2.png"),
  love.graphics.newImage("assets/img/prologue/star3_1.png"), love.graphics.newImage("assets/img/prologue/star3_2.png"),
  love.graphics.newImage("assets/img/prologue/doudou_1.png"), love.graphics.newImage("assets/img/prologue/doudou_2.png")}
  assets_idx = {1, 1, 3, 3}
end

function Prologue:update(dt)
	frame_counter = (frame_counter+1)%12
end

function Prologue:draw()
  love.graphics.setBackgroundColor(0,0,0)
  if frame_counter < 6 then
    love.graphics.draw(prologue_images[prologue_counter])
  else
    love.graphics.draw(prologue_images[prologue_counter+1])
  end
  love.graphics.setColor(255,255,255)

  local wTitle = math.floor(WINDOW_WIDTH/3)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(WINDOW_HEIGHT/3)
  local title = "moi c'est théodule"
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")
  
  -- on ecrit text[prologue_counter]
  -- et on dessine asset[idx] avec idx un truc scripté
end

function Prologue:keypressed(key, code)
  if key == 'space' then
	  prologue_counter = prologue_counter+1
  elseif key == 'escape' then
    love.event.quit()
  end
  if prologue_counter >= 3 then
	self:popState("Prologue")
  end
end
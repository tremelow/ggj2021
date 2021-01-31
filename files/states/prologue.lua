local Prologue = Game:addState("Prologue")

require "../src/json"
require "math"

local prologue_counter = 1
local frame_counter = 0
local prologue_text = {}
local anim_counter = 1
local assets_idx = {}

function Prologue:enteredState()
  prologue_images = {love.graphics.newImage("assets/img/prologue/theodule_1.png"), love.graphics.newImage("assets/img/prologue/theodule_2.png"),
  love.graphics.newImage("assets/img/prologue/emilie_1.png"), love.graphics.newImage("assets/img/prologue/emilie_2.png"),
  {love.graphics.newImage("assets/img/prologue/telescope_1.png"), love.graphics.newImage("assets/img/prologue/telescope_2.png"),
  love.graphics.newImage("assets/img/prologue/star1_1.png"), love.graphics.newImage("assets/img/prologue/star1_2.png"),
  love.graphics.newImage("assets/img/prologue/star2_1.png"), love.graphics.newImage("assets/img/prologue/star2_2.png"),
  love.graphics.newImage("assets/img/prologue/star3_1.png"), love.graphics.newImage("assets/img/prologue/star3_2.png")},
  love.graphics.newImage("assets/img/prologue/doudou_1.png"), love.graphics.newImage("assets/img/prologue/doudou_2.png"),
  {love.graphics.newImage("assets/img/prologue/doko_1.png"),love.graphics.newImage("assets/img/prologue/doko_2.png"),
  love.graphics.newImage("assets/img/prologue/doko_3.png"), love.graphics.newImage("assets/img/prologue/doko_4.png"),
  love.graphics.newImage("assets/img/prologue/doko_5.png"), love.graphics.newImage("assets/img/prologue/doko_6.png"),
  love.graphics.newImage("assets/img/prologue/doko_7.png"), love.graphics.newImage("assets/img/prologue/doko_8.png"),
  love.graphics.newImage("assets/img/prologue/doko_9.png")}}
  assets_idx = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 6, 6, 6, 8, 8, 8, 8}

  local content = ""
  for line in love.filesystem.lines("assets/txt/prologue.json") do
    content = content .. line
  end
  prologue_text = json.decode(content)

  --music
  prologueMusic:play()
  currentMusic = prologueMusic
end

function Prologue:update(dt)
	frame_counter = (frame_counter+1)%12
end

function Prologue:draw()
  love.graphics.setBackgroundColor(0,0,0)
  if (prologue_counter>16 and prologue_counter<22) then
    if frame_counter < 6 then
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][1], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]][1]:getWidth())/2, 0)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][3], (WINDOW_WIDTH)/8, 0)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][5], 6*(WINDOW_WIDTH)/8, WINDOW_HEIGHT/6)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][7], 2*(WINDOW_WIDTH)/8, WINDOW_HEIGHT/3)
    else
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][2], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]][2]:getWidth())/2, 0)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][4], (WINDOW_WIDTH)/8, 0)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][6], 6*(WINDOW_WIDTH)/8, WINDOW_HEIGHT/6)
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][8], 2*(WINDOW_WIDTH)/8, WINDOW_HEIGHT/3)
    end
  elseif prologue_counter==25 then
	if (frame_counter==6) then
		anim_counter = anim_counter+1
	end
	if (anim_counter>7 and frame_counter>6) then
		anim_counter = 9
	elseif(anim_counter>7) then
		anim_counter = 8
	end
	local anim_image = prologue_images[8][anim_counter]
	love.graphics.draw(anim_image, (WINDOW_WIDTH-anim_image:getWidth())/2, 0)
  elseif prologue_counter>25 then
    if frame_counter < 6 then
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]][8], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]][8]:getWidth())/2, 0)
	else
	  love.graphics.draw(prologue_images[assets_idx[prologue_counter]][9], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]][9]:getWidth())/2, 0)
	end
  else
	if frame_counter < 6 then
      love.graphics.draw(prologue_images[assets_idx[prologue_counter]], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]]:getWidth())/2, 0)
	else
	  love.graphics.draw(prologue_images[assets_idx[prologue_counter]+1], (WINDOW_WIDTH-prologue_images[assets_idx[prologue_counter]+1]:getWidth())/2, 0)
	end
  end



  love.graphics.setColor(255,255,255)

  local wTitle = math.floor(WINDOW_WIDTH/2)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(8*WINDOW_HEIGHT/9)
  local title = prologue_text[prologue_counter]
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")

  -- on ecrit text[prologue_counter]
  -- et on dessine asset[idx] avec idx un truc scripté
end

function Prologue:keypressed(key, code)
  if key == 'space' then
    prologue_counter = prologue_counter+1
  elseif key == 'escape' then
    prologueMusic:stop()
    self:popState("Prologue")
    overworldMusic:play()
    currentMusic = overworldMusic
  elseif key == 'p' then
    self:pushState("Pause")
  end
  if prologue_counter >= 29 then
    prologueMusic:stop()
    self:popState("Prologue")
    overworldMusic:play()
    currentMusic = overworldMusic
  end
end
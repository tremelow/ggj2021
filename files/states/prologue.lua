local Prologue = Game:addState("Prologue")

require "../src/json"

local prologue_counter = 0

function Prologue:enteredState()
  image_1 = love.graphics.newImage("assets/img/prologue/theodule_1.png")
end

function Prologue:update(dt)
end

function Prologue:draw()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.draw(image_1)
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
  if prologue_counter >= 1 then
	self:popState("Prologue")
  end
end
local Prologue = Game:addState("Prologue")

require "../src/json"

function Prologue:enteredState()
	counter = 0
end

function Prologue:update(dt)
  -- You should switch to another state here,
  -- Usually when a button is pressed.
  -- Either with gotoState() or pushState()
end

function Prologue:draw()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setColor(255,255,255)

  local wTitle = math.floor(WINDOW_WIDTH/3)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(WINDOW_HEIGHT/3)
  local title = "moi c'est théodule"
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")

  local wInst = wTitle
  local xInst = (WINDOW_WIDTH - wInst)/2
  local yInst = WINDOW_HEIGHT/2
  local inst = "Appuyez sur n'importe quelle touche pour continuer."
  love.graphics.printf(inst, xInst, yInst, wInst, "center")
end

function Prologue:keypressed(key, code)
  if key == 'space' then
	counter = counter+1
  end
  elseif key == 'escape' then
    love.event.quit()
  end
end
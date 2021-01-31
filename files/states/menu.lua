local Menu = Game:addState("Menu")

function Menu:enteredState()
end

function Menu:update(dt)
  -- You should switch to another state here,
  -- Usually when a button is pressed.
  -- Either with gotoState() or pushState()
end

function Menu:draw()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setColor(255,255,255)

  local wTitle = math.floor(WINDOW_WIDTH/3)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(WINDOW_HEIGHT/3)
  local title = "Panique à la Kermesse"
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")

  local wInst = wTitle
  local xInst = (WINDOW_WIDTH - wInst)/2
  local yInst = WINDOW_HEIGHT/2
  local inst = "Appuyez sur n'importe quelle touche pour continuer." ..
                "\n\n(Echap pour quitter)"
  love.graphics.printf(inst, xInst, yInst, wInst, "center")
end

function Menu:keypressed(key, code)
  if key == 'escape' then
    love.event.quit()
  end

  self:gotoState("Prologue")
end
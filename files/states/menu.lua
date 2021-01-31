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

  local defaultFont = love.graphics.getFont()
  
  self:drawTitle()
  self:drawControls()
  self:drawInstructions()

  love.graphics.setFont(defaultFont)
end

function Menu:drawTitle()
  love.graphics.setNewFont(36)
  local wTitle = math.floor(WINDOW_WIDTH/2)
  local xTitle = math.floor((WINDOW_WIDTH - wTitle)/2)
  local yTitle = math.floor(WINDOW_HEIGHT/3)
  local title = "Théodule à la Kermesse"
  love.graphics.printf(title, xTitle, yTitle, wTitle, "center")
end

function Menu:drawControls()
  love.graphics.setNewFont(18)
  local msg = "Déplacements avec ZQSD ou les flèches directionnelles\n"
  msg = msg .. "Interactions avec Espace\n"
  msg = msg .. "Pause en appuyant sur P"

  local wdth = math.floor(2/3 * WINDOW_WIDTH)
  local x = math.floor((WINDOW_WIDTH - wdth)/2)
  local y = math.floor(WINDOW_HEIGHT/2)
  love.graphics.printf(msg, x, y, wdth, "center")
end

function Menu:drawInstructions()
  love.graphics.setNewFont(14)
  local wInst = math.floor(WINDOW_WIDTH/3)
  local xInst = (WINDOW_WIDTH - wInst)/2
  local yInst = 2*WINDOW_HEIGHT/3
  local inst = "Appuyez sur n'importe quelle touche pour continuer." ..
                "\n(Echap pour quitter)"
  love.graphics.printf(inst, xInst, yInst, wInst, "center")
end

function Menu:keypressed(key, code)
  if key == 'escape' then
    love.event.quit()
  end

  self:gotoState("Prologue")
end
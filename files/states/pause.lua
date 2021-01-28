local Pause = Game:addState("Pause")

function Pause:enteredState()
end

function Pause:exitedState()
end

function Pause:update(dt)
end

function Pause:draw()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setColor(255, 255, 255)

  local wText = 200
  local xText = (WINDOW_WIDTH - wText)/2
  local yText = math.floor(WINDOW_HEIGHT/3)
  love.graphics.printf("PAUSE", xText, yText, wText, "center")

  local wInst = 500
  local xInst = (WINDOW_WIDTH - wInst)/2
  local yInst = WINDOW_HEIGHT/2
  love.graphics.printf("P pour revenir au jeu, Echap pour quitter.",
    xInst, yInst, wInst, "center")
end

function Pause:keypressed(key, code)
  if key == 'p' then
    self:popState("Pause")
  elseif key == 'escape' then
    love.event.quit()
  end
end
local Pause = Game:addState("Pause")

function Pause:enteredState()
end

function Pause:exitedState()
end

function Pause:update(dt)
end

function Pause:draw()
  love.graphics.setBackgroundColor(0,0,0)
  
  local xText = WINDOW_HEIGHT/2
  local yText = WINDOW_WIDTH/2
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("GAME PAUSED", xText, yText, 200, "center")
end

function Pause:keypressed(key, code)
  if key == 'p' then
    self:popState("Pause")
  end
end
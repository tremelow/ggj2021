local Dialog = Player:addState("Dialog")

local lines = nil

function Dialog:enteredState(linesFile)
    lines = readlines(linesFile)
end

function Dialog:update(dt)
  -- You should switch to another state here,
  -- Usually when a button is pressed.
  -- Either with gotoState() or pushState()
end

function Dialog:draw()
  -- Problème : quand on fait "draw", tous les pixels sont remis à zéro,
  -- donc il faut trouver un moyen de dessiner le background quand même !
end

function Dialog:keypressed(key, code)
  if key == 'escape' then
    love.event.quit()
  end

  self:popState("Menu")
end
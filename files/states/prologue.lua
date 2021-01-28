local Prologue = Game:addState("Prologue")

require "../src/json"

function Prologue:enteredState()
	prologue_counter = 0
	-- j'aimerais charger le fichier assets/txt/prologue.json avec les textes dans un tableau
	-- et les assets dans un tableau d'assets
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
  
  -- on ecrit text[prologue_counter]
  -- et on dessine asset[idx] avec idx un truc scripté
end

function Prologue:keypressed(key, code)
  if key == 'space' then
	prologue_counter = prologue_counter+1
  end
  elseif key == 'escape' then
    love.event.quit()
  end
  -- si counter dépasse la taille du tableau d'asset, on sort de prologue et on rentre dans game
end
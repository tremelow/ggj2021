local Dessin = Game:addState("Dessin")


local function loadJeuDessin()
  width, height, flags = love.window.getMode( ) --Taille de la fenetre
  
  --Taille de l'image background craie
  widthCraie = 1280 
  heightCraie = 720

  gameWidth = width*3/5
  gameHeight = height*0.80
  gamex0 = (width-gameWidth)/2
  gamey0 = (height - gameHeight)/2
  --gameCanvas : Canvas qui représente la "fenetre" du mini jeu sur lequel on va dessiner le background craie
  -- puis par dessus un rectangle noir (qu'on gommera ensuite)
  gameCanvas = love.graphics.newCanvas(gameWidth,gameHeight) 
  -- drawingCanvas : le canvas qui accueille le rectangle noir sur lequel on va dessiner
  drawingCanvas = love.graphics.newCanvas(gameWidth,gameHeight)
  exampleCanvas = love.graphics.newCanvas(gameWidth,gameHeight)
  craieBackground = love.graphics.newImage("assets/craieback.png")

  tailleCrayon = 5

  love.graphics.setCanvas(drawingCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir


  --Dessin de l'exemple à reproduire
  love.graphics.setCanvas(exampleCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.setLineWidth( tailleCrayon ) 
  love.graphics.setLineStyle( "smooth" )
  love.graphics.line(1/3*gameWidth,0.35*gameHeight, 1/3*gameWidth, 0.45*gameHeight) --barre 1
  love.graphics.line(1/2*gameWidth,0.35*gameHeight, 1/2*gameWidth, 0.45*gameHeight) --barre 2
  love.graphics.line(2/3*gameWidth,0.35*gameHeight, 2/3*gameWidth, 0.45*gameHeight) --barre 3
  love.graphics.line(1/3*gameWidth,0.55*gameHeight, 1/3*gameWidth, 0.65*gameHeight) --barre 4
  love.graphics.line(1/2*gameWidth,0.55*gameHeight, 1/2*gameWidth, 0.65*gameHeight) --barre 5
  love.graphics.line(2/3*gameWidth,0.55*gameHeight, 2/3*gameWidth, 0.65*gameHeight) --barre 6

  --triangle haut
  love.graphics.line(1/3*gameWidth,0.35*gameHeight, 1/2*gameWidth, 0.15*gameHeight)
  love.graphics.line(2/3*gameWidth,0.35*gameHeight, 1/2*gameWidth, 0.15*gameHeight)

  --triangle bas
  love.graphics.line(1/3*gameWidth,0.65*gameHeight, 1/2*gameWidth, 0.85*gameHeight)
  love.graphics.line(2/3*gameWidth,0.65*gameHeight, 1/2*gameWidth, 0.85*gameHeight)

  --croisement 1
  love.graphics.line(1/3*gameWidth,0.45*gameHeight, 1/2*gameWidth, 0.55*gameHeight)
  love.graphics.line(1/2*gameWidth,0.45*gameHeight, 2/3*gameWidth, 0.55*gameHeight)

  --croisement 2
  love.graphics.line(2/3*gameWidth,0.45*gameHeight, 5/9*gameWidth, (1/30 + 0.45)*gameHeight)
  love.graphics.line(1/3*gameWidth,0.55*gameHeight, 4/9*gameWidth, (0.45 + 2/30)*gameHeight)
  

  --Dessin des points pour indiquer
  love.graphics.setCanvas(drawingCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.ellipse("fill", 1/3*gameWidth, 0.35*gameWidth,3,3)
  love.graphics.ellipse("fill", 1/2*gameWidth, 0.35*gameWidth,3,3)
  love.graphics.ellipse("fill", 2/3*gameWidth, 0.35*gameWidth,3,3)

  love.graphics.ellipse("fill", 1/3*gameWidth, 0.45*gameWidth,3,3)
  love.graphics.ellipse("fill", 1/2*gameWidth, 0.45*gameWidth,3,3)
  love.graphics.ellipse("fill", 2/3*gameWidth, 0.45*gameWidth,3,3)

  love.graphics.ellipse("fill", 1/3*gameWidth, 0.55*gameWidth,3,3)
  love.graphics.ellipse("fill", 1/2*gameWidth, 0.55*gameWidth,3,3)
  love.graphics.ellipse("fill", 2/3*gameWidth, 0.55*gameWidth,3,3)

  love.graphics.ellipse("fill", 1/3*gameWidth, 0.65*gameWidth,3,3)
  love.graphics.ellipse("fill", 1/2*gameWidth, 0.65*gameWidth,3,3)
  love.graphics.ellipse("fill", 2/3*gameWidth, 0.65*gameWidth,3,3)

  love.graphics.ellipse("fill", 1/2*gameWidth, 0.15*gameWidth,3,3)
  love.graphics.ellipse("fill", 1/2*gameWidth, 0.85*gameWidth,3,3)

  love.graphics.setCanvas()




end

local function updateJeuDessin()

  -- Quand on appuie sur la souris on dessine
  if love.mouse.isDown(1) and timer > 5 then
    love.graphics.setCanvas(drawingCanvas) --On dessine sur drawingCanvas
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(0, 0, 0, 0) -- Puisqu'on veut effacer on prend une couleur avec alpha = 0
    curx = love.mouse.getX() - gamex0 -- Position où le joueur à cliqué. Je comprends pas pk il faut retrancher la position du canvas gameCanvas
    cury = love.mouse.getY() - gamey0
    love.graphics.ellipse("fill", curx,cury, 5, 5) --On dessine une point assez large à cet endroit
    love.graphics.setLineWidth( 10 ) 
    love.graphics.setLineStyle( "smooth" )
    love.graphics.line(prevx, prevy, curx, cury) --On dessine une ligne de même epaisseur pour relier le point où est la souris a celui où elle était avant
    prevx = curx
    prevy = cury
    love.graphics.setCanvas()
  end
end


-- function compareCanvases (example, drawing, localWidth, localHeight)
--   local score 
--   for i = 0,(width-1) do   
--     for j = 0,(height-1) do 
--       local r1,g1,b1,a1 = 

local function drawJeuDessin()
  if timer < 6 then
    love.graphics.setCanvas(gameCanvas)-- Sur le gameCanvas on affiche d'abord le background puis drawingCanvas
    love.graphics.draw(craieBackground)
    --love.graphics.draw(drawingCanvas,width/4, height/4)
    love.graphics.draw(exampleCanvas)
    love.graphics.setCanvas()
    love.graphics.setCanvas() --on repasse sur le canvas de base puis on affiche gameCanvas (la fenetre de jeu)
	  love.graphics.draw(gameCanvas, gamex0, gamey0)
  else
    love.graphics.setCanvas(gameCanvas)-- Sur le gameCanvas on affiche d'abord le background puis drawingCanvas
    love.graphics.draw(craieBackground)
    --love.graphics.draw(drawingCanvas,width/4, height/4)
    love.graphics.draw(drawingCanvas)
    love.graphics.setCanvas() --on repasse sur le canvas de base puis on affiche gameCanvas (la fenetre de jeu)
    love.graphics.draw(gameCanvas, gamex0, gamey0)
  end
end


function Dessin:enteredState()
  love.graphics.setBackgroundColor(1,1,1,1)
  loadJeuDessin()
  timer = 0
end

function Dessin:mousepressed(x, y, button, istouch)
  prevx = x - gamex0
  prevy = y - gamey0
end

function Dessin:update(dt)
  updateJeuDessin()
  timer = timer + dt
end

function Dessin:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  drawJeuDessin()
end

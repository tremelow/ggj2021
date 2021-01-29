function loadJeuDessin()
  width, height, flags = love.window.getMode( ) --Taille de la fenetre
  --Taille de l'image background craie
  widthCraie = 1280 
  heightCraie = 720

  gameWidth = width*0.66
  gameHeight = height*0.66
  gamex0 = (width - gameWidth)/2
  gamey0 = (height-gameHeight)/2
  --gameCanvas : Canvas qui représente la "fenetre" du mini jeu sur lequel on va dessiner le background craie
  -- puis par dessus un rectangle noir (qu'on gommera ensuite)
  gameCanvas = love.graphics.newCanvas(gameWidth,gameHeight) 
  -- drawingCanvas : le canvas qui accueille le rectangle noir sur lequel on va dessiner
  drawingCanvas = love.graphics.newCanvas(gameWidth,gameHeight)
  craieBackground = love.graphics.newImage("craieback.png")

  love.graphics.setCanvas(drawingCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.setCanvas()

end

function updateJeuDessin()

  --Si quelqu'un comprend ce qui se passe quand on décommente ça
  --
  -- if timer < 5 then
  --   love.graphics.setCanvas(drawingCanvas)
  --   love.graphics.setBlendMode("multiply", "premultiplied")
  --   love.graphics.setColor(1, 0, 0, 1)
  --   love.graphics.ellipse("fill", gamex0,gamey0, 1, 1)
  -- end

  -- Quand on appuie sur la souris on dessine
  if love.mouse.isDown(1) then
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

function drawJeuDessin()
  love.graphics.setCanvas(gameCanvas)-- Sur le gameCanvas on affiche d'abord le background puis drawingCanvas
  love.graphics.draw(craieBackground, 0,0, 0, 0.5, 0.5)
  --love.graphics.draw(drawingCanvas,width/4, height/4)
	love.graphics.draw(drawingCanvas)
	love.graphics.setCanvas() --on repasse sur le canvas de base puis on affiche gameCanvas (la fenetre de jeu)
	love.graphics.draw(gameCanvas, gamex0,gamey0)
end


function love.load()
  love.graphics.setBackgroundColor(1,1,1,1)
  loadJeuDessin()
  timer = 0
end

function love.mousepressed(x, y, button, istouch)
  prevx = x - gamex0
  prevy = y - gamey0
end

function love.update(dt)
  updateJeuDessin()
  timer = timer + dt
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  drawJeuDessin()
end

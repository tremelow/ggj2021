local Dessin = Game:addState("Dessin")

local JeuDessin = class("JeuDessin")

function JeuDessin:drawExample()
  --Dessin de l'exemple à reproduire
  love.graphics.setCanvas(self.exampleCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.draw(tableau, 0,0)
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.setLineWidth( 2*self.tailleCrayon ) 
  love.graphics.setLineStyle( "smooth" )
  love.graphics.line(0.4*self.gameWidth,0.35*self.gameHeight, 0.4*self.gameWidth, 0.45*self.gameHeight) --barre 1
  love.graphics.line(1/2*self.gameWidth,0.35*self.gameHeight, 1/2*self.gameWidth, 0.45*self.gameHeight) --barre 2
  love.graphics.line(0.6*self.gameWidth,0.35*self.gameHeight, 0.6*self.gameWidth, 0.45*self.gameHeight) --barre 3
  love.graphics.line(0.4*self.gameWidth,0.55*self.gameHeight, 0.4*self.gameWidth, 0.65*self.gameHeight) --barre 4
  love.graphics.line(1/2*self.gameWidth,0.55*self.gameHeight, 1/2*self.gameWidth, 0.65*self.gameHeight) --barre 5
  love.graphics.line(0.6*self.gameWidth,0.55*self.gameHeight, 0.6*self.gameWidth, 0.65*self.gameHeight) --barre 6

  --triangle haut
  love.graphics.line(0.4*self.gameWidth,0.35*self.gameHeight, 1/2*self.gameWidth, 0.15*self.gameHeight)
  love.graphics.line(0.6*self.gameWidth,0.35*self.gameHeight, 1/2*self.gameWidth, 0.15*self.gameHeight)

  --triangle bas
  love.graphics.line(0.4*self.gameWidth,0.65*self.gameHeight, 1/2*self.gameWidth, 0.85*self.gameHeight)
  love.graphics.line(0.6*self.gameWidth,0.65*self.gameHeight, 1/2*self.gameWidth, 0.85*self.gameHeight)

  --croisement 1
  love.graphics.line(0.4*self.gameWidth,0.45*self.gameHeight, 1/2*self.gameWidth, 0.55*self.gameHeight)
  love.graphics.line(1/2*self.gameWidth,0.45*self.gameHeight, 0.6*self.gameWidth, 0.55*self.gameHeight)

  --croisement 2
  love.graphics.line(0.6*self.gameWidth,0.45*self.gameHeight, (0.16/0.3)*self.gameWidth, (0.16/0.3 - 0.05)*self.gameHeight)
  love.graphics.line(0.4*self.gameWidth,0.55*self.gameHeight, (0.14/0.3)*self.gameWidth, (0.14/0.3 + 0.05)*self.gameHeight)

  --Dessin des points pour indiquer
  love.graphics.setCanvas(self.drawingCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.draw(tableau, 0,0)
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.15*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.85*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.setCanvas()
end

function JeuDessin:resetDessin()
  --Dessin des points pour indiquer
  love.graphics.setCanvas(self.drawingCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.draw(tableau, 0,0)
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.35*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.45*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.55*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 0.4*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 0.6*self.gameWidth, 0.65*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.15*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)
  love.graphics.ellipse("fill", 1/2*self.gameWidth, 0.85*self.gameHeight,self.tailleCrayon/2, self.tailleCrayon/2)

  love.graphics.setCanvas()
end

function JeuDessin:drawButton()
  love.graphics.setCanvas(self.gameCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", 0.9*self.gameWidth, 0.9*self.gameHeight, self.gameWidth, self.gameHeight)
  love.graphics.setCanvas()
end



function JeuDessin:loadJeuDessin()
  self.timer = 0
  self.scoreComputed = false
  self.seuilScore = 11000

  self.width, self.height, flags = love.window.getMode( ) --Taille de la fenetre
  --Taille de l'image background craie
  -- widthCraie = 1280 
  -- heightCraie = 720

  self.gameWidth = 850
  self.gameHeight = self.height*0.80
  self.gamex0 = (self.width-self.gameWidth)/2
  -- gamey0 = (height - gameHeight)/2
  self.gamey0 = 0
  --gameCanvas : Canvas qui représente la "fenetre" du mini jeu sur lequel on va dessiner le background craie
  -- puis par dessus un rectangle noir (qu'on gommera ensuite)
  self.gameCanvas = love.graphics.newCanvas(self.gameWidth,self.gameHeight) 
  -- drawingCanvas : le canvas qui accueille le rectangle noir sur lequel on va dessiner
  self.drawingCanvas = love.graphics.newCanvas(self.gameWidth,self.gameHeight)
  self.exampleCanvas = love.graphics.newCanvas(self.gameWidth,self.gameHeight)
  craieBackground = love.graphics.newImage("assets/craieback.png")
  tableau = love.graphics.newImage("assets/tableau.png")

  self.tailleCrayon = 5

  -- set font

  love.graphics.setCanvas(drawingCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  -- love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight) --On met le rectangle noir
  love.graphics.draw(tableau, 0,0)

  self:drawExample()

  self:drawButton()

  love.graphics.setCanvas()
end

function JeuDessin:compareCanvases ()
  love.graphics.setCanvas()
  local dataDrawing = self.drawingCanvas:newImageData()
  local dataExample = self.exampleCanvas:newImageData()
  local dataW, dataH = dataExample:getDimensions()
  local score = 0
  for i = 0,(dataW-1) do   
    for j = 0,(dataH-1) do 
      local r1,g1,b1,a1 = dataExample:getPixel(i,j)
      local r2,g2,b2,a2 = dataDrawing:getPixel(i,j)
      if a1 ~= a2 then
        score = score + 1
      end
    end
  end
  self.scoreGame = score
  self.scoreComputed = true
  return score
end


function JeuDessin:updateJeuDessin(dt)
  if self.timer < 20 then
    self.timer = self.timer + dt
  end
end


function JeuDessin:drawJeuDessin()
  font = love.graphics.getFont()
  local fontWidth
  local fontHeight
  --Dialogue Box
  local textDialogue
  if not self.scoreComputed then
    textDialogue = "Montre moi que tu sais dessiner le S de Superman"
  else
    if self.scoreGame > self.seuilScore then
      textDialogue = "Perdu. T'es nul !"
    else
      textDialogue = "Bravo. Tu dessines trop bien !"
    end
  end
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", self.gamex0, self.gamey0+self.gameHeight, self.gameWidth,self.height-(self.gamey0+self.gameHeight))
  love.graphics.setColor(1,1,1,1)
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", self.gamex0+2.5, self.gamey0+self.gameHeight, self.gameWidth-5,self.height-(self.gamey0+self.gameHeight))
  love.graphics.setBlendMode("alpha", "alphamultiply")
  fontWidth = font:getWidth(textDialogue)
  fontHeight = font:getHeight(textDialogue)
  love.graphics.printf(textDialogue, self.gamex0 + (self.gameWidth - fontWidth)/2, self.gamey0+self.gameHeight + (self.height-(self.gamey0+self.gameHeight) - fontHeight)/2, 1000 )

  if self.timer < 3 then
    love.graphics.setCanvas(self.gameCanvas)-- Sur le gameCanvas on affiche d'abord le background puis drawingCanvas
    love.graphics.draw(craieBackground)
    --love.graphics.draw(drawingCanvas,width/4, height/4)
    love.graphics.draw(self.exampleCanvas)
    love.graphics.setCanvas() --on repasse sur le canvas de base puis on affiche gameCanvas (la fenetre de jeu)
    love.graphics.draw(self.gameCanvas, self.gamex0, self.gamey0)
  else
    love.graphics.setCanvas(self.gameCanvas)-- Sur le gameCanvas on affiche d'abord le background puis drawingCanvas
    love.graphics.draw(craieBackground)
    --love.graphics.draw(drawingCanvas,width/4, height/4)
    love.graphics.draw(self.drawingCanvas)
    love.graphics.setCanvas() --on repasse sur le canvas de base puis on affiche gameCanvas (la fenetre de jeu)
    love.graphics.draw(self.gameCanvas, self.gamex0, self.gamey0)
    --Bouton Valider
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", self.gamex0+26,self.gamey0+497, 100,50)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", self.gamex0+26+2.5, self.gamey0+497+2.5 , 100,50-5)
    love.graphics.setLineWidth(1)
    love.graphics.setBlendMode("alpha", "alphamultiply")
    fontWidth = font:getWidth("Valider")
    fontHeight = font:getWidth("Valider")
    love.graphics.print("Valider", self.gamex0+26 + (100-fontWidth)/2, self.gamey0+497 + 10 )
    --Bouton Effacer
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", self.gamex0+26,self.gamey0+447, 100,50)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", self.gamex0+26+2.5, self.gamey0+447+2.5 , 100,50-5)
    love.graphics.setLineWidth(1)
    love.graphics.setBlendMode("alpha", "alphamultiply")
    fontWidth = font:getWidth("Effacer")
    fontHeight = font:getWidth("Effacer")
    love.graphics.print("Effacer", self.gamex0+26 + (100-fontWidth)/2, self.gamey0+447 + 10 )
  

    -- Quand on appuie sur la souris on dessine
    if love.mouse.isDown(1) then
      love.graphics.setCanvas(self.drawingCanvas) --On dessine sur drawingCanvas
      love.graphics.setBlendMode("multiply", "premultiplied")
      love.graphics.setColor(0, 0, 0, 0) -- Puisqu'on veut effacer on prend une couleur avec alpha = 0
      self.curx = love.mouse.getX() - self.gamex0 -- Position où le joueur à cliqué. Je comprends pas pk il faut retrancher la position du canvas gameCanvas
      self.cury = love.mouse.getY() - self.gamey0
      love.graphics.ellipse("fill", self.curx,self.cury, self.tailleCrayon, self.tailleCrayon) --On dessine une point assez large à cet endroit
      love.graphics.setLineWidth( 2*self.tailleCrayon ) 
      love.graphics.setLineStyle( "smooth" )
      love.graphics.line(self.prevx, self.prevy, self.curx, self.cury) --On dessine une ligne de même epaisseur pour relier le point où est la souris a celui où elle était avant
      self.prevx = self.curx
      self.prevy = self.cury
      love.graphics.setCanvas()
    end
  end
end


---------------------
-- STATE MANAGEMENT
---------------------
local minigame = JeuDessin()

function Dessin:enteredState()
  love.graphics.setBackgroundColor(0,0,0,1)
  minigame:loadJeuDessin()
  
  cursorImg = love.image.newImageData("assets/img/draw/chalk_shade.png")
  cursor = love.mouse.newCursor(cursorImg)
  love.mouse.setCursor(cursor)
end

function Dessin:mousepressed(x, y, button, istouch)
  minigame.prevx = x - minigame.gamex0
  minigame.prevy = y - minigame.gamey0
  if x > minigame.gamex0+26+2.5 and x < minigame.gamex0+100+2.5 and y > minigame.gamey0+497+2.5 and y < minigame.gamey0+497+45+2.5 then
    score = minigame:compareCanvases()
  end
  if x > minigame.gamex0+26+2.5 and x < minigame.gamex0+100+2.5 and y > minigame.gamey0+447+2.5 and y < minigame.gamey0+447+45+2.5 then
    minigame:resetDessin()
  end
end

function Dessin:update(dt)
  minigame:updateJeuDessin(dt)
end

function Dessin:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(1)
  love.graphics.setBlendMode("alpha", "alphamultiply")
  minigame:drawJeuDessin()
end

function Dessin:keypressed(key, code)
  if key == 'escape' then
      love.mouse.setCursor()
      self:popState("Dessin")
  elseif key == 'p' then
      self:pushState("Pause")
  elseif key == 'r' then
      minigame:reset()
  end
end
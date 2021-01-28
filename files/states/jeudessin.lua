function loadJeuDessin()
  width, height, flags = love.window.getMode( )
  widthCraie = 1280
  heightCraie = 720

  gameWidth = width*0.66
  gameHeight = height*0.66
  gamex0 = (width - gameWidth)/2
  gamey0 = (height-gameHeight)/2
  gameCanvas = love.graphics.newCanvas(gameWidth,gameHeight)
  drawingCanvas = love.graphics.newCanvas(gameWidth,gameHeight)
  craieBackground = love.graphics.newImage("../assets/craieback.png")

  love.graphics.setCanvas(drawingCanvas)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0,0,gameWidth,gameHeight)
  love.graphics.setCanvas()

end

function updateJeuDessin()
  -- if timer < 5 then
  --   love.graphics.setCanvas(drawingCanvas)
  --   love.graphics.setBlendMode("multiply", "premultiplied")
  --   love.graphics.setColor(1, 0, 0, 1)
  --   love.graphics.ellipse("fill", gamex0,gamey0, 1, 1)
  -- end

  if love.mouse.isDown(1) then
    love.graphics.setCanvas(drawingCanvas)
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(0, 0, 0, 0)
    curx = love.mouse.getX() - gamex0
    cury = love.mouse.getY() - gamey0
    love.graphics.ellipse("fill", curx,cury, 5, 5)
    love.graphics.setLineWidth( 10 )
    love.graphics.setLineStyle( "smooth" )
    love.graphics.line(prevx, prevy, curx, cury)
    prevx = curx
    prevy = cury
    love.graphics.setCanvas()
  end
end

function drawJeuDessin()
  love.graphics.setCanvas(gameCanvas)
  love.graphics.draw(craieBackground, 0,0, 0, 0.5, 0.5)
  --love.graphics.draw(drawingCanvas,width/4, height/4)
	love.graphics.draw(drawingCanvas)
	love.graphics.setCanvas()
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

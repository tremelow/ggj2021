--! file: Soccer.lua
local Soccer = Game:addState("soccer")

Object = require(".src.Classic")

-- THIS IS NOT THE SAME PLAYER CLASS AS IN MAIN GAME
-- THIS CLASS IS LOCAL ONLY TO THIS MINIGAME
local SoccerGame = Object:extend()
local Ball = Object:extend()
local Player = Object:extend()

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

local GRAVITY = 800

local SCORE = 0
local GAME_OVER = false

-----------------------
-- VECTOR HELPER OBJECT
-----------------------
local Vector = Object:extend()

function Vector:new(x,y)
    self.x = x
    self.y = y
end

function Vector:add(U)
    return Vector(self.x + U.x, self.y + U.y)
end

function Vector:prod(s)
    return Vector(s * self.x, s * self.y)
end

function Vector:dot(U)
    return self.x * U.x + self.y * U.y
end

function Vector:norm()
    return math.sqrt(self:dot(self))
end

function Vector:unit()
    norm = self:norm()
    return Vector(self.x/norm, self.y/norm)
end

function Vector:conjugate()
    return Vector(- self.y, self.x)
end

---------------------
-- PLAYER
-----------------
local PLAYER_WIDTH = 130
local PLAYER_HEIGHT = 180
local PLAYER_JUMP = 200
local PLAYER_SPEED = 800
local PLAYER_HEAD_RADIUS = 40
-- Player Sprite
local PLAYER_SPRITE = love.graphics.newImage("assets/papyrus.png")

function Player:new()
    -- Position and radius
    self.x = WINDOW_WIDTH / 2
    self.y = WINDOW_HEIGHT - PLAYER_HEIGHT

    -- Velocity
    self.vx = 0
    self.vy = 0
end

function Player:getHeadCenter()
    xr = self.x + PLAYER_WIDTH / 2
    yr = self.y + PLAYER_HEAD_RADIUS
    return xr, yr
end

function Player:update(dt)

    colx=1
    -- Update player location
    if love.keyboard.isDown("d") then
        self.x = self.x + PLAYER_SPEED * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - PLAYER_SPEED * dt
    end

    self.vy = self.vy + GRAVITY * dt
    if (self.y + PLAYER_HEIGHT == WINDOW_HEIGHT) then
        self.vy = 0
    end
    
    if (self.y + PLAYER_HEIGHT > WINDOW_HEIGHT - 3) and love.keyboard.isDown("w") then
        self.vy = - PLAYER_JUMP
    end

    self.x = math.min(math.max(0, self.x), WINDOW_WIDTH  - PLAYER_WIDTH)
    self.y = math.min(WINDOW_HEIGHT - PLAYER_HEIGHT, self.y + self.vy * dt)

end

function Player:draw()
    -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    scalex = PLAYER_WIDTH / PLAYER_SPRITE:getWidth()
    scaley = PLAYER_HEIGHT / PLAYER_SPRITE:getHeight()

    -- Draw image to scale
    love.graphics.draw(PLAYER_SPRITE, self.x, self.y, 0, scalex, scaley)
end

---------------------
-- Ball
-----------------
local BALL_RADIUS = 30
local isCollision = false
local computeCollision = true

function Ball:new(x,y)
    -- Position and radius
    self.x = x
    self.y = y

    -- velocity
    self.vx = - 100 + 200 * math.random()
    self.vy = - 500
end

function Ball:checkWallCollision(colx, coly)
    if self.x <= BALL_RADIUS or self.x + BALL_RADIUS >= WINDOW_WIDTH then
        colx = - 0.9 * colx
    end
    if self.y + BALL_RADIUS >= WINDOW_HEIGHT then
        coly = - 0.9 * coly
    end
    return colx, coly
end

function Ball:UpdatePlayerCollision(player)
    -- Get Player head position and speed
    px, py = player:getHeadCenter()
    pvx = player.vx
    pvy = player.vy

    -- Vector between ball center and head center - VC
    VC = Vector(px - self.x, py - self.y)
    -- Player velocity
    headVelocity = Vector(pvx, pvy)
    -- Ball velocity before collision
    ballVelocity = Vector(self.vx, self.vy)
    -- If collision detected
    if VC:norm() < BALL_RADIUS + PLAYER_HEAD_RADIUS then
        isCollision = true
    else
        isCollision = false
    end   

    if isCollision and computeCollision then
        -- Update score only if the ball is falling
        if not GAME_OVER then
            SCORE = SCORE + 1
        end
        computeCollision = false
        -- VC -> VC_unit -> VC_unit_conjugate 
        conj = VC:unit():conjugate()
        -- project ball velocity onto VC_unit_conjugate and use this value to scale 
        conj = conj:prod(conj:dot(ballVelocity))
        -- New ball velocity is twice the previous vector minus the ball velocity
        ballVelocity = conj:prod(2):add(ballVelocity:prod(-1))
        -- We add the head velocity to the ball velocity
        ballVelocity = ballVelocity:add(headVelocity)
    end

    if not isCollision and not computeCollision then
        isCollision = false
        computeCollision = true
    end
    -- Return the velocity (unchanged if no collision)
    return ballVelocity
end

function Ball:update(dt, playe)

    colx=1
    coly=1

    self.vy = self.vy + GRAVITY * dt

    colx, coly = self:checkWallCollision(colx, coly)
    self.vx = colx * self.vx
    self.vy = coly * self.vy

    newVelocity = self:UpdatePlayerCollision(playe)
    self.vx = newVelocity.x
    self.vy = newVelocity.y

    self.x = math.min(
                math.max(BALL_RADIUS, self.x + self.vx * dt),
                WINDOW_WIDTH - BALL_RADIUS)
    self.y = math.min(WINDOW_HEIGHT - BALL_RADIUS, self.y + self.vy * dt)
    -- self.x = self.x + self.vx * dt
    -- self.y = self.y + self.vy * dt

    if self.y == WINDOW_HEIGHT - BALL_RADIUS then
        GAME_OVER = true
    end
end

function Ball:draw()
    love.graphics.circle('fill', self.x, self.y, BALL_RADIUS)
end


---------------------
-- SOCCER GAME
-----------------

function SoccerGame:new()
    -- Init ball
    self.ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 30)
    self.player = Player()
end

function SoccerGame:reset()
    -- Init ball
    self.ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 30)
    self.player = Player()

    -- Reset Score
    SCORE = 0
    GAME_OVER = false
end

function SoccerGame:update(dt)
    if love.keyboard.isDown("r") then
        self:reset()
    end
    -- Update player
    self.player:update(dt)

    -- Update ball
    self.ball:update(dt, self.player)
end

function SoccerGame:draw()
    self.ball:draw()
    self.player:draw()
    
    -- SCORE
    love.graphics.rectangle("line", 20, 20, 140, 50)
    love.graphics.print("SCORE - ", 21, 20)
    love.graphics.print(SCORE, 120, 20)
    if GAME_OVER then
        love.graphics.print("GAME OVER", 21, 40)
    end
end

---------------------
-- STATE MANAGEMENT
---------------------
local minigame = SoccerGame()

function Soccer:enteredState()    
end

function Soccer:update(dt)
    minigame:update(dt)
end

function Soccer:draw()
    minigame:draw()
end

function Soccer:keypressed(key, code)
    if key == 'escape' then
        self:popState("soccer")
    end
    if key == 'r' then
        minigame:reset()
    end 
end
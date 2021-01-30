--! file: Soccer.lua
local MiniGame = Game:addState("Soccer")

local Vector = require("src.utils.vector")

-- THIS IS NOT THE SAME PLAYER CLASS AS IN MAIN GAME
-- THIS CLASS IS LOCAL ONLY TO THIS MINIGAME
local Ball = class("Ball")
local Player = class("Player")

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

local GRAVITY = 800

local SCORE = 0
local GAME_OVER = false

---------------------
-- PLAYER
-----------------
local PLAYER_WIDTH = 140
local PLAYER_HEIGHT = 150
local PLAYER_JUMP = 200
local PLAYER_SPEED = 800
local PLAYER_HEAD_RADIUS = PLAYER_WIDTH / 2
local OFFSET = 10
-- Player Sprite
local PLAYER_SPRITE = love.graphics.newImage("/assets/img/football/theodule_head.png")


function Player:initialize()
    -- Position
    self.x = WINDOW_WIDTH / 2
    self.y = WINDOW_HEIGHT - PLAYER_HEIGHT - OFFSET

    -- Velocity
    self.vx = 0
    self.vy = 0
end

function Player:getHeadCenter()
    xr = self.x + PLAYER_WIDTH / 2
    yr = self.y + PLAYER_HEIGHT / 2
    return xr, yr
end

function Player:update(dt)

    colx=1
    -- Update player location
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        self.vx = PLAYER_SPEED
    elseif love.keyboard.isDown("q") or love.keyboard.isDown("left") then
        self.vx = - PLAYER_SPEED
    else
        self.vx = 0
    end

    self.x = self.x + self.vx * dt
    self.vy = self.vy + GRAVITY * dt
    if (self.y + PLAYER_HEIGHT == WINDOW_HEIGHT - OFFSET ) then
        self.vy = 0
    end
    
    if (self.y + PLAYER_HEIGHT > WINDOW_HEIGHT - OFFSET - 3) and (love.keyboard.isDown("z", "up", "space")) then
        self.vy = - PLAYER_JUMP
    end

    self.x = math.min(math.max(0, self.x), WINDOW_WIDTH  - PLAYER_WIDTH)
    self.y = math.min(WINDOW_HEIGHT - PLAYER_HEIGHT - OFFSET, self.y + self.vy * dt)
end

function Player:draw(ball)
    local direction = 1
    if self.x + PLAYER_WIDTH/2 < ball.x then
        direction = -1
    else
        direction = 1
    end

    -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    scalex = PLAYER_WIDTH / PLAYER_SPRITE:getWidth() * direction
    scaley = PLAYER_HEIGHT / PLAYER_SPRITE:getHeight()

    -- Draw image to scale
    love.graphics.draw(PLAYER_SPRITE,
        self.x + (1 - direction) * PLAYER_WIDTH / 2,
        self.y,
        0,
        scalex, scaley)
end

---------------------
-- Ball
-----------------
local BALL_RADIUS = 50
local BALL_SPRITE = love.graphics.newImage("assets/img/football/football.png")

local isCollision = false
local computeCollision = true
 

function Ball:initialize(x,y)
    -- Position of the ball center
    self.x = x
    self.y = y

    -- Ball angle
    self.angle = 0

    -- velocity
    self.vx = - 100 + 200 * math.random()
    self.vy = - 500
    self.w = -10 + 20 * math.random() -- rotation
end

function Ball:checkWallCollision(colx)
    if self.x <= BALL_RADIUS or self.x + BALL_RADIUS >= WINDOW_WIDTH then
        colx = - 0.9 * colx
        self.w = - 0.9 * self.w
    end
    return colx
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
        conj = VC:unit():perp()
        -- project ball velocity onto VC_unit_conjugate and use this value to scale 
        conj = conj:prod(conj:dot(ballVelocity))
        -- New ball velocity is twice the previous vector minus the ball velocity
        ballVelocity = conj:prod(2):add(ballVelocity:prod(-1))
        -- Damping
        ballVelocity = ballVelocity:prod(0.8)
        -- We add the head velocity to the ball velocity
        ballVelocity = ballVelocity:add(headVelocity)

        -- New angular rotation
        self.w = -10 + 20 * math.random()
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

    self.angle = self.angle + self.w * dt
    self.vy = self.vy + GRAVITY * dt

    colx = self:checkWallCollision(colx)
    self.vx = colx * self.vx

    newVelocity = self:UpdatePlayerCollision(playe)
    self.vx = newVelocity.x
    self.vy = newVelocity.y

    self.x = math.min(
                math.max(BALL_RADIUS, self.x + self.vx * dt),
                WINDOW_WIDTH - BALL_RADIUS)
    self.y = self.y + self.vy * dt
    -- self.x = self.x + self.vx * dt
    -- self.y = self.y + self.vy * dt

    if self.y > WINDOW_HEIGHT + BALL_RADIUS then
        GAME_OVER = true
    end
end

function Ball:draw()
    -- Scaling parameters to fit image in a DIAMETER x DIAMETER box
    scalex = BALL_RADIUS * 2 / BALL_SPRITE:getWidth()
    scaley = BALL_RADIUS * 2 / BALL_SPRITE:getHeight()

    -- Draw image to scale
    -- love.graphics.circle('fill', self.x, self.y, BALL_RADIUS)
    love.graphics.draw(BALL_SPRITE,
        (self.x),
        (self.y),
        self.angle,
        scalex, scaley,
        BALL_RADIUS*2, BALL_RADIUS*2
    )
end

---------------------
-- GAME MANAGEMENT
---------------------

function MiniGame:enteredState()
    self.background_img = love.graphics.newImage("assets/img/football/foot.png")
     --music 
    self.source = love.audio.newSource("assets/audio/minigame.wav", "stream")
    self.source:isLooping(true)
    love.audio.play(self.source)
    self:reset()
end

function MiniGame:reset()
    -- Init ball
    self.ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 30)
    self.player = Player()

    -- Reset Score
    SCORE = 0
    GAME_OVER = false
end

function MiniGame:update(dt)
    if love.keyboard.isDown("r") then
        self:reset()
    end
    -- Update player
    self.player:update(dt)

    -- Update ball if not game over
    if not GAME_OVER then
        self.ball:update(dt, self.player)
    end
end

function MiniGame:draw()
    -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    scalex = WINDOW_WIDTH / self.background_img:getWidth()
    scaley = WINDOW_HEIGHT / self.background_img:getHeight()

    -- Draw image to scale
    love.graphics.draw(self.background_img, 0, 0, 0, scalex, scaley)

    --Draw Ball and player
    self.ball:draw()
    self.player:draw(self.ball)
    
    -- SCORE
    love.graphics.rectangle("line", 20, 20, 140, 50)
    love.graphics.print("SCORE - ", 21, 20)
    love.graphics.print(SCORE, 120, 20)
    if GAME_OVER then
        love.graphics.print("GAME OVER", 21, 40)
    end
end

function MiniGame:keypressed(key, code)
    if key == 'escape' then
        self.source:stop()
        self:popState("Soccer")
    elseif key == 'p' then
        self:pushState("Pause")
    elseif key == 'r' then
        self:reset()
    end
end
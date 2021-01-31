--! file: billes.lua
local MiniGame = Game:addState("Billes")

local Vector = require("src.utils.vector")

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

local TRIES = 4
local GAME_OVER = false

---------------------
-- Bille
-----------------
local Bille = class("Bille")

local DRAG = 1
local BALL_RADIUS = 40
local SPRITE_PATH = "/assets/img/billes/bille"

local isCollision = false
local computeCollision = true

function Bille:initialize(x,y, sprite)
    -- Position of the ball center
    self.x = x
    self.y = y

    -- Ball angle
    self.angle = 0

    -- velocity
    self.vx = 0
    self.vy = 0
    self.w  = 0

    self.sprite = love.graphics.newImage(SPRITE_PATH .. sprite)
end

function Bille:update(dt)
    self.vx = self.vx * DRAG
    self.vy = self.vy * DRAG
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Bille:draw()
    -- Draw image to scale

    love.graphics.draw(self.sprite,
        (self.x - BALL_RADIUS),
        (self.y - BALL_RADIUS),
        self.angle
    )
end

function Bille:isOut(dt)
    if (self.x - BALL_RADIUS > WINDOW_WIDTH or self.x + BALL_RADIUS < 0
        or self.y + BALL_RADIUS < 0 or self.y - BALL_RADIUS > WINDOW_HEIGHT) then
        return true
    else
        return false
    end
end

function Bille:setV(vect)
    self.vx = vect.x
    self.vy = vect.y
end    

-------------------------
-- PLAYER BILLE
--------------------------
-- Subclass bille
PlayerBille = class("PlayerBille", Bille)

function PlayerBille:UpdateCollision(other)
    -- Vector between ball center and head center - VC
    VC = Vector(other.x - self.x, other.y - self.y)
    -- Player velocity
    otherVelocity = Vector(other.vx, other.vy)
    -- Ball velocity before collision
    ballVelocity = Vector(self.vx, self.vy)
    -- If collision detected
    if VC:norm() < 2 * BALL_RADIUS then
        isCollision = true
    else
        isCollision = false
    end   

    if isCollision and computeCollision then
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
        ballVelocity = ballVelocity:add(otherVelocity)

        -- Modifiy other Velocity
        otherNewVelocity = VC:unit():prod(ballVelocity:norm())
        other:setV(otherNewVelocity)
    end

    if not isCollision and not computeCollision then
        isCollision = false
        computeCollision = true
    end



    -- Return the velocity (unchanged if no collision)
    return ballVelocity
end

function PlayerBille:update(dt, other)

    newVelocity = self:UpdateCollision(other)
    self.vx = newVelocity.x
    self.vy = newVelocity.y

    self.vx = self.vx * DRAG
    self.vy = self.vy * DRAG

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

end

---------------------
--  ARROW
---------------------
local Arrow = class("Arrow")

local ARROW_ANGLE_RANGE = 60
local ARROW_ANGLE_SPEED = 70

local ARROW_POWER_MIN = 100
local ARROW_POWER_MAX = 200
local ARROW_POWER_SPEED = 100

function Arrow:initialize(x, y)
    self.ox = x
    self.oy = y
    self.angle = 0
    self.power = ARROW_POWER_MIN
    self.direction = 1
end   

function Arrow:update(dt, phase, ball)
    if phase == 'aim' then
        self.angle = self.angle + dt * self.direction * ARROW_ANGLE_SPEED
        if math.abs(self.angle) > ARROW_ANGLE_RANGE then
           self.direction = - self.direction 
        end
    elseif phase == 'charge' then
        self.power = self.power + dt * self.direction * ARROW_POWER_SPEED
        if self.power > ARROW_POWER_MAX or self.power < ARROW_POWER_MIN then
            self.direction = - self.direction
        end

        ball:setV(
            Vector(
                - self.power * math.sin(self:rad_angle()),
                - self.power * math.cos(self:rad_angle())
            ):prod(10)
        )
    end
end

function Arrow:rad_angle()
    return self.angle * 2 * 3.1415 / 360
end


function Arrow:draw()
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(10)
    love.graphics.line(
        self.ox - (BALL_RADIUS + 20) * math.sin(self:rad_angle()),
        self.oy - (BALL_RADIUS + 20) * math.cos(self:rad_angle()),
        self.ox - self.power * math.sin(self:rad_angle()),
        self.oy - self.power * math.cos(self:rad_angle())
    )
end
---------------------
-- STATE MANAGEMENT
---------------------
local background_img = love.graphics.newImage("assets/img/billes/space.jpg")

local GAME_STOP = true
local GAME_OVER = false
local TRIES = 4

function MiniGame:drawWelcome()
    if TRIES > 1 then
        love.graphics.printf("J'ai encore "..TRIES.." billes !", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    else
        love.graphics.printf("C'est la dernière bille que m'ont prêté mes amis ! \n Je ne dois pas les décevoir ! ", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    end
end

function MiniGame:drawOutcome()
    
    if self.player:isOut() then
        love.graphics.printf("Raté !", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    end
    if self.target:isOut() then
        love.graphics.printf("Oui ! J'ai gagné ", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    end
end

function MiniGame:resolve()
    if self.target:isOut() then
        -- If already won
        if Hero.advancement[self.pnj_id] == "minigame_won" then
            self:pushState("Dialog", self.pnj_id, "victory_not_first")
        else
            -- First win
            Hero.advancement[self.pnj_id] = "minigame_won"
            Hero.advancement[self.unlock] = "pres_minigame"
            self:pushState("Dialog", self.pnj_id, "victory_first")
        end
    elseif TRIES < 1 then
        self:pushState("Dialog", self.pnj_id, "defeat")
    end
    if TRIES < 1 or self.target:isOut() then 
        minigameMusic:stop()
        overworldMusic:play()
        currentMusic = overworldMusic
        self:popState("Billes")
    else
        self:replace()
    end
end

function MiniGame:reset()
    TRIES = 4
    self:replace()
end

function MiniGame:replace()
    self.target = Bille(WINDOW_WIDTH/2, WINDOW_HEIGHT / 6, "_emilie.png")
    self.player = PlayerBille(WINDOW_WIDTH/5 + 3/5 * WINDOW_WIDTH * math.random(),
                        WINDOW_HEIGHT * 5/6,
                        TRIES ..".png"
                    )
    self.arrow = Arrow(self.player.x, self.player.y)

    self.phase = 'init'
    GAME_STOP = false
end

function MiniGame:enteredState(name, unlock)
    self:reset() 
     --music 
    currentMusic:stop()
    minigameMusic:play()
    currentMusic = minigameMusic
    self.pnj_id = name
    self.unlock = unlock
end


function MiniGame:update(dt)
    if self.phase == 'aim' then
        self.arrow:update(dt, self.phase)
    elseif self.phase == 'charge' then
        self.arrow:update(dt, self.phase, self.player)
    elseif not GAME_STOP then
        -- print(self.player.vx, self.player.vy)
        self.player:update(dt, self.target)
        self.target:update(dt)
        if self.player:isOut() or self.target:isOut() then
            GAME_STOP = true
        end
    end
end

function MiniGame:nextPhase()
    if self.phase == 'init' then
        self.phase = 'aim'
    elseif self.phase == 'aim' then
        self.phase = 'charge'
    elseif self.phase == 'charge' then
        self.phase = 'shoot'
        TRIES = TRIES - 1
    end
end

function MiniGame:draw()
    font = love.graphics.newFont(37)
    love.graphics.setFont(font)
    -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    scalex = WINDOW_WIDTH / background_img:getWidth()
    scaley = WINDOW_HEIGHT / background_img:getHeight()

    -- Draw image to scale
    love.graphics.draw(background_img, 0, 0, 0, scalex, scaley)
    if self.phase == 'init' then
        self:drawWelcome()
    end
    
    self.player:draw()
    self.target:draw()
    if self.phase == 'aim' or self.phase == 'charge' then
        self.arrow:draw()
    end

    if GAME_STOP then
        self:drawOutcome()
    end

    font = love.graphics.newFont(20)
end

function MiniGame:keypressed(key, code)
    if key == 'escape' then
        self:popState("Billes")
        minigameMusic:stop()
        overworldMusic:play()
        currentMusic = overworldMusic
    elseif key == 'p' then
        minigameMusic:pause()
        self:pushState("Pause")
    elseif key == 'r' then
        self:reset()
    elseif GAME_STOP and key == 'space' then
        self:resolve()
    elseif key == 'space' then
        self:nextPhase()
    end 
end
--! file: billes.lua
local MiniGame = Game:addState("Billes")

local Vector = require("src.utils.vector")

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

local SCORE = 0
local GAME_OVER = false

---------------------
-- Bille
-----------------
local Bille = class("Bille")

local DRAG = 1
local BALL_RADIUS = 40
-- local BALL_SPRITE = love.graphics.newImage("assets/img/football/football.png")

local isCollision = false
local computeCollision = true

function Bille:initialize(x,y)
    -- Position of the ball center
    self.x = x
    self.y = y

    -- Ball angle
    self.angle = 0

    -- velocity
    self.vx = 0
    self.vy = 0
    self.w  = 0
end

function Bille:update(dt)
    self.vx = self.vx * DRAG
    self.vy = self.vy * DRAG
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Bille:draw()
    -- -- Scaling parameters to fit image in a DIAMETER x DIAMETER box
    -- scalex = BALL_RADIUS * 2 / BALL_SPRITE:getWidth()
    -- scaley = BALL_RADIUS * 2 / BALL_SPRITE:getHeight()

    -- Draw image to scale
    love.graphics.circle('fill', self.x, self.y, BALL_RADIUS)
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
local background_img = love.graphics.newImage("assets/img/billes/asphalt.jpg")

local GAME_OVER = false
local GAME_WON = false

function MiniGame:reset()
    self.target = Bille(WINDOW_WIDTH/2, WINDOW_HEIGHT / 6)
    self.player = PlayerBille(WINDOW_WIDTH/5 + 3/5 * WINDOW_WIDTH * math.random(),
                        WINDOW_HEIGHT * 5/6
                    )
    self.arrow = Arrow(self.player.x, self.player.y)
    GAME_OVER = false
    GAME_WON = false
    self.phase = 'aim'
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
    if self.player:isOut() then
        GAME_OVER = true
    end
    if self.target:isOut() then
        GAME_WON = true
    end

    if GAME_OVER then
        if GAME_WON then
            -- If already won
            if Hero.advancement[self.pnj_id] == "minigame_won" then
                self:pushState("Dialog", self.pnj_id, "victory_not_first")
            else
                -- First win
                Hero.advancement[self.pnj_id] = "minigame_won"
                Hero.advancement[self.unlock] = "pres_minigame"
                self:pushState("Dialog", self.pnj_id, "victory_first")
            end
        else
            self:pushState("Dialog", self.pnj_id, "defeat")
        end
        minigameMusic:stop()
        overworldMusic:play()
        currentMusic = overworldMusic
        self:popState("Billes")
    end

    if self.phase == 'aim' then
        self.arrow:update(dt, self.phase)
    elseif self.phase == 'charge' then
        self.arrow:update(dt, self.phase, self.player)
    elseif not GAME_OVER or not GAME_WON then
        -- print(self.player.vx, self.player.vy)
        self.player:update(dt, self.target)
        self.target:update(dt)
    end
end

function MiniGame:nextPhase()
    if self.phase == 'aim' then
        self.phase = 'charge'
    elseif self.phase == 'charge' then
        self.phase = 'shoot'
    end
end

function MiniGame:draw()
    -- -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    -- scalex = WINDOW_WIDTH / background_img:getWidth()
    -- scaley = WINDOW_HEIGHT / background_img:getHeight()

    -- -- Draw image to scale
    -- love.graphics.draw(background_img, 0, 0, 0, scalex, scaley)
    
    self.player:draw()
    self.target:draw()
    if self.phase == 'aim' or self.phase == 'charge' then
        self.arrow:draw()
    end

    if GAME_OVER then
        love.graphics.print("GAME OVER", 20, 20)
        if GAME_WON then
            love.graphics.print("YOU WIN", 20, 40)
        else
            love.graphics.print("YOU LOSE", 20, 40)
        end
    end
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
    elseif key == 'space' then
        self:nextPhase()
    end 
end
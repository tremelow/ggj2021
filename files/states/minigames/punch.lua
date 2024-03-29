--! file: billes.lua
local MiniGame = Game:addState("Punch")

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

--Asset Folder
local ASSET_FOLDER = "assets/img/punchingball/"

TARGET_SCORE = 0.1

-----------------------
-- Punching Ball
------------------------
local PunchingBall = class("PunchingBall")
local PB_RADIUS = WINDOW_HEIGHT / 6

function PunchingBall:initialize()
	self.back = love.graphics.newImage(ASSET_FOLDER .. "background.png")
    self.img = love.graphics.newImage(ASSET_FOLDER .. "punchingball_1.png")
end

function PunchingBall:update(dt)
end

function PunchingBall:draw(dt)
	love.graphics.draw(self.back)
    love.graphics.draw(self.img, 
        WINDOW_WIDTH/2 - self.img:getWidth()/2,
        WINDOW_HEIGHT * 2/ 5 - self.img:getHeight()/2)
end

-----------------------
-- Power Bar
------------------------
local PowerBar = class("Power Bar")

POWER_MAX = 100
DISCHARGE_RATE = 50
CHARGE_AMOUNT = 9

function PowerBar:initialize()
    self.power = 0
    self.sbam = love.graphics.newImage(ASSET_FOLDER .. "sbam_1.png")
    self.bbam = love.graphics.newImage(ASSET_FOLDER .. "bbam_1.png")
end

function PowerBar:charge()
    self.power = self.power + CHARGE_AMOUNT
end

function PowerBar:score()
    return math.min(POWER_MAX, self.power) / POWER_MAX
end

function PowerBar:update(dt)
    self.power = self.power - DISCHARGE_RATE * dt
    self.power = math.max(0, self.power)
end

function PowerBar:draw(punch)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line",
        WINDOW_WIDTH / 4,
        WINDOW_HEIGHT * 6/8,
        WINDOW_WIDTH / 2,
        WINDOW_HEIGHT * 1/16
    )
    
    love.graphics.setColor(0.2, 1, 0.2)
    love.graphics.rectangle("fill",
        WINDOW_WIDTH / 4,
        WINDOW_HEIGHT * 6/8,
        WINDOW_WIDTH / 2 * math.min(POWER_MAX,self. power) / POWER_MAX,
        WINDOW_HEIGHT * 1/16
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("...",
        WINDOW_WIDTH / 4, WINDOW_HEIGHT * 6/8 - 60)
    love.graphics.print("pas mal !",
        WINDOW_WIDTH / 2, WINDOW_HEIGHT * 6/8 - 60)
    love.graphics.print("wouah !",
        WINDOW_WIDTH * 6 / 8, WINDOW_HEIGHT * 6/8 - 60)

        
    love.graphics.printf("Concentre ta force dans ton poing !",
    0 , WINDOW_HEIGHT*14/16 + 20 , WINDOW_WIDTH, 'center')


    
    if punch then
        if self:score() < 0.7 then
            love.graphics.draw(self.sbam, 
                WINDOW_WIDTH/2 - self.sbam:getWidth()/2,
                WINDOW_HEIGHT * 2/ 5 - self.sbam:getHeight()/2)
        else 
            love.graphics.draw(self.bbam, 
                WINDOW_WIDTH/2 - self.bbam:getWidth()/2,
                WINDOW_HEIGHT * 2/ 5 - self.bbam:getHeight()/2)
        end
    end
end

---------------------
-- STATE MANAGEMENT
---------------------

function MiniGame:reset()
    self.bar = PowerBar()
    self.punching_ball = PunchingBall()

    self.timer = 5
    self.bam = false

    self.GAME_START = false
    GAME_OVER  = false
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

function MiniGame:drawOutcome()
    --love.graphics.setColor(0.3,0.3, 1)
    -- love.graphics.rectangle("fill", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, WINDOW_WIDTH/5)
    if self.bar:score() > TARGET_SCORE then
        love.graphics.printf("Wouah Trop fort ! !", WINDOW_WIDTH/4, WINDOW_HEIGHT/12, WINDOW_WIDTH/2, 'center')
    else
        love.graphics.printf("T'as pas le niveau !", WINDOW_WIDTH/4, WINDOW_HEIGHT/12, WINDOW_WIDTH/2, 'center')
    end
    love.graphics.setColor(1,1, 1)
end


function MiniGame:resolve()
    if self.bar:score() > TARGET_SCORE then
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
    self:popState("Punch")
end


function MiniGame:update(dt)

    if self.GAME_START then
        self.bar:update(dt)
        self.timer = self.timer - dt
    end

    if self.timer <= 0 then
        self.timer = self.timer - dt
        self.GAME_START = false
        self.bam = true
    end

    if self.timer <= -1 then
        GAME_OVER = true
    end

    Talkies.update(dt)
end


function MiniGame:draw()
    
    self.punching_ball:draw()
    love.graphics.setColor(1, 1, 1)


    self.bar:draw(self.bam)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("TIME LEFT - " .. string.format("%.1f", math.max(0,self.timer)), 22, 30)

    font = love.graphics.newFont(37)
    love.graphics.setFont(font)

    if GAME_OVER then
        self:drawOutcome()
    end

    font = love.graphics.newFont(16)


end

function MiniGame:keypressed(key, code)
    if key == 'escape' then
        minigameMusic:stop()
        overworldMusic:play()
        currentMusic = overworldMusic
        self:popState("Punch")
    elseif key == 'p' then
        minigameMusic:pause()
        self:pushState("Pause")
    elseif key == 'r' then
        self:reset()
    elseif GAME_OVER and key == "space" then
        self:resolve()
    elseif key == 'space' and self.timer > 0 then
        self.GAME_START = true
        self.bar:charge()
    end 
end
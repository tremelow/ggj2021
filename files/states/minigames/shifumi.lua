--! file: billes.lua
local MiniGame = Game:addState("Shifumi")

-- Window dimensions
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

local PLAYER_SCORE = 0
local OPPONENT_SCORE
local GAME_OVER = false
local GAME_WON = false


local TILE_FOLDER = "assets/img/shifumi/"
local TILE_HEIGHT = WINDOW_HEIGHT / 4
local N_TILES = 3

---------------------
-- Tiles
-----------------
local Tile = class("Tile")

function Tile:initialize(image, pos)
    self.img = love.graphics.newImage(TILE_FOLDER .. image)
    
    self.pos = pos
    self.highlight = false
end

function Tile:update(dt)
end

function Tile:draw(select)   
    -- Scaling parameters to fit image in a TILE_HEIGHT x TILE_HEIGHT box
    scale = TILE_HEIGHT / self.img:getHeight()
    
    if select == self.pos then
        love.graphics.rectangle("fill",
            WINDOW_WIDTH/N_TILES * self.pos - WINDOW_WIDTH/N_TILES/2 - TILE_HEIGHT/2 - 10,
            WINDOW_HEIGHT - TILE_HEIGHT - 20,
            TILE_HEIGHT + 20,
            TILE_HEIGHT + 40
        )
    end

    -- Draw image to scale
    love.graphics.draw(self.img,
        WINDOW_WIDTH/N_TILES * self.pos - WINDOW_WIDTH/N_TILES/2 - TILE_HEIGHT/2,
        WINDOW_HEIGHT - TILE_HEIGHT - 10,
        0,
        scale, scale
    )
end 

-----------------
-- Players
-----------------
local Player = class("Player")

HAND_WIDTH = WINDOW_WIDTH / 4

function Player:initialize(prefix, pos)
    self.choices = {
        love.graphics.newImage(TILE_FOLDER .. "hand" .. prefix .. "_rock.png"),
        love.graphics.newImage(TILE_FOLDER .. "hand" .. prefix .. "_paper.png"),
        love.graphics.newImage(TILE_FOLDER .. "hand" .. prefix .. "_scissors.png"),
    }
    self.screen_pos = pos
end

function Player:draw(select)
    local img = self.choices[select]
    -- Scaling parameters to fit image in a HAND_HEIGHT x HAND_HEIGHT box
    scale = HAND_WIDTH / img:getWidth()

    -- Draw image to scale
    love.graphics.draw(img,
        WINDOW_WIDTH/2 * self.screen_pos - WINDOW_WIDTH/4 - HAND_WIDTH / 2,
        3/8 * WINDOW_HEIGHT - scale * img:getHeight() / 2,
        0,
        scale, scale
    )
end 

---------------------
-- STATE MANAGEMENT
---------------------
OUTCOMES = {{ 0, -1,  1},
            { 1,  0, -1},
            {-1,  1,  0}}

function MiniGame:reset()
    self.tiles = {
        Tile('rps_rock.png', 1),
        Tile('rps_paper.png', 2),
        Tile('rps_scissors.png', 3),
    }
    self.player = Player("_me", 1)
    self.olga = Player("_olga", 2)

    self.select = -1
    self.me_select = -1
    self.MI = false

    OPPONENT_SCORE = 0
    PLAYER_SCORE = 0

    GAME_OVER = false
    GAME_WON = false
end


function MiniGame:drawOutcome()
    --love.graphics.setColor(0.3,0.3, 1)
    -- love.graphics.rectangle("fill", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, WINDOW_WIDTH/5)
    if PLAYER_SCORE > OPPONENT_SCORE then
        love.graphics.printf("Quel mastermind !", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    else
        love.graphics.printf("Joue mieux !", WINDOW_WIDTH/4, WINDOW_HEIGHT/3, WINDOW_WIDTH/2, 'center')
    end
    love.graphics.setColor(1,1, 1)
end


function MiniGame:resolve()
    minigameMusic:stop()
    overworldMusic:play()
    currentMusic = overworldMusic
    if PLAYER_SCORE > OPPONENT_SCORE then
        -- If already won
        if Hero.advancement[self.pnj_id] == "minigame_won" then
            self:gotoState("Dialog", self.pnj_id, "victory_not_first")
        else
            -- First win
            Hero.advancement[self.pnj_id] = "minigame_won"
            Hero.advancement[self.unlock] = "pres_minigame"
            self:gotoState("Dialog", self.pnj_id, "victory_first")
        end
    else
        self:gotoState("Dialog", self.pnj_id, "defeat")
    end
    -- self:popState("Shifumi")
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
    if PLAYER_SCORE > 2 or OPPONENT_SCORE > 2 then
        GAME_OVER = true
    end
    self.select = MiniGame:mouseSelect()
    Talkies.update(dt)
end

function MiniGame:mouseSelect()
    local mSelect
    for i = 1,3 do
        local x1 = WINDOW_WIDTH/N_TILES * i - WINDOW_WIDTH/N_TILES/2 - TILE_HEIGHT/2 - 10
        local x2 = x1 + TILE_HEIGHT + 20
        local y1 = WINDOW_HEIGHT - TILE_HEIGHT - 20
        local y2 = y1 + WINDOW_HEIGHT - TILE_HEIGHT - 20 + TILE_HEIGHT + 40
        local mx, my = love.mouse.getPosition()
        if mx > x1 and mx < x2 and my > y1 and my < y2 then
            mSelect = i
        end
    end
    return mSelect
end

function MiniGame:nextSelect()
    self.MI = false
    self.select = (self.select + 1 ) % 3 + 1
    self.select = (self.select + 1 ) % 3 + 1
end

function MiniGame:prevSelect()
    self.MI = false
    self.select = (self.select + 1 ) % 3 + 1
end

function MiniGame:Select()
    self.me_select = self.select
    self.ia_select = math.random(1,3)
    self.MI = true
    local outcome = self:outCome()
    if outcome > 0 then
        PLAYER_SCORE = PLAYER_SCORE + 1
    elseif outcome < 0 then
        OPPONENT_SCORE = OPPONENT_SCORE + 1
    end
    self.select = -1
end

function MiniGame:outCome()
    return OUTCOMES[self.select][self.ia_select]
end

function MiniGame:draw()
	love.graphics.draw(love.graphics.newImage(TILE_FOLDER .. "shifumi_back.png"), 160, 0)
    for i,v in ipairs(self.tiles) do
        v:draw(self.select)
    end

    if self.me_select > 0 then
        self.player:draw(self.me_select)
    end 

    -- draw the MI !
    if self.MI then
        self.olga:draw(self.ia_select)
    end

    
    -- Draw Score
    love.graphics.print("Theodule - " .. PLAYER_SCORE, 22, 30)
    love.graphics.print("Olga - " .. OPPONENT_SCORE, WINDOW_WIDTH - 138, 30)

    if GAME_OVER then
        self:drawOutcome()
    end

    -- Talkies
    Talkies.draw()
end

function MiniGame:mousepressed(x, y, button, istouch)
    for i = 1,3 do
        local x1 = WINDOW_WIDTH/N_TILES * i - WINDOW_WIDTH/N_TILES/2 - TILE_HEIGHT/2 - 10
        local x2 = x1 + TILE_HEIGHT + 20
        local y1 = WINDOW_HEIGHT - TILE_HEIGHT - 20
        local y2 = y1 + WINDOW_HEIGHT - TILE_HEIGHT - 20 + TILE_HEIGHT + 40
        local mx, my = love.mouse.getPosition()
        if mx > x1 and mx < x2 and my > y1 and my < y2 then
            self:Select()
        end
    end
end


function MiniGame:keypressed(key, code)
    if key == 'escape' then
        minigameMusic:stop()
        overworldMusic:play()
        currentMusic = overworldMusic
        self:popState("Shifumi")
    elseif GAME_OVER then
        self:resolve()
    elseif key == 'p' then
        minigameMusic:pause()
        self:pushState("Pause")
    elseif key == 'r' then
        self:reset()
    elseif key == 'left' or key == "q" then
        self:prevSelect()
    elseif key == 'right' or key == "d" then
        self:nextSelect()
    elseif key == 'space' and self.select > 0 then
        self:Select()
    else
        self.select = -1
        self.MI = false
    end 
end
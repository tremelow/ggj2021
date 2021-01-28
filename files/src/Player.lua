
Player = Character:extend()

-- LIMITS FOR THE PLAYER
-- TODO ! FIND ADEQUATE LIMITS FOR THE x POSITION
WINDOW_HEIGHT = love.graphics.getHeight()
WINDOW_WIDTH = love.graphics.getWidth()

function Player:new(x,y)
    -- Init Player at position x, y
    Player.super.new(self,x,y)

    -- Player Sprite
    self.image = love.graphics.newImage("assets/papyrus.png")
end

function Player:update(dt)
    -- Update player location
    if love.keyboard.isDown("right") then
        self.x = self.x + self.v * dt
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.v * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.v * dt
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + self.v * dt
    end

    -- Bound the player movement
    self.x = math.max(                  0, self.x)
    self.y = math.min(math.max(WINDOW_HEIGHT * 3/5 - self.HEIGHT, self.y), WINDOW_HEIGHT - self.HEIGHT)
end
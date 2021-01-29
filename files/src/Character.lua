--! file: rectangle.lua

Character = Object:extend()


function Character:new(x,y)
    -- Width and Height of characters (in pixels)
    self.WIDTH = 90
    self.HEIGHT = 180

    -- Speed of character
    self.v = 500

    -- Sprite of character
    self.image = love.graphics.newImage("assets/sheep.png")

    -- Position
    self.x = x 
    self.y = y
end


function Character:draw()

    -- Scaling parameters to fit image in a WIDTH x HEIGHT box
    scalex = self.WIDTH / self.image:getWidth()
    scaley = self.HEIGHT / self.image:getHeight()

    -- Draw image to scale
    love.graphics.draw(self.image, self.x, self.y, 0, scalex, scaley)
end

function Character:isCharacterClose(X)
    -- check whether Hero is close to character
    -- return boolean
    dist = Character.distTo(self, X)
    if dist < self.WIDTH/2 or dist < self.HEIGHT/2 then
        return true
    end
    return false
end

function Character:distTo(other)
    -- Euclidian Distance from the character to another character
    -- (from the center of the bounding box)
    diffCenterX = ((2 * self.x + self.WIDTH) - (2 * other.x + other.WIDTH)) * 0.5
    diffCenterY = ((2 * self.y + self.HEIGHT) - (2 * other.y + other.HEIGHT)) * 0.5
    return math.sqrt(diffCenterX * diffCenterX + diffCenterY * diffCenterY)
end
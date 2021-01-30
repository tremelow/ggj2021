
Player = Character:extend()


-- LIMITS FOR THE PLAYER
-- TODO ! FIND ADEQUATE LIMITS FOR THE x POSITION
WINDOW_HEIGHT = love.graphics.getHeight()
WINDOW_WIDTH = love.graphics.getWidth()

function Player:new(x,y)
  -- Init Player at position x, y
  self.super.new(self,x,y)

  self.direction = {x = 0, y = 0}
  self.orientation = {x = 0, y = -1} -- start facing down

  -- Player Sprite
  local spritePath = "assets/img/characters/theodule.png"
  self.sprite = love.graphics.newImage(spritePath)
  local width = math.floor(self.sprite:getWidth() / 12)
  local height = math.floor(self.sprite:getHeight() / 4)
  local allQuads = Animation:new(self.sprite, width, height, 0.2)

  -- Isolate quad depending on direction/orientation
  self.animation = {}
  self.neutral = {}
  for i, dir in pairs({"E", "SE", "S", "NE", "N", "NW", "W", "SW"}) do
    local indices = {4*(i-1) + 1, 4*(i-1) + 2, 4*(i-1) + 3, 4*i}
    self.animation[dir] = allQuads:isolateQuads(indices)
  end
  for i, dir in pairs({"E", "SE", "S", "SW", "W", "NW", "N", "NE"})do
    self.neutral[dir] = allQuads:isolateQuads({36 + i})
  end
end

function Player:update(dt)
  -- Reset direction
  self.direction.x = 0
  self.direction.y = 0

  -- Update player direction
  if love.keyboard.isDown("d", "right") then
    self.direction.x = 1
  end
  if love.keyboard.isDown("q", "left") then
    self.direction.x = -1
  end
  if love.keyboard.isDown("z", "up") then
    self.direction.y = -1
  end
  if love.keyboard.isDown("s", "down") then
    self.direction.y = 1
  end

  -- Update player orientation if player is moving
  if self.direction.x ~= 0 or self.direction.y ~= 0 then
    self.orientation.x = self.direction.x
    self.orientation.y = self.direction.y
  end

  -- Update player location
  self.x = self.x + self.direction.x * self.v * dt
  self.y = self.y + self.direction.y * self.v * dt

  -- Bound the player movement
  self.x = math.max(                  0, self.x)
  self.y = math.min(math.max(WINDOW_HEIGHT * 3/5 - self.HEIGHT, self.y),
  WINDOW_HEIGHT - self.HEIGHT)

  for _, anim in pairs(self.animation) do
    anim:update(dt)
  end
  for _, anim in pairs(self.neutral) do
    anim:update(dt)
  end
end


function Player:draw()  
  local orientation = ""
  if self.orientation.y == 1 then
    orientation = orientation .. "S"
  elseif self.orientation.y == -1 then
    orientation = orientation .. "N"
  end

  if self.orientation.x == 1 then
    orientation = orientation .. "E"
  elseif self.orientation.x == -1 then
    orientation = orientation .. "W"
  end

  local movement = "animation"
  if self.direction.x == 0 and self.direction.y == 0 then
    movement = "neutral"
  end
  self[movement][orientation]:draw(self.x, self.y)
end
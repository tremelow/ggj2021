Animation = class("Animation"):include(Stateful)

function Animation:initialize(image, width, height, duration)
  self.spriteSheet = image
  self.width = width
  self.height = height
  self.quads = {}


  for y = 0, image:getHeight() - height, height do
    for x = 0, image:getWidth() - width, width do
      table.insert(self.quads,
        love.graphics.newQuad(x, y, width, height, image:getDimensions())
      )
    end
  end

  self.spriteDuration = duration or 0.5
  self.currentTime = 0

end

function Animation:update(dt)
  self.currentTime = self.currentTime + dt
  -- truncate animation total duration
  self.currentTime = self.currentTime % (self.spriteDuration * #self.quads)
end

function Animation:draw(x,y)
  local spriteNum = math.floor(self.currentTime / self.spriteDuration) + 1
  love.graphics.draw(self.spriteSheet, self.quads[spriteNum], x,y)
end

function Animation:isolateQuads(indices)
  local newAnim = Animation:new(self.spriteSheet, self.width, 
                                self.height, self.spriteDuration)
  newAnim.quads = {}
  for _, index in pairs(indices) do
    table.insert(newAnim.quads, self.quads[index])
  end

  return newAnim
end
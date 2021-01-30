PNJ = Character:extend()


function PNJ:new(params)
    -- initialize PNJ
    Player.super.new(self, params.xpos, params.ypos)
    -- give name to the character
    self.name = params.name
    self.minigame = params.game
    -- flag for interaction
    self.highlight = false
    -- messages (sous-bloc "ready" au cas où on voudrait distinguer des
    -- phases de l'histoire)
    self.dialog = params.dialog.ready

    local spritePath = "assets/img/characters/" .. params.sprite
    self.sprite = love.graphics.newImage(spritePath)
    self:initAnimation(self.sprite)
end

function PNJ:initAnimation(sprite)
    local width  = math.floor(sprite:getWidth() / 2)
    local height = sprite:getHeight()
    os.execute("echo " .. width .. " " .. height)
    self.animation = Animation:new(sprite, width, height, 0.25)
    os.execute("echo " .. self.animation.currentTime)
end

function PNJ:update(dt, Hero)
    -- highlight is true if player is close
    self.highlight = PNJ.isCharacterClose(self,Hero)
    self.animation:update(dt)
end

function PNJ:draw()
    -- if highlight draw a box around
    if self.highlight then
        love.graphics.setColor(0.9,0,0)
        love.graphics.rectangle("fill", self.x - 10, self.y - 10, self.WIDTH + 20, self.HEIGHT + 20)
        love.graphics.setColor(1,1,1)

    end

    self.animation:draw(self.x, self.y)
end
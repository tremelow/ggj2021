PNJ = Character:extend()


function PNJ:new(x,y,name)
    -- initialize PNJ
    Player.super.new(self,x,y)
    -- give name to the character
    self.name = name

    -- flag for interaction
    self.highlight = false
end

function PNJ:isPlayerClose(Hero)
    -- check whether Hero is close to character
    -- return boolean
    dist = PNJ.distTo(self, Hero)
    if dist < self.WIDTH/2 or dist < self.HEIGHT/2 then
        return true
    end
    return false
end

function PNJ:update(dt, Hero)
    -- highlight is true if player is close
    self.highlight = PNJ.isPlayerClose(self,Hero)
end

function PNJ:draw()
    -- if highlight draw a box around
    if self.highlight then
        love.graphics.setColor(0.9,0,0)
        love.graphics.rectangle("fill", self.x - 10, self.y - 10, self.WIDTH + 20, self.HEIGHT + 20)
        love.graphics.setColor(1,1,1)
    end
    PNJ.super.draw(self)
end
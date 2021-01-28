PNJ = Character:extend()


function PNJ:new(x,y,name)
    -- initialize PNJ
    Player.super.new(self,x,y)
    -- give name to the character
    self.name = name

    -- flag for interaction
    self.highlight = false
end

function PNJ:update(dt, Hero)
    -- highlight is true if player is close
    self.highlight = PNJ.isCharacterClose(self,Hero)
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
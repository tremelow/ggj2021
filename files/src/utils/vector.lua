-----------------------
-- VECTOR HELPER OBJECT
-----------------------
local Vector = class("Vector")

function Vector:initialize(x,y)
    self.x = x
    self.y = y
end

function Vector:add(U)
    return Vector(self.x + U.x, self.y + U.y)
end

function Vector:prod(s)
    return Vector(s * self.x, s * self.y)
end

function Vector:dot(U)
    return self.x * U.x + self.y * U.y
end

function Vector:norm()
    return math.sqrt(self:dot(self))
end

function Vector:unit()
    norm = self:norm()
    return Vector(self.x/norm, self.y/norm)
end

function Vector:perp()
    return Vector(- self.y, self.x)
end

return Vector
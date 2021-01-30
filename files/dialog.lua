local Dialog = Game:addState("Dialog")

function Dialog:enteredState(id, key)
  self.id = id
  self.key = key
  self.pnj = PNJs[id]
  self.currentLine = 1
  self:sayLine(self:getLine())
end

function Dialog:getLine()
  return dialogs[self.id][self.key][self.currentLine]
end

function Dialog:sayLine(line)
  if line[1] == "Minigame" then
    self:gotoState(self.pnj.minigame)
  elseif line[3] then
    local options = {}
    for index, choice in ipairs(line[3]) do
      table.insert(options, {choice, function(dialog)
          self.key = line[4][index]
          self.currentLine = 1
        end })
    end
    Talkies.say(line[1], line[2], {options = options})
  else
    Talkies.say(line[1], line[2])
    self.currentLine = self.currentLine + 1
  end
end

function Dialog:exit()
end

function Dialog:update(dt)
  Talkies.update(dt)
end

function Dialog:keypressed(key, code)
  if key == "space" then
    Talkies.onAction()
    if not Talkies.isOpen() then
      line = self:getLine()
      if line then
        self:sayLine(line)
      else
        self:popState("Dialog")
      end
    end
  end
  if key == "z" or key == "up" then Talkies.prevOption() end
  if key == "s" or key == "down" then Talkies.nextOption() end
end
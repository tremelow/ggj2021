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
    self:gotoState(self.pnj.minigame, self.id, self.pnj.unlock)
  else
    local config = {image = DialogSprite[line[1]]}
    if line[3] then
      local options = {}
      for index, choice in ipairs(line[3]) do
        table.insert(options, {choice, function(dialog)
            self.key = line[4][index]
            self.currentLine = 1
  
            if self.key == "no_minigame" and not Hero.advancement[self.id] == "minigame_won" then
              Hero.advancement[self.id] = "minigame_known_never_won"
            end
          end })
      end
      config.options = options
    end
    self.currentLine = self.currentLine + 1
    Talkies.say(Names[line[1]], line[2], config)
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
      local line = self:getLine()

      if line then
        if line[1] == "Continue" then
          self.key = Hero.advancement[self.id]
          self.currentLine = 1
          line = self:getLine()
        end
        self:sayLine(line)
      else
        self:popState("Dialog")
      end
    end
  end
  if key == "z" or key == "up" then Talkies.prevOption() end
  if key == "s" or key == "down" then Talkies.nextOption() end

  if key == 'escape' then
    Talkies.clearMessages()
    self:popState() -- the topmost state has priority
  end
end
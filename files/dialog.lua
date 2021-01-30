local Dialog = Interact:addState("Dialog")

function Dialog:enteredState(pnj)
  -- ugly copies
  self.title = pnj.name
  self.msg = pnj.dialog.messages
  self.outcome = 0
  self.opt = {}
  for i, opt in pairs(pnj.dialog.options) do
    table.insert(self.opt, {
      opt, function(dialog) self.outcome = tonumber(i) end})
  end
  self.yes = pnj.dialog.yes
  self.no = pnj.dialog.no
  self.minigame = pnj.minigame
  Talkies.say(self.title, self.msg, {
    options = self.opt,
    oncomplete = function (dialog) self:exit()  end
    })
end

function Dialog:exit()
  local finalLine = self.no
  if self.outcome == 1 then finalLine = self.yes end

  Talkies.say(self.title, finalLine, {
      oncomplete = function (dialog)
        if self.outcome == 1 then
          self.game:pushState(self.minigame)
        end
        self:popState("Dialog")
      end
    })
end

function Dialog:update(dt)
  Talkies.update(dt)
end

function Dialog:draw()
  Talkies.draw()
end

function Dialog:keypressed(key, code)
  if key == "space" then Talkies.onAction() end
  if key == "up" then Talkies.prevOption() end
  if key == "down" then Talkies.nextOption() end
end
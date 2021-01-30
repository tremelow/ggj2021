local Dialog = Game:addState("Dialog")

function Dialog:enteredState(id, key)
  self.id = id
  self.pnj = PNJs[id]
  self:parse(dialogs[id][key])
end

function Dialog:parse(list)
  if list then
    local speaker = list[1][1]
    local msg = {}
    local opt = {}
    local oncomplete = function (dialog) self:popState("Dialog") end
    for i, line in ipairs(list) do

      if line[1] == "Minigame" then
        oncomplete = function(dialog)
            self:gotoState(self.pnj.minigame)
          end
      
      elseif line[1] == speaker then
        table.insert(msg, line[2])
      else
        Talkies.say(speaker, msg)
        msg = {}
        speaker = list[i+1]
      end
    end
    
    -- Final check: is there a choice?
    local i = #list
    if list[i][3] then
      for index, choice in ipairs(list[i][3]) do
        table.insert(opt, {choice, function(dialog)
            
          end })
      end
      Talkies.say(speaker, msg, {options = opt, oncomplete = oncomplete})
    else
      Talkies.say(speaker, msg, {oncomplete = oncomplete})
    end
  end
end

function Dialog:exit()
end

function Dialog:update(dt)
  Talkies.update(dt)
end

function Dialog:keypressed(key, code)
  if key == "space" then Talkies.onAction() end
  if key == "z" or key == "up" then Talkies.prevOption() end
  if key == "s" or key == "down" then Talkies.nextOption() end
end
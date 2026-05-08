local GUI = {}
GUI.Controls = {["index"]=0}
backgroundColor = colors.black

local function withMonitor(Monitor, func)
  local isMonitor = Monitor ~= term
  if isMonitor then term.redirect(Monitor) end
  local result = func()
  if isMonitor then term.redirect(term.native()) end
  return result
end

function GUI.getObj(id)
  return GUI.Controls[id]
end

function GUI.remove(handle) -- entire handle or just ID
  if type(handle) == "table" then
    table.remove(GUI.Controls, handle.id)
  else
    table.remove(GUI.Controls, handle)
  end
end

function removeAll() -- removes all elements; manual clearing of all monitors still needs to be done though.
  while #GUI.Controls > 0 do
    GUI.remove(1)
  end
  GUI.Controls.index = 0
end

function GUI.removeListItem(List, index)
  GUI.Controls[List.id]["entries"][index] = nil
end

function GUI.createButton(text, x, y, w, h, textColor, backgroundColor, activeTextColor, activeBackgroundColor)
  local Button = {}
  Button.type = "button"
  Button.id = GUI.Controls.index + 1
  Button.text = text
  Button.onClick = nil
  Button.toggle = true -- If set to true, the button will act like a checkbox.
  Button.x = x
  Button.y = y
  Button.w = w
  Button.h = h
  Button.state = false
  Button.timeout = 1
  Button.backgroundColor = backgroundColor
  Button.textColor = textColor
  Button.activeBackgroundColor = activeBackgroundColor
  Button.activeTextColor = activeTextColor
  Button.monitor = term --monitor
  GUI.Controls.index = GUI.Controls.index + 1
  GUI.Controls[GUI.Controls.index] = Button
  return Button
end

function GUI.createLabel(text, x, y, backgroundColor, textColor)
  local Text = {}
  Text.type = "label"
  Text.id = GUI.Controls.index + 1
  Text.text = text
  Text.x = x
  Text.y = y
  Text.backgroundColor = backgroundColor
  Text.textColor = textColor
  Text.monitor = term --monitor
  GUI.Controls.index = GUI.Controls.index + 1
  GUI.Controls[GUI.Controls.index] = Text
  return Text
end

function GUI.createList(x, y, w, h, backgroundColor, textColor, selectedBackgroundColor, selectedTextColor, borderColor)
  local List = {}
  List.type = "list"
  List.id = GUI.Controls.index + 1
  List.x = x
  List.y = y
  List.w = w
  List.h = h
  List.backgroundColor = backgroundColor
  List.textColor = textColor
  List.selectedBackgroundColor = selectedBackgroundColor
  List.selectedTextColor = selectedTextColor
  List.entries = {}
  List.delCount = 0
  List.selection = 0
  List.scrollActive = false
  List.scroll = 1
  List.onClick = nil
  List.borderColor = borderColor or backgroundColor
  List.sidebarBackgroundColor = List.borderColor
  List.buttonColor = textColor
  List.buttonbackgroundColor = backgroundColor
  List.monitor = term --monitor
  GUI.Controls.index = GUI.Controls.index + 1
  GUI.Controls[GUI.Controls.index] = List
  return List
end

function GUI.createProgressBar(x, y, w, h, color, value)
  local ProgressBar = {}
  ProgressBar.type = "progress"
  ProgressBar.id = GUI.Controls.index + 1
  ProgressBar.direction = 0 --0 = horizontal, 1 = vertical
  ProgressBar.x = x
  ProgressBar.y = y
  ProgressBar.w = w
  ProgressBar.h = h
  ProgressBar.color = color
  ProgressBar.colorB = colors.gray
  ProgressBar.value = value
  ProgressBar.monitor = term --monitor
  GUI.Controls.index = GUI.Controls.index + 1
  GUI.Controls[GUI.Controls.index] = ProgressBar
  return ProgressBar
end

function GUI.createListEntry(List, text)
  table.insert(List.entries, text)
  return #List.entries
end

function GUI.createInput(text, x, y, w, h, backgroundColor, textColor)
  local Input = {}
  Input.type = "input"
  Input.id = GUI.Controls.index + 1
  Input.text = text
  Input.x = x
  Input.y = y
  Input.w = w
  Input.h = h
  Input.backgroundColor = backgroundColor
  Input.textColor = textColor
  Input.borderColor = colors.lightGray
  Input.selected = false
  Input.monitor = term --monitor
  Input.cursorPos = nil
  Input.textOffset = 0 -- offset for when text overflows. Marks start of text window. e.g.: This i[s som]e text - offset is 6. Width of the input is 5.
  GUI.Controls.index = GUI.Controls.index + 1
  GUI.Controls[GUI.Controls.index] = Input
  return Input
end

function GUI.fillRegion(Monitor, startX, startY, endX, endY, color)
  withMonitor(Monitor, function() paintutils.drawFilledBox(startX, startY, endX, endY, color) end)
end

function GUI.drawRect(Monitor, startX, startY, endX, endY, color)
  withMonitor(Monitor, function() paintutils.drawBox(startX, startY, endX, endY, color) end)
end

function GUI.drawLine(Monitor, startX, startY, endX, endY, color)
  withMonitor(Monitor, function() paintutils.drawLine(startX, startY, endX, endY, color) end)
end

function GUI.drawPixel(Monitor, x, y, color)
  withMonitor(Monitor, function() paintutils.drawPixel(x, y, color) end)
end

function GUI.drawText(Monitor, x, y, textColor, backgroundColor, text)
  withMonitor(Monitor, function()
    Monitor.setCursorPos(x, y)
    Monitor.setTextColor(textColor)
    Monitor.setBackgroundColor(backgroundColor)
    Monitor.write(text)
  end)
end

function GUI.drawAll(clearMonitors)
  if clearMonitors == nil then
    clearMonitors = true
  end
  for id, ControlElement in pairs(GUI.Controls) do
    if id ~= "index" then
      ControlElement.monitor.setBackgroundColor(backgroundColor)
      if clearMonitors then ControlElement.monitor.clear() end
    end
  end
  
  for id, ControlElement in pairs(GUI.Controls) do
    if id ~= "index" then
      if ControlElement.type == "button" then
        local textColor, backgroundColor
        if ControlElement.state == false then
          textColor = ControlElement.textColor
          backgroundColor = ControlElement.backgroundColor
        else
          textColor = ControlElement.activeTextColor
          backgroundColor = ControlElement.activeBackgroundColor
        end
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w, ControlElement.y + ControlElement.h, backgroundColor)
        local textY = ControlElement.y + (ControlElement.h / 2)
        local textX = ControlElement.x + (ControlElement.w / 2) - (ControlElement.text:len() / 2)
        GUI.drawText(ControlElement.monitor, textX, textY, textColor, backgroundColor, ControlElement.text)
      elseif ControlElement.type == "label" then
        GUI.drawText(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.textColor, ControlElement.backgroundColor, ControlElement.text)
      elseif ControlElement.type == "list" then
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w + 1, ControlElement.y + ControlElement.h + 1, ControlElement.sidebarBackgroundColor)
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w, ControlElement.y + ControlElement. h, ControlElement.backgroundColor)
        ControlElement.scrollActive = #ControlElement.entries - ControlElement.delCount > ControlElement.h
        if ControlElement.scrollActive then
          GUI.drawLine(ControlElement.monitor, ControlElement.x + ControlElement.w - 1, ControlElement.y, ControlElement.x + ControlElement.w - 1, ControlElement.y + ControlElement.h, ControlElement.sidebarBackgroundColor)
          GUI.drawLine(ControlElement.monitor, ControlElement.x + ControlElement.w, ControlElement.y, ControlElement.x + ControlElement.w, ControlElement.y + ControlElement.h, ControlElement.buttonbackgroundColor)
          GUI.drawPixel(ControlElement.monitor, ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement.h / 2), ControlElement.sidebarBackgroundColor)
          ControlElement.monitor.setBackgroundColor(ControlElement.buttonbackgroundColor)
          ControlElement.monitor.setTextColor(ControlElement.buttonColor)
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement.h / 4))
          ControlElement.monitor.write("^")
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y + (3 * ControlElement.h / 4))
          ControlElement.monitor.write("v")
        end
        local offset = 0
        for index, item in pairs(ControlElement.entries) do
          if index >= ControlElement.scroll and index <= ControlElement.scroll + ControlElement.h then
            if item == nil then
              offset = offset + 1
            else
              ControlElement.monitor.setCursorPos(ControlElement.x, index - ControlElement.scroll + ControlElement.y - offset)
              if ControlElement.selection == index then
                ControlElement.monitor.setTextColor(ControlElement.selectedTextColor)
                ControlElement.monitor.setBackgroundColor(ControlElement.selectedBackgroundColor)
              else
                ControlElement.monitor.setTextColor(ControlElement.textColor)
                ControlElement.monitor.setBackgroundColor(ControlElement.backgroundColor)
              end
              ControlElement.monitor.write(item)
            end
          end
        end
      elseif ControlElement.type == "input" then
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w - 1, ControlElement.y, ControlElement.backgroundColor)
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w, ControlElement.y + 1, ControlElement.borderColor)
        local text = ControlElement.text
        if ControlElement.textOffset > 0 then
          text = string.sub(text, ControlElement.textOffset + 1)
          GUI.drawText(ControlElement.monitor, ControlElement.x - 1, ControlElement.y, ControlElement.textColor, ControlElement.borderColor, "<")
        end
        local textLen = string.len(text)
        if textLen > ControlElement.w then
          text = string.sub(text, 1, ControlElement.w)
          GUI.drawText(ControlElement.monitor, ControlElement.x + ControlElement.w, ControlElement.y, ControlElement.textColor, ControlElement.borderColor, ">")
        end
        GUI.drawText(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.textColor, ControlElement.backgroundColor, text)
        if ControlElement.cursorPos ~= nil then
          local printChar
          if ControlElement.cursorPos > string.len(ControlElement.text) then
            printChar = " "
          else
            printChar = string.sub(ControlElement.text, ControlElement.cursorPos, ControlElement.cursorPos)
          end
          GUI.drawText(ControlElement.monitor, ControlElement.x + ControlElement.cursorPos - 1 - ControlElement.textOffset, ControlElement.y, ControlElement.backgroundColor, ControlElement.textColor, printChar)
        end
      elseif ControlElement.type == "progress" then
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w + 1, ControlElement.y + ControlElement.h + 1, ControlElement.colorB)
        if ControlElement.direction == 0 then
          GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + (ControlElement.w * ControlElement.value / 100), ControlElement.y + ControlElement.h, ControlElement.color)
        elseif ControlElement.direction == 1 then
          GUI.fillRegion(ControlElement.monitor, ControlElement.x, math.ceil(ControlElement.y + ControlElement.h - (ControlElement.h * ControlElement.value / 100)), ControlElement.x + ControlElement.w, ControlElement.y + ControlElement.h, ControlElement.color)
        end
      end
    end
  end
end

function GUI.compareMonitors(monitorA, monitorB)
  if monitorA.getCursorPos() ~= monitorB.getCursorPos() then return false end
  monitorB.setCursorPos(1, 1)
  if monitorA.getCursorPos() ~= monitorB.getCursorPos() then return false end
  monitorB.setCursorPos(2, 2)
  if monitorA.getCursorPos() ~= monitorB.getCursorPos() then return false end
  return true
end

function GUI._2Dhit(bx, by, ax, ay, ax2, ay2)
  if bx >= ax and bx <= ax2 and by >= ay and by <= ay2 then return true end
  return false
end

function GUI._2DhitA(bx, by, ax, ay, w, h)
  return GUI._2Dhit(bx, by, ax, ay, ax + w, ay + h)
end

function GUI.handleEvent(event) -- event = {os.pullEvent()}
  local referenceMonitor
  if event[1] == "mouse_click" then
    referenceMonitor = term
  elseif event[1] == "monitor_touch" then
    referenceMonitor = peripheral.wrap(event[2])
  end
  if event[1] == "monitor_touch" or event[1] == "mouse_click" then --event,side,x,y
      for id, ControlElement in pairs(GUI.Controls) do
        if id ~= "index" then
          term.setCursorPos(1, 1)
          term.setBackgroundColor(colors.black)
          term.setTextColor(colors.white)
          
          if GUI.compareMonitors(referenceMonitor, ControlElement.monitor) then
            if ControlElement.type == "button" then
              if GUI._2DhitA(event[3], event[4], ControlElement.x, ControlElement.y, ControlElement.w, ControlElement.h) then
                if ControlElement.toggle then
                  ControlElement.state = not ControlElement.state
                  GUI.drawAll()
                else
                  ControlElement.state = true
                  ControlElement.timer = os.startTimer(ControlElement.timeout)
                  GUI.drawAll()
                end
                term.setCursorPos(1, 1)
                if ControlElement.onClick ~= nil then
                  ControlElement.onClick({["id"]=id, ["state"]=ControlElement.state})
                end
              end
            elseif ControlElement.type == "list" then
              local elementWidth
              if ControlElement.scrollActive then
                elementWidth = ControlElement.w - 2
                if ControlElement.scroll > 1 and GUI._2DhitA(event[3], event[4], ControlElement.x + ControlElement.w, ControlElement.y, 0, ControlElement.h / 2) then
                  ControlElement.scroll = ControlElement.scroll - 1
                elseif ControlElement.scroll <= (#ControlElement.entries - ControlElement.h) - 1 and GUI._2DhitA(event[3], event[4], ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement. h / 2), 0, ControlElement.h / 2) then
                  ControlElement.scroll = ControlElement.scroll + 1
                end
              else
                elementWidth = ControlElement.w
              end
              if GUI._2DhitA(event[3], event[4], ControlElement.x, ControlElement.y, elementWidth, ControlElement.h) then
                local previousSelection = ControlElement.selection
                ControlElement.selection = event[4] - ControlElement.y + ControlElement.scroll
                if ControlElement.selection <= #ControlElement.entries then
                  if ControlElement.onClick ~= nil then
                    ControlElement.onClick(ControlElement.selection)
                  end
                else
                  ControlElement.selection = previousSelection
                end
              end
            elseif ControlElement.type == "input" then
              if GUI._2DhitA(event[3], event[4], ControlElement.x, ControlElement.y, ControlElement.w, ControlElement.h) then
                local relativeClickPosition = math.min(event[3] - ControlElement.x + 1, string.len(ControlElement.text) + 1)
                ControlElement.cursorPos = relativeClickPosition + ControlElement.textOffset
              elseif ControlElement.cursorPos ~= nil then
                ControlElement.cursorPos = nil
              end
            end
          end
        end
      end
  elseif event[1] == "timer" then
    for id, ControlElement in pairs(GUI.Controls) do
      if id ~= "index" then
        if ControlElement.type == "button" and ControlElement.timer ~= nil then
          if ControlElement.timer == event[2] then
            ControlElement.timer = nil
            ControlElement.state = false
          end
        end
      end
    end
  elseif event[1] == "char" or event[1] == "key_up" then
    local isCharEvent = event[1] == "char"
    local isKeyUpEvent = event[1] == "key_up"
    local char = event[2]
    local keyName
    if isKeyUpEvent then
      keyName = keys.getName(char)
      if keyName == "space" then
        keyName = " "
      end
    elseif isCharEvent then
      keyName = char
    end
    if keyName ~= nil then
      for id, ControlElement in pairs(GUI.Controls) do
        if id ~= "index" and ControlElement.type == "input" and ControlElement.cursorPos ~= nil then
          if keyName == "backspace" then
            ControlElement.text = string.sub(ControlElement.text, 1, math.max(ControlElement.cursorPos - 2, 0)) .. string.sub(ControlElement.text, ControlElement.cursorPos)
            ControlElement.cursorPos = math.max(ControlElement.cursorPos - 1, 1)
            if ControlElement.textOffset > 0 then
              ControlElement.textOffset = ControlElement.textOffset - 1
            end
          elseif keyName == "delete" then
            ControlElement.text = string.sub(ControlElement.text, 1, math.max(ControlElement.cursorPos - 1, 0)) .. string.sub(ControlElement.text, ControlElement.cursorPos + 1)
          elseif keyName == "left" then
            ControlElement.cursorPos = math.max(ControlElement.cursorPos - 1, 1)
          elseif keyName == "right" then
            ControlElement.cursorPos = math.min(ControlElement.cursorPos + 1, string.len(ControlElement.text) + 1)
          elseif isCharEvent then
            ControlElement.text = string.sub(ControlElement.text, 1, ControlElement.cursorPos - 1) .. keyName .. string.sub(ControlElement.text, ControlElement.cursorPos)
            ControlElement.cursorPos = ControlElement.cursorPos + 1
          end
          if ControlElement.cursorPos <= ControlElement.textOffset then
            ControlElement.textOffset = ControlElement.textOffset - 1
          end
          if ControlElement.cursorPos - ControlElement.textOffset > ControlElement.w then
            ControlElement.textOffset = ControlElement.textOffset + 1
          end
        end
      end
    end
  end
end

return GUI
local GUI = {}
tObj = {["index"]=0}
backgroundColor = colors.black

function GUI.getObj(id)
  return tObj[id]
end

function GUI.remove(handle) -- entire handle or just ID
  if type(handle) == "table" then
    table.remove(tObj, handle.id)
  else
    table.remove(tObj, handle)
  end
end

function removeAll() -- removes all elements; manual clearing of all monitors still needs to be done though.
  while #tObj > 0 do
    GUI.remove(1)
  end
  tObj.index = 0
end

function GUI.removeListItem(hList, itemID)
  tObj[hList.id]["entries"][itemID] = nil
end

function GUI.createButton(sText, x, y, w, h, textColor, bkColor, alttextColor, altbkColor)
  Button = {}
  Button.type = "button"
  Button.id = tObj.index + 1
  Button.text = sText
  Button.onClick = nil --funcOnclick
  Button.toggle = true --bToggleMode
  Button.x = x
  Button.y = y
  Button.w = w
  Button.h = h
  Button.state = false
  Button.timeout = 1
  Button.bkColor = bkColor
  Button.textColor = textColor
  Button.altbkColor = altbkColor
  Button.alttextColor = alttextColor
  Button.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = Button
  return Button
end

function GUI.createLabel(sText, x, y, bkColor, textColor)
  Text = {}
  Text.type = "label"
  Text.id = tObj.index + 1
  Text.text = sText
  Text.x = x
  Text.y = y
  Text.bkColor = bkColor
  Text.textColor = textColor
  Text.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = Text
  return Text
end

function GUI.createList(x, y, w, h, bkColor, textColor, selectbkColor, selectTextColor)
  List = {}
  List.type = "list"
  List.id = tObj.index + 1
  List.x = x
  List.y = y
  List.w = w
  List.h = h
  List.bkColor = bkColor
  List.textColor = textColor
  List.selectbkColor = selectbkColor
  List.selecttextColor = selectTextColor
  List.entries = {}
  List.delCount = 0
  List.selection = 0
  List.scrollactive = false
  List.scroll = 1
  List.onClick = nil
  List.buttonColor = colors.gray
  List.buttonbkColor = colors.lightGray
  List.buttonTextColor = colors.black
  List.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = List
  return List
end

function GUI.createProgressBar(x, y, w, h, color, value)
  ProgressBar = {}
  ProgressBar.type = "progress"
  ProgressBar.id = tObj.index + 1
  ProgressBar.direction = 0 --0 = horizontal, 1 = vertical
  ProgressBar.x = x
  ProgressBar.y = y
  ProgressBar.w = w
  ProgressBar.h = h
  ProgressBar.color = color
  ProgressBar.colorB = colors.gray
  ProgressBar.value = value
  ProgressBar.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = ProgressBar
  return ProgressBar
end

function GUI.createListEntry(List, sText)
  table.insert(List.entries, sText)
  return #List.entries
end

function GUI.createInput(sText, x, y, w, h, bkColor, textColor)
  Input = {}
  Input.type = "input"
  Input.id = tObj.index + 1
  Input.text = sText
  Input.x = x
  Input.y = y
  Input.w = w
  Input.h = h
  Input.bkColor = bkColor
  Input.textColor = textColor
  Input.borderColor = colors.lightGray
  Input.selected = false
  Input.monitor = term --monitor
  Input.cursorPos = nil
  Input.textOffset = 0 -- offset for when text overflows. Marks start of text window. e.g.: This i[s som]e text - offset is 6. Width of the input is 5.
  tObj.index = tObj.index + 1
  tObj[tObj.index] = Input
  return Input
end

function GUI.fillRegion(Monitor, startX, startY, endX, endY, color)
  local isMonitor = Monitor ~= term
  if isMonitor then term.redirect(Monitor) end
  paintutils.drawFilledBox(startX, startY, endX, endY, color)
  if isMonitor then term.redirect(term.native()) end
end

function GUI.drawRect(Monitor, startX, startY, endX, endY, color)
  local isMonitor = Monitor ~= term
  if isMonitor then term.redirect(Monitor) end
  paintutils.drawBox(startX, startY, endX, endY, color)
  if isMonitor then term.redirect(term.native()) end
end

function GUI.drawAll()
  for id, ControlElement in pairs(tObj) do
    if id ~= "index" then
      ControlElement.monitor.setBackgroundColor(backgroundColor)
      ControlElement.monitor.clear()
    end
  end
  
  for id, ControlElement in pairs(tObj) do
    if id ~= "index" then
      if ControlElement.type == "button" then
        if ControlElement.state == false then
          tempC = ControlElement.textColor
          tempbkC = ControlElement.bkColor
        else
          tempC = ControlElement.alttextColor
          tempbkC = ControlElement.altbkColor
        end
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w, ControlElement.y + ControlElement.h, tempbkC)
        tempY = ControlElement.y + (ControlElement.h / 2)
        tempX = ControlElement.x + (ControlElement.w / 2) - (ControlElement.text:len() / 2)
        ControlElement.monitor.setCursorPos(tempX, tempY)
        ControlElement.monitor.setTextColor(tempC)
        ControlElement.monitor.setBackgroundColor(tempbkC)
        ControlElement.monitor.write(ControlElement.text)
      elseif ControlElement.type == "label" then
        ControlElement.monitor.setCursorPos(ControlElement.x, ControlElement.y)
        ControlElement.monitor.setTextColor(ControlElement.textColor)
        ControlElement.monitor.setBackgroundColor(ControlElement.bkColor)
        ControlElement.monitor.write(ControlElement.text)
      elseif ControlElement.type == "list" then
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w + 1, ControlElement.y + ControlElement.h + 1, colors.cyan)
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w, ControlElement.y + ControlElement. h, colors.white)
        ControlElement.scrollactive = #ControlElement.entries - ControlElement.delCount > ControlElement.h
        if ControlElement.scrollactive then
          ControlElement.monitor.setBackgroundColor(ControlElement.buttonColor)
          for i = ControlElement.y, ControlElement.y + ControlElement.h do
            ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w - 1, i)
            ControlElement.monitor.write(" ")
          end
          ControlElement.monitor.setBackgroundColor(ControlElement.buttonbkColor)
          for i = ControlElement.y, ControlElement.y + ControlElement.h do
            ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, i)
            ControlElement.monitor.write(" ")
          end
          ControlElement.monitor.setBackgroundColor(ControlElement.buttonColor)
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement.h / 2))
          ControlElement.monitor.write(" ")
          ControlElement.monitor.setBackgroundColor(ControlElement.buttonbkColor)
          ControlElement.monitor.setTextColor(ControlElement.buttonColor)
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement.h / 4))
          ControlElement.monitor.write("^")
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y + (3 * ControlElement.h / 4))
          ControlElement.monitor.write("v")
        end
        tempOffset = 0
        for num, item in pairs(ControlElement.entries) do
          if num >= ControlElement.scroll and num <= ControlElement.scroll + ControlElement.h then
            tempY = num - ControlElement.scroll + ControlElement.y - tempOffset
            if item == nil then
              tempOffset = tempOffset + 1
            else
              ControlElement.monitor.setCursorPos(ControlElement.x, tempY)
              if ControlElement.selection == num then
                ControlElement.monitor.setTextColor(ControlElement.selecttextColor)
                ControlElement.monitor.setBackgroundColor(ControlElement.selectbkColor)
              else
                ControlElement.monitor.setTextColor(ControlElement.textColor)
                ControlElement.monitor.setBackgroundColor(ControlElement.bkColor)
              end
            end
            ControlElement.monitor.write(item)
          end
        end
      elseif ControlElement.type == "input" then
        GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + ControlElement.w - 1, ControlElement.y, ControlElement.bkColor)
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w, ControlElement.y + 1, ControlElement.borderColor)
        local text = ControlElement.text
        if ControlElement.textOffset > 0 then
          text = string.sub(text, ControlElement.textOffset + 1)
          ControlElement.monitor.setCursorPos(ControlElement.x - 1, ControlElement.y)
          ControlElement.monitor.setBackgroundColor(ControlElement.borderColor)
          ControlElement.monitor.setTextColor(ControlElement.textColor)
          ControlElement.monitor.write("<")
        end
        local textLen = string.len(text)
        if textLen > ControlElement.w then
          text = string.sub(text, 1, ControlElement.w)
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.w, ControlElement.y)
          ControlElement.monitor.setBackgroundColor(ControlElement.borderColor)
          ControlElement.monitor.setTextColor(ControlElement.textColor)
          ControlElement.monitor.write(">")
        end
        ControlElement.monitor.setCursorPos(ControlElement.x, ControlElement.y)
        ControlElement.monitor.setBackgroundColor(ControlElement.bkColor)
        ControlElement.monitor.setTextColor(ControlElement.textColor)
        ControlElement.monitor.write(text)
        if ControlElement.cursorPos ~= nil then
          local printChar
          if ControlElement.cursorPos > string.len(ControlElement.text) then
            printChar = " "
          else
            printChar = string.sub(ControlElement.text, ControlElement.cursorPos, ControlElement.cursorPos)
          end
          ControlElement.monitor.setCursorPos(ControlElement.x + ControlElement.cursorPos - 1 - ControlElement.textOffset, ControlElement.y)
          ControlElement.monitor.setBackgroundColor(ControlElement.textColor)
          ControlElement.monitor.setTextColor(ControlElement.bkColor)
          ControlElement.monitor.write(printChar)
        end
      elseif ControlElement.type == "progress" then
        GUI.drawRect(ControlElement.monitor, ControlElement.x - 1, ControlElement.y - 1, ControlElement.x + ControlElement.w + 1, ControlElement.y + ControlElement.h + 1, ControlElement.colorB)
        --ControlElement.monitor.setBackgroundColor(ControlElement.color)
        if ControlElement.direction == 0 then
          GUI.fillRegion(ControlElement.monitor, ControlElement.x, ControlElement.y, ControlElement.x + (ControlElement.w * ControlElement.value / 100), ControlElement.y + ControlElement.h, ControlElement.color)
        elseif ControlElement.direction == 1 then
          GUI.fillRegion(ControlElement.monitor, ControlElement.x, math.ceil(ControlElement.y + ControlElement.h - (ControlElement.h * ControlElement.value / 100)), ControlElement.x + ControlElement.w, ControlElement.y + ControlElement.h, ControlElement.color)
        end
      end
    end
  end
end

function GUI.isSide(testMon, mon)
  --testMon = peripheral.wrap(sSide)
  if testMon.getCursorPos() ~= mon.getCursorPos() then return false end
  mon.setCursorPos(1, 1)
  if testMon.getCursorPos() ~= mon.getCursorPos() then return false end
  mon.setCursorPos(2, 2)
  if testMon.getCursorPos() ~= mon.getCursorPos() then return false end
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
  if event[1] == "mouse_click" then
    refMon = term
  elseif event[1] == "monitor_touch" then
    refMon = peripheral.wrap(event[2])
  end
  if event[1] == "monitor_touch" or event[1] == "mouse_click" then --event,side,x,y
      for id, ControlElement in pairs(tObj) do
        if id ~= "index" then
          term.setCursorPos(1, 1)
          term.setBackgroundColor(colors.black)
          term.setTextColor(colors.white)
          
          if GUI.isSide(refMon, ControlElement.monitor) then
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
              if ControlElement.scrollactive then
                tempWidth = ControlElement.w - 2
                if ControlElement.scroll > 1 and GUI._2DhitA(event[3], event[4], ControlElement.x + ControlElement.w, ControlElement.y, 0, ControlElement.h / 2) then
                  ControlElement.scroll = ControlElement.scroll - 1
                elseif ControlElement.scroll <= (#ControlElement.entries - ControlElement.h) - 1 and GUI._2DhitA(event[3], event[4], ControlElement.x + ControlElement.w, ControlElement.y + (ControlElement. h / 2), 0, ControlElement.h / 2) then
                  ControlElement.scroll = ControlElement.scroll + 1
                end
              else
                tempWidth = ControlElement.w
              end
              if GUI._2DhitA(event[3], event[4], ControlElement.x, ControlElement.y, tempWidth, ControlElement.h) then
                tempSelection = ControlElement.selection
                ControlElement.selection = event[4] - ControlElement.y + ControlElement.scroll
                if ControlElement.selection <= #ControlElement.entries then
                  if ControlElement.onClick ~= nil then
                    ControlElement.onClick(ControlElement.selection)
                  end
                else
                  ControlElement.selection = tempSelection
                end
              end
            elseif ControlElement.type == "input" then
              if GUI._2DhitA(event[3], event[4], ControlElement.x, ControlElement.y, ControlElement.w, ControlElement.h) then
                local relativeClickPosition = math.min(event[3] - ControlElement.x + 1, string.len(ControlElement.text) + 1)
                local textLen = string.len(ControlElement.text)
                ControlElement.cursorPos = relativeClickPosition + ControlElement.textOffset
              elseif ControlElement.cursorPos ~= nil then
                ControlElement.cursorPos = nil
              end
            end
          end
        end
      end
  elseif event[1] == "timer" then
    for id, ControlElement in pairs(tObj) do
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
    local eventIsChar = event[1] == "char"
    local eventIsKeyUp = event[1] == "key_up"
    local char = event[2]
    local keyName
    if eventIsKeyUp then
      keyName = keys.getName(char)
      if keyName == "space" then
        keyName = " "
      end
    elseif eventIsChar then
      keyName = char
    end
    if keyName ~= nil then
      for id, ControlElement in pairs(tObj) do
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
          elseif eventIsChar then
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
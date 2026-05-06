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
  tButton = {}
  tButton.type = "button"
  tButton.id = tObj.index + 1
  tButton.text = sText
  tButton.onClick = nil --funcOnclick
  tButton.toggle = true --bToggleMode
  tButton.x = x
  tButton.y = y
  tButton.w = w
  tButton.h = h
  tButton.state = false
  tButton.timeout = 1
  tButton.bkColor = bkColor
  tButton.textColor = textColor
  tButton.altbkColor = altbkColor
  tButton.alttextColor = alttextColor
  tButton.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = tButton
  return tButton
end

function GUI.createLabel(sText, x, y, bkColor, textColor)
  tText = {}
  tText.type = "label"
  tText.id = tObj.index + 1
  tText.text = sText
  tText.x = x
  tText.y = y
  tText.bkColor = bkColor
  tText.textColor = textColor
  tText.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = tText
  return tText
end

function GUI.createList(x, y, w, h, bkColor, textColor, selectbkColor, selectTextColor)
  tList = {}
  tList.type = "list"
  tList.id = tObj.index + 1
  tList.x = x
  tList.y = y
  tList.w = w
  tList.h = h
  tList.bkColor = bkColor
  tList.textColor = textColor
  tList.selectbkColor = selectbkColor
  tList.selecttextColor = selectTextColor
  tList.entries = {}
  tList.delCount = 0
  tList.selection = 0
  tList.scrollactive = false
  tList.scroll = 1
  tList.onClick = nil
  tList.buttonColor = colors.gray
  tList.buttonbkColor = colors.lightGray
  tList.buttonTextColor = colors.black
  tList.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = tList
  return tList
end

function GUI.createProgressBar(x, y, w, h, color, value)
  tProg = {}
  tProg.type = "progress"
  tProg.id = tObj.index + 1
  tProg.direction = 0 --0 = horizontal, 1 = vertical
  tProg.x = x
  tProg.y = y
  tProg.w = w
  tProg.h = h
  tProg.color = color
  tProg.colorB = colors.gray
  tProg.value = value
  tProg.monitor = term --monitor
  tObj.index = tObj.index + 1
  tObj[tObj.index] = tProg
  return tProg
  
end

function GUI.createListEntry(tList, sText)
  table.insert(tList.entries, sText)
  return #tList.entries
end

function GUI.createInput(sText, x, y, w, h, bkColor, textColor)
  tInput = {}
  tInput.type = "input"
  tInput.id = tObj.index + 1
  tInput.text = sText
  tInput.x = x
  tInput.y = y
  tInput.w = w
  tInput.h = h
  tInput.bkColor = bkColor
  tInput.textColor = textColor
  tInput.borderColor = colors.lightGray
  tInput.selected = false
  tInput.monitor = term --monitor
  tInput.cursorPos = nil
  tInput.textOffset = 0 -- offset for when text overflows. Marks start of text window. e.g.: This i[s som]e text - offset is 6. Width of the input is 5.
  tObj.index = tObj.index + 1
  tObj[tObj.index] = tInput
  return tInput
end

function GUI.fillRegion(mon, startX, startY, endX, endY, color)
  tempText = ""
  for i = startX, endX do
    tempText = tempText .. " "
  end
  for i=startY, endY do
    mon.setCursorPos(startX, i)
    mon.setBackgroundColor(color)
    mon.write(tempText)
  end
end

function GUI.drawRect(monitor, startX, startY, endX, endY, pColor)
  tempX = math.min(startX, endX)
  tempXa = math.max(startX, endX)
  tempY = math.min(startY, endY)
  tempYa = math.max(startY, endY)
  
  monitor.setBackgroundColor(pColor)
  tempText = ""
  for i=tempX, tempXa do
    tempText = tempText .. " "
  end
  
  monitor.setCursorPos(tempX, tempY)
  monitor.write(tempText)
  monitor.setCursorPos(tempX, tempYa)
  monitor.write(tempText)
  for i=tempY, tempYa do
    monitor.setCursorPos(tempX, i)
    monitor.write(" ")
    monitor.setCursorPos(tempXa, i)
    monitor.write(" ")
  end
end

function GUI.drawAll()
  for id, tCtrl in pairs(tObj) do
    if id ~= "index" then
      tCtrl.monitor.setBackgroundColor(backgroundColor)
      tCtrl.monitor.clear()
    end
  end
  
  for id, tCtrl in pairs(tObj) do
    if id ~= "index" then
      if tCtrl.type == "button" then
        if tCtrl.state == false then
          tempC = tCtrl.textColor
          tempbkC = tCtrl.bkColor
        else
          tempC = tCtrl.alttextColor
          tempbkC = tCtrl.altbkColor
        end
        GUI.fillRegion(tCtrl.monitor, tCtrl.x, tCtrl.y, tCtrl.x + tCtrl.w, tCtrl.y + tCtrl.h, tempbkC)
        tempY = tCtrl.y + (tCtrl.h / 2)
        tempX = tCtrl.x + (tCtrl.w / 2) - (tCtrl.text:len() / 2)
        tCtrl.monitor.setCursorPos(tempX, tempY)
        tCtrl.monitor.setTextColor(tempC)
        tCtrl.monitor.setBackgroundColor(tempbkC)
        tCtrl.monitor.write(tCtrl.text)
      elseif tCtrl.type == "label" then
        tCtrl.monitor.setCursorPos(tCtrl.x, tCtrl.y)
        tCtrl.monitor.setTextColor(tCtrl.textColor)
        tCtrl.monitor.setBackgroundColor(tCtrl.bkColor)
        tCtrl.monitor.write(tCtrl.text)
      elseif tCtrl.type == "list" then
        GUI.drawRect(tCtrl.monitor, tCtrl.x - 1, tCtrl.y - 1, tCtrl.x + tCtrl.w + 1, tCtrl.y + tCtrl.h + 1, colors.cyan)
        GUI.fillRegion(tCtrl.monitor, tCtrl.x, tCtrl.y, tCtrl.x + tCtrl.w, tCtrl.y + tCtrl. h, colors.white)
        tCtrl.scrollactive = #tCtrl.entries - tCtrl.delCount > tCtrl.h
        if tCtrl.scrollactive then
          tCtrl.monitor.setBackgroundColor(tCtrl.buttonColor)
          for i = tCtrl.y, tCtrl.y + tCtrl.h do
            tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w - 1, i)
            tCtrl.monitor.write(" ")
          end
          tCtrl.monitor.setBackgroundColor(tCtrl.buttonbkColor)
          for i = tCtrl.y, tCtrl.y + tCtrl.h do
            tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w, i)
            tCtrl.monitor.write(" ")
          end
          tCtrl.monitor.setBackgroundColor(tCtrl.buttonColor)
          tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w, tCtrl.y + (tCtrl.h / 2))
          tCtrl.monitor.write(" ")
          tCtrl.monitor.setBackgroundColor(tCtrl.buttonbkColor)
          tCtrl.monitor.setTextColor(tCtrl.buttonColor)
          tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w, tCtrl.y + (tCtrl.h / 4))
          tCtrl.monitor.write("^")
          tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w, tCtrl.y + (3 * tCtrl.h / 4))
          tCtrl.monitor.write("v")
        end
        tempOffset = 0
        for num, item in pairs(tCtrl.entries) do
          if num >= tCtrl.scroll and num <= tCtrl.scroll + tCtrl.h then
            tempY = num - tCtrl.scroll + tCtrl.y - tempOffset
            if item == nil then
              tempOffset = tempOffset + 1
            else
              tCtrl.monitor.setCursorPos(tCtrl.x, tempY)
              if tCtrl.selection == num then
                tCtrl.monitor.setTextColor(tCtrl.selecttextColor)
                tCtrl.monitor.setBackgroundColor(tCtrl.selectbkColor)
              else
                tCtrl.monitor.setTextColor(tCtrl.textColor)
                tCtrl.monitor.setBackgroundColor(tCtrl.bkColor)
              end
            end
            tCtrl.monitor.write(item)
          end
        end
      elseif tCtrl.type == "input" then
        GUI.fillRegion(tCtrl.monitor, tCtrl.x, tCtrl.y, tCtrl.x + tCtrl.w - 1, tCtrl.y, tCtrl.bkColor)
        GUI.drawRect(tCtrl.monitor, tCtrl.x - 1, tCtrl.y - 1, tCtrl.x + tCtrl.w, tCtrl.y + 1, tCtrl.borderColor)
        local text = tCtrl.text
        if tCtrl.textOffset > 0 then
          text = string.sub(text, tCtrl.textOffset + 1)
          tCtrl.monitor.setCursorPos(tCtrl.x - 1, tCtrl.y)
          tCtrl.monitor.setBackgroundColor(tCtrl.borderColor)
          tCtrl.monitor.setTextColor(tCtrl.textColor)
          tCtrl.monitor.write("<")
        end
        local textLen = string.len(text)
        if textLen > tCtrl.w then
          text = string.sub(text, 1, tCtrl.w)
          tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.w, tCtrl.y)
          tCtrl.monitor.setBackgroundColor(tCtrl.borderColor)
          tCtrl.monitor.setTextColor(tCtrl.textColor)
          tCtrl.monitor.write(">")
        end
        tCtrl.monitor.setCursorPos(tCtrl.x, tCtrl.y)
        tCtrl.monitor.setBackgroundColor(tCtrl.bkColor)
        tCtrl.monitor.setTextColor(tCtrl.textColor)
        tCtrl.monitor.write(text)
        if tCtrl.cursorPos ~= nil then
          local printChar
          if tCtrl.cursorPos > string.len(tCtrl.text) then
            printChar = " "
          else
            printChar = string.sub(tCtrl.text, tCtrl.cursorPos, tCtrl.cursorPos)
          end
          tCtrl.monitor.setCursorPos(tCtrl.x + tCtrl.cursorPos - 1 - tCtrl.textOffset, tCtrl.y)
          tCtrl.monitor.setBackgroundColor(tCtrl.textColor)
          tCtrl.monitor.setTextColor(tCtrl.bkColor)
          tCtrl.monitor.write(printChar)
        end
      elseif tCtrl.type == "progress" then
        GUI.drawRect(tCtrl.monitor, tCtrl.x - 1, tCtrl.y - 1, tCtrl.x + tCtrl.w + 1, tCtrl.y + tCtrl.h + 1, tCtrl.colorB)
        --tCtrl.monitor.setBackgroundColor(tCtrl.color)
        if tCtrl.direction == 0 then
          GUI.fillRegion(tCtrl.monitor, tCtrl.x, tCtrl.y, tCtrl.x + (tCtrl.w * tCtrl.value / 100), tCtrl.y + tCtrl.h, tCtrl.color)
        elseif tCtrl.direction == 1 then
          GUI.fillRegion(tCtrl.monitor, tCtrl.x, math.ceil(tCtrl.y + tCtrl.h - (tCtrl.h * tCtrl.value / 100)), tCtrl.x + tCtrl.w, tCtrl.y + tCtrl.h, tCtrl.color)
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
      for id, tCtrl in pairs(tObj) do
        if id ~= "index" then
          term.setCursorPos(1, 1)
          term.setBackgroundColor(colors.black)
          term.setTextColor(colors.white)
          
          if GUI.isSide(refMon, tCtrl.monitor) then
            if tCtrl.type == "button" then
              if GUI._2DhitA(event[3], event[4], tCtrl.x, tCtrl.y, tCtrl.w, tCtrl.h) then
                if tCtrl.toggle then
                  tCtrl.state = not tCtrl.state
                  GUI.drawAll()
                else
                  tCtrl.state = true
                  tCtrl.timer = os.startTimer(tCtrl.timeout)
                  GUI.drawAll()
                end
                term.setCursorPos(1, 1)
                if tCtrl.onClick ~= nil then
                  tCtrl.onClick({["id"]=id, ["state"]=tCtrl.state})
                end
              end
            elseif tCtrl.type == "list" then
              if tCtrl.scrollactive then
                tempWidth = tCtrl.w - 2
                if tCtrl.scroll > 1 and GUI._2DhitA(event[3], event[4], tCtrl.x + tCtrl.w, tCtrl.y, 0, tCtrl.h / 2) then
                  tCtrl.scroll = tCtrl.scroll - 1
                elseif tCtrl.scroll <= (#tCtrl.entries - tCtrl.h) - 1 and GUI._2DhitA(event[3], event[4], tCtrl.x + tCtrl.w, tCtrl.y + (tCtrl. h / 2), 0, tCtrl.h / 2) then
                  tCtrl.scroll = tCtrl.scroll + 1
                end
              else
                tempWidth = tCtrl.w
              end
              if GUI._2DhitA(event[3], event[4], tCtrl.x, tCtrl.y, tempWidth, tCtrl.h) then
                tempSelection = tCtrl.selection
                tCtrl.selection = event[4] - tCtrl.y + tCtrl.scroll
                if tCtrl.selection <= #tCtrl.entries then
                  if tCtrl.onClick ~= nil then
                    tCtrl.onClick(tCtrl.selection)
                  end
                else
                  tCtrl.selection = tempSelection
                end
              end
            elseif tCtrl.type == "input" then
              if GUI._2DhitA(event[3], event[4], tCtrl.x, tCtrl.y, tCtrl.w, tCtrl.h) then
                local relativeClickPosition = math.min(event[3] - tCtrl.x + 1, string.len(tCtrl.text) + 1)
                local textLen = string.len(tCtrl.text)
                tCtrl.cursorPos = relativeClickPosition + tCtrl.textOffset
              elseif tCtrl.cursorPos ~= nil then
                tCtrl.cursorPos = nil
              end
            end
          end
        end
      end
  elseif event[1] == "timer" then
    for id, tCtrl in pairs(tObj) do
      if id ~= "index" then
        if tCtrl.type == "button" and tCtrl.timer ~= nil then
          if tCtrl.timer == event[2] then
            tCtrl.timer = nil
            tCtrl.state = false
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
      for id, tCtrl in pairs(tObj) do
        if id ~= "index" and tCtrl.type == "input" and tCtrl.cursorPos ~= nil then
          if keyName == "backspace" then
            tCtrl.text = string.sub(tCtrl.text, 1, math.max(tCtrl.cursorPos - 2, 0)) .. string.sub(tCtrl.text, tCtrl.cursorPos)
            tCtrl.cursorPos = math.max(tCtrl.cursorPos - 1, 1)
            if tCtrl.textOffset > 0 then
              tCtrl.textOffset = tCtrl.textOffset - 1
            end
          elseif keyName == "delete" then
            tCtrl.text = string.sub(tCtrl.text, 1, math.max(tCtrl.cursorPos - 1, 0)) .. string.sub(tCtrl.text, tCtrl.cursorPos + 1)
          elseif keyName == "left" then
            tCtrl.cursorPos = math.max(tCtrl.cursorPos - 1, 1)
          elseif keyName == "right" then
            tCtrl.cursorPos = math.min(tCtrl.cursorPos + 1, string.len(tCtrl.text) + 1)
          elseif eventIsChar then
            tCtrl.text = string.sub(tCtrl.text, 1, tCtrl.cursorPos - 1) .. keyName .. string.sub(tCtrl.text, tCtrl.cursorPos)
            tCtrl.cursorPos = tCtrl.cursorPos + 1
          end
          if tCtrl.cursorPos <= tCtrl.textOffset then
            tCtrl.textOffset = tCtrl.textOffset - 1
          end
          if tCtrl.cursorPos - tCtrl.textOffset > tCtrl.w then
            tCtrl.textOffset = tCtrl.textOffset + 1
          end
        end
      end
    end
  end
end

return GUI
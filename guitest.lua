GUI = require("GUI")
myMonitor = peripheral.wrap("left")
myMonitor.setBackgroundColor(colors.black)
myMonitor.setTextScale(0.5)
myMonitor.clear()
hButton1 = 0
hButton2 = 0
hButton3 = 0
flashLeft = false
flashUp = false

function button(param)
  id = param.id
  state = param.state
  if id == hButton1.id then
    flashLeft = state
  elseif id == hButton2.id then
    flashUp = state
  elseif id == hButton3.id then
    if state then
      hProgress.direction = 0
      hButton3.text = "vertical bar"
    else
      hProgress.direction = 1
      hButton3.text = "horizontal bar"
    end
  end
end

hLabel1 = GUI.createLabel("CC-GUI Demo", 20, 5, colors.gray, colors.white)
hLabel1.monitor = myMonitor
hLabel2 = GUI.createLabel("Demo - buttons", 20, 8, colors.gray, colors.white)
hLabel2.monitor = myMonitor
hButton1 = GUI.createButton("flash right", 10, 10, 15, 5, colors.green, colors.white, colors.black, colors.red)
hButton1.monitor = myMonitor
hButton1.onClick = button
hButton1.toggle = true
hButton2 = GUI.createButton("flash up", 28, 10, 15, 5, colors.blue, colors.lime, colors.yellow, colors.magenta)
hButton2.monitor = myMonitor
hButton2.onClick = button
hButton2.toggle = true
hLabel3 = GUI.createLabel("Demo - progress bar", 19, 18, colors.gray, colors.white)
hLabel3.monitor = myMonitor
hButton3 = GUI.createButton("horizontal bar", 5, 20, 20, 5, colors.white, colors.green, colors.green, colors.white)
hButton3.monitor = myMonitor
hButton3.onClick = button
hButton3.toggle = true
hLabel4 = GUI.createLabel("0%", 22 + 19, 19, colors.black, colors.white)
hLabel4.monitor = myMonitor
hProgress = GUI.createProgressBar(11 + 19, 21, 25, 25, colors.green, 0)
hProgress.monitor = myMonitor
hProgress.direction = 1
hLabel5 = GUI.createLabel("Demo - progress bar", 62, 7, colors.gray, colors.white)
hLabel5.monitor = myMonitor
hList = GUI.createList(63, 10, 15, 10, colors.gray, colors.white, colors.lime, colors.white)
hList.monitor = myMonitor
GUI.createListEntry(hList, "Demo entry 1")
GUI.createListEntry(hList, "Demo entry 2")
GUI.createListEntry(hList, "Demo entry 3")
iProgress = 0
os.startTimer(0.5)
while true do
  
  GUI.drawAll()
  events = {os.pullEvent()}
  GUI.handleEvent(events)
  if events[1] == "timer" then
    os.startTimer(0.5)
    if flashLeft then rs.setOutput("right", not rs.getOutput("left")) end
    if flashUp then rs.setOutput("top", not rs.getOutput("top")) end
    if iProgress < 100 then
      iProgress = iProgress + 1
      if iProgress > 75 then hProgress.color = colors.red end
      hProgress.value = iProgress
      hLabel4.text = iProgress .. "%"
    else
      hProgress.color = colors.green
      iProgress = 0
    end
  end
end
print("end")
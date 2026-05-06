GUI = require("GUI")
hButton1 = 0
hButton2 = 0
hButton3 = 0
flashLeft = false
flashUp = false

function button(param)
  --print("button:")
  print(textutils.serialize(param))
  --print("buttons: " .. hButton1 .. ", " .. hButton2)
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
hLabel1 = GUI.createLabel("MyAwesomeGUI", 5, 1, colors.gray, colors.white)
hButton1 = GUI.createButton("flash left", 2, 3, 15, 5, colors.green, colors.white, colors.black, colors.red)
hButton1.onClick = button
hButton1.toggle = true
hButton2 = GUI.createButton("flash up", 2, 8, 15, 5, colors.blue, colors.lime, colors.yellow, colors.magenta)
hButton2.onClick = button
hButton2.toggle = true
hButton3 = GUI.createButton("horizontal bar", 1, 13, 16, 4, colors.white, colors.green, colors.green, colors.white)
hButton3.onClick = button
hButton3.toggle = true
hLabel2 = GUI.createLabel("0%", 25, 2, colors.black, colors.white)
hProgress = GUI.createProgressBar(20, 4, 15, 8, colors.green, 0)
hProgress.direction = 1

hInput = GUI.createInput("testInput", 20, 16, 10, 5, colors.yellow, colors.black)

iProgress = 0
os.startTimer(0.5)
while true do
  
  GUI.drawAll()
  events = {os.pullEvent()}
  GUI.handleEvent(events)
  
  if events[1] == "timer" then
    os.startTimer(0.5)
    if flashLeft then rs.setOutput("left", not rs.getOutput("left")) end
    if flashUp then rs.setOutput("top", not rs.getOutput("top")) end
    if iProgress < 100 then
      iProgress = iProgress + 1
      if iProgress > 75 then hProgress.color = colors.red end
      hProgress.value = iProgress
      hLabel2.text = iProgress .. "%"
    else
      hProgress.color = colors.green
      iProgress = 0
    end
  end
end
print("end")
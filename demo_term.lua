GUI = require("GUI")
ButtonsFlashLeft = 0
ButtonsFlashUp = 0
ProgressbarButton = 0
flashLeft = false
flashUp = false

function toggleBarDirection(param)
  id = param.id
  state = param.state
  if state then
    Progressbar.direction = 0
    ProgressbarButton.text = "vertical bar"
  else
    Progressbar.direction = 1
    ProgressbarButton.text = "horizontal bar"
  end
end

function toggleFlashRedstone(param)
  id = param.id
  state = param.state
  if id == ButtonsFlashLeft.id then
    flashLeft = state
  elseif id == ButtonsFlashUp.id then
    flashUp = state
  end
end

-- Create title label
TitleLabel = GUI.createLabel("MyAwesomeGUI", 5, 1, colors.gray, colors.white)

-- Create demo buttons
ButtonsFlashLeft = GUI.createButton("flash left", 2, 3, 15, 5, colors.green, colors.white, colors.black, colors.red)
ButtonsFlashLeft.onClick = toggleFlashRedstone
ButtonsFlashLeft.toggle = true

ButtonsFlashUp = GUI.createButton("flash up", 2, 8, 15, 5, colors.blue, colors.lime, colors.yellow, colors.magenta)
ButtonsFlashUp.onClick = toggleFlashRedstone
ButtonsFlashUp.toggle = true

ProgressbarButton = GUI.createButton("horizontal bar", 1, 13, 16, 4, colors.white, colors.green, colors.green, colors.white)
ProgressbarButton.onClick = toggleBarDirection
ProgressbarButton.toggle = true

-- Create demo progress bar
ProgressbarLabel = GUI.createLabel("0%", 25, 2, colors.black, colors.white)
Progressbar = GUI.createProgressBar(20, 4, 15, 8, colors.green, 0)
Progressbar.direction = 1

-- Create demo input
Input = GUI.createInput("testInput", 20, 16, 10, 5, colors.yellow, colors.black)

-- Main loop logic
local progessCounter = 0
local restoneFlashInterval = 0.5
os.startTimer(restoneFlashInterval) -- For the redstone flashing
while true do
  GUI.drawAll()
  events = {os.pullEvent()}
  GUI.handleEvent(events)
  
  if events[1] == "timer" then
    os.startTimer(restoneFlashInterval) -- restart redstone flash timer
    if flashLeft then rs.setOutput("left", not rs.getOutput("left")) end
    if flashUp then rs.setOutput("top", not rs.getOutput("top")) end
    if progessCounter < 100 then
      progessCounter = progessCounter + 1
      if progessCounter > 75 then Progressbar.color = colors.red end
      Progressbar.value = progessCounter
      ProgressbarLabel.text = progessCounter .. "%"
    else
      Progressbar.color = colors.green
      progessCounter = 0
    end
  end
end
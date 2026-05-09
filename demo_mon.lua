GUI = require("GUI")
Theme = require("Theme")
-- Prepare monitor
Monitor = peripheral.wrap("left")
Monitor.setBackgroundColor(colors.black)
Monitor.setTextScale(0.5)
Monitor.clear()

flashRight = false
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
  if id == ButtonsFlashRight.id then
    flashRight = state
  elseif id == ButtonsFlashUp.id then
    flashUp = state
  end
end

function toggleListSize(param)
  state = param.state
  if state == true then
    List.h = 20
  else
    List.h = 10
  end
end

-- Create title label
TitleLabel = GUI.createLabel("CC-GUI Demo", 22, 2, Theme.backgroundColor, Theme.textColor)
TitleLabel.monitor = Monitor

-- Create demo buttons
ButtonsLabel = GUI.createLabel("Demo - buttons", 20, 5, Theme.backgroundColor, Theme.textColor)
ButtonsLabel.monitor = Monitor

ButtonsFlashRight = GUI.createButton("flash right", 10, 7, 15, 5, Theme.textColor, Theme.primaryColor, Theme.textColor, Theme.successColor)
ButtonsFlashRight.monitor = Monitor
ButtonsFlashRight.onClick = toggleFlashRedstone
ButtonsFlashRight.toggle = true

ButtonsFlashUp = GUI.createButton("flash up", 28, 7, 15, 5, Theme.textColor, Theme.primaryColor, Theme.textColor, Theme.successColor)
ButtonsFlashUp.monitor = Monitor
ButtonsFlashUp.onClick = toggleFlashRedstone
ButtonsFlashUp.toggle = true

-- Create demo progress bar
ProgressbarLabel = GUI.createLabel("Demo - progress bar", 6, 15, Theme.backgroundColor, Theme.textColor)
ProgressbarLabel.monitor = Monitor

ProgressbarButton = GUI.createButton("horizontal bar", 5, 17, 20, 5, Theme.textColor, Theme.primaryColor, Theme.textColor, Theme.secondaryColor)
ProgressbarButton.monitor = Monitor
ProgressbarButton.onClick = toggleBarDirection
ProgressbarButton.toggle = true

ProgressbarLabel = GUI.createLabel("0%", 9 + 5, 24, Theme.backgroundColor, Theme.textColor)
ProgressbarLabel.monitor = Monitor

Progressbar = GUI.createProgressBar(0 + 5, 26, 20, 20, Theme.successColor, 0)
Progressbar.monitor = Monitor
Progressbar.direction = 1

-- Create demo list
ListLabel = GUI.createLabel("Demo - list", 35, 15, Theme.backgroundColor, Theme.textColor)
ListLabel.monitor = Monitor

ListButton = GUI.createButton("toggle size", 30, 17, 20, 5, Theme.textColor, Theme.primaryColor, Theme.textColor, Theme.secondaryColor)
ListButton.monitor = Monitor
ListButton.onClick = toggleListSize
ListButton.toggle = true

List = GUI.createList(30, 26, 20, 10, Theme.backgroundColor, Theme.textColor, Theme.secondaryColor, Theme.textColor, Theme.borderColor)
List.monitor = Monitor
for i = 1, 20 do
  GUI.createListEntry(List, "Demo entry " .. i)
end

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
    if flashRight then rs.setOutput("right", not rs.getOutput("right")) end
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
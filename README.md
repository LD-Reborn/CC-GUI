# CC-GUI
Computercraft toolkit for creating graphical user interfaces

**This code is very old (see hungarian notation) and being adapted for current Computercraft. Expect slight changes in behavior or usage in the next commits.**

features:
- integrated terminal display: yes
- external monitor display: yes
- multi-monitor display: yes
- event handling (i.e. click handling, etc.): yes
- widgets:
  - label: yes
  - button: yes
  - list: yes
  - progress bar: yes
  - input: WIP - buggy

## Setup
To install CC-GUI, enter this command in the CLI or download the `GUI.lua` file from the list above:
```
wget https://raw.githubusercontent.com/LD-Reborn/CC-GUI/main/GUI.lua
```

## Usage
See `guitest.lua` for an example with a monitor.

## FAQ
### Will over-the-network rendering become a feature?
~~This is not X11~~ Maybe...? If you have like a distributed shop system with digital signage that might be a valid use-case.

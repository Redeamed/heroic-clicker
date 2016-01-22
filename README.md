# Heroic Clicker 
Version: 1
Date: 1/19/2016
Author: Redeamed (https://github.com/Redeamed)
Adapted from: SGoertzen (v4.2)(https://github.com/sgoertzen)
Which was Adapted from: Andrux51 (http://github.com/Andrux51)


----Read Me may need Further Updating for new Features------

![Screenshot of UI](https://raw.githubusercontent.com/sgoertzen/heroic-clicker/master/Screenshot.png)

Heroic Clicker will play the steam version of Clicker Heroes for you.  
Features:
- Can play the entire game for you forever
- Automatically clicks enemies and levels up your heroes
- Supports idling for a while before clicking
- Collects fish and bees
- Can automatically level up all heroes and purchase their skills
- Will detect your gilded hero and will keep upgraded them only
- Uses your skills as soon as they become available
- Works well with the ancient Iris
- Automatically enables progression mode if a failed boss fight turns it off
- Stores settings in configuration file between runs

## Instructions (requires 64bit windows):
1. Download the latest release from https://github.com/sgoertzen/heroic-clicker/releases
2. Extract the zip file to a folder of your choice
3. Double click the HeroicClicker.exe
4. Profit!

## Hotkeys
- F11 - Pause (press F11 to resume)
- F12 - Exit

## Warnings!
### Relics Destroyed
Any relics you get will be destroyed before ascending.  Feel free to pause the game (F11) and check your relics during a run.  
### Works better with clicker heroes in front
The clicker heroes window must be active for the script to detect if auto-progression is off and to detect your highest gilded hero.  Hero leveling is also much faster with the window active.  There are fall backs in case you want to run this in the background, but they make the run slighly less efficient 
### Pause
Using F11 to pause the grinding does not pause the ascension timer.
### Relic Dialog
Be sure to turn off the "Show relic found popups" under options otherwise it will interrupt the program.

## Future Enhancements
- Keep track of the timers on skills and use them more effectively
- Automatically save out the game state on a regular interval
- Detect color of relic and don't ascend if it is purple

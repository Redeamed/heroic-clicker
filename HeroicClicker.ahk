;/// Heroic Clicker 
;/// Version: 1.0
;/// Date: 1/19/2016
;/// Author: Redeamed (https://github.com/Redeamed)
;/// Adapted from: SGoertzen (v4.2)(https://github.com/sgoertzen)
;/// Adapted from: Andrux51 (http://github.com/Andrux51)
;///
;/// Instructions:
;/// Run .ahk file (using autohotkey: http://www.autohotkey.com/)
;/// F9  - Start auto-playing showing options dialog first
;/// F10 - Start auto-playing with defaults (skip option dialog) 
;/// F11 - Pause (press F11 to resume)
;/// F12 - Exit
;///
;/// 

;///THESE CAN BE CHANGED HERE FOR QUICK EDITING

global scrollSome := 10 ;  ////number of mouse chicks when scrolling the bar some

; ///DON'T CHANGE THESE HERE.  Make the adjustments in the Settings.ini file
global minutesPerAscension	:= 120 ; ////How many minutes before it should ascend
global idleMinutes			:= 0 ;	 ////How many minutes before it should ascend
global irisLevel			:= 0 ;	 ////Level of your iris ancient
global irisJump				:= 13 ;  ///// Current default number
global timing				:= 25 ;	 ////change this value to adjust script speed (milliseconds)
global keepInFront			:= 0
global timeTillLevelScreen  := 10 ;	 ///// Number of levels per hero per cycle
global levelsPerHero		:= 25 ;	 ///// Number of levels per hero per cycle

#SingleInstance force ;				//// if script is opened again, replace instance

global title			:= "Clicker Heroes" ;	//// we will exact match against this for steam version
global stop				:= false
global idling			:= false


global CLICK_STORM		:= 170
global POWER_SURGE		:= 220
global LUCKY_STRIKES	:= 270
global METAL_DETECTOR	:= 325
global GOLDEN_CLICKS	:= 375
global DARK_RITUAL		:= 425
global SUPER_CLICK		:= 480
global ENERGIZE			:= 530
global RELOAD			:= 580


;//// Run the GUI on startup
showGUI()

F11::
  ;///pause := !pause
	Pause
  return
   
F12::
GuiClose:
GuiEscape:
  ExitApp
  return

showGui() 
{
  ;///////////// Read the options from the ini, with defaults///////////////////////

  IniRead, minutesPerAscension, Settings.ini, HeroicClicker, MinutesPerAscension, %minutesPerAscension%
  IniRead, idleMinutes,			Settings.ini, HeroicClicker, IdleMinutes		, %idleMinutes%
  IniRead, irisLevel,			Settings.ini, HeroicClicker, IrisLevel			, %irisLevel%
  IniRead, irisJump,			Settings.ini, HeroicClicker, IrisJump			, %irisJump%
  IniRead, timeTillLevelScreen, Settings.ini, HeroicClicker, TimeTillLevelScreen, %timeTillLevelScreen%
  IniRead, levelsPerHero,		Settings.ini, HeroicClicker, LevelsPerHero		, %levelsPerHero%
  IniRead, ascendOnStart,		Settings.ini, HeroicClicker, AscendOnStart		, 0
  IniRead, keepInFront,			Settings.ini, HeroicClicker, KeepInFront		, 0
  
  ;//////////////////display //////////////////////////////////
  ;
  ;////////Text only values
  Gui, Add, Text, , Iris Level: 
  Gui, Add, Text, , Number of levels to jump:
  Gui, Add, Text, , Minutes Per Ascension:
  Gui, Add, Text, , Idle minutes before clicking:
  Gui, Add, Text, , Time Between Leveling Heroes on Screen:
  Gui, Add, Text, , Levels Per Hero:
  ;
  ;/////////////editable values
  Gui, Add, Edit, w100 Number vEnteredLevel ym           , %irisLevel%  ; The ym option starts a new column of controls.
  Gui, Add, Edit,      Number vEnteredIrisJump	         , %irisJump%
  Gui, Add, Edit,      Number vEnteredMinutes            , %minutesPerAscension%
  Gui, Add, Edit,      Number vEnteredIdleMinutes        , %idleMinutes%
  Gui, Add, Edit,	   Number vEnteredTimeTillLevelScreen, %timeTillLevelScreen%
  Gui, Add, Edit,	   Number vEnteredLevelsPerHero      , %levelsPerHero%
  ;
  ;///////////togglable checkboxes
  Gui, Add, Checkbox, Checked%ascendOnStart% vEntertedAscendOnStart, Start with Ascension
  Gui, Add, Checkbox, Checked%keepInFront% vEntertedKeepInFront    , Keep window active
  ;
  ;/////Run Button
  Gui, Add, Button, default, &Run
  
  ;
  ;//////Hint Texts
  Gui, Add, Text, ym, (Set to zero if you don't have iris)
  Gui, Add, Text,	, (number of levels you jump to reach iris)
  Gui, Add, Text,	, (Set to zero to never auto ascend)
  Gui, Add, Text,	, (Set to zero to never idle)
  Gui, Add, Text,	, (Wait time until the code will level visible heroes)
  Gui, Add, Text,	, (number of levels each hero gets each cycle)
  Gui, Add, Text,	, (If checked, it will ascend first before auto-playing)
  Gui, Add, Text,	, (Will bring the game to the front as necessary)


  Gui, Add, Text,   ,(Once running use F11 to pause, F12 to exit)
  ;
  ;/////Display the gui after set up?
  Gui, Show,, Heroic Clicker
}
;/////////////////////////////////////////////////////////////////////
;
;
;/////////////////////////BUTTON RUN IS CLICKED
ButtonRun:
  Gui, Submit
  ;
  ;///////////////////set player input values///////////////////
  minutesPerAscension := EnteredMinutes
  idleMinutes := EnteredIdleMinutes
  irisLevel := EnteredLevel
  irisJump := EnteredIrisJump
  keepInFront := KeepInFront
  timeTillLevelScreen := EnteredTimeTillLevelScreen
  levelsPerHero := EnteredLevelsPerHero
  ;
  ;//////////////////Write player input values to settings file
  IniWrite, %minutesPerAscension%,   Settings.ini, HeroicClicker, MinutesPerAscension
  IniWrite, %idleMinutes%,           Settings.ini, HeroicClicker, IdleMinutes
  IniWrite, %irisLevel%,			 Settings.ini, HeroicClicker, IrisLevel
  IniWrite, %EntertedAscendOnStart%, Settings.ini, HeroicClicker, AscendOnStart
  IniWrite, %EntertedKeepInFront%,   Settings.ini, HeroicClicker, KeepInFront
  IniWrite, %EnteredTimeTillLevelScreen%,  Settings.ini, HeroicClicker, timeTillLevelScreen
  IniWrite, %EnteredLevelsPerHero%,  Settings.ini, HeroicClicker, levelsPerHero
  ;///////////////////////////////////////////////////////////////////////////
  ;
  ;

  validateInputs()
  bringToFront()

  ;////////////////////here the core loop begings
  ;
  doEverything(EntertedAscendOnStart)
  ;
  ;///////////////////////////////////

  ;/////after doEverything finishes ExitApp
  ExitApp
  
  ; ///////////////////Bring this to the front for now//////////
bringToFront()
{
  if (keepInFront) 
  {
    WinActivate, %title% 
  }
}
;//////////////////////////////////////////////////////////


validateInputs() 
{
  if (idleMinutes > minutesPerAscension && minutesPerAscension != 0) 
  {
    MsgBox, Idle minutes can not be higher then ascension minutes.  Program will exit.
    ExitApp
  }
}


;///////////////////////////////Main Loop////////////////////////////////////
doEverything(shouldAscend) {

  setDefaults()
  startTimer()
  startLevelHeroTimer()
  
  while (true) 
  {
    stop   := false
    idling := (idleMinutes > 0)

    if (shouldAscend) 
	{
      salvageRelics()
      ascend()
      if (irislevel > 0)
	  {
        irisStart()
        
      }
	  else
	  {
		
		 Sleep 1000
		 if(isProgressionModeOff())
		 {
				clickProgressionMode()
		 }
	  }

    }

    shouldAscend := true
    startIdleTimer()

	;////core clicking method
    grind()
  }
}
;//////////////////////////////////////////////////////////////////////////////


;/////////////////Initialize Timers///////////////////////////////
startTimer(){
  if (minutesPerAscension > 0) {
    timeInMilli := minutesPerAscension * 60 * 1000
    SetTimer, AscensionTimer, %timeInMilli%
  }
}

startIdleTimer(){
  if (idleMinutes > 0) {
    idleTimeInMilli := idleMinutes * 60 * 1000
    SetTimer, IdleTimer, %idleTimeInMilli%
  }
}
testValue := 0
startLevelHeroTimer()
{ if (timeTillLevelScreen > 0) 
{
    levelHeroTimeInMilli := timeTillLevelScreen * 60 * 1000
    SetTimer, HeroLevelTimer, %levelHeroTimeInMilli%
	
  }
}

AscensionTimer:
  stop := true
  return
  
IdleTimer:
   idling := false
   SetTimer, IdleTimer, OFF
   return

HeroLevelTimer:

		upgradeHerosOnScreen(levelsPerHero) 
		scrollDownSome()
		if(testValue >= 10)
		{
		
			clickBuyAvailableUpgrades()
			sleep 300
			scrollToListTop()
			testValue = 0;
		}
		else
		{
		testValue++
		}
		
	startLevelHeroTimer()
   return
  ;////////////////////////////////////////////////////////////


;/////////////////////////ASCEND/////////////////////////////////
ascend() 
{
  ; Click ascend button
  ControlClick,, %title%,,,, x1113 y291 NA
  Sleep 1000
  ; Click ok button
  ControlClick,, %title%,,,, x493 y481 NA
}
;//////////////////////////////////////////////////////////////////
irisStart() 
{
  ; Just kill some to get initial gold
  Loop, 20 
  {
    getSkillBonusClickable()
    collectGold()
  }

  ; Go up by twelve levels at a time
  steps := Round(Round(irislevel / irisjump))
  Loop, %steps% 
  {
    if(stop) 
	{
        return
    }
    scrollToListBottom()
    clickHeroInSlot(2,25)

    scrollToFarmZone(irisjump)

    ; Let it get some gold on this new level
    Loop, 10 
	{
      getSkillBonusClickable()
      getClickables()
      collectGold()
      Sleep timing
    }
  }
  
    if (isProgressionModeOff())
	{       
		turnOnProgressionMode := true
		clickProgressionMode()
	}
	scrollToListTop();
}

;///////////////////////////////////GRIND //////////////////////////////////
grind() 
{
  ;///////////// We get the title match for the Clicker Heroes game window
  setDefaults()


  i = 1

  turnOnProgressionMode := false
  
  ; ////////////Send clicks to CH while the script is active
  while(!stop) 
  {
    if (idling) 
	{
      Sleep 50
    }

    if (!idling) 
	{
      ; /////////////try to catch skill bonus clickable
      getSkillBonusClickable()
  
      remainder := mod(i, 30)
      if(remainder = 0) 
	  {
        getClickables()
      }
    }
        
	remainder := mod(i, 100)  ;///does nothing unless lower than 1000
    if(timeTillLevelScreen <= 0 && remainder = 0) ;///only runs if level heros on screen is disabled
	{     

      gildInSecond := isGildedHeroInSecondSlot()
      gildInThird := isGildedHeroInThirdSlot()    
      thirdRowLeveled := isThirdRowLeveledUp()

      if (!gildInSecond && !gildInThird) 
	  {
        scrollToListBottom()
      }
		clickBuyAvailableUpgrades()
      
      if (gildInThird && thirdRowLeveled)
	  {
          clickHeroInSlot(3, 50)
      } 
	  else 
	  {
         clickHeroInSlot(3, 10)
		clickHeroInSlot(2, 50)
      }
      if (!idling) {
        useAbilities()
      }
    }

	;///Disabled for now while testing Timer based leveling
	;///remainder := mod(i, 100)
	;///if(remainder = 0)
	;///{
	;///	upgradeHerosOnScreen(levelsPerHero) 
	;///	scrollDownSome()
	;///  
	;///}
	;///   
		remainder := mod(i, 200)
    if(remainder = 0) 
	{
			if (isProgressionModeOff())
			{
               turnOnProgressionMode := true
				clickProgressionMode()
			}
    }
        
    i++
    if (i>1000) 
	{
	if (timeTillLevelScreen <= 0 i>1000) 
	{
		clickBuyAvailableUpgrades()
		sleep 300
		scrollToListTop()
	}

	useAbilities()
      i = 1

    }
    Sleep timing

   ;// while (pause) {
    ;//  Sleep 1000
    ;///}
  }
  return
}
;////////////////////////////////////////////////////////////

;/////////////// RELICS /////////////////////////////////
salvageRelics() 
{

;////rest to x373 after powerbloop ends
  ControlClick,, %title%,,,, x323 y100 NA ; Click relics tab
  Sleep 500  
  ControlClick,, %title%,,,, x278 y439 NA ; Click Salvage
  Sleep 500
  ControlClick,, %title%,,,, x501 y404 NA ; Click yes button
  Sleep 500
  ControlClick,, %title%,,,, x41 y100 NA ; Click hero tab
  Sleep 500
}
;////////////////////////////////////////////////////////


useAbilities() {
    ;/////// TODO: use abilities at more appropriate times
    ;/////// Combos: 123457, 1234, 12

    useAbility(CLICK_STORM)
    useAbility(POWER_SURGE)
    useAbility(LUCKY_STRIKES)
    useAbility(METAL_DETECTOR)
    useAbility(GOLDEN_CLICKS)
    useAbility(SUPER_CLICK)

    useAbility(ENERGIZE)
    useAbility(DARK_RITUAL)
    useAbility(RELOAD)
    return
}


useAbility(ability) 
{
	ControlClick,, %title%,,,, x600 y%ability% NA
  return
}


clearRelicDialog() 
{
  ControlClick,, %title%,,,, x560 y375 NA
  Sleep 1000
  ControlClick,, %title%,,,, x925 y120 NA
  Sleep 500
  return
}

collectGold() 
{
  ControlClick,, %title%,,,, d x760 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x800 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x850 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x910 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, u x5 y300 NA
  return
}

getSkillBonusClickable() 
{
    ; click in a sequential area to try to catch mobile clickable
    ControlClick,, %title%,,,, x770 y130 NA
    ControlClick,, %title%,,,, x790 y130 NA
    ControlClick,, %title%,,,, x870 y130 NA
    ControlClick,, %title%,,,, x890 y130 NA
    ControlClick,, %title%,,,, x970 y130 NA
    ControlClick,, %title%,,,, x990 y130 NA

    return
}

getClickables() 
{
    ; clickable positions
    ControlClick,, %title%,,,, x505 y460 NA
    ControlClick,, %title%,,,, x730 y400 NA
    ControlClick,, %title%,,,, x745 y450 NA
    ControlClick,, %title%,,,, x745 y340 NA
    ControlClick,, %title%,,,, x850 y480 NA
    ControlClick,, %title%,,,, x990 y425 NA
    ControlClick,, %title%,,,, x1030 y410 NA

    return
}

setDefaults() 
{
    SendMode InputThenPlay
    CoordMode, Mouse, Client
    SetKeyDelay, 0, 0
    SetMouseDelay 1 ; anything lower becomes unreliable for scrolling
    SetControlDelay 1 ; anything lower becomes unreliable for scrolling
    SetTitleMatchMode 3 ; window title is an exact match of the string supplied

    return
}

clickForwardArrow(times) 
{
    ControlClick,, %title%,,, %times%, x1035 y40 NA
    return
}

clickZone() 
{
    ControlClick,, %title%,,,, x980 y40 NA
    return
}

clickHeroInSlot(slot, times) 
{
  if (times > 24 && isClickerHeroesWindowActive()) 
  {
    Send {z down}
    times := (times+1) / 25
  }
  if(slot = 1) 
  {
    ControlClick,, %title%,,, %times%, x50 y250 NA
  }
  if(slot = 2) 
  {
    ControlClick,, %title%,,, %times%, x50 y356 NA
  }
  if(slot = 3) 
  {
    ControlClick,, %title%,,, %times%, x50 y462 NA
  }
  if(slot = 4) 
  {
    ControlClick,, %title%,,, %times%, x50 y568 NA
  }
  if (isClickerHeroesWindowActive()) 
  {
    Send {z up}
  }
  return
}

scrollToFarmZone(zone) 
{
    ; subtract 3 because zone 3 is already on screen,
    ; so it takes 3 less clicks to get there than the zone number
    clicksToFarmZone := zone - 3
    looper := 0
    while(looper < clicksToFarmZone) {
        clickForwardArrow(1)
        Sleep 10
        looper++
    }

    ; let the screen catch up, then go to zone
    Sleep 300
    clickZone()

    return
}

;////////////////////LEVEL ALL HEROS
levelAllHeroes() 
{
;////////////////////////
    ;////scrollToListTop()
	scrollToListBottom()
;//////////////////////////////////

    ;/// This is set to click the very left side of each hire button
	;/// so that it avoids clicking the "Gilded" button when it makes it
	;/// to the bottom
  
  stepAmount := 46
  
	Loop, 10 
	{
  		Sleep 500
		upgradeHerosOnScreen(25)

		scrollUpSome() 

		Sleep 500
	}


    return
}


  ;//////////////////////// UPGRADE ON SCREEN /////////////////////////////////
upgradeHerosOnScreen(value) 
{
  ;// Since the scroll bar is inconsistent, we just slowly walk up the
  ;// screen clicking the entire time.  This means some heroes will
  ;// have more upgrades then others but everyone will be at
  ;// at least 150
  ;//bringToFront() ;//should be unneccesaay as it is called in isClickerHeroesWindowActive
  
  ;// If the window is active we can great increase the speed of this by
  ;// holding down 'Z' while clicking

  if (isClickerHeroesWindowActive() && value > 25) 
  {
		Send {z down}
		value =  Round(value / 25)
	

	;////ControlSend,, {z down}, %title%
    
  }


  ;//ypos := 600
  ;//while (ypos >= 200) 
  ;//{
  ;//  ypos -= 6
  ;//    ControlClick,, %title%,,,value, x50 y%ypos% NA
  ;//}

  clickHeroInSlot(1,value)
  clickHeroInSlot(2,value)
  clickHeroInSlot(3,value)
  clickHeroInSlot(4,value)


  if (isClickerHeroesWindowActive()) 
  {
    Send {z up}
	;////ControlSend,, {z up}, %title%
  }
}
;///////////////////////////////////////////////


isClickerHeroesWindowActive()
{
   bringToFront()
   WinGetActiveTitle, ActiveWindowTitle
  return (ActiveWindowTitle = title)
}

clickBuyAvailableUpgrades()
{
	scrollToListBottom()
	sleep 500
    ControlClick,, %title%,,,, x280 y550 NA
}

scrollToListTop() 
{
    ;//// scroll to the top of the hero list
    ControlClick,, %title%,,,, x545 y208 NA
    ;//// This pause is needed so the screen can catch up
    Sleep 350
    return
}
scrollToListBottom() 
{
    ;/// Sometimes when a new hero unlocked the scrollbar doesn't expand as it should
    ;/// In order to work around this we scroll to the top first then scroll back down
    scrollToListTop()

    ;//// Scroll to far bottom of the hero list
    ControlClick,, %title%,,,, x545 y605 NA

    ;//// This pause is needed so the screen can catch up
    Sleep 350
    return
}

scrollUpSome()
{

		ControlClick,, %title%,,,scrollSome, x550 y193 NA

		Sleep 500
}
scrollDownSome()
{

		ControlClick,, %title%,,,scrollSome, x550 y623 NA


		Sleep 500

}
;////////////////////////////////////////IS PROGRESSION MODE OFF////////////////////////////////////
isProgressionModeOff()
{
  bringToFront()
  ImageSearch, foundX, foundY, 1124, 278, 1126, 280, *5 red.png

	if ErrorLevel = 2
		return false
	else if ErrorLevel = 1
		return false
	else
		return true
}
;//////////////////////////////////////CLICK PROGRESSION////////////////////////////////////////
clickProgressionMode() 
{
	;////Why doesnt this work?
;///if(isClickerHeroesWindowActive)
;///{
;///	Send {a down}
;///	Send {a up}
;///}

    ControlClick,, %title%,,,, x1110 y250 NA

}

;/////////////////////////////////////CHECK GUILDS//////////////////////////////////////////
isGildedHeroInSecondSlot() {
  return imageAt(15, 230, 24, 380, "gold.png")
}

isGildedHeroInThirdSlot() {
  return imageAt(15, 430, 24, 500, "gold.png")
}

isThirdRowLeveledUp() {
  return !imageAt(195, 518, 200, 522, "lightgold.png")
}
;///////////////////////////////////////////////////////////////////////////////////////////


imageAt(startX, startY, endX, endY, imageFile) {
  bringToFront()
  ImageSearch, foundX, foundY, startX, startY, endX, endY, *5 %imageFile%
  if ErrorLevel = 2
		return false
	else if ErrorLevel = 1
		return false
	else
		return true
}